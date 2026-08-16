`timescale 1ns/1ps
module tb_uart;
    reg clk;
    reg reset;
    reg wr_uart;
    reg rd_uart;

    reg [7:0]data;
    wire [7:0]out;

    uart uart_uut(
        .clk(clk),
        .reset(reset),
        .wr_uart(wr_uart),
        .rd_uart(rd_uart),
        .data(data),
        .out(out)
    );

    //100 MHz clock
    always #5 clk=~clk;

    initial begin
        reset=1;
        clk=0;
        wr_uart=0;
        rd_uart=0;
        data=0;

        #20

        reset=0;
        wr_uart=1;
        data=8'b11100011;
        #10
        wr_uart=0;

        #1000

        wr_uart=1;
        data=8'b00110011;
        #10
        wr_uart=0;

        #1000
        wr_uart=1;
        data=8'b11000010;
        #10
        wr_uart=0;

        #1000
        wr_uart=1;
        data=8'b00111101;
        #10
        wr_uart=0;

        #500000;

        rd_uart = 1;
        #10;
        rd_uart = 0;

        #100000;

        rd_uart=1;
        #10;
        rd_uart=0;

        #100000
        rd_uart=1;
        #10
        rd_uart=0;

        #100000
        rd_uart=1;
        #10
        rd_uart=0;



        #1000000
        $finish;
    end

    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0, tb_uart);
    end

endmodule
