package SPI_wrapper_seq_item_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared_pkg::*;
  class SPI_wrapper_seq_item extends uvm_sequence_item;
      `uvm_object_utils(SPI_wrapper_seq_item)

       
    rand logic MOSI, rst_n, SS_n;
    

    //output signals
    
    logic MISO,MISO_GM;

    //control signals
    
    operation_t prev_operation = read_data;
    rand operation_t operation;
    rand int cycle_count = 0;
    rand bit[2:0]spi_cmd;

    rand bit MOSI_data[];
  


    constraint reset_c {
      rst_n dist {0:=1,1:=99};
    }
    constraint MOSI_c {
      MOSI_data.size() == cycle_count-1;
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
      prev_operation = operation;
      MOSI_data = new[cycle_count-1];
      for(int i = 0; i < 3; i++)begin
        MOSI_data[i] = spi_cmd[2-i];
      end
      for(int i = 3; i < cycle_count-1; i++)begin
        MOSI_data[i] = $urandom_range(0,1);
      end
      
    endfunction

    function string convert2string();
        return $sformatf("%s MOSI =0b%0b,\n SS_n =0b%0b,\n rst_n =0b%0b,\n MISO =0b%0b",super.convert2string(),
                        MOSI, SS_n, rst_n,MISO);    
    endfunction
    function string convert2string_stimulus();
        return $sformatf("MOSI =0b%0b,\n SS_n =0b%0b,\n rst_n =0b%0b,\n",MOSI, SS_n, rst_n);      
    endfunction
  endclass

endpackage