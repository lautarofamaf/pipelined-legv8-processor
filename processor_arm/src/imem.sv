`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  6:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:127] = '{default:32'h0};

    initial begin
ROM [0:47] ='{32'hd37f3c2a,
32'h8b08014b,
32'h8b1f00ec,
32'hd37f3c2d,
32'hd37f2c34,
32'h8b1401ad,
32'hd37f1c34,
32'h8b1401ad,
32'hd37f0c34,
32'h8b1401ad,
32'h8b0101ad,
32'hd37f3c2e,
32'hd37f3434,
32'h8b1401ce,
32'hd37f34f0,
32'hf8400174,
32'hcb0d0294,
32'hb4000114,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff,
32'hb4fffeff,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff,
32'hf800014c,
32'h8b1f01cd,
32'hb400012d,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff,
32'hcb0101ad,
32'hb4ffff7f,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff,
32'hb40000b4,
32'hd37f058c,
32'hcb100194,
32'hb4fffe5f,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f00ec,
32'hb4fffdbf,
32'h8b1f03ff,
32'h8b1f03ff,
32'h8b1f03ff};
    end
    
  assign q = ROM[addr];
endmodule
