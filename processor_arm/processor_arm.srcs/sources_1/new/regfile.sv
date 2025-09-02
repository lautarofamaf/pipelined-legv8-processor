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
        input  logic clk,
        input  logic we3,
        input  logic ra1,
        input  logic ra2,
        input  logic wa3,
        input  logic wd3,
        output logic rd1,
        output logic rd2
    );

    logic [63:0] registers [31:0];
    initial begin
        for (int i = 0 ; i < 31 ; i++) begin
            registers[i] = i;
        end
        registers[31] = 64'd0;
    end

endmodule
