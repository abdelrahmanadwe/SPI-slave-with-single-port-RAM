interface RAM_if(clk);
logic      [9:0] din;
logic            rst_n, rx_valid;
logic      [7:0] dout, ex_dout;
logic      tx_valid, ex_tx_valid;
input       clk; 
endinterface