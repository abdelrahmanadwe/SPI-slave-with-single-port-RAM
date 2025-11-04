package SPI_slave_monitor_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import SPI_slave_item_pkg::*;

    class SPI_slave_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_slave_monitor);
    
        virtual SPI_slave_if SPI_slave_vif;
        SPI_slave_item rsp_seq_item;
        uvm_analysis_port #(SPI_slave_item) mon_ap;
    
        function new (string name = "SPI_slave_monitor",uvm_component parant = null );
            super.new(name,parant);
        endfunction
    
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
        
            mon_ap = new("mon_ap",this);
    
        endfunction
        
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = SPI_slave_item::type_id::create("rsp_seq_item");
                @(negedge SPI_slave_vif.clk);
                rsp_seq_item.rst_n = SPI_slave_vif.rst_n;
                rsp_seq_item.MOSI = SPI_slave_vif.MOSI;
                rsp_seq_item.MISO = SPI_slave_vif.MISO;
                rsp_seq_item.SS_n = SPI_slave_vif.SS_n;
                rsp_seq_item.tx_data = SPI_slave_vif.tx_data;
                rsp_seq_item.tx_valid = SPI_slave_vif.tx_valid;
                rsp_seq_item.rx_data = SPI_slave_vif.rx_data;
                rsp_seq_item.rx_valid = SPI_slave_vif.rx_valid;
                rsp_seq_item.rx_data_GM = SPI_slave_vif.rx_data_GM;
                rsp_seq_item.rx_valid_GM = SPI_slave_vif.rx_valid_GM;
                rsp_seq_item.MISO_GM = SPI_slave_vif.MISO_GM;
                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase",rsp_seq_item.convert2string(),UVM_DEBUG);
            end
            
        endtask
    endclass   
endpackage