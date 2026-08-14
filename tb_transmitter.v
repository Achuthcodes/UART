`timescale 1ns/1ps
module tb_transmitter;
    reg clk;
    reg reset;
    wire s_tick;
    reg tx_start;
    reg [7:0]din;
    reg [10:0] dvsr;
    wire tx;
    wire tx_done_tick;

    transmitter transmitter_uut(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .tx_start(tx_start),
        .tx(tx),
        .tx_done_tick(tx_done_tick),
        .din(din)
    );

    baudgen baudgen_uut(
        .clk(clk),
        .reset(reset),
        .dvsr(dvsr),
        .tick(s_tick)
    );
    //Generate clock
    always #5 clk=~clk; //100MHz clock
    initial begin
        clk=0;
        reset=1;
        dvsr=53; //54 clk cycles between two ticks
        
        //wait 20 ns
        #20
        reset=0;
        
        din=8'b11100110; //test data
        tx_start=1;
        #10
        tx_start=0;

        #100000

        $finish;
    end
    initial begin
        $dumpfile("transmitter.vcd");
        $dumpvars(0,tb_transmitter);
    end
endmodule







