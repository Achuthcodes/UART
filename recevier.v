module receiver(
    input clk,
    input rx, //data from Tx
    input s_tick, //tick from the baud gen (16 per bit period)
    input reset, //synchronus
    output reg [7:0]d_out,
    output reg rx_done_tick
);
    parameter IDLE=0,START=1,DATA=2,STOP=3;
    reg [1:0]state;
    reg[1:0]next_state;
    parameter DBIT=8;//number of data bits
    parameter SB_TICK=16; //number of s_ticks in one stop-bit period

    reg [3:0] s; //tick counter
    reg [2:0] n;//data bit counter
    reg [7:0] data; //to store the data
    
    //NEXT STATE LOGIC
    always @(*) begin
        case (state)
            IDLE:begin
                if (rx) begin
                    next_state=IDLE;
                end
                else begin
                    
                    next_state=START;
                end
            end

            START:begin
                if(!s_tick) //if we haven't got the tick yet, wait
                    next_state=START;
                else begin
                    
                        
                    if(s==7) begin //count the number of ticks in the start bit, once we reach the middle, ie s==7, reset the counter and move to the DATA state
                        if (rx)
                            next_state=IDLE; //INVALID START BIT
                        else
                            next_state=DATA;
                    end
                    else begin //if not yet 7, keep incrementing
                        
                        next_state=START;
                    end
                end
            end

            DATA:begin
                if (!s_tick) //if we haven't yet recieved the tick, wait
                    next_state=DATA;
                else begin
                    if (s==15) begin // if we have counted all 16 ticks (half from the first bit and half from the next)
                        
                        
                        if (n==DBIT-1)
                            next_state=STOP;
                        else begin
                            
                            next_state=DATA;
                        end
                    end
                    else
                        next_state=DATA;
                    
                end
            end
            STOP:begin
                if (!s_tick) //if not recieved tick wait
                    next_state=STOP; 
                else begin
                    if (s==SB_TICK-1) begin
                        next_state=IDLE;
                    end
                    else begin
                        
                        next_state=STOP;
                    end
                end
            end
        endcase
    end


    //STATE REGISTER
    always @(posedge clk) begin
        if (reset) begin //synchronous reset
            state<=IDLE;
            s <= 0;
            n <= 0;
            data <= 0;
            rx_done_tick<=0;
            d_out<=0;
        end
        else begin
            state<=next_state;
            if(state==STOP &&s_tick && s == SB_TICK-1 && rx ) begin //here we are checking if the stop bit is valid or not, and based on that we will assign the done signal
                rx_done_tick<=1; //HERE WE WANT THE DONE SIGNAL TO LAST ONE CLOCK CYCLE ONLY WHEN IT IS IN STOP STATE AND RX=1, SO IT IS IN THE CLOCKED BLOCK
                d_out<=data; //DATA OUTPUT
            end
            else begin
                rx_done_tick<=0; //DONE SIGNAL IS DIRECTLY ASSIGNED IN THIS BLOCK
                
            end
                
            
            case(state)
                IDLE:begin
                    if (next_state==START)
                        s<=0;
                end
                START:begin
                    n<=0;
                    if(next_state==DATA)
                        s<=0;
                    else if (s_tick) //DONT UPDATE AT EVERY CLOCK CYCLE, UPDATE ONLY WHEN THE TICK COMES!
                        s<=s+1;
                end
                DATA:begin
                    if (s==15) begin
                        s<=0; //reset s
                        data[n]<=rx;
                        if (next_state==DATA && s_tick) //DONT UPDATE AT EVERY CLOCK CYCLE, UPDATE ONLY WHEN THE TICK COMES!
                            n<=n+1;

                    end
                    else if (s_tick)//Increment s
                        s<=s+1;
                end

                STOP:begin
                  
                    if(next_state==START)
                        s<=0;
                    else if (next_state==STOP && s_tick) //DONT UPDATE AT EVERY CLOCK CYCLE, UPDATE ONLY WHEN THE TICK COMES!
                        s<=s+1;
                end
            endcase
        end
    end

    


