`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  6:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:127] = '{default:32'h0};

    initial begin
ROM [0:10] ='{
    32'hd37f043a, // LSL X26, X1, 1
    32'hd35f045b, // LSR X27, X2, 1
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hf800001a,
32'hf800801b,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hb400001f};
    end
  assign q = ROM[addr];
endmodule
