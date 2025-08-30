`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/29/2025 10:28:20 AM
// Design Name:
// Module Name: flopr_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module flopr_tb ();
  logic clk, reset;
  logic [63:0] q, d;
  logic [31:0] q32, d32;

  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  // instancio flopr usando el parametro 64
  flopr #(
      .N(64)
  ) dut (
      .clk(clk),
      .reset(reset),
      .d(d),
      .q(q)
  );
  // instancio flopr usando el parametro 32
  flopr #(
      .N(32)
  ) dut32 (
      .clk(clk),
      .reset(reset),
      .d(d32),
      .q(q32)
  );
  // apply inputs one at a time:
  initial begin
    clk   = 0;
    reset = 1;
    #3;
    d   = 64'd0;
    d32 = 32'd0;
    #10;
    d   = 64'd1;
    d32 = 32'd1;
    #10;
    d   = 64'd2;
    d32 = 32'd2;
    #10;
    d   = 64'd3;
    d32 = 32'd3;
    #10;
    d   = 64'd4;
    d32 = 32'd4;
    #10;

    reset = 0;
    d = 64'd5;
    d32 = 32'd5;
    #10;
    d   = 64'd6;
    d32 = 32'd6;
    #10;
    d   = 64'd7;
    d32 = 32'd7;
    #10;
    d   = 64'd8;
    d32 = 32'd8;
    #10;
    d   = 64'd9;
    d32 = 32'd9;
    #10;
    $finish;
  end
endmodule
