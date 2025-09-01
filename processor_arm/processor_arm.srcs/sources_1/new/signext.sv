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

module signext (
    input  logic [31:0] a,
    output logic [63:0] y
);

  logic [10:0] opcode_INPUT;
  assign opcode_INPUT = a[31:21];
  assign opcode_INPUT = a[31:21];

  // opcodes
  logic [10:0] opcode_LDUR = 11'b1111_1000_010;
  logic [10:0] opcode_STUR = 11'b1111_1000_000;
  logic [ 7:0] opcode_CBZ = 8'b1011_0100;

  logic [ 2:0] opcode_TEST = 3'b101;
  logic [ 2:0] opcode_TESTB = 3'b101;
  always_comb begin
    if ((opcode_INPUT == opcode_LDUR) || (opcode_INPUT == opcode_STUR)) begin
      y = {{55{a[20]}}, a[20:12]};
    end else if (opcode_INPUT[10:3] == opcode_CBZ) begin
      y = {{45{a[23]}}, a[23:5]};
    end else begin
      y = 64'b0;
    end
  end
endmodule

// Tomar los 32bits de instruccion
// Analizar opcode
// Determinar si la instruccion posee valor inmediato
// if ( tiene) --> extender el signo a 64bits
// if (~tiene) --> mandar 0
