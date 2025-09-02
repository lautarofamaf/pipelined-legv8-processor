`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09/01/2025 03:45:43 P
// Design Name:
// Module Name: alu_tb
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


module alu_tb ();
  // Inputs
  logic [63:0] a;
  logic [63:0] b;
  logic [3:0] ALUControl;
  // Outputs
  logic [63:0] result;
  logic zero;  // flag 0

  alu dut (  // instancio la alu device under test
      .a(a),
      .b(b),
      .ALUControl(ALUControl),
      .result(result),
      .zero(zero)
  );

  logic [3:0] AND = 4'b0000;
  logic [3:0] OR = 4'b0001;
  logic [3:0] ADD = 4'b0010;
  logic [3:0] SUB = 4'b0110;
  logic [3:0] PASS_INPUT = 4'b0111;

  initial begin
    // ADD
    a = 64'd257;
    b = 64'd150;
    ALUControl = ADD;
    #10;
    if (result != 64'd407) $display("1) ADD failed: 257 + 150 != %d", result);

    a = 64'd0;
    b = 64'd0;
    ALUControl = ADD;
    #10;
    if (result != 64'd0) $display("2) ADD failed: 0 + 0 != %d", result);

    a = 64'd12345;
    b = 64'd6789;
    ALUControl = ADD;
    #10;
    if (result != 64'd19134) $display("3) ADD failed: 12345 + 6789 != %d", result);

    // SUB
    a = 64'd500;
    b = 64'd200;
    ALUControl = SUB;
    #10;
    if (result != 64'd300) $display("1) SUB failed: 500 - 200 != %d", result);

    a = 64'd200;
    b = 64'd500;
    ALUControl = SUB;
    #10;
    if (result != -64'd300) $display("2) SUB failed: 200 - 500 != %d", result);

    a = 64'd0;
    b = 64'd0;
    ALUControl = SUB;
    #10;
    if (result != 64'd0) $display("3) SUB failed: 0 - 0 != %d", result);

    // AND
    a = 64'hFFFF_FFFF_FFFF_FFFF;
    b = 64'h0F0F_0F0F_0F0F_0F0F;
    ALUControl = AND;
    #10;
    if (result != 64'h0F0F_0F0F_0F0F_0F0F) $display("1) AND failed");

    a = 64'h1234_5678_9ABC_DEF0;
    b = 64'hFFFF_0000_FFFF_0000;
    ALUControl = AND;
    #10;
    if (result != 64'h1234_0000_9ABC_0000) $display("2) AND failed");

    a = 64'd0;
    b = 64'd0;
    ALUControl = AND;
    #10;
    if (result != 64'd0) $display("3) AND failed: 0 & 0 != %d", result);

    // OR
    a = 64'hFFFF_0000_FFFF_0000;
    b = 64'h0000_FFFF_0000_FFFF;
    ALUControl = OR;
    #10;
    if (result != 64'hFFFF_FFFF_FFFF_FFFF) $display("1) OR failed");

    a = 64'd0;
    b = 64'd0;
    ALUControl = OR;
    #10;
    if (result != 64'd0) $display("2) OR failed: 0 | 0 != %d", result);

    a = 64'h1234_5678_9ABC_DEF0;
    b = 64'h0000_0000_FFFF_FFFF;
    ALUControl = OR;
    #10;
    if (result != 64'h1234_5678_FFFF_FFFF) $display("3) OR failed");

    // PASS_INPUT
    b = 64'hDEAD_BEEF_DEAD_BEEF;
    ALUControl = PASS_INPUT;
    #10;
    if (result != 64'hDEAD_BEEF_DEAD_BEEF) $display("1) PASS_INPUT failed");

    b = 64'd0;
    ALUControl = PASS_INPUT;
    #10;
    if (result != 64'd0) $display("2) PASS_INPUT failed: expected 0");

    b = 64'hFFFF_FFFF_FFFF_FFFF;
    ALUControl = PASS_INPUT;
    #10;
    if (result != 64'hFFFF_FFFF_FFFF_FFFF) $display("3) PASS_INPUT failed");

    $display("---------------------------------");
    $finish;
  end

endmodule
