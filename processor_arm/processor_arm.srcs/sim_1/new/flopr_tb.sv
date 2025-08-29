`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2025 10:28:20 AM
// Design Name: 
// Module Name: flopr_tb
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


module flopr_tb ();
 logic clk, reset;
 logic [63:0] q, d;

always 
    begin 
        clk=1; #5; clk=0; #5;
    end

// instancio flopr usando el parametro 
flopr #(.N(64)) dut (.clk(clk), .reset(reset), .d(d), .q(q));
// apply inputs one at a time:
initial begin
    #3;
    reset=1'b1;

    d=64'd0;#10;
    d=64'd1;#10;
    d=64'd2;#10;
    d=64'd3;#10;
    d=64'd4;#10;

    reset=1'b0;
    d=64'd6;#10;
    d=64'd7;#10;
    d=64'd8;#10;
    d=64'd9;#10;
    $finish;
end
endmodule
