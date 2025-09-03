`timescale 1ns / 1ps

module alu (
    input logic [63:0] a,
    input logic [63:0] b,
    input logic [3:0] ALUControl,
    output logic [63:0] result,
    output logic zero
);

  // ALU control lines
  logic [ 3:0] AND = 4'b0000;
  logic [ 3:0] OR = 4'b0001;
  logic [ 3:0] ADD = 4'b0010;
  logic [ 3:0] SUB = 4'b0110;
  logic [ 3:0] PASS_INPUT = 4'b0111;

  // alu logic
  logic [63:0] zeros = 64'b0;
  always_comb begin
    case (ALUControl)
      AND:        result = a & b;
      OR:         result = a | b;
      ADD:        result = a + b;
      SUB:        result = a - b;
      PASS_INPUT: result = b;
      default:    result = zeros;
    endcase
    // zero flag
    zero = (result == zeros);
  end
endmodule
