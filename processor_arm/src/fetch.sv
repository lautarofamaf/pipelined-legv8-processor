`timescale 1ns / 1ps

module fetch (
    input  logic        PCSrc_F,
    input  logic        clk,
    input  logic        reset,
    input  logic [63:0] PCBranch_F,
    input  logic enable,
    output logic [63:0] imem_addr_F
);
  logic [63:0] PC;  // salida del registro
  logic [63:0] PCNext;  // salida del mux
  logic [63:0] PCPlus4;  // salida del adder

  // mux decide entre PC+4 y la dirección de branch
  mux2 mux (
      .d0(PCPlus4),
      .d1(PCBranch_F),
      .s (PCSrc_F),
      .y (PCNext)
  );

  // registro PC
  flopre #(64) pc (
      .d(PCNext),
      .enable(enable),
      .clk(clk),
      .reset(reset),
      .q(PC)
  );

  // adder suma 4
  adder sumador (
      .a(PC),
      .b(64'd4),
      .y(PCPlus4)
  );

  // salida hacia memoria de instrucciones
  assign imem_addr_F = PC;

endmodule
