module RAM_assertions(din,clk,rst_n,rx_valid,dout,tx_valid);
input      [9:0] din;
input            clk, rst_n, rx_valid;
input reg [7:0] dout;
input reg       tx_valid;

reset: assert property  (@(posedge clk)   !rst_n   
                    |=>     (dout==0) && (tx_valid==0));
//-------------------------------------------------------------------------------------------
tx_deasserted: assert property (@(posedge clk)   (!(din[9:8]==2'b11) && rx_valid)     
                    |=>     tx_valid==0 );
//--------------------------------------------------------------------------------------------
tx_asserted: assert property (@(posedge clk) disable iff(!rst_n) ((din[9:8]==2'b11) && rx_valid)     
                    |=>    (($rose(tx_valid)) && (!tx_valid) [ -> 1] ) );
//--------------------------------------------------------------------------------------------
write_assert:assert property (@(posedge clk)   (din[9:8]==2'b00) && rx_valid   
                    |=>    ((din[9:8]==2'b01) && rx_valid) [ -> 1]  );
//--------------------------------------------------------------------------------------------
read_assert: assert property (@(posedge clk)    (din[9:8]==2'b10) && rx_valid   
                    |=>     ((din[9:8]==2'b11) && rx_valid) [ -> 1] );

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

reset_cover: cover property (@(posedge clk)   !rst_n   |=>     (dout==0) && (tx_valid==0));

tx_deasserted_cover: cover property (@(posedge clk)   (!(din[9:8]==2'b11) && rx_valid)     |=>     tx_valid==0 );

tx_asserted_cover: cover property (@(posedge clk)    ((din[9:8]==2'b11) && rx_valid)     |=>    (($rose(tx_valid)|| (din[9:8]==2'b11)||!rst_n) ##1 ($fell(tx_valid) || (din[9:8]==2'b11)||!$past(rst_n))) );

write_cover:cover property (@(posedge clk)   (din[9:8]==2'b00) && rx_valid   |=>   ##1 ((din[9:8]==2'b01) && rx_valid) [ -> 1]  );

read_cover: cover property (@(posedge clk)    (din[9:8]==2'b10) && rx_valid   |=>    ##1 ((din[9:8]==2'b11) && rx_valid) [ -> 1] );

endmodule