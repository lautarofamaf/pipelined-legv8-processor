`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2025 06:04:43 PM
// Design Name: 
// Module Name: imem_tb
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


module imem_tb();

    imem#(.N(64)) dut (.addr(addr), .q(q));
    logic [5:0] addr;
    logic [31:0] q;
    
    initial begin
        for (int i = 0; i < 50; i++) begin    
            addr = i;
            #5;        
        end
       $finish;
    end
endmodule
