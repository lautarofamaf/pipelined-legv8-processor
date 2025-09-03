`timescale 1ns / 1ps

module flopr_tb ();
  logic clk_TEST, reset_TEST;
  logic [63:0] q_TEST, d_TEST;
  logic [31:0] q32_TEST, d32_TEST;

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
      .clk(clk_TEST),
      .reset(reset_TEST),
      .d(d_TEST),
      .q(q_TEST)
  );

  // instancio flopr usando el parametro 32
  flopr #(
      .N(32)
  ) dut32 (
      .clk(clk_TEST),
      .reset(reset_TEST),
      .d(d32_TEST),
      .q(q32_TEST)
  );

  // apply inputs one at a time:
  initial begin
    clk_TEST   = 0;
    reset_TEST = 1;
    #0;
  end

  initial begin
    d_TEST   = 64'd0;
    d32_TEST = 32'd0;
    #10;
    d_TEST   = 64'd1;
    d32_TEST = 32'd1;
    #10;
    d_TEST   = 64'd2;
    d32_TEST = 32'd2;
    #10;
    d_TEST   = 64'd3;
    d32_TEST = 32'd3;
    #10;
    d_TEST   = 64'd4;
    d32_TEST = 32'd4;
    #10;

    reset_TEST = 0;
    d_TEST = 64'd5;
    d32_TEST = 32'd5;
    #10;
    d_TEST   = 64'd6;
    d32_TEST = 32'd6;
    #10;
    d_TEST   = 64'd7;
    d32_TEST = 32'd7;
    #10;
    d_TEST   = 64'd8;
    d32_TEST = 32'd8;
    #10;
    d_TEST   = 64'd9;
    d32_TEST = 32'd9;
    #10;
    $finish;
  end
endmodule
