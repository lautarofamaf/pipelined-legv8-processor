// Etapa: DECODE

module decode #(parameter N = 64)
					(input logic regWrite_D, reg2loc_D, clk,
					input logic [N-1:0] writeData3_D,
					input logic [31:0] instr_D,
					output logic [N-1:0] signImm_D, readData1_D, readData2_D, 
					input logic [4:0] wa3_D,
					output logic [5:0] shamt,
					output logic [4:0] rs1_D,
    				output logic [4:0] rs2_D,
					input logic id_ex_memRead,
					input logic [4:0] id_ex_Rd,
					input logic [4:0] if_id_Rn1,
					input logic [4:0] if_id_Rn2,
					output logic stall);
					
	logic [4:0] ra2;			
	assign shamt = instr_D[15:10];
	assign rs1_D = instr_D[9:5];
	assign rs2_D = ra2;

	mux2 	#(5) 	ra2mux	(.d0(instr_D[20:16]), .d1(instr_D[4:0]), .s(reg2loc_D), .y(ra2));
	
	regfile 		registers(.clk(clk), .we3(regWrite_D), .ra1(instr_D[9:5]), .ra2(ra2), .wa3(wa3_D), 
								 .wd3(writeData3_D), .rd1(readData1_D), .rd2(readData2_D));
									
	signext 		ext		(.a(instr_D), .y(signImm_D));	

	
	hdu HDU (.id_ex_memRead(id_ex_memRead),
				.id_ex_Rd(id_ex_Rd),
				.if_id_Rn1(if_id_Rn1),
				.if_id_Rn2(if_id_Rn2),
				.stall(stall));																				
										
endmodule
