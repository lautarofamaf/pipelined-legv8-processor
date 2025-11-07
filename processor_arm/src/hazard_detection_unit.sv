//
// Módulo: hazard_detection_unit.sv
//
`timescale 1ns / 1ps

module hazard_detection_unit (
    // Registros fuente de la instrucción en etapa ID
    input logic [4:0] ID_rs1,  // (viene de decode.sv)
    input logic [4:0] ID_rs2,  // (viene de decode.sv)

    // Señales de la instrucción en etapa EX
    input logic [4:0] ID_EX_Rd,      // Registro destino (viene de reg ID/EX)
    input logic       ID_EX_MemRead, // (viene de reg ID/EX)

    // Salidas de control de Stall
    output logic PCWrite,    // 0 = Congelar PC
    output logic IFIDWrite,  // 0 = Congelar IF/ID
    output logic Stall       // 1 = Inyectar NOP (burbuja) en ID/EX
);

  logic load_use_hazard;

  // Detectamos hazard si la instrucción en EX está leyendo de memoria (LDUR)
  // y su registro destino (Rd) es una de las fuentes (rs1 o rs2) de la
  // instrucción en ID.
  // Importante: No hacemos stall si la fuente o destino es XZR (5'd31).
  always_comb begin
    if (ID_EX_MemRead && 
            (ID_EX_Rd != 5'd31) &&
           ((ID_EX_Rd == ID_rs1) || (ID_EX_Rd == ID_rs2)))
        begin
      load_use_hazard = 1'b1;
    end else begin
      load_use_hazard = 1'b0;
    end

    // Si hay hazard, detenemos el PC y el registro IF/ID
    PCWrite   = ~load_use_hazard;
    IFIDWrite = ~load_use_hazard;

    // E inyectamos una burbuja (NOP) en el pipeline
    Stall     = load_use_hazard;
  end

endmodule
