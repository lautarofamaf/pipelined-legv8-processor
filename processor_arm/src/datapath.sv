// DATAPATH

module datapath #(parameter N = 64)
					(input logic reset, clk,
					input logic reg2loc,									
					input logic AluSrc,
					input logic [3:0] AluControl,
					input logic	Branch,
					input logic memRead,
					input logic memWrite,
					input logic regWrite,	
					input logic memtoReg,									
					input logic [31:0] IM_readData,
					input logic [N-1:0] DM_readData,
					output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
					output logic DM_writeEnable, DM_readEnable );					
					
	logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] signImm_D, readData1_D, readData2_D;
	logic zero_E;
	logic [95:0] qIF_ID;
	logic [286:0] qID_EX;
	logic [202:0] qEX_MEM;
	logic [134:0] qMEM_WB;
	logic [5:0] shamt;
	logic [1:0] forward_A;
	logic [1:0] forward_B;
	logic [4:0] rs1_D;
	logic [4:0] rs2_D;
	logic [N-1:0] readData1_E, readData2_E;
	
	fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
										.clk(clk),
										.reset(reset),
										.PCBranch_F(qEX_MEM[197:134]),
										.imem_addr_F(IM_addr));								
					
	
	flopr 	#(96)		IF_ID 	(.clk(clk),
										.reset(reset), 
										.d({IM_addr, IM_readData}),
										.q(qIF_ID));
										
	
	decode 	#(64) 	DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc), 
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]), 
										.signImm_D(signImm_D), 
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.wa3_D(qMEM_WB[4:0]),
										.shamt(shamt),
										.rs1_D(rs1_D),
										.rs2_D(rs2_D));				
																									
									
	flopr 	#(287)	ID_EX 	(.clk(clk),
										.reset(reset), 
										.d({rs1_D, rs2_D, shamt, AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg,	
											qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));	
	
	mux4 muxA (
	.d0(qID_EX[132:69]), // normal
	.d1(writeData3), // forwarding memory
	.d2(qEX_MEM[132:69]), // forwarding alu
	.d3(64'b0),
	.s(forward_A),
	.y(readData1_E));

	mux4 muxB (
	.d0(qID_EX[68:5]),
	.d1(writeData3),
	.d2(qEX_MEM[132:69]),
	.d3(64'b0),
	.s(forward_B),
	.y(readData2_E));


	execute 	#(64) 	EXECUTE 	(.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]), 
										.signImm_E(qID_EX[196:133]), 
										.readData1_E(readData1_E), 
										.readData2_E(readData2_E), 
										.shamt(qID_EX[276:271]),
										.PCBranch_E(PCBranch_E), 
										.aluResult_E(aluResult_E), 
										.writeData_E(writeData_E), 
										.zero_E(zero_E));											
											

	forwarding_unit FORWARDING_UNIT (.id_ex_Rn(qID_EX[286:282]),
                        				.id_ex_Rm(qID_EX[281:277]),
                        				.ex_mem_Rd(qEX_MEM[4:0]),
										.mem_wb_Rd(qMEM_WB[4:0]),
										.ex_mem_regWrite(qEX_MEM[199]),
										.mem_wb_regWrite(qMEM_WB[134]),
										.forward_A(forward_A),
										.forward_B(forward_B));


	flopr 	#(203)	EX_MEM 	(.clk(clk),
										.reset(reset), 
										.d({qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));	
	
										
	memory				MEMORY	(.Branch_M(qEX_MEM[202]), 
										.zero_M(qEX_MEM[133]), 
										.PCSrc_M(PCSrc));		
	
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr 	#(135)	MEM_WB 	(.clk(clk),
										.reset(reset), 
										.d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));
		
	
	writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[133]), 
										.writeData3_W(writeData3));		
		
endmodule
