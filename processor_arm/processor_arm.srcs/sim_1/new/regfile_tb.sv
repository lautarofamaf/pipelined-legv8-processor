`timescale 1ns / 1ps

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
  logic        we3;  // write enable (habilita escritura)
  logic [ 4:0] ra1;  // dirección read address 1
  logic [ 4:0] ra2;  // dirección read address 2
  logic [ 4:0] wa3;  // dirección write address
  logic [63:0] wd3;  // dato a escribir
  logic [63:0] rd1;  // dato leido address 1
  logic [63:0] rd2;  // dato leido address 2

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

  initial begin
    clk = 0;
  end

  initial begin
    for (int i = 0; i < 31; i++) begin

      @(negedge clk);  // ESPERO FLANCO DESCENDENTE
      // en flanco descendente se setea ra1 y ra2
      ra1 = i;
      ra2 = i;
      #0  // ESPERO UN DELTA PARA QUE rd1 Y rd2 SE ACTUALICEN
      if (ra1 == rd1 && ra2 == rd2) $display("OK");
      else $display("ERROR regfile: ra1 = %d, rd1 = %d, ra2 = %d, rd2 = ", ra1, rd1, ra2, rd2);

    end

    // // Veo en el 31
    // ra1 = 31;
    // ra2 = 31;
    // #0;  // NO ES 0, ES UN DELTA (1ps????) TODO: ??????????????????????????????????????????????????? 
    // if (!(rd1 == 64'b0)) $display("Error regfile 2a, rd1 = %0d", rd1);
    // if (!(rd2 == 64'b0)) $display("Error regfile 2b, rd2 = %0d", rd2);

  end





endmodule
