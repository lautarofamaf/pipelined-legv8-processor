`timescale 1ns / 1ps

module flopre_tb ();

  // Señales de prueba
  logic        clk;
  logic        reset;
  logic        enable;  // <-- Señal nueva a probar
  logic [63:0] d;  // Entrada de datos
  logic [63:0] q;  // Salida del registro

  // Generador de clock (10ns de período / 100MHz)
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  // Instanciar el DUT (Device Under Test)
  flopre #(
      .N(64)
  ) dut (
      .clk(clk),
      .reset(reset),
      .enable(enable),  // <-- Conectar enable
      .d(d),
      .q(q)
  );

  // Lógica del Test
  initial begin
    $display("---------- TEST FLOPRE (Flip-Flop con Enable) ----------");

    // 1. Estado Inicial y Test de Reset Asíncrono
    $display("Test 1: Reset Asíncrono (reset = 1)");
    @(negedge clk);
    reset = 1;
    enable = 1;  // Enable alto no debe afectar al reset
    d = 64'hAAAA;
    @(posedge clk);
    #1;  // Dejar que la señal se propague
    assert (q == 64'b0)
    else $display("ERROR: Reset (enable=1) falló. q=%h", q);

    @(negedge clk);
    d = 64'hBBBB;
    enable = 0;  // Enable bajo tampoco debe afectar al reset
    @(posedge clk);
    #1;
    assert (q == 64'b0)
    else $display("ERROR: Reset (enable=0) falló. q=%h", q);

    // 2. Quitar Reset - Modo Habilitado (enable = 1)
    $display("Test 2: Modo Habilitado (reset = 0, enable = 1)");
    @(negedge clk);
    reset = 0;  // Quitar reset
    enable = 1;  // Habilitar
    d = 64'd123;

    @(posedge clk);  // Flanco 1
    #1;
    assert (q == 64'd123)
    else $display("ERROR: Carga (enable=1) falló. q=%d", q);

    @(negedge clk);
    d = 64'd456;

    @(posedge clk);  // Flanco 2
    #1;
    assert (q == 64'd456)
    else $display("ERROR: Carga 2 (enable=1) falló. q=%d", q);

    // 3. Modo Deshabilitado / Congelado (enable = 0)
    $display("Test 3: Modo Congelado (reset = 0, enable = 0)");
    @(negedge clk);
    enable = 0;  // Deshabilitar (congelar)
    d = 64'hDEADBEEF;  // Nuevo dato de entrada que debe ser ignorado

    // q debería mantener 456
    @(posedge clk);  // Flanco 3
    #1;
    assert (q == 64'd456)
    else $display("ERROR: Congelado (enable=0) falló. q=%d, esperaba 456", q);

    @(negedge clk);
    d = 64'hCAFE;  // Otro dato de entrada que debe ser ignorado

    // q debería AÚN mantener 456
    @(posedge clk);  // Flanco 4
    #1;
    assert (q == 64'd456)
    else $display("ERROR: Congelado 2 (enable=0) falló. q=%d, esperaba 456", q);

    // 4. Reactivación (enable = 1)
    $display("Test 4: Reactivación (enable = 1)");
    @(negedge clk);
    enable = 1;  // Reactivar
    d = 64'd789;  // Este dato sí debe cargarse

    @(posedge clk);  // Flanco 5
    #1;
    assert (q == 64'd789)
    else $display("ERROR: Reactivación falló. q=%d, esperaba 789", q);

    $display("---------- TEST FLOPRE DONE ----------");
    $finish;
  end

endmodule
