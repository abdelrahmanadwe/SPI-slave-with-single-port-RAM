package SPI_slave_driver_pkg;
 `include "uvm_macros.svh"
 import SPI_slave_config_pkg::*;
 import SPI_slave_item_pkg::*;
 import uvm_pkg::*;
class SPI_slave_driver extends uvm_driver #(SPI_slave_item);
    `uvm_component_utils(SPI_slave_driver);

    virtual SPI_slave_if SPI_slave_vif;
    SPI_slave_item seq_item;

    function new (string name = "SPI_slave_driver",uvm_component parant = null );
        super.new(name,parant);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item = SPI_slave_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
            SPI_slave_vif.rst_n = seq_item.rst_n;
            SPI_slave_vif.MOSI = seq_item.MOSI;
            SPI_slave_vif.tx_data = seq_item.tx_data;
            SPI_slave_vif.tx_valid = seq_item.tx_valid;
            SPI_slave_vif.SS_n = seq_item.SS_n;
            @(negedge SPI_slave_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase" , seq_item.convert2string_stimulus(),UVM_HIGH)
        end
        
    endtask
endclass   
endpackage