`timescale 1ns / 1ps

module adder (
    input  logic [63:0] addr,
    output logic [63:0] result
);

  logic [3:0] ALU_ADD = 4'b0010;  // Codigo suma
  logic dummy_zero;

  alu instancia_alu (
      .a(addr),
      .b(64'd4),
      .ALUControl(ALU_ADD),
      .result(result),
      .zero(dummy_zero)
  );

endmodule
