`timescale 1ns / 1ps

module imem_tb ();
  logic [ 5:0] addr;
  logic [31:0] q;

  imem #(
      .N(64)
  ) dut (
      .addr(addr),
      .q(q)
  );

  logic [31:0] ROM_COPIA[64] = '{
      32'hf8000001,  // palabra 1
      32'hf8008002,  // palabra 2
      32'hf8000203,  // palabra 3
      32'h8b050083,  // palabra 4
      32'hf8018003,  // palabra 5
      32'hcb050083,  // palabra 6
      32'hf8020003,  // palabra 7
      32'hcb0a03e4,  // palabra 8
      32'hf8028004,  // palabra 9
      32'h8b040064,  // palabra 10
      32'hf8030004,  // palabra 11
      32'hcb030025,  // palabra 12
      32'hf8038005,  // palabra 13
      32'h8a1f0145,  // palabra 14
      32'hf8040005,  // palabra 15
      32'h8a030145,  // palabra 16
      32'hf8048005,  // palabra 17
      32'h8a140294,  // palabra 18
      32'hf8050014,  // palabra 19
      32'haa1f0166,  // palabra 20
      32'hf8058006,  // palabra 21
      32'haa030166,  // palabra 22
      32'hf8060006,  // palabra 23
      32'hf840000c,  // palabra 24
      32'h8b1f0187,  // palabra 25
      32'hf8068007,  // palabra 26
      32'hf807000c,  // palabra 27
      32'h8b0e01bf,  // palabra 28
      32'hf807801f,  // palabra 29
      32'hb4000040,  // palabra 30
      32'hf8080015,  // palabra 31
      32'hf8088015,  // palabra 32
      32'h8b0103e2,  // palabra 33
      32'hcb010042,  // palabra 34
      32'h8b0103f8,  // palabra 35
      32'hf8090018,  // palabra 36
      32'h8b080000,  // palabra 37
      32'hb4ffff82,  // palabra 38
      32'hf809001e,  // palabra 39
      32'h8b1e03de,  // palabra 40
      32'hcb1503f5,  // palabra 41
      32'h8b1403de,  // palabra 42
      32'hf85f83d9,  // palabra 43
      32'h8b1e03de,  // palabra 44
      32'h8b1003de,  // palabra 45
      32'hf81f83d9,  // palabra 46
      32'hb400001f,  // palabra 47
      // -------------------------
      32'h00000000,  // palabra 48
      32'h00000000,  // palabra 49
      32'h00000000,  // palabra 50
      32'h00000000,  // palabra 51
      32'h00000000,  // palabra 52
      32'h00000000,  // palabra 53
      32'h00000000,  // palabra 54
      32'h00000000,  // palabra 55
      32'h00000000,  // palabra 56
      32'h00000000,  // palabra 57
      32'h00000000,  // palabra 58
      32'h00000000,  // palabra 59
      32'h00000000,  // palabra 60
      32'h00000000,  // palabra 61
      32'h00000000,  // palabra 62
      32'h00000000,  // palabra 63
      32'h00000000  // palabra   64
  };

  initial begin
    for (int i = 0; i < 64; i++) begin
      addr = i;
      #1  // SUMO UN DELTA PARA QUE q ACTUALICE
      assert (ROM_COPIA[addr] == q)
      else $display("ERROR: imem != ROM en addr = %d", addr);
      #4;
    end
    $finish;
  end
endmodule
