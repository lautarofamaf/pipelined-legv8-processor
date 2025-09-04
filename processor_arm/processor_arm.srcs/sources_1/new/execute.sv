`timescale 1ns / 1ps

module execute (
    input logic AluSrc,
    input logic [3:0] AluControl,
    input logic [63:0] PC_E,
    input logic [63:0] signImm_E,
    input logic [63:0] readData1_E,
    input logic [63:0] readData2_E,
    output logic [63:0] aluResult_E,
    output logic [63:0] writeData_E,
    output logic [63:0] PCBranch_E,
    output logic zero_E
);

  logic [63:0] salidaDelMultiplexor;
  mux2 mux (
      .d0(readData2_E),
      .d1(signImm_E),
      .s (AluSrc),
      .y (salidaDelMultiplexor)
  );

  adder sumador (
      .addr(PC_E),
      .sum(signImm_E << 2),
      .result(PCBranch_E)
  );

  alu alalu (
      .a(readData1_E),
      .b(salidaDelMultiplexor),
      .ALUControl(AluControl),
      .result(aluResult_E),
      .zero(zero_E)
  );

endmodule
