`timescale 1ns / 1ps

module adder (
    input  logic [63:0] addr,
    output logic [63:0] result
);

  assign result = addr + 64'd4;

endmodule
