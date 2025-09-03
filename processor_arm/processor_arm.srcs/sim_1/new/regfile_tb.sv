`timescale 1ns / 1ps

module regfile_tb ();

  // Inputs/outputs
  logic        clk;
  logic        we3;
  logic [ 4:0] ra1;
  logic [ 4:0] ra2;
  logic [ 4:0] wa3;
  logic [63:0] wd3;
  logic [63:0] rd1;
  logic [63:0] rd2;

  // Clock de 10ns -> 100MHz
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  // Instancio regfile
  regfile dut (
      .clk(clk),
      .we3(we3),
      .ra1(ra1),
      .ra2(ra2),
      .wa3(wa3),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
  );

  // Si addr = ra1 = ra2 chequeo que registros[addr] = rd1 = rd2 = data_expected
  task automatic check_rd(input logic [4:0] addr, input logic [63:0] data_expected);
    begin
      ra1 = addr;
      ra2 = addr;
      #0;  // delta para que rd1 y rd2 se actualicen
      assert (rd1 == data_expected || rd2 == data_expected)
        $display(
            "ERROR: ra1=%0d rd1=%0d, ra2=%0d rd2=%0d, esperado=%0d",
            addr,
            rd1,
            addr,
            rd2,
            data_expected
        );
      else $display("OK: ra1=%0d rd1=%0d, ra2=%0d rd2=%0d", addr, rd1, addr, rd2);
    end
  endtask

  initial begin
    $display("---------- TEST REGFILE ----------");
    // ------------------------------------------------

    // 2 - Leo registros 0..30
    logic [ 4:0] addr;
    logic [63:0] data_expected;
    for (int i = 0; i < 31; i++) begin
      @(negedge clk);  // en el flanco negativo del clock
      addr = i;
      data_expected = i;
      check_rd(addr, data_expected);  // chequeo que registro[i] = i
    end

    // Leo XZR (31)
    @(negedge clk);
    check_rd(31, 64'b0);  // chequeo que registro[XZR] = 64'b0

    // ------------------------------------------------

    // 3 - Escribo 12345 en R5 y lo leo desde ra1 y ra2 en el mismo ciclo
    @(posedge clk);  // en el flanco positivo del clock

    // Escribo (we = 1) el dato 12345 en el registro R5
    we3 = 1;
    wa3 = 5'd5;
    wd3 = 64'd1234;

    // Leo desde ra1 y ra2 el registro R5
    ra1 = 5'd5;
    ra2 = 5'd5;

    #0;  // dejo actualizar rd1 y rd2

    if (rd1 == 64'd1234 && rd2 == 64'd1234)
      $display("OK escritura/lectura en el registro anda (mismo ciclo)");
    if (rd1 != 64'd1234 || rd2 != 64'd1234)
      $display("ERROR escritura/lectura en el registro NO ANDA (mismo ciclo)");

    // ------------------------------------------------

    // 4 - Si we=0 no-escribo el dato 9999 en el registro R5
    @(posedge clk);
    // No-escribo (we = 0) el dato 9999 en el registro R5
    we3 = 0;
    wa3 = 5'd5;
    wd3 = 64'd9999;

    // Leo desde ra1 y ra2 el registro R5
    ra1 = 5'd5;
    ra2 = 5'd5;

    #0;  // Dejo actualizar rd1 y rd2

    if (rd1 == 64'd1234 && rd2 == 64'd1234) $display("OK registro no cambia con we3=0");
    if (rd1 != 64'd1234 || rd2 != 64'd1234) $display("ERROR registro CAMBIO con we3=0");

    // ------------------------------------------------
    // 5 - Intento escribir en XZR
    @(posedge clk);
    // Intento escribir el dato 5555 en R31 = XZR
    we3 = 1;
    wa3 = 5'd31;
    wd3 = 64'd5555;

    // Leo desde ra1 y ra2 el registro R31 = XZR
    ra1 = 5'd31;
    ra2 = 5'd31;

    #0;  // Dejo actualizar rd1 y rd2

    if (rd1 == 0 && rd2 == 0) $display("OK XZR permanece 0");
    if (rd1 != 0 || rd2 != 0) $display("ERROR XZR NO VALE 0!");

    $display("---------- TEST REGFILE DONE ----------");
    $finish;
  end

endmodule
