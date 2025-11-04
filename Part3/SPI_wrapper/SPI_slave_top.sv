////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////

import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_slave_test_pkg::*;
module top();
  bit clk;
  initial begin
    forever begin
      #1 clk = ~clk;
    end
  end
  
  SPI_slave_if SPI_slaveif (clk);
  SPI_slave_GM GM (SPI_slaveif.MOSI,SPI_slaveif.SS_n,SPI_slaveif.clk,SPI_slaveif.rst_n,SPI_slaveif.tx_valid,SPI_slaveif.tx_data,SPI_slaveif.MISO_GM,SPI_slaveif.rx_data_GM,SPI_slaveif.rx_valid_GM);
  SLAVE DUT (SPI_slaveif);
  bind SLAVE SPI_slave_sva inst (SPI_slaveif);   
  initial begin 
    uvm_config_db #(virtual SPI_slave_if)::set(null,"uvm_test_top","SPI",SPI_slaveif);
    run_test("SPI_slave_test");
  end
endmodule