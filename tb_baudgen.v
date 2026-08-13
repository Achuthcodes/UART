`timescale 1ns/1ps
module tb_baudgen;

    reg clk;
    reg reset;
    reg [10:0] dvsr;
    wire tick;

    baudgen uut ( //Unit Under Test
        .clk(clk),
        .reset(reset),
        .dvsr(dvsr),
        .tick(tick)
    );

    // Generate clock
    always #5 clk = ~clk; //100 MHz clock (T=1ns*5*2=10ns so f=1/10ns=100*10^5=10M)

    initial begin
        clk = 0;
        reset = 1;
        dvsr = 54; //54 clock cycles between two ticks
        //dvsr=100M/(16*115200) -1 =53
        //WE ARE USING BAUD RATE OF 115200

        #20; //wait for 20ns
        reset = 0;

        #20000; //finish at 220 ns
        $finish;
    end

    // Generate waveform
    initial begin
        $dumpfile("baud.vcd");
        $dumpvars(0, tb_baudgen);
    end

endmodule
