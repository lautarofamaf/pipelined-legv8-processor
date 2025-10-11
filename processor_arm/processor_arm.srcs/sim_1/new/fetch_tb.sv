`timescale 1ns / 1ps

module fetch_tb ();
  logic PCSrc_F;
  logic clk;
  logic reset;
  logic [63:0] PCBranch_F;
  logic [63:0] imem_addr_F;

  fetch dut (  // fetch instanciado
      .PCSrc_F(PCSrc_F),
      .clk(clk),
      .reset(reset),
      .PCBranch_F(PCBranch_F),
      .imem_addr_F(imem_addr_F)
  );

  // Clock
  initial begin  // fuerzo que comience con un flanco descendente
    clk = 1;
    #0;
    clk = 0;
  end
  always #5 clk = ~clk;  // clock de 10ns

  initial begin
    $display("---------- TESTS FETCH ----------");

    // Seteo reset en 1
    @(negedge clk);
    reset = 1;
    PCBranch_F = 64'hDEAD_BEEF_DEAD_BEEF;
    PCSrc_F = 64'b0;

    // Espero durante 5 ciclos de clock
    repeat (5) @(posedge clk);

    // En el sig ciclo (6)
    @(negedge clk);
    reset = 0;
    repeat (5) @(posedge clk);

    // Ver que si PCSrc_F = 1 hago el salto
    @(negedge clk);
    PCSrc_F = 1;
    @(posedge clk);
    #1;  // tiempo para actualizar cables

    $display("---------- TESTS FETCH DONE ----------");
    @(negedge clk) $finish;
  end

endmodule
