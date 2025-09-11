`timescale 1ns / 1ps

module imem #(
    parameter int N = 32
) (
    input  logic [  5:0] addr,
    output logic [N-1:0] q
);
    logic [N-1:0] ROM [0:63] = '{default:32'h0};

    initial begin
        ROM[1]  = 32'haa1f03fd;
        ROM[2]  = 32'hf80003de;
        ROM[3]  = 32'hcb0803de;
        ROM[4]  = 32'hb400005e;
        ROM[5]  = 32'hb4ffffbf;

    end

  assign q = ROM[addr];
endmodule
