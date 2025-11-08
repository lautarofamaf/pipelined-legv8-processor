`timescale 1ns / 1ps

module flopr #(
    parameter int N = 64
) (
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [N-1:0] d,
    output logic [N-1:0] q
);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 'b0;
    else begin
        if (enable) begin
            q <= d;
        end    
    end
endmodule
