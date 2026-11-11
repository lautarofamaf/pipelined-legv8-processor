# 5-Stage Pipelined LEGv8 Processor Core in SystemVerilog

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-1A365D?style=flat-square&logo=verilog&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-ARMv8%20%2F%20LEGv8-green?style=flat-square)
![Hardware](https://img.shields.io/badge/Hardware-Pipelining%20%26%20Hazards-blue?style=flat-square)

Hardware implementation of a 5-stage pipelined processor core (**Fetch**, **Decode**, **Execute**, **Memory**, **Writeback**) executing the LEGv8 (subset of ARMv8) instruction set in **SystemVerilog**, featuring hazard detection, data forwarding units, and ALU instruction extensions.

---

### Authors
* Lautaro Deco
* Gaspar Saenz Valiente
* Juan Cruz Hermosilla Artico

---

### Technical Highlights & Microarchitecture Extensions

Para la implementación de las instrucciones de desplazamiento LSL y LSR, se realizaron modificaciones en la unidad de control, el datapath, la ALU y la ROM.

1. Expansión de la Memoria de Instrucciones (imem.sv):

    Se duplicó la capacidad de la memoria de instrucciones (imem.sv) de 64 a 128 entradas (de 2^6 a 2^7). Esta modificación implicó:
    * Ampliar el puerto de entrada addr a 7 bits (input logic [6:0] addr).
    * Expandir la declaración del array de la ROM a ```logic [N-1:0] ROM [0:127]```.

2. Actualización de decodificadores (maindec.sv y aludec.sv):

    Se actualizó la lógica de control para decodificar y manejar las nuevas instrucciones:

    * maindec.sv: Se modificó el decodificador principal para reconocer los opcodes de LSL y LSR y generar las señales de control (ALUOp) correspondientes para la ALU.

    * aludec.sv: Se extendió el decodificador de la ALU para generar dos nuevas señales alucontrol (ALUOps) a partir de las señales de maindec y el campo funct:

        * 4'b1000: LSL

        * 4'b1001: LSR

3. Modificación del Datapath para el shamt:

    Se implementó el camino de datos necesario para transportar el valor shamt a través del pipeline hasta la ALU:

    * Etapa Decode (decode.sv): Se añadió la lógica para extraer el campo shamt de 6 bits (correspondiente a los bits [15:10] de la instrucción) mediante la asignación:
    ```assign shamt = instr_D[15:10];```

    * Pipeline (datapath.sv): El valor shamt extraído se propaga a la siguiente etapa almacenándolo en el registro de pipeline ID/EX.

    * Etapa Execute (execute.sv): Se lee el valor shamt desde el registro ```(.shamt(qID_EX[276:271]))``` y se conecta a un nuevo puerto de entrada en la ALU.

4. Actualización de la ALU:

    Finalmente, se modificó el módulo alu.sv para que pudiera ejecutar las nuevas operaciones:

    * Se añadió un nuevo puerto de entrada de 6 bits para recibir el valor shamt desde la etapa de ejecución.

    * Se actualizó la lógica interna (case) para que, al recibir las señales alucontrol 4'b1000 (LSL) o 4'b1001 (LSR), la ALU realice la operación de desplazamiento correspondiente utilizando el valor de shamt.

### Codigo test
```asm
.text
.org 0x0000
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
STUR X1, [X0, #0] // MEM 0:0x1
STUR X2, [X0, #8] // MEM 1:0x2
STUR X3, [X16, #0] // MEM 2:0x3
ADD X3, X4, X5
STUR X3, [X0, #24] // MEM 3:0x9
SUB X3, X4, X5
STUR X3, [X0, #32] // MEM 4:0xFFFFFFFFFFFFFFFF
SUB X4, XZR, X10
STUR X4, [X0, #40] // MEM 5:0xFFFFFFFFFFFFFFF6
ADD X4, X3, X4
STUR X4, [X0, #48] // MEM 6:0xFFFFFFFFFFFFFFF5
SUB X5, X1, X3
STUR X5, [X0, #56] // MEM 7:0x2
AND X5, X10, XZR
STUR X5, [X0, #64] // MEM 8:0x0
AND X5, X10, X3
STUR X5, [X0, #72] // MEM 9:0xA
AND X20, X20, X20
STUR X20, [X0, #80] // MEM 10:0x14
ORR X6, X11, XZR
STUR X6, [X0, #88] // MEM 11:0xB
ORR X6, X11, X3
STUR X6, [X0, #96] // MEM 12:0xFFFFFFFFFFFFFFFF
LDUR X12, [X0, #0]
ADD X7, X12, XZR
STUR X7, [X0, #104] // MEM 13:0x1
STUR X12, [X0, #112] // MEM 14:0x1
ADD XZR, X13, X14
STUR XZR, [X0, #120] // MEM 15:0x0
CBZ X0, L1
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
STUR X21, [X0, #128] // MEM 16:0x0(si falla CBZ =21)
L1: STUR X21, [X0, #136] // MEM 17:0x15
ADD X2, XZR, X1
L2: SUB X2, X2, X1
ADD X24, XZR, X1
STUR X24, [X0, #144] // MEM 18:0x1 y MEM 19=0x1
ADD X0, X0, X8
CBZ X2, L2
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
STUR X30, [X0, #144] // MEM 20:0x1E
ADD X30, X30, X30
SUB X21, XZR, X21
ADD X30, X30, X20
LDUR X25, [X30, #-8]
ADD X30, X30, X30
ADD X30, X30, X16
STUR X25, [X30, #-8] // MEM 21:0xA (= MEM 9)

// --- LSL y LSR ---
ADD X2, X1, X1 // X2 = 0x2
LSL X26, X2, #4
STUR X26, [X30, #0] // MEM 22:0x20
LSR X27, X16, #1 // X16 = 0x10
STUR X27, [X30, #8] // MEM 23:0x4
// --- LSL y LSR ---

finloop: CBZ XZR, finloop
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
ADD XZR, XZR, XZR
```

#### mem.dump:
```text
Memoria RAM de Arm:
Address Data
0 0000000000000000000000000000000000000000000000000000000000000001
1 0000000000000000000000000000000000000000000000000000000000000010
2 0000000000000000000000000000000000000000000000000000000000000011
3 0000000000000000000000000000000000000000000000000000000000001001
4 1111111111111111111111111111111111111111111111111111111111111111
5 1111111111111111111111111111111111111111111111111111111111110110
6 1111111111111111111111111111111111111111111111111111111111110101
7 0000000000000000000000000000000000000000000000000000000000000010
8 0000000000000000000000000000000000000000000000000000000000000000
9 0000000000000000000000000000000000000000000000000000000000001010
10 0000000000000000000000000000000000000000000000000000000000010100
11 0000000000000000000000000000000000000000000000000000000000001011
12 1111111111111111111111111111111111111111111111111111111111111111
13 0000000000000000000000000000000000000000000000000000000000000001
14 0000000000000000000000000000000000000000000000000000000000000001
15 0000000000000000000000000000000000000000000000000000000000000000
16 0000000000000000000000000000000000000000000000000000000000000000
17 0000000000000000000000000000000000000000000000000000000000010101
18 0000000000000000000000000000000000000000000000000000000000000001
19 0000000000000000000000000000000000000000000000000000000000000001
20 0000000000000000000000000000000000000000000000000000000000011110
21 0000000000000000000000000000000000000000000000000000000000001010
22 0000000000000000000000000000000000000000000000000000000000100000
23 0000000000000000000000000000000000000000000000000000000000000100
24 0000000000000000000000000000000000000000000000000000000000000000
25 0000000000000000000000000000000000000000000000000000000000000000
26 0000000000000000000000000000000000000000000000000000000000000000
27 0000000000000000000000000000000000000000000000000000000000000000
28 0000000000000000000000000000000000000000000000000000000000000000
29 0000000000000000000000000000000000000000000000000000000000000000
30 0000000000000000000000000000000000000000000000000000000000000000
31 0000000000000000000000000000000000000000000000000000000000000000
32 0000000000000000000000000000000000000000000000000000000000000000
33 0000000000000000000000000000000000000000000000000000000000000000
34 0000000000000000000000000000000000000000000000000000000000000000
35 0000000000000000000000000000000000000000000000000000000000000000
36 0000000000000000000000000000000000000000000000000000000000000000
37 0000000000000000000000000000000000000000000000000000000000000000
38 0000000000000000000000000000000000000000000000000000000000000000
39 0000000000000000000000000000000000000000000000000000000000000000
40 0000000000000000000000000000000000000000000000000000000000000000
41 0000000000000000000000000000000000000000000000000000000000000000
42 0000000000000000000000000000000000000000000000000000000000000000
43 0000000000000000000000000000000000000000000000000000000000000000
44 0000000000000000000000000000000000000000000000000000000000000000
45 0000000000000000000000000000000000000000000000000000000000000000
46 0000000000000000000000000000000000000000000000000000000000000000
47 0000000000000000000000000000000000000000000000000000000000000000
48 0000000000000000000000000000000000000000000000000000000000000000
49 0000000000000000000000000000000000000000000000000000000000000000
50 0000000000000000000000000000000000000000000000000000000000000000
51 0000000000000000000000000000000000000000000000000000000000000000
52 0000000000000000000000000000000000000000000000000000000000000000
53 0000000000000000000000000000000000000000000000000000000000000000
54 0000000000000000000000000000000000000000000000000000000000000000
55 0000000000000000000000000000000000000000000000000000000000000000
56 0000000000000000000000000000000000000000000000000000000000000000
57 0000000000000000000000000000000000000000000000000000000000000000
58 0000000000000000000000000000000000000000000000000000000000000000
59 0000000000000000000000000000000000000000000000000000000000000000
60 0000000000000000000000000000000000000000000000000000000000000000
61 0000000000000000000000000000000000000000000000000000000000000000
62 0000000000000000000000000000000000000000000000000000000000000000
63 0000000000000000000000000000000000000000000000000000000000000000
```

### Diagrama de bloques general del procesador
#### Processor
![processor](./processor_arm/images/processor.jpg)

#### Datapath
![dp](./processor_arm/images/datapath.jpg)

#### Forwarding 
![forwarding-logic](./processor_arm/images/forwarding_cropped_page-0001.jpg)

#### Decode
![decode](./processor_arm/images/decode_cropped_page-0001.jpg)



### Verificación y Programa GPIO (Ejercicio 1)

Para validar la implementación del hardware (LSL/LSR) y la E/S (GPIO), se implementó un programa assembly interactivo que utiliza tanto los switches (`i_sw`) como los LEDs (`o_led`).

#### 1\. Descripción del Funcionamiento

El programa (`main.s`) implementa una animación de LEDs bloqueada por contraseña. El procesador permanece en un bucle de espera (`PASSWORD_LOOP`) hasta que el usuario introduce la contraseña correcta a través de los switches.

1.  **Espera de Contraseña:**

      * El programa lee continuamente la dirección `0x8008` (mapeada a `i_sw`) usando la instrucción `LDUR X20, [X11, #0]`.
      * Compara el valor leído (`X20`) con la contraseña predefinida (`X13`).
      * La contraseña es `34953` (decimal) o **`0x8889`** (hex), lo que requiere que los switches **15, 11, 7, 3 y 0** estén activos.
      * Mientras la contraseña sea incorrecta, el procesador se mantiene en el `PASSWORD_LOOP`.

2.  **Animación de LEDs:**

      * Una vez que `i_sw` es igual a `0x8889`, el programa salta a `ANIMATION_LOOP`.
      * La animación consiste en un patrón de 3 bits (`0b...0111`) que se desplaza hacia la izquierda.
      * El estado de los LEDs (guardado en `X12`) se escribe en la dirección `0x8000` (`STUR X12, [X10, #0]`).
      * Se ejecuta un bucle de *delay* (`DELAY_LOOP`) para que el movimiento sea visible.
      * Se comprueba si el patrón ha llegado al borde izquierdo (comparando `X12` con `X16 = 0xE000`, es decir, LEDs 13, 14 y 15).
      * Si no ha llegado al borde, el patrón se desplaza 1 bit a la izquierda (`LSL X12, X12, #1`).
      * Si ha llegado al borde, el patrón se resetea a su valor inicial (`ADD X12, X7, XZR`, que es `7` o `0b...0111`).
      * El bucle de animación se repite indefinidamente.

*(Nota: Para que la imagen de arriba se muestre, asegurate de renombrar tu `imagen.png` a `animacion_leds.png` y colocarla en una carpeta `images` dentro de `processor_arm/`)*

#### 2\. Testbench Específico (`leds_tb.sv`)

Para probar esta funcionalidad, se creó un testbench (`leds_tb.sv`) que simula la interacción del usuario:

1.  Inicia con `i_sw = 0x0000` (contraseña incorrecta).
2.  Espera 50,000 ns y cambia a `i_sw = 0x000F` (otra contraseña incorrecta).
3.  Espera 50,000 ns más e introduce la contraseña correcta `i_sw = 0x8889`.
4.  En este punto, la simulación muestra cómo `o_led` comienza la animación, validando el `LDUR`, `CBZ`, `LSL` y `STUR`.

#### 3\. Código `main.s` del GPIO

```armasm
.global _start
.text
_start:

// INICIALIZACION

    // X10 = 0x8000 (Dirección base LEDs)
    LSL X10, X1, #15
    
    // X11 = 0x8008 (Dirección base switches)
    ADD X11, X10, X8
    
    // X12 = 7 (Patrón inicial de LEDs: ...0111)
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
    
    // X14 = 4096 (Valor de delay = 1 << 12)
    LSL X14, X1, #12
    ADD X20, XZR, XZR
    
    // X16 = 57344 (Valor de borde: 7 << 13 = 0xE000)
    LSL X16, X7, #13

// Bucle de espera de contraseña
PASSWORD_LOOP:
    // 1. Leer los switches
    LDUR X20, [X11, #0]
    // NOPs para hazard load-use (LDUR -> SUB)
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

    // 2. Comparar con contraseña (en X13)
    SUB X20, X20, X13       // X20 = 0 si (switches == 34953)
    
    // 3. Si es correcta (X20 == 0), saltar a la animación
    CBZ X20, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    
    // 4. Si es incorrecta, volver a leer
    CBZ XZR, PASSWORD_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

// Bucle de animación
ANIMATION_LOOP:
    // 1. Escribir patrón en LEDs
    STUR X12, [X10, #0]
    
    // 2. Cargar contador de delay (X13 ahora se usa para el delay)
    ADD X13, X14, XZR       // Reinicia el contador de delay a 4096

// Bucle de delay
DELAY_LOOP:
    // 3. Salir del delay si X13 es 0
    CBZ X13, END_DELAY
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

    // 4. Decrementar delay
    SUB X13, X13, X1
    CBZ XZR, DELAY_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

// Fin del delay, lógica de animación
END_DELAY:
    // 5. Comparar patrón actual (X12) con borde (X16 = 0xE000)
    SUB X20, X12, X16
    
    // 6. Si llegó al borde (X20 == 0), resetear LEDs
    CBZ X20, RESET_LEDS
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    
    // 7. Si no, mover 1 bit a la izquierda
    LSL X12, X12, #1
    CBZ XZR, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR

// Rutina de reseteo
RESET_LEDS:
    // 8. Resetear patrón a ...0111 (valor 7, guardado en X7)
    ADD X12, X7, XZR
    CBZ XZR, ANIMATION_LOOP
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
    ADD XZR, XZR, XZR
```


### Funcionamiento Forwarding Unit y Hazard Detection Unit

#### Forwarding Unit
![FU-Working](./processor_arm/images/fu.png)
```asm
SUB X4, XZR, X10
STUR X4, [X0, #40] *// MEM 5:0xFFFFFFFFFFFFFFF6*
ADD X4, X3, X4
```
En el ciclo de reloj que comienza en 145 ns, se hace fetch de la instrucción SUB X4, XZR, X10.

En el siguiente ciclo, se hace fetch de STUR X4, [X0, #40] y se decodifica la instrucción SUB, donde se observa ra1 = 31, ra2 = 10, wa = 4.

En el ciclo siguiente, se ejecuta SUB y se decodifica STUR.

En el ciclo posterior, la instrucción SUB se encuentra en la etapa MEM y se ejecuta STUR.

En este momento, la forwarding unit entra en acción. Observa los inputs que recibe: id_ex_Rm = 4, ex_mem_Rd = 4 y ex_mem_regWrite = 1. Detecta la dependencia de datos RAW y envía la señal forward_B = 01 para que la entrada a la ALU en readData_2 sea el resultado de haber ejecutado el SUB (−10).

#### Hazard Detection Unit
![HDU-Working](./processor_arm/images/hdu.png)

```asm
STUR X6, [X0, #96] // MEM 12:0xFFFFFFFFFFFFFFFF
LDUR X12, [X0, #0]
ADD X7, X12, XZR
STUR X7, [X0, #104] // MEM 13:0x1
STUR X12, [X0, #112] // MEM 14:0x1
```

Como se ve en el código, existe una dependencia RAW entre la instrucción LDUR X12, [X0, #0] y ADD X7, X12, XZR, donde la HDU debe intervenir para insertar un stall.

En el flanco ascendente de clock en 465 ns, se hace fetch de la instrucción LDUR X12, [X0, #0].

En el siguiente clock, se decodifica esa instrucción, donde observamos memRead en 1. A su vez, se hace fetch de la instrucción ADD X7, X12, XZR.

En el siguiente clock, se ejecuta LDUR y se decodifica ADD. En este momento, la HDU recibe memRead y Rd provenientes de qID_EX, y Rn y Rm provenientes de la instrucción ADD decodificada.

La HDU verifica que Rd == Rn, Rn ≠ XZR y memRead == 1, por lo que envía la señal Stall. Esto deshabilita el enable del registro IF_ID y IF_ID_TOP para mantener el PC y la instrucción fetcheada. Como se puede ver, el ADD (f8068007) permanece un ciclo de clock extra en fetch mientras que todas las señales de control se ponen en 0.