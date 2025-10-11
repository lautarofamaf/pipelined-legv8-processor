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
  logic [3:0] PASS_INPUT_B = 4'b0111;

  // automatic --> variables viven y mueren en cada llamada
  task automatic check(input logic [63:0] aval, input logic [63:0] bval, input logic [3:0] op,
                       input logic [63:0] expected, string msg);
    begin
      a = aval;
      b = bval;
      ALUControl = op;
      #1;  // ESPERO UN NS PARA QUE EL RESULT SE POPULE
      assert (result == expected)
      else $display("ERROR con %s!!! Tuve: %0d, y esperaba: %0d", msg, result, expected);

      assert (zero == (result == 64'b0))
      else
        $display(
            "ERROR con %s!!! Tenia que tener zero flag = %d y tiene zero = %d",
            msg,
            result == 64'b0,
            zero
        );
      #9;  // completar 10ns
    end
  endtask

  initial begin
    // ----------- ADD -----------
    // 1: Dos numeros positivos
    check(2, 15, ADD, 17, "ADD 2 + 15");

    // 2: Dos numeros negativos
    check(-64'd50, -64'd25, ADD, -64'd75, "ADD -50 + -25");

    // 3: Uno positivo y otro negativo
    check(64'd1, -64'd3, ADD, -64'd2, "ADD 1 + (-3)");

    // 4: Uno negativo y otro positivo
    check(-64'd5, 64'd3, ADD, -64'd2, "ADD -5 + 3");

    // ----------- SUB -----------
    // 1: Dos numeros positivos
    check(64'd5, 64'd2, SUB, 64'd3, "SUB 5-2");

    // 2: Dos numeros negativos
    check(-64'd2, -64'd5, SUB, 64'd3, "SUB -2 - (-5)");

    // 3: Uno positivo y otro negativo
    check(64'd1, -64'd3, SUB, 64'd4, "SUB 1 - (-3)");

    // 4: Uno negativo y otro positivo
    check(-64'd5, 64'd2, SUB, -64'd7, "SUB -5 - 2");

    // ----------- AND -----------
    check(64'hFFFF_FFFF_FFFF_FFFF, 64'h0F0F_0F0F_0F0F_0F0F, AND, 64'h0F0F_0F0F_0F0F_0F0F,
          "AND mask full");

    check(64'h1234_5678_9ABC_DEF0, 64'hFFFF_0000_FFFF_0000, AND, 64'h1234_0000_9ABC_0000,
          "AND half mask");

    check(64'd0, 64'd0, AND, 64'd0, "AND 0&0");

    // ----------- OR -----------
    check(64'hFFFF_0000_FFFF_0000, 64'h0000_FFFF_0000_FFFF, OR, 64'hFFFF_FFFF_FFFF_FFFF,
          "OR combine");

    check(64'd0, 64'd0, OR, 64'd0, "OR 0|0");

    check(64'h1234_5678_9ABC_DEF0, 64'h0000_0000_FFFF_FFFF, OR, 64'h1234_5678_FFFF_FFFF,
          "OR fill low");

    // ----------- PASS_INPUT_B -----------
    check(64'd0, 64'hDEAD_BEEF_DEAD_BEEF, PASS_INPUT_B, 64'hDEAD_BEEF_DEAD_BEEF, "PASS B");

    check(64'd0, 64'd0, PASS_INPUT_B, 64'd0, "PASS 0");

    check(64'd0, 64'hFFFF_FFFF_FFFF_FFFF, PASS_INPUT_B, 64'hFFFF_FFFF_FFFF_FFFF, "PASS all ones");

    // ----------- ZERO FLAG -----------
    // 1) ADD que da 0
    check(-5, 5, ADD, 64'd0, "ADD -5 + 5");

    // // 2) SUB que da 0
    check(10, 10, SUB, 64'd0, "SUB 10 - 10");
    //
    // // 3) AND que da 0
    check(64'hFF00, 64'h00FF, AND, 64'd0, "AND 0");
    //
    // // 4) OR que da 0
    check(64'd0, 64'd0, OR, 64'd0, "OR 0");
    //
    // // 5) PASS_INPUT B que da 0
    check(64'd123, 64'd0, PASS_INPUT_B, 64'd0, "PASS_INPUT 0");

    $finish;
  end

endmodule
