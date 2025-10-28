.text
.org 0x0000
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
ADD X10, X0, X7
STUR X10, [X0, #0]
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
LDUR X20, [X0, #0]
SUB XZR, XZR, XZR
ADD X1, X20, XZR
STUR X1, [X0, #8]
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
finloop: CBZ XZR, finloop
