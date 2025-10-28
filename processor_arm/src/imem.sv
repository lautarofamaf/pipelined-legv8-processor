`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  6:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:127] = '{default:32'h0};

    initial begin
ROM [0:15] ='{32'h8b07000a,
32'hf800000a,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hf8400014,
32'hcb1f03ff,
32'h8b1f0281,
32'hf8008001,
32'hcb1f03ff,
32'hcb1f03ff,
32'hcb1f03ff,
32'hb400001f};
    end
  assign q = ROM[addr];
endmodule
