`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  5:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:63] = '{default:32'h0};

    initial begin
        ROM [0:7] ='{32'h8b1f03fd,
        32'h8b1f03fc,
        32'hf800039d,
        32'h8b0103bd,
        32'h8b08039c,
        32'hcb0103de,
        32'hb400005e,
        32'hb4ffff7f};
    end
  assign q = ROM[addr];
endmodule
