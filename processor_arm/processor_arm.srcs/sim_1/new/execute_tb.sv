`timescale 1ns / 1ps

module execute_tb ();

  logic AluSrc;
  logic [3:0] AluControl;
  logic [63:0] PC_E;
  logic [63:0] signImm_E;
  logic [63:0] readData1_E;
  logic [63:0] readData2_E;
  logic [63:0] aluResult_E;
  logic [63:0] writeData_E;
  logic [63:0] PCBranch_E;
  logic zero_E;

  execute dut (
      .AluSrc(AluSrc),
      .AluControl(AluControl),
      .PC_E(PC_E),
      .signImm_E(signImm_E),
      .readData1_E(readData1_E),
      .readData2_E(readData2_E),
      .aluResult_E(aluResult_E),
      .writeData_E(writeData_E),
      .PCBranch_E(PCBranch_E),
      .zero_E(zero_E)
  );


  logic [3:0] AND = 4'b0000;
  logic [3:0] OR = 4'b0001;
  logic [3:0] ADD = 4'b0010;
  logic [3:0] SUB = 4'b0110;
  logic [3:0] PASS_INPUT_B = 4'b0111;

  logic clk = 0;

  // Clock de 5ns
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $display("---------- TESTS EXECUTE  ----------");

    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'b0;
    AluControl = AND;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'b0;
    AluControl = OR;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'b0;
    AluControl = ADD;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'b0;
    AluControl = SUB;
    @(posedge clk);

    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'b0;
    AluControl = PASS_INPUT_B;
    @(posedge clk);

    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'd1;
    AluControl = AND;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'd1;
    AluControl = OR;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'd1;
    AluControl = ADD;
    @(posedge clk);


    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'd1;
    AluControl = SUB;
    @(posedge clk);

    @(negedge clk);
    PC_E = 64'd1;
    signImm_E = 64'd2;
    readData1_E = 64'd3;
    readData2_E = 64'd4;
    AluSrc = 1'd1;
    AluControl = PASS_INPUT_B;
    @(posedge clk);

    $display("---------- TESTS EXECUTE DONE ----------");

    @(negedge clk);
    $finish;
  end


endmodule
