module fifo( //It is applicable for both the TX FIFO and the RX FIFO
    input clk,
    input [7:0]w_data, //Input into the FIFO

    input reset,
    
    input wr,//write control signal
    input rd,//read control signal
    output reg [7:0]r_data, //OUTPUT OF THE FIFO
    output reg full, //FIFO is full or not
    output reg empty //FIFO is empty or not
);
    reg [4:0]count; //to count number of bytes currently stored
    reg [7:0] memory [15:0];  //16 DIFFERENT MEMORY LOCATIONS EACH CONTAINING ONE BYTE (so fifo can store 16 entries at once)

    reg [3:0]w_ptr; //WRITE POINTER
    reg[3:0] r_ptr; //READ POINTER

    always @(*) begin
        full=(count==16); //check if fifo is full
        empty=(count==0); //check if fifo is empty
    end
    always @(posedge clk) begin
        if (reset) begin
            count<=0;
            r_data<=0;
            w_ptr<=0;
            r_ptr<=0;
        end

        else begin
            
            //BOTH READ AND WRITE
            if (wr && !full && rd && !empty)begin
                memory [w_ptr]<=w_data;
                w_ptr<=w_ptr+1;
                r_data<=memory[r_ptr];
                r_ptr<=r_ptr+1;
                count<=count; //count remains same;
            end 


            //WRITE
            else if (wr && !full) begin
                memory[w_ptr]<=w_data;
                if (w_ptr==15 && !full)
                    w_ptr<=0; //CIRCULAR QUEUE
                else
                    w_ptr<=w_ptr+1; //ADVANCE POINTER
                count<=count+1; //UPDATE COUNT

            end

            //READ
            else if (rd && !empty) begin
                r_data<=memory[r_ptr];
                if (r_ptr ==15 && !empty)
                    r_ptr<=0; //CIRCULAR QUEUE
                else
                    r_ptr<=r_ptr+1;//ADVANCE POINTER    
                count<=count-1; //UPDATE COUNT
            end

            
        end
    end

            
                
endmodule






    


