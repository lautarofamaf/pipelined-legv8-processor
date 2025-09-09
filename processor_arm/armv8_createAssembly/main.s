	.text
	.org 0x0000
	
	add x1,x0,x1
infLoop:  
	cbz XZR infLoop

	
   /* Me piden programar en LEGV8 este codigo basicamente */
   // N = Cantidad de direcciones de memoria
   // i = Direccion base (0) y voy aumentando en 1/4/8/16/32 <- ver bien cual
   // Asignar en la memoria 
   //
   // for (uint64_t i = 0; i < N; ++i) {
   //     mem[i] = i;
   // }
   //

