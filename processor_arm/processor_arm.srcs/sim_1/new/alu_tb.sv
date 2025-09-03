`timescale 1ns / 1ps

module alu_tb ();
  logic [63:0] a;
  logic [63:0] b;
  logic [3:0] ALUControl;
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
    // ----------- ADD -----------
    // 1: Dos numeros positivos
    a = 64'd2;
    b = 64'd15;
    ALUControl = ADD;
    assert (result == 64'd17)
    else $display("1) ADD failed: 2 + 15 != %d", result);
    #10;

    // 2: Dos numeros negativos
    a = -64'd50;
    b = -64'd25;
    ALUControl = ADD;
    assert (result == -64'd75)
    else $display("2) ADD failed: -50 + (-25) != %d", result);
    #10;

    //3: Uno positivo y otro negativo
    a = 64'd1;
    b = -64'd3;
    ALUControl = ADD;
    assert (result == -64'd2)
    else $display("3) ADD failed: 1 + (-3) != %d", result);
    #10;

    //4: Uno negativo y otro positivo
    a = -64'd5;
    b = 64'd3;
    ALUControl = ADD;
    assert (result == -64'd2)
    else $display("4) ADD failed: -5 + 3 != %d", result);
    #10;

    // ----------- SUB -----------
    // 1: Dos numeros positivos
    a = 64'd5;
    b = 64'd2;
    ALUControl = SUB;
    assert (result == 64'd3)
    else $display("1) SUB failed: 5 - 2 != %d", result);
    #10;

    // 2: Dos numeros negativos
    a = -64'd2;
    b = -64'd5;
    ALUControl = SUB;
    assert (result == 64'd3)
    else $display("2) SUB failed: -2 - (-5) != %d", result);
    #10;

    // 3: Uno positivo y otro negativo
    a = 64'd1;
    b = -64'd3;
    ALUControl = SUB;
    assert (result == 64'd4)
    else $display("3) SUB failed: 1 - (-3) != %d", result);
    #10;

    // 4: Uno negativo y otro positivo
    a = -64'd5;
    b = 64'd2;
    ALUControl = SUB;
    assert (result == -64'd7)
    else $display("4) SUB failed: -5 - 2 != %d", result);
    #10;

    // ----------- AND -----------
    a = 64'hFFFF_FFFF_FFFF_FFFF;
    b = 64'h0F0F_0F0F_0F0F_0F0F;
    ALUControl = AND;
    assert (result == 64'h0F0F_0F0F_0F0F_0F0F)
    else $display("1) AND failed");
    #10;

    a = 64'h1234_5678_9ABC_DEF0;
    b = 64'hFFFF_0000_FFFF_0000;
    ALUControl = AND;
    assert (result == 64'h1234_0000_9ABC_0000)
    else $display("2) AND failed");
    #10;

    a = 64'd0;
    b = 64'd0;
    ALUControl = AND;
    assert (result == 64'd0)
    else $display("3) AND failed: 0 & 0 != %d", result);
    #10;

    // ----------- OR -----------
    a = 64'hFFFF_0000_FFFF_0000;
    b = 64'h0000_FFFF_0000_FFFF;
    ALUControl = OR;
    assert (result == 64'hFFFF_FFFF_FFFF_FFFF)
    else $display("1) OR failed");
    #10;

    a = 64'd0;
    b = 64'd0;
    ALUControl = OR;
    assert (result == 64'd0)
    else $display("2) OR failed: 0 | 0 != %d", result);
    #10;

    a = 64'h1234_5678_9ABC_DEF0;
    b = 64'h0000_0000_FFFF_FFFF;
    ALUControl = OR;
    assert (result == 64'h1234_5678_FFFF_FFFF)
    else $display("3) OR failed");
    #10;

    // ----------- PASS_INPUT -----------
    b = 64'hDEAD_BEEF_DEAD_BEEF;
    ALUControl = PASS_INPUT;
    assert (result == 64'hDEAD_BEEF_DEAD_BEEF)
    else $display("1) PASS_INPUT failed");
    #10;

    b = 64'd0;
    ALUControl = PASS_INPUT;
    assert (result == 64'd0)
    else $display("2) PASS_INPUT failed: expected 0");
    #10;

    b = 64'hFFFF_FFFF_FFFF_FFFF;
    ALUControl = PASS_INPUT;
    assert (result == 64'hFFFF_FFFF_FFFF_FFFF)
    else $display("3) PASS_INPUT failed");
    #10;

    $display("TESTS ALU TERMINADOS");

    $finish;
  end

endmodule
