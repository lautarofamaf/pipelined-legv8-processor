.global _start
.text
_start:

// --- INICIALIZACIÓN (Solo se ejecuta una vez) ---

    // X1 = 1 (valor pre-cargado por regfile)
    // X2 = 2 (valor pre-cargado por regfile)
    // X4 = 4 (valor pre-cargado por regfile)

    // X10 = 0x8000 (Dirección base GPIO)
    // (Calculamos 1 << 15)
    LSL X10, X1, #15        // X10 = 32768 (0x8000)
    
    // X12 = 0x0001 (Estado inicial del LED: LED0 encendido)
    ADD X12, X1, XZR        // X12 = 1
    
    // X14 = Valor de delay (para velocidad lenta)
    // (Calculamos (1 << 15) + (1 << 13) = 32768 + 8192 = 40960)
    LSL X14, X1, #15        // X14 = 32768
    LSL X13, X1, #13        // X13 = 8192
    ADD X14, X14, X13       // X14 = 40960
    
    // X15 = 0x8000 (Valor del LED 15, para comparar borde)
    ADD X15, X10, XZR       // X15 = 0x8000

    // X16 = 1 (Dirección: 1=Izquierda, 0=Derecha)
    ADD X16, X1, XZR        // X16 = 1 (Empezar moviendo a la izquierda)

// --- BUCLE PRINCIPAL ---
MAIN_LOOP:
    // 1. Escribir el estado actual en los LEDs (en 0x8000)
    STUR X12, [X10, #0] 
    
    // 2. Leer los switches (de 0x8008)
    LDUR X11, [X10, #8]
    
    // NOPs para el hazard de load-use (LDUR -> AND)
    // (El Ejercicio 2 eliminará la necesidad de esto)
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

    // 3. Chequear SW0 (Pausa)
    // X1 (que vale 1) se usa como máscara para SW0
    AND X20, X11, X1        // X20 = (Switches AND 1)
    CBZ X20, MAIN_LOOP      // Si SW0 es 0 (pausa), saltar al inicio (no mover)

    // 4. Chequear SW1 (Velocidad)
    // X2 (que vale 2) se usa como máscara para SW1
    AND X20, X11, X2        // X20 = (Switches AND 2)
    // Cargar el valor de delay base en X13
    ADD X13, X14, XZR       // X13 = 40960 (delay lento)
    // Si SW1 es 1 (rápido), dividir el delay por 4 (LSR #2)
    CBNZ X20, FAST_DELAY
    CBZ XZR, DELAY_LOOP     // Salto incondicional a DELAY_LOOP
FAST_DELAY:
    LSR X13, X13, #2        // X13 = 40960 / 4 = 10240 (delay rápido)
    
DELAY_LOOP:
    // 5. Lazo de espera (Delay)
    SUB X13, X13, X1       // X13 = X13 - 1 (X1 vale 1)
    CBNZ X13, DELAY_LOOP   // Repetir hasta que X13 sea 0

    // 6. Mover el LED según la dirección (X16)
    CBNZ X16, MOVE_LEFT

// --- Mover a la Derecha (X16 == 0) ---
MOVE_RIGHT:
    LSR X12, X12, #1       // Mover bit a la derecha
    // ¿Llegamos al borde (LED 0)? (Comparar X12 con 1)
    SUB X20, X12, X1       // Si X12 == 1, X20 = 0
    CBZ X20, SET_LEFT      // Si llegó al borde, cambiar dirección
    CBZ XZR, MAIN_LOOP     // Salto incondicional al loop principal
    
SET_LEFT:
    ADD X16, X1, XZR       // Cambiar dirección (X16 = 1)
    CBZ XZR, MAIN_LOOP     // Salto incondicional

// --- Mover a la Izquierda (X16 == 1) ---
MOVE_LEFT:
    LSL X12, X12, #1       // Mover bit a la izquierda
    // ¿Llegamos al borde (LED 15)? (Comparar X12 con X15)
    SUB X20, X12, X15      // Si X12 == 0x8000, X20 = 0
    CBZ X20, SET_RIGHT     // Si llegó al borde, cambiar dirección
    CBZ XZR, MAIN_LOOP     // Salto incondicional
    
SET_RIGHT:
    ADD X16, XZR, XZR      // Cambiar dirección (X16 = 0)
    CBZ XZR, MAIN_LOOP     // Salto incondicional

; .text
; .org 0x0000
; // ---------------------------------------------------------------------------------------------------------------------------------------------------------------
; STUR X1, [X0, #0] // MEM 0:0x1
; STUR X2, [X0, #8] // MEM 1:0x2
; STUR X3, [X16, #0] // MEM 2:0x3
; ADD X3, X4, X5
; STUR X3, [X0, #24] // MEM 3:0x9
; SUB X3, X4, X5
; STUR X3, [X0, #32] // MEM 4:0xFFFFFFFFFFFFFFFF
; SUB X4, XZR, X10
; STUR X4, [X0, #40] // MEM 5:0xFFFFFFFFFFFFFFF6
; ADD X4, X3, X4
; STUR X4, [X0, #48] // MEM 6:0xFFFFFFFFFFFFFFF5
; SUB X5, X1, X3
; STUR X5, [X0, #56] // MEM 7:0x2
; AND X5, X10, XZR
; STUR X5, [X0, #64] // MEM 8:0x0
; AND X5, X10, X3
; STUR X5, [X0, #72] // MEM 9:0xA
; AND X20, X20, X20
; STUR X20, [X0, #80] // MEM 10:0x14
; ORR X6, X11, XZR
; STUR X6, [X0, #88] // MEM 11:0xB
; ORR X6, X11, X3
; STUR X6, [X0, #96] // MEM 12:0xFFFFFFFFFFFFFFFF
; LDUR X12, [X0, #0]
; ADD XZR, XZR, XZR // NOP
; ADD X7, X12, XZR
; STUR X7, [X0, #104] // MEM 13:0x1
; STUR X12, [X0, #112] // MEM 14:0x1
; ADD XZR, X13, X14
; STUR XZR, [X0, #120] // MEM 15:0x0
; CBZ X0, L1
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; STUR X21, [X0, #128] // MEM 16:0x0(si falla CBZ =21)
; L1: STUR X21, [X0, #136] // MEM 17:0x15
; ADD X2, XZR, X1
; L2: SUB X2, X2, X1
; ADD X24, XZR, X1
; STUR X24, [X0, #144] // MEM 18:0x1 y MEM 19=0x1
; ADD X0, X0, X8
; CBZ X2, L2
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; STUR X30, [X0, #144] // MEM 20:0x1E
; ADD X30, X30, X30
; SUB X21, XZR, X21
; ADD X30, X30, X20
; LDUR X25, [X30, #-8]
; ADD XZR, XZR, XZR
; ADD X30, X30, X30
; ADD X30, X30, X16
; STUR X25, [X30, #-8] // MEM 21:0xA (= MEM 9)
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; ADD XZR, XZR, XZR
; finloop: CBZ XZR, finloop
