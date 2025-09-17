.text
.org 0x0000


// X29 = i
// X28 = direccion de memoria actual = i * 8

// 2-A 
ADD X29, XZR, XZR 
ADD X28, XZR, XZR

LOOP_A:
  // x15 = N = 15
  STUR X29, [X28, #0]
  ADD X29, X29, X1
  ADD X28, X28, X8
  SUB x15, x15, X1
  CBZ x15, END_LOOP_A
  CBZ XZR, LOOP_A

END_LOOP_A:
  // x29=0, x28=0, x15=15
  ADD X29, XZR, XZR 
  ADD X28, XZR, XZR
  ADD X15, X10, X5 
  CBZ XZR, LOOP_B

LOOP_B:
  LDUR X29, [X28, #0]
  ADD X28, X28, X8
  ADD X0, X0, X29

  SUB X10, X10, X1
  CBZ X10, END_LOOP_B
  CBZ XZR, LOOP_B

END_LOOP_B:
  STUR X0, [X28, #0]


INF_LOOP:
  CBZ XZR, INF_LOOP
