`timescale 1ns / 1ps

module regfile (
    input  logic        clk,  // reloj
    input  logic        we3,  // write enable (habilita escritura)
    input  logic [ 4:0] ra1,  // dirección read address 1
    input  logic [ 4:0] ra2,  // dirección read address 2
    input  logic [ 4:0] wa3,  // dirección write address
    input  logic [63:0] wd3,  // dato a escribir
    output logic [63:0] rd1,  // dato leído address 1
    output logic [63:0] rd2   // dato leído address 2
);

  // N (= 32) registros de 64bits
  localparam int N = 32;
  logic [63:0] registers[N];


  // Inicializo el registro[i] en [i] para i = 0...30
  // registro[31] = XZR = 0
  localparam int XZRContent = 64'b0;
  initial begin
    for (int i = 0; i < 31; i++) begin
      registers[i] = i;
    end
    registers[31] = XZRContent;
  end

  // data = registro[direccion]
  always_comb begin
    rd1 = registers[ra1];
    rd2 = registers[ra2];
  end

  // ESTO ES EQUIVALENTE       <-- TODO: Gonzalo
  // assign rd1 = registers[ra1];
  // assign rd2 = registers[ra2];

  // always_ff @(posedge clk) begin
  //   if (we3 && wa3 != 5'd31) begin
  //     registers[wa3] <= wd3;
  //   end
  // end

  // Que se yo, hago mi funcion
  always_ff @(posedge clk) begin
    logic        writeEnable = we3;
    logic [ 4:0] writeAddress = wa3;
    logic [63:0] writeData = wd3;
    localparam int XZR = 5'd31;

    if (writeEnable && writeAddress != XZR) begin
      registers[writeAddress] <= writeData;
    end
  end


endmodule
