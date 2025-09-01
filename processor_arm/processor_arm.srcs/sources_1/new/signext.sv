`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/31/2025 09:29:50 PM
// Design Name:
// Module Name: signext
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module signext(
    input [31:0] a,
    output [63:0] y
    );

    logic [10:0] opcode_INPUT = a[31:20];

    logic opcode_LDUR = 11'b111_1100_0010;
    logic opcode_STUR = 11'b111_1100_0000;
    logic opcode_CBZ  = 11'b101_1010_0???;

    always_comb
      //Tipo D, inmediato entre los bits [20:12]
      if (opcode_INPUT == opcode_LDUR || opcode_INPUT == opcode_STUR)
        // ocho bits
        assign y = { {57{a[20]}}, a[20:12] };
      // Tipo CB, inmediato entre los bits [23:5] 18 bits
      else if (opcode_INPUT == opcode_CBZ)
        // 18bits
        assign y = { {46{a[23]}}, a[23:5] };
      else
        assign y = 64'b0;
endmodule

// Tomar los 32bits de instruccion
// Analizar opcode
// Determinar si la instruccion posee valor inmediato
// if ( tiene) --> extender el signo a 64bits
// if (~tiene) --> mandar 0
