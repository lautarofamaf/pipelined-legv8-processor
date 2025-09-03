`timescale 1ns / 1ps

// `define fore(i,a,b) for (int i = a; i < b; i++)

module regfile_tb ();
  logic clk = 0;  // pinta inicializar el clock en 0

  // Clock de ciclo 10ns
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  // inputs/outputs de regfile
  logic        we3;
  logic [ 4:0] ra1;
  logic [ 4:0] ra2;
  logic [ 4:0] wa3;
  logic [63:0] wd3;
  logic [63:0] rd1;
  logic [63:0] rd2;

  // Instancio regfile con estos valores
  regfile dut (
      .we3(we3),
      .ra1(ra1),
      .ra2(ra2),
      .wa3(wa3),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
  );

  initial begin  // initial == secuencial tipo C
    for (int i = 0; i < 31; i++) begin
      // ---------------------
      // Zona flanco positivo
      ra1 = i;
      ra2 = i;
      // ---------------------
      #5;
      // ---------------------
      // Zona flanco negativo
      // En el registro i tengo el numero i, por eso hago este chequeo
      if (ra1 != rd1) $display("Error regfile 1");
      #5;
      // ---------------------
    end
    // Veo en el 31
    ra1 = 31;
    ra2 = 31;
    #0;  // NO ES 0, ES UN DELTA (1ps????) TODO: ??????????????????????????????????????????????????????????????????????????????????
    if (!(ra1 == 31 && rd1 == 64'b0)) $display("Error regfile 2a, ra1 = %0d, rd1 = %0d", ra1, rd1);
    if (!(ra2 == 31 && rd2 == 64'b0)) $display("Error regfile 2b, ra2 = %0d, rd2 = %0d", ra2, rd2);

  end





endmodule
