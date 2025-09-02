`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 11:14:51 AM
// Design Name: 
// Module Name: regfile
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


module regfile(
        input logic clk,
        input logic we3,
        input logic [4:0] ra1,
        input logic [4:0] ra2,
        input logic [4:0] wa3,
        input logic [63:0] wd3,
        output logic [63:0] rd1,
        output logic [63:0] rd2
    );

    logic [63:0] registers [31:0];
    initial begin
        for (int i = 0 ; i < 31 ; i++) begin
            registers[i] = i;
        end
        registers[31] = 64'd0;
    end

    
    if (we3 == 5'b00001 & clk == 1'b1) begin
        
    end

endmodule
