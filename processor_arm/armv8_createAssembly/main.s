.global _start
.text
_start:

// INICIALIZACION

    // X10 = 0x8000 (lEDs)
    LSL X10, X1, #15
    
    // X11 = 0x8008 (switches)
    ADD X11, X10, X8
    
    // X12 = 7 (patron inicial ...0111)
    ADD X12, X7, XZR
    
    // X13 = 34953 (Contraseña: 0x8889)
    // (34953 = (1<<15) + (1<<11) + (1<<7) + (1<<3) + 1)
    LSL X13, X1, #15        // X13 = 32768
    LSL X20, X1, #11        // X20 = 2048
    ADD X13, X13, X20       // X13 = 34816
    LSL X20, X1, #7         // X20 = 128
    ADD X13, X13, X20       // X13 = 34944
    LSL X20, X1, #3         // X20 = 8
    ADD X13, X13, X20       // X13 = 34952
    ADD X13, X13, X1        // X13 = 34953
    
    // X14 = 40960 (delay)
    LSL X14, X1, #15
    LSL X20, X1, #13
    ADD X14, X14, X20
    
    // X16 = 57344 (valor de borde: 7 << 13)
    LSL X16, X7, #13

// se queda hasta que los switches sean 0x8889
PASSWORD_LOOP:
    // 1. Leer los switches
    LDUR X20, [X11, #0]

    // comparar el valor leído con la contraseña (en X13)
    // (No hace falta AND porque dp_readData pone 0 
    // en los bits altos, y queremos que el resto sea 0)
    SUB X20, X20, X13       // X20 = 0 si (switches == 34953)
    
    // si la contraseña es correcta (X20 == 0), b animacion
    CBZ X20, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    
    // else password loop
    CBZ XZR, PASSWORD_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

ANIMATION_LOOP:
    STUR X12, [X10, #0]
    
    // cargar contador de delay
    ADD X13, X14, XZR       // reinicia el contador

DELAY_LOOP:
    CBZ X13, END_DELAY
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

    SUB X13, X13, X1
    CBZ XZR, DELAY_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

END_DELAY:
    // chequear borde (1110...0)
    SUB X20, X12, X16       // X20 = 0 si (patron == borde)
    CBZ X20, RESET_LOOP
    
    // mover un bit a la izquierda
    LSL X12, X12, #1
    CBZ XZR, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

RESET_LOOP:
    // resetear el patron a 7 (...0111)
    ADD X12, X7, XZR 
    CBZ XZR, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
