module forwarding_unit (input logic [4:0] id_ex_Rn,
                        input logic [4:0] id_ex_Rm,
                        input logic [4:0] ex_mem_Rd,
                        input logic [4:0] mem_wb_Rd,
                        input logic ex_mem_regWrite,
                        input logic mem_wb_regWrite,
                        output logic [1:0] forward_A,
                        output logic [1:0] forward_B);  

    localparam int XZR = 5'd31;

    always_comb begin
        forward_A = 2'b00;
        forward_B = 2'b00;

        
        if (    // EX hazard
            ex_mem_regWrite &&
            ex_mem_Rd != XZR &&
            ex_mem_Rd == id_ex_Rn
        ) begin
            forward_A = 2'b10;
        end
        else if (// MEM hazard
            mem_wb_regWrite &&
            mem_wb_Rd != XZR &&
            mem_wb_Rd == id_ex_Rn
        ) begin
            forward_A = 2'b01;
        end
        
        if (    // EX hazard
            ex_mem_regWrite &&
            ex_mem_Rd != XZR &&
            ex_mem_Rd == id_ex_Rm
        ) begin
            forward_B = 2'b10;
        end
        else if (// MEM hazard
            mem_wb_regWrite &&
            mem_wb_Rd != XZR &&
            mem_wb_Rd == id_ex_Rm
        ) begin
            forward_B = 2'b01;
        end

    end
endmodule;


/*
ForwardA = 00 ID/EX The first ALU operand comes from the register file.
ForwardA = 10 EX/MEM The first ALU operand is forwarded from the prior ALU result.
ForwardA = 01 MEM/WB The first ALU operand is forwarded from data memory or an earlier ALU result.

ForwardB = 00 ID/EX The second ALU operand comes from the register file.
ForwardB = 10 EX/MEM The second ALU operand is forwarded from the prior ALU result.
ForwardB = 01 MEM/WB The second ALU operand is forwarded from data memory or an earlier ALU result.
*/