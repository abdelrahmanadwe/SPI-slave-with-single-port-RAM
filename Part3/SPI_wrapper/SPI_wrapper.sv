module WRAPPER (SPI_wrapper_if.DUT SPI_wrapperif);

    SPI_slave_if   SPI_slaveif(SPI_wrapperif.clk);

    wire [9:0] rx_data_din;
    wire       rx_valid;
    wire       tx_valid;
    wire [7:0] tx_data_dout;

    assign SPI_slaveif.MOSI  = SPI_wrapperif.MOSI;
    assign SPI_slaveif.SS_n  = SPI_wrapperif.SS_n;
    assign SPI_slaveif.rst_n = SPI_wrapperif.rst_n;

    assign SPI_slaveif.tx_data  = tx_data_dout;
    assign SPI_slaveif.tx_valid = tx_valid;

    assign rx_data_din = SPI_slaveif.rx_data;
    assign rx_valid = SPI_slaveif.rx_valid;
    

    assign SPI_wrapperif.MISO = SPI_slaveif.MISO;
    


RAM   RAM_instance   (rx_data_din,SPI_wrapperif.clk,SPI_wrapperif.rst_n,rx_valid,tx_data_dout,tx_valid);
SLAVE SLAVE_instance (SPI_slaveif);

endmodule