	.text
	.org 0x0000
	
	// add x1,x0,x1
  //infLoop:  
  //cbz XZR, infLoop

	
   /* Me piden programar en LEGV8 este codigo basicamente */
   // N = Cantidad de direcciones de memoria
   // i = Direccion base (0) y voy aumentando en 1/4/8/16/32 <- ver bien cual
   // Asignar en la memoria 
   //
   // for (uint64_t i = 0; i < N; ++i) {
   //     mem[i] = i;
   // }
   //

// NOTA: En regfile creo que era tengo que mi CPU al iniciarse ya tiene
// R[Xi] = i

// X30 = N = 30
// X29 = i
// X28 = direccion de memoria actual = i * 8

ADD X29, XZR, XZR 
ADD X28, XZR, XZR 

LOOP:
  STUR X29, [X28, #0]
  ADD X29, X29, X1
  ADD X28, X28, X8
  SUB X30, X30, X1
  CBZ X30, END_LOOP
  CBZ XZR, LOOP

END_LOOP:
