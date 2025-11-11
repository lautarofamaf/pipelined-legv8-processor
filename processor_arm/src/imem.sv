`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  6:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:127] = '{default:32'h0};

    initial begin
ROM [0:27] ='{32'hd37f3c2a,
32'h8b1f014f,
32'h8b1f002c,
32'hd37f3c2e,
32'hd37f342d,
32'h8b0d01ce,
32'hf800014c,
32'hcb0f0194,
32'hb4000274,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'h8b1f01cd,
32'hb400012d,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb0101ad,
32'hb4ffff7f,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hd37f058c,
32'hb4fffdff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hb400001f};
    end
    
  assign q = ROM[addr];
endmodule
