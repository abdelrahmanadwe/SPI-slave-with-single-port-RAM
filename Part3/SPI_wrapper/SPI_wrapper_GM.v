module WRAPPER_GM (MOSI,MISO,SS_n,clk,rst_n);

input  MOSI, SS_n, clk, rst_n;
output MISO;

wire [9:0] rx_data_din;
wire       rx_valid;
wire       tx_valid;
wire [7:0] tx_data_dout;

RAM_golden_model   RAM_instance   (rx_data_din, rx_valid, clk, rst_n, tx_data_dout, tx_valid);
SPI_slave_GM SLAVE_instance (MOSI, SS_n, clk, rst_n, tx_valid, tx_data_dout, MISO,rx_data_din,rx_valid);

endmodule