package SPI_wrapper_monitor_pkg;


    import shared_pkg::*;
    import uvm_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_wrapper_monitor)

        SPI_wrapper_seq_item SPI_wrapper_monitor_seq_item;
        virtual SPI_wrapper_if SPI_wrapper_monitor_vif;
        uvm_analysis_port #(SPI_wrapper_seq_item) SPI_wrapper_monitor_aport;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            SPI_wrapper_monitor_aport = new("SPI_wrapper_monitor_aport", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                SPI_wrapper_monitor_seq_item = SPI_wrapper_seq_item::type_id::create("SPI_wrapper_monitor_seq_item");
                @(negedge SPI_wrapper_monitor_vif.clk);

                SPI_wrapper_monitor_seq_item.MOSI     = SPI_wrapper_monitor_vif.MOSI ; 
                SPI_wrapper_monitor_seq_item.rst_n    = SPI_wrapper_monitor_vif.rst_n;
                SPI_wrapper_monitor_seq_item.SS_n     = SPI_wrapper_monitor_vif.SS_n ;
                SPI_wrapper_monitor_seq_item.MISO     = SPI_wrapper_monitor_vif.MISO ;
                SPI_wrapper_monitor_seq_item.MISO_GM  = SPI_wrapper_monitor_vif.MISO_GM ;

                SPI_wrapper_monitor_aport.write(SPI_wrapper_monitor_seq_item);
            end
        endtask

    endclass

endpackage