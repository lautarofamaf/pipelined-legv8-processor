`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2025 11:39:46 AM
// Design Name: 
// Module Name: maindec_tb
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


module maindec_tb();
    logic [10:0] Op;
    logic Reg2Loc;
    logic ALUSrc;
    logic MemtoReg;
    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic Branch;
    logic [1:0] ALUOp;

    maindec dut(
        .Op(Op),
        .Reg2Loc(Reg2Loc),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    initial begin
        #3;
        Op = 11'b111_1100_0010; // LDUR
        #10;
        Op = 11'b111_1100_0000; // STUR
        #10;
        Op = 11'b101_1010_0101; // CBZ
        #10;
        Op = 11'b100_0101_1000; // ADD
        #10;
        Op = 11'b110_0101_1000; // SUB
        #10;
        Op = 11'b100_0101_0000; // AND
        #10;
        Op = 11'b101_0101_0000; // ORR
        #10;
        Op = 11'b000_0000_0000; // default test
        #10;
        $finish;
    end
endmodule
