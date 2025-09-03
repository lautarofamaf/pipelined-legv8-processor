`timescale 1ns / 1ps

module imem_tb ();

  imem #(
      .N(64)
  ) dut (
      .addr(addr),
      .q(q)
  );
  logic [ 5:0] addr;
  logic [31:0] q;

  initial begin
    for (int i = 0; i < 50; i++) begin
      addr = i;
      #5;
    end
    $finish;
  end
endmodule
