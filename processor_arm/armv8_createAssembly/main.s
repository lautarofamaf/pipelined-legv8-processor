.text
.org 0x0000
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
STUR X26, [X0, #0]
STUR X27, [X0, #8]
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
SUB XZR, XZR, XZR
infloop: CBZ XZR, infloop
