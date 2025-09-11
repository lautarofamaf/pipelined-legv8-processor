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

// X30 = N
// X29 = i
// X28 = direccion de memoria actual = i * 8


inicializo:
  ORR X29, XZR, XZR // X28 = 0

loop:
  STUR X30, [X30, #0]  // M[i] = R[i]
  SUB X30, X30, X8 // i--

  CBZ X30, finLoop
  CBZ XZR, loop
finLoop:
