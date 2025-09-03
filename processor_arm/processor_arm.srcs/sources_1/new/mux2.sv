`timescale 1ns / 1ps

module mux2 (
    input logic [63:0] d0,
    input logic [63:0] d1,
    input logic s,
    output logic [63:0] y
);
  assign y = s ? d1 : d0;
endmodule
