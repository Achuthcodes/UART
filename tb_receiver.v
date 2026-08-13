`timescale 1ns/1ps
module tb_receiver;
    reg clk;
    reg reset;
    reg rx;
    reg [10:0]dvsr;
    wire s_tick;
    wire rx_done_tick;
    wire [7:0]d_out;

    receiver receiver_uut(
        .clk(clk),
        .reset(reset),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .d_out(d_out),
        .rx(rx)
    );
    baudgen baudgen_uut(
        .tick(s_tick),
        .reset(reset),
        .dvsr(dvsr),
        .clk(clk)
    );

    //Generate clock
    always #5 clk=~clk; //100MHz clk

    initial begin
        clk = 0;
        reset = 1;
        dvsr=53; //54 clock cycles between two ticks
        rx=1;
        //wait 20 ns
        #20
        reset=0;
        rx=1; //some test data
        #8640 // time period between two bits
        rx=1;
        #8640
        rx=0;
        #8640
        rx=1;
        #8640
        rx=0;
        #8640
        rx=0;
        #8640
        rx=1;
        #8640
        rx=1;
        #8640
        rx=0;
        #8640
        rx=1;
        #8640
        rx=0;
        #8640
        rx=1;
        #8640
        #8640
        $finish;


        
        //WE ARE USING ~115741 BAUD
    end

    //Generate waveform
    initial begin
        $dumpfile("receiver.vcd");
        $dumpvars(0, tb_receiver);
    end

endmodule
    
    




