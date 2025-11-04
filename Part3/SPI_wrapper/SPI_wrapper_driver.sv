package SPI_wrapper_driver_pkg;

    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import SPI_wrapper_seq_item_pkg::*;

    class SPI_wrapper_driver extends uvm_driver #(SPI_wrapper_seq_item);
        `uvm_component_utils(SPI_wrapper_driver)

        virtual SPI_wrapper_if SPI_wrapper_driver_vif;
        SPI_wrapper_seq_item SPI_wrapper_driver_seq_item;
        
        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                SPI_wrapper_driver_seq_item = SPI_wrapper_seq_item::type_id::create("SPI_wrapper_driver_seq_item");
                seq_item_port.get_next_item(SPI_wrapper_driver_seq_item);
                drive_transaction(SPI_wrapper_driver_seq_item);
                seq_item_port.item_done(); 
            end
            
        endtask

        task drive_transaction(SPI_wrapper_seq_item item);
          SPI_wrapper_driver_vif.rst_n = item.rst_n;
          SPI_wrapper_driver_vif.SS_n = item.SS_n;
          SPI_wrapper_driver_vif.MOSI = item.MOSI;
          @(negedge SPI_wrapper_driver_vif.clk);
          `uvm_info(get_type_name(), $sformatf("Driving: %s", item.convert2string()), UVM_DEBUG)
        endtask

    endclass


endpackage