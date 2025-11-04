package SPI_slave_sequencer_pkg;
  import uvm_pkg::*;
  import SPI_slave_item_pkg::*;
  `include "uvm_macros.svh"
  
  class SPI_slave_sequencer extends uvm_sequencer #(SPI_slave_item);
    `uvm_component_utils(SPI_slave_sequencer);
  
    function new (string name = "SPI_slave_sequencer",uvm_component parant = null);
      super.new(name,parant);
    endfunction
  
  endclass
endpackage