////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Interface
// 
////////////////////////////////////////////////////////////////////////////////
interface SPI_slave_if (input bit clk);

  logic MOSI, rst_n, SS_n, tx_valid,rx_valid,rx_valid_GM, MISO,MISO_GM;
  logic [7:0] tx_data;
  logic [9:0] rx_data,rx_data_GM;



  modport DUT (
  input MOSI, rst_n, SS_n, tx_valid,clk,tx_data,
  output rx_valid, MISO,rx_data
  );

  // modport GM (
  // input MOSI, rst_n, SS_n, tx_valid,clk,tx_data,
  // output rx_valid_GM, MISO_GM,rx_data_GM
  // );

  
endinterface : SPI_slave_if

