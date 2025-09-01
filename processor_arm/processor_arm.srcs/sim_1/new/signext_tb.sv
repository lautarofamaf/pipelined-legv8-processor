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


module signext_tb ();
  logic [63:0] y;
  logic [31:0] a;

  signext dut (
      .a(a),
      .y(y)
  );

  // apply inputs one at a time:
  initial begin
    #3;
    // ---------- LDUR ----------
    // LDUR X1, [X2, #8]
    //    'b1111_1000_010| <-- OPCODE LDUR OK
    a = {11'b11111000010, 9'b000001000, 2'b00, 5'b00010, 5'b00001};
    #10
    // LDUR X3, [X4, #-4]
    a = 32'b11111000010_111111100_00_00100_00011;
    #10
    // ---------- STUR ----------
    // STUR X5, [X6, #16]
    a = 32'b11111000000_000010000_00_00110_00101;
    #10
    // STUR X7, [X8, #-3]
    a = 32'b11111000000_111111101_00_01000_00111;
    #10
    // ---------- CBZ ----------
    // CBZ X9, #32
    a = 32'b10110100000_0000000000100000_01001;
    #10
    // CBZ X10, #-4
    a = 32'b10110100111_1111111111111100_01010;

    // OPCODE NADA
    #10 a = 32'b11111100111_1111111111111100_01010;
    #10 $finish;
  end

endmodule
