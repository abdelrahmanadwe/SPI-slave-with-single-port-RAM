module SPI_slave_sva (SPI_slave_if.DUT SPI_slaveif);


    property MISO_reset;
        @(posedge SPI_slaveif.clk) (!SPI_slaveif.rst_n) |=> (~SPI_slaveif.MISO);
    endproperty

    assert property (MISO_reset);
    cover property (MISO_reset);

    property rx_valid_reset;
        @(posedge SPI_slaveif.clk) (!SPI_slaveif.rst_n) |=> (~SPI_slaveif.rx_valid);
    endproperty

    assert property (rx_valid_reset);
    cover property (rx_valid_reset);

    property rx_data_reset;
        @(posedge SPI_slaveif.clk) (!SPI_slaveif.rst_n) |=> (SPI_slaveif.rx_data == 0);
    endproperty

    assert property (rx_data_reset);
    cover property (rx_data_reset);

    property valid_command_wr_addr;
        @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) 
         ($fell(SPI_slaveif.SS_n) ##1 !SPI_slaveif.MOSI ##1 !SPI_slaveif.MOSI ##1 !SPI_slaveif.MOSI) |-> ##10 (SPI_slaveif.rx_valid) ##[0:$](SPI_slaveif.SS_n);
    endproperty

    assert property (valid_command_wr_addr);
    cover property (valid_command_wr_addr);

    property valid_command_wr_data;
        @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) 
         ($fell(SPI_slaveif.SS_n) ##1 !SPI_slaveif.MOSI ##1 !SPI_slaveif.MOSI ##1 SPI_slaveif.MOSI) |-> ##10 (SPI_slaveif.rx_valid)##[0:$](SPI_slaveif.SS_n);
    endproperty

    assert property (valid_command_wr_data);
    cover property (valid_command_wr_data);

    property valid_command_rd_addr;
        @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) 
         ($fell(SPI_slaveif.SS_n) ##1 SPI_slaveif.MOSI ##1 SPI_slaveif.MOSI ##1 !SPI_slaveif.MOSI) |-> ##10 (SPI_slaveif.rx_valid)##[0:$](SPI_slaveif.SS_n);
    endproperty

    assert property (valid_command_rd_addr);
    cover property (valid_command_rd_addr);

    property valid_command_rd_data;
        @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) 
         ($fell(SPI_slaveif.SS_n) ##1 SPI_slaveif.MOSI ##1 SPI_slaveif.MOSI ##1 SPI_slaveif.MOSI) |-> ##10 (SPI_slaveif.rx_valid)##[0:$](SPI_slaveif.SS_n);
    endproperty

    assert property (valid_command_rd_data);
    cover property (valid_command_rd_data);

endmodule