.global _start
.text
_start:

    LSL X10, X1, #15
    
    ADD X15, X10, XZR
    
    ADD X12, X1, XZR
    
    LSL X14, X1, #15
    LSL X13, X1, #13
    ADD X14, X14, X13
    

MAIN_LOOP:

    STUR X12, [X10, #0]
    
    SUB X20, X12, X15
    CBZ X20, FINISH
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    
    ADD X13, X14, XZR

DELAY_LOOP:
    CBZ X13, END_DELAY
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    
    SUB X13, X13, X1
    CBZ XZR, DELAY_LOOP
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
END_DELAY:

    LSL X12, X12, #1
    
    CBZ XZR, MAIN_LOOP
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR
    SUB XZR, XZR, XZR    
FINISH:
    CBZ XZR, FINISH
