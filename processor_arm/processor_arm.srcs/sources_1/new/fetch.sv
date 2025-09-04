`timescale 1ns / 1ps

module fetch (
    input  logic        PCSrc_F,
    input  logic        clk,
    input  logic        reset,
    input  logic [63:0] PCBranch_F,
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
  flopr #(64) pc (
      .d(PCNext),
      .clk(clk),
      .reset(reset),
      .q(PC)
  );

  // adder suma 4
  adder sumador (
      .addr(PC),
      .sum(64'd4),
      .result(PCPlus4)
  );

  // salida hacia memoria de instrucciones
  assign imem_addr_F = PC;

endmodule
