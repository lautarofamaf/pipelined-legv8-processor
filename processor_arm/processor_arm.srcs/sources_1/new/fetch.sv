`timescale 1ns / 1ps

module fetch (
    input logic PCSrc_F,
    input logic clk,
    input logic reset,
    input logic [63:0] PCBranch_F,
    output logic [63:0] imem_addr_F
);
  logic [63:0] PC;
  logic [63:0] PCPlus4;
  logic [63:0] PCNext;

  flopr #(
      .N(64)
  ) pc (
      .clk(clk),
      .reset(reset),
      .d(PCNext),
      .q(PC)
  );

  mux2 mux (
      .d0(PCPlus4),
      .d1(PCBranch_F),
      .s (PCSrc_F),
      .y (PC)
  );

  adder sumador (
      .adrr  (PC),
      .result(PCPlus4)
  );

  assign imem_addr_F = PC;

endmodule











