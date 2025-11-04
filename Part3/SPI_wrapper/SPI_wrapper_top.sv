import uvm_pkg::*;
`include "uvm_macros.svh"

import SPI_wrapper_test_pkg::*;

module SPI_wrapper_top();
    bit clk;

    initial begin
        forever begin
            #1 clk = ~clk;
        end
    end
    SPI_wrapper_if SPI_wrapperif(clk);
    SPI_slave_if   SPI_slaveif(clk);
    RAM_if         RAMif(clk);

    WRAPPER SPI_wrapper_instance (SPI_wrapperif);

    //spi_slave wiring
    assign SPI_slaveif.MOSI = SPI_wrapperif.MOSI;
    assign SPI_slaveif.MISO = SPI_wrapperif.MISO;
    assign SPI_slaveif.SS_n = SPI_wrapperif.SS_n;
    assign SPI_slaveif.rst_n= SPI_wrapperif.rst_n;
    assign SPI_slaveif.rx_data = SPI_wrapper_instance.rx_data_din;
    assign SPI_slaveif.rx_valid = SPI_wrapper_instance.rx_valid;
    assign SPI_slaveif.tx_data = SPI_wrapper_instance.tx_data_dout;
    assign SPI_slaveif.tx_valid = SPI_wrapper_instance.tx_valid;
    
    //ram wiring
    assign RAMif.din = SPI_wrapper_instance.rx_data_din;
    assign RAMif.rst_n = SPI_wrapperif.rst_n;
    assign RAMif.rx_valid = SPI_wrapper_instance.rx_valid;
    assign RAMif.dout = SPI_wrapper_instance.tx_data_dout;
    assign RAMif.tx_valid = SPI_wrapper_instance.tx_valid;

    WRAPPER_GM gm(SPI_wrapperif.MOSI, SPI_wrapperif.MISO_GM, SPI_wrapperif.SS_n, SPI_wrapperif.clk, SPI_wrapperif.rst_n);

    bind SLAVE SPI_slave_sva slave_sva (SPI_slaveif);
    bind WRAPPER SPI_wrapper_sva wrapper_sva (SPI_wrapperif);
    bind RAM RAM_assertions ram_sva(RAMif.din,RAMif.clk,RAMif.rst_n,RAMif.rx_valid,RAMif.dout,RAMif.tx_valid);
    initial begin
        uvm_config_db #(virtual SPI_wrapper_if) ::set(null, "uvm_test_top", "SPI_WRAPPER_VIF",SPI_wrapperif);
        uvm_config_db #(virtual SPI_slave_if)   ::set(null, "uvm_test_top", "SPI_SLAVE_VIF",SPI_slaveif);
        uvm_config_db #(virtual RAM_if)         ::set(null, "uvm_test_top", "RAM_VIF",RAMif);
        run_test("SPI_wrapper_test");
    end

endmodule 