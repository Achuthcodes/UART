`timescale 1ns/1ps
module tb_fifo;
    reg clk;
    reg [7:0]w_data; //Input into the FIFO

    reg reset;
    
    reg wr;//write control signal
    reg rd;//read control signal
    wire  [7:0]r_data; //OUTPUT OF THE FIFO
    wire full; //FIFO is full or not
    wire empty; //FIFO is empty or not


    fifo fifo_uut(
        .clk(clk),
        .reset(reset),
        .wr(wr),
        .w_data(w_data),
        .full(full),
        .empty(empty),
        .rd(rd),
        .r_data(r_data)

    );

    always #5 clk=~clk;

    initial begin
        reset=1;
        clk=0;
        wr=0;
        rd=0;
        #20

        reset=0;
     
        wr=1;
        w_data=8'b10001101;
        #10
        
        wr=1;
        w_data=8'b11110011;
        #10
        
        w_data=8'b11000111;
        #10
        w_data=8'b00111100;
        #10
        wr=0;
        #20
        rd=1;
        #10
        
        rd=1;
        #10
        rd=1;
        #10
        rd=1;
        #10
        rd=0;
        #20
        $finish;
    end
    
    initial begin 
        $dumpfile("fifo.vcd");
        $dumpvars(0,tb_fifo);
    end
endmodule





