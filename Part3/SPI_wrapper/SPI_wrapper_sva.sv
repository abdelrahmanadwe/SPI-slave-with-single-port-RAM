import shared_pkg::*;


module SPI_wrapper_sva(SPI_wrapper_if.DUT SPI_wrapperif);


    property MISO_reset;
        @(posedge SPI_wrapperif.clk) (!SPI_wrapperif.rst_n) |=> (~SPI_wrapperif.MISO);
    endproperty

    assert property (MISO_reset);
    cover  property (MISO_reset);

    property rx_valid_reset;
        @(posedge SPI_wrapperif.clk) (!SPI_wrapperif.rst_n) |=> (~WRAPPER.rx_valid);
    endproperty

    assert property (rx_valid_reset);
    cover  property (rx_valid_reset);

    property rx_data_reset;
        @(posedge SPI_wrapperif.clk) (!SPI_wrapperif.rst_n) |=> (WRAPPER.rx_data_din == 0);
    endproperty

    assert property (rx_data_reset);
    cover  property (rx_data_reset);

    property MISO_satble;
        @(posedge SPI_wrapperif.clk) disable iff (!SPI_wrapperif.rst_n) (WRAPPER.SLAVE_instance.cs != READ_DATA) |-> $stable(SPI_wrapperif.MISO);
    endproperty

    assert property (MISO_satble);
    cover  property (MISO_satble);

    
endmodule