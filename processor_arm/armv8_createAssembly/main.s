.global _start
.text
_start:

// --- INICIALIZACIÓN ---
    // X1=1, X7=7, X8=8 (pre-cargados por regfile)

    // X10 = 0x8000 (Dirección base LEDs)
    LSL X10, X1, #15
    
    // X11 = 0x8008 (Dirección base Switches)
    ADD X11, X10, X8
    
    // X12 = 7 (Patrón de luz inicial: ...0111)
    ADD X12, X7, XZR
    
    // X13 = 34953 (Contraseña: 0x8889)
    // (Construimos 34953 = (1<<15) + (1<<11) + (1<<7) + (1<<3) + 1)
    LSL X13, X1, #15        // X13 = 32768
    LSL X20, X1, #11        // X20 = 2048
    ADD X13, X13, X20       // X13 = 34816
    LSL X20, X1, #7         // X20 = 128
    ADD X13, X13, X20       // X13 = 34944
    LSL X20, X1, #3         // X20 = 8
    ADD X13, X13, X20       // X13 = 34952
    ADD X13, X13, X1        // X13 = 34953 (Contraseña lista)
    
    // X14 = 40960 (Valor de delay)
    LSL X14, X1, #15
    LSL X20, X1, #13
    ADD X14, X14, X20
    
    // X16 = 57344 (Valor de borde: 7 << 13)
    LSL X16, X7, #13

// --- BUCLE DE CONTRASEÑA ---
// Se queda aquí hasta que los switches sean 0x8889
PASSWORD_LOOP:
    // 1. Leer los switches
    LDUR X20, [X11, #0]
    
    // (NOPs para el hazard de LDUR->SUB)
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    
    // 2. Comparar el valor leído con la contraseña (en X13)
    // (No hace falta 'AND', ya que dp_readData pone 0 
    // en los bits altos, y queremos que el resto sea 0)
    SUB X20, X20, X13       // X20 = 0 si (Switches == 34953)
    
    // 3. Si la contraseña es correcta (X20 == 0), saltar a la animación
    CBZ X20, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    
    // 4. Si no, volver a leer (Salto incondicional)
    CBZ XZR, PASSWORD_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

// --- BUCLE DE ANIMACIÓN ---
// (Esta parte no se modifica)
ANIMATION_LOOP:
    // 1. Mostrar el patrón de LEDs actual (ej. ...0111)
    STUR X12, [X10, #0]
    
    // 2. Cargar contador de delay
    ADD X13, X14, XZR       // X13 = 40960 (reinicia el contador)

DELAY_LOOP:
    // 3. Lazo de espera
    CBZ X13, END_DELAY      // Salir si X13 == 0
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

    SUB X13, X13, X1        // X13 = X13 - 1
    CBZ XZR, DELAY_LOOP     // Repetir (Salto incondicional)
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

END_DELAY:
    // 4. Mover el patrón de luz un paso a la izquierda
    LSL X12, X12, #1        // Mover ...0111 a ...1110
    
    // 5. Chequear si llegamos al borde (1110...0)
    SUB X20, X12, X16       // X20 = 0 si (Patrón == Borde)
    CBZ X20, RESET_LOOP     // Si llegamos al borde, resetear
    
    // 6. Si no, continuar animación (Salto incondicional)
    CBZ XZR, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

RESET_LOOP:
    // 7. Resetear el patrón de luz a 7 (...0111)
    ADD X12, X7, XZR        // X12 = 7
    CBZ XZR, ANIMATION_LOOP // Volver al bucle de animación
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
