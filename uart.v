module uart(
    input reset,
    input clk,
    input wr_uart,
    input rd_uart,
    input [7:0]data,
    output [7:0]out
    
);
    
    
    wire s_tick;
    wire [7:0] tx_fifo_out; 
    wire tx_fifo_full;
    wire tx_fifo_empty;
    reg tx_fifo_rd; //read signal to tx fifo
    reg tx_start;
    wire tx_done_tick;
    wire tx;

    wire [7:0]d_out;
    wire rx_done_tick;
    reg rx_fifo_wr;
    wire rx_fifo_full;
    wire rx_fifo_empty;
    

    reg [1:0]tx_state;
    reg [1:0]tx_next_state;
    parameter IDLE=0,FETCH=1, START_TX=2,SEND=3; //TRANSMITTER CONTROL FSM
    baudgen baudgen_uart(clk,reset,11'd53,s_tick);


    always @(*) begin //NEXT STATE LOGIC FOR TRANSMITTER CONTROL FSM
    case(tx_state)

        IDLE: begin
            if (!tx_fifo_empty)
                tx_next_state = FETCH;
            else
                tx_next_state = IDLE;
        end

        FETCH: begin
            tx_next_state = START_TX;
        end

        START_TX: begin
            tx_next_state = SEND;
        end

        SEND: begin
            if (tx_done_tick) begin
                if (!tx_fifo_empty)
                    tx_next_state = FETCH;
                else
                    tx_next_state = IDLE;
            end
            else
                tx_next_state = SEND;
        end

        default:
            tx_next_state = IDLE;

    endcase
end
always @(posedge clk) begin //SEQUENTIAL LOGIC FOR TRANSMITTER
    if (reset) begin
        tx_state   <= IDLE;
        tx_fifo_rd <= 0;
        tx_start   <= 0;
    end
    else begin
        tx_state   <= tx_next_state;

        tx_fifo_rd <= 0;
        tx_start   <= 0;

        case(tx_state)

            FETCH:
                tx_fifo_rd <= 1;

            START_TX:
                tx_start <= 1;

        endcase
    end
end


                    
    //TX FIFO
    fifo tx_fifo_uart(clk,data,reset,wr_uart,tx_fifo_rd,tx_fifo_out,tx_fifo_full,tx_fifo_empty);


    //TRANSMITTER
    transmitter tx_uart(s_tick,clk,reset,tx_fifo_out,tx_start,tx,tx_done_tick);

    //RECEIVER
    receiver rx_uart(clk,tx,s_tick,reset,d_out,rx_done_tick);

    always @(posedge clk) begin
    if (reset)
        rx_fifo_wr <= 0;
    else
        rx_fifo_wr <= rx_done_tick && !rx_fifo_full;
    end

    //RX FIFO
    fifo rx_fifo_uart(clk,d_out,reset,rx_fifo_wr,rd_uart,out,rx_fifo_full,rx_fifo_empty);



endmodule
