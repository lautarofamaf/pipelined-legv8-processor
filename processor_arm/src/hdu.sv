module hdu (input logic id_ex_memRead,
            input logic [4:0] id_ex_Rd,
            input logic [4:0] if_id_Rn1,
            input logic [4:0] if_id_Rn2,
            output logic stall);  

    localparam int XZR = 5'd31;

    always_comb begin
        stall = 1'b0;
        if (id_ex_memRead &&
            id_ex_Rd != XZR &&
           ((id_ex_Rd == if_id_Rn1) || (id_ex_Rd == if_id_Rn2))
        )
        begin
            stall = 1'b1;
        end
    end
endmodule;
