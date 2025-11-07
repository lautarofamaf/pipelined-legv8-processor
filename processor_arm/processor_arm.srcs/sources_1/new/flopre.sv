//
// Módulo: flopre.sv
//
`timescale 1ns / 1ps

module flopre #(
    parameter int N = 64
) (
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,  // 1: Habilitado (funciona normal), 0: Congelado
    input  logic [N-1:0] d,
    output logic [N-1:0] q
);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 'b0;
    else if (enable) q <= d;  // Solo actualiza el valor si enable es 1

endmodule
