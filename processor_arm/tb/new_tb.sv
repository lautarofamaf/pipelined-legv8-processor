// Testbench for processorPatterson
// Top-level Entity: processor_arm
module new_tb();
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
        #5 i_mclk = ~i_mclk;
    end

    initial
    begin
        i_mclk = 0; i_reset = 1; dump = 0;
        #20 i_reset = 0;
        #3000 dump = 1;
        #20 $stop;
    end
endmodule