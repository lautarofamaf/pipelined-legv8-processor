`timescale 1ns / 1ps

module adder (
    input  logic [63:0] addr,
    input  logic [63:0] sum,
    output logic [63:0] result
);

  assign result = addr + sum;

endmodule
