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
