module transmitter(
    input s_tick,
    input clk,
    input reset,
    input [7:0]din,
    input tx_start,
    output reg tx, 
    output reg tx_done_tick
);
    parameter IDLE=0,START =1,DATA=2,STOP=3 ; //IDLE-WAITING FOR tx_start, START-TRANSMIT THE START BIT, DATA-TRANSMIT ALL THE DATA BITS 16 BITS,
    //STOP- SET tx 1, and done signal
    reg [7:0]data;
    reg [1:0]state;
    reg [1:0]next_state;
    
    reg [2:0]n;
    reg [3:0]s;
    parameter DBIT=8;
    
    //NEXT STATE LOGIC (COMBINATIONAL)
    always @(*) begin
        case(state)
            IDLE:begin
                if (tx_start) begin
                    next_state=START;
                    
                end
                else
                    next_state=IDLE;
            end
            START:begin
                if (s==15 && s_tick)
                    next_state=DATA;
                else
                    next_state=START;
            end
            DATA:begin
                if(s==15) begin
                    if (n==DBIT-1)
                        next_state=STOP;
                    else
                        next_state=DATA;
                end
                else
                    next_state=DATA;
            end
            STOP:begin
                if (s==15)
                    next_state=IDLE;
                else
                    next_state=STOP;
            end
        endcase
    end

    //STATE REGISTERS (SEQUENTIAL)
    always @(posedge clk) begin
        if (reset) begin
            tx<=1;
            tx_done_tick<=0;
            n<=0;
            s<=0;
            data<=0;
            state<=IDLE;
        end
        else begin
            state<=next_state;
            tx_done_tick<=0;
            case (state)
                IDLE:begin
                    s<=0;
                    if (next_state==START)
                        data<=din;
                    
                end
                START:begin
                    
                    tx<=0;
                    if(s!=15 && s_tick)
                        s<=s+1;
                    else if (s==15 && s_tick) begin
                        s<=0;
                        n<=0;
                        tx=data[n];
                    end
                    

                    
                    
                end
                DATA:begin
                    if (s==15) begin
                        
                        s<=0;
                        if (n!=DBIT-1) begin
                            n<=n+1;
                            tx<=data[n+1]; //HERE n+1 BECAUSE IT'S NON BLOCKING ASSIGNENT. n value wont be updated until the next clock cycle
                        end
                        else
                            n<=0;
                        


                    end

                    else if (s_tick)
                        s<=s+1;
                end
                STOP:begin
                    tx<=1;
                    if (s!=15 && s_tick)
                        s<=s+1;
                    else if(s==15)
                        tx_done_tick<=1;
                end
            endcase
        end
    end
endmodule

                    





                

