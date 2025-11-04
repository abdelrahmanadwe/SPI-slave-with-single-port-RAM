package SPI_slave_item_pkg;
  import uvm_pkg::*;
  import shared_pkg::*;

  `include "uvm_macros.svh"
  class SPI_slave_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_slave_item)
    

    rand logic MOSI, rst_n, SS_n, tx_valid;
    rand logic [7:0] tx_data;

    //output signals
    logic [9:0] rx_data,rx_data_GM;
    logic rx_valid,rx_valid_GM, MISO,MISO_GM;

    //control signals
    
    rand operation_t operation;
    operation_t pre_operation = read_data;
    rand int cycle_count = 0;
    rand bit[2:0]spi_cmd;

    rand bit MOSI_data[];
  


    constraint reset_c {
      rst_n dist {0:=1,1:=99};
    }
    constraint MOSI_c {
      MOSI_data.size() == cycle_count-1;
    } 
    constraint tx_valid_c {
      if (operation == read_data) {
        tx_valid == 1;
      }
      else{
        tx_valid == 0;
      }
        
    }
    constraint spi_cmd_cons{
      spi_cmd inside {3'b000, 3'b001, 3'b110, 3'b111};

      if(operation == write_addr){
        spi_cmd == 3'b000;
      }
      else if (operation == write_data){
        spi_cmd == 3'b001;
      }
      else if(operation == read_addr){
        spi_cmd == 3'b110;
      }
      else if(operation == read_data){
        spi_cmd == 3'b111;
      }
      
    }
    constraint cycle_count_cons{
      if(operation == read_data){
        cycle_count == 23;
      }
      else{
        cycle_count == 13;
      }
    }

    function void post_randomize();
      pre_operation = operation;
      MOSI_data = new[cycle_count-1];
      for(int i = 0; i < 3; i++)begin
        MOSI_data[i] = spi_cmd[2-i];
      end
      for(int i = 3; i < cycle_count-1; i++)begin
        MOSI_data[i] = $urandom_range(0,1);
      end
      
    endfunction



    function new (string name = "SPI_slave_item");
      super.new(name);
    endfunction

    function string convert2string();
      return $sformatf("%s MOSI = %d,MISO = %d,SS_n = %d,rst_n = %d,rx_data = %d,rx_valid = %d,tx_data = %d,tx_valid = %d",super.convert2string(),MOSI,MISO,SS_n,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    endfunction

    function string convert2string_stimulus();
      return $sformatf("MOSI = %d,MISO = %d,SS_n = %d,rst_n = %d,rx_data = %d,rx_valid = %d,tx_data = %d,tx_valid = %d",MOSI,MISO,SS_n,rst_n,rx_data,rx_valid,tx_data,tx_valid);
    endfunction

  endclass
endpackage

