`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  6:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:127] = '{default:32'h0};

    initial begin
ROM [0:8] = '{
    32'hd37f0881, // LSL X1, X4, 2 
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hf8000001,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hb400001f};
    end
  assign q = ROM[addr];
endmodule
