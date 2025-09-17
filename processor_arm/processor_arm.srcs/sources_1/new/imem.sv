`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  5:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:63] = '{default:32'h0};

    initial begin
        ROM [0:19] ='{32'h8b1f03fd,
32'h8b1f03fc,
32'hf800039d,
32'h8b0103bd,
32'h8b08039c,
32'hcb0101ef,
32'hb400004f,
32'hb4ffff7f,
32'h8b1f03fd,
32'h8b1f03fc,
32'h8b05014f,
32'hb400003f,
32'hf840039d,
32'h8b08039c,
32'h8b1d0000,
32'hcb01014a,
32'hb400004a,
32'hb4ffff7f,
32'hf8000380,
32'hb400001f};
    end
  assign q = ROM[addr];
endmodule
