`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  5:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:63] = '{default:32'h0};

    initial begin
ROM [0:27] ='{32'h8b1f03fd,
32'h8b1f03fc,
32'hf800039d,
32'h8b0103bd,
32'h8b08039c,
32'hcb010294,
32'hb4000054,
32'hb4ffff7f,
32'h8b1f03fd,
32'h8b1f03fc,
32'h8b0a0154,
32'hb400003f,
32'hf840039d,
32'h8b08039c,
32'h8b1d0000,
32'hcb010294,
32'hb4000054,
32'hb4ffff7f,
32'hf8000380,
32'h8b1f03fd,
32'h8b1f03e0,
32'hb400003f,
32'h8b1103bd,
32'hcb010210,
32'hb4000050,
32'hb4ffffbf,
32'hf800001d,
32'hb400001f};
    end
  assign q = ROM[addr];
endmodule
