module SPI_slave_GM (
    input MOSI ,
    input SS_n ,
    input clk , rst_n ,
    input tx_valid ,
    input [7:0] tx_data ,
    output reg MISO ,
    output reg [9:0] rx_data ,
    output reg rx_valid 
);
parameter IDLE      = 3'b000 ;
parameter CHK_CMD   = 3'b001 ;
parameter WRITE     = 3'b010 ;
parameter READ_ADD  = 3'b011 ;
parameter READ_DATA = 3'b100 ;

  reg [3:0] counter;
  reg rd_add;
  reg [9:0] out_reg;
 
  reg [2:0]cs, ns;


always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (!rd_add) 
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
       READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        rd_add <= 0;
        out_reg <= 0;
        MISO <= 0;
        
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
                
                out_reg <= 0;
                MISO <= 0;
                
            end
            CHK_CMD : begin
                counter <= 10; 
                
            end
            WRITE : begin
                if (counter > 0 && !rx_valid) begin
                   out_reg[counter-1] <= MOSI;
                    counter <= counter - 1;
                    
                end
                else begin
                    rx_data <= out_reg;
                    rx_valid <= 1;
                    
                    
                end
            end
            READ_ADD : begin
                if (counter > 0 && !rx_valid) begin
                    out_reg[counter-1] <= MOSI;
                    counter <= counter - 1;
                    
                end
                else begin
                    rx_data <= out_reg;
                    rx_valid <= 1;
                    rd_add <= 1;
                   
                end
            end
           READ_DATA : begin
                if (tx_valid && (rx_valid)) begin
                    
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;

                    end
                    else begin
                        rd_add <= 0;
                        
                    end
                end
                else begin
                    if (counter > 0 && !rx_valid) begin
                        out_reg[counter-1] <= MOSI;
                        counter <= counter - 1;
                        
                    end
                    else begin
                        rx_data <= out_reg;
                        rx_valid <= 1;
                        counter <= 8;
                        
                    end
                end
            end
        endcase
    end
end
endmodule