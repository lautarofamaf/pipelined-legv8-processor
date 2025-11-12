// Testbench for processorPatterson
// Top-level Entity: processor_arm
module leds_tb();
    localparam N = 64;
    logic [15:0] i_sw, o_led;
    logic [7:0] D0_seg, D1_seg;
    logic [3:0] D0_a, D1_a;
    logic i_mclk, i_reset;
    logic dump;

    // instantiate device under test
    processor_arm dut ( .i_sw(i_sw), .i_mclk(i_mclk), 
                        .i_reset(i_reset), .o_led(o_led), .D0_seg(D0_seg), 
                        .D1_seg(D1_seg), .D0_a(D0_a), .D1_a(D1_a), .dump(dump));

    // generate clock
    always  // no sensitivity list, so it always executes
    begin
        #5 i_mclk = ~i_mclk; // Reloj de 10ns (100 MHz)
    end

    // 1. iniciar con contraseña incorrecta (0x0000)
    // 2. probar otra contraseña incorrecta (0x000F)
    // 3. ingresar la contraseña correcta (0x8889) y ver la animacion
    initial
    begin
        i_mclk = 0;
        i_reset = 1;
        dump = 0;
        // 1
        i_sw = 16'h0000;
        #20 i_reset = 0;
        
        // procesador en PASSWORD_LOOP
        #500; 
        
        // 2.
        i_sw = 16'h000F;
        
        // sigue en PASSWORD_LOOP
        #500

        // 3. contraseña correcta (sw[15], sw[11], sw[7], sw[3], s[0]) == (1000 1000 1000 1001)
        i_sw = 16'h8889; 
        
        // procesador en ANIMATION_LOOP
        #50000;

        #20;
        $stop;
    end
endmodule