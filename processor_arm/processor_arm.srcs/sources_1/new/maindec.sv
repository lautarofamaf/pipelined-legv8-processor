`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2025 11:07:17 AM
// Design Name: 
// Module Name: maindec
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


module maindec(
        input logic [10:0] Op,
        output logic Reg2Loc,
        output logic ALUSrc,
        output logic MemtoReg,
        output logic RegWrite,
        output logic MemRead,
        output logic MemWrite,
        output logic Branch,
        output logic [1:0] ALUOp
    );

    always_comb begin
        Reg2Loc  = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00; 

        case (Op)
            11'b111_1100_0010: begin // LDUR
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
            end
            11'b111_1100_0000: begin // STUR
                Reg2Loc  = 1'b1;
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
            end
            default : begin
                if (Op[10:3] == 8'b101_1010_0) begin // CBZ
                    Reg2Loc  = 1'b1;
                    Branch   = 1'b1;
                    ALUOp    = 2'b01;
                end
                if (Op[7:4] == 4'b0101) begin // R-format
                    ALUSrc   = 1'b0;
                    RegWrite = 1'b1;
                    ALUOp    = 2'b10;
                end
            end
        endcase
    end
endmodule