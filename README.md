[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/ItraukZ2)
# Arquitectura de Computadoras - FAMAF - UNC

## Lab 1: Implementación del procesador LEGv8 con pipeline de 5 etapas

### Modificaciones introducidas

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


### Diagrama de bloques general del procesador
#### Processor
![processor](./processor_arm/images/processor.jpg)

#### Datapath
![dp](./processor_arm/images/datapath.jpg)

#### Forwarding 
![forwarding-logic](./processor_arm/images/forwarding_cropped_page-0001.jpg)

#### Decode
![decode](./processor_arm/images/decode_cropped_page-0001.jpg)


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