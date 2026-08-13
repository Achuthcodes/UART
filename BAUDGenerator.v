module baudgen(
    input clk,
    input reset,
    input [10:0]dvsr,
    output reg tick
);
    reg [10:0]counter;
    always @(posedge clk) begin
        if(reset) begin//synchronous
            counter<=0;
            tick<=0;
        end
        else begin
            if (dvsr==counter) begin
                counter<=0;
                tick<=1;
            end
            else begin
                tick<=0;
                counter<=counter+1;
            end
        end
    end
endmodule


