package SPI_wrapper_agent_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_driver_pkg::*;
    import SPI_wrapper_monitor_pkg::*;
    import SPI_wrapper_sequencer_pkg::*;
    import SPI_wrapper_config_obj_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;

    class SPI_wrapper_agent extends uvm_agent;
        `uvm_component_utils(SPI_wrapper_agent)

        SPI_wrapper_driver driver;
        SPI_wrapper_monitor monitor;
        SPI_wrapper_sequencer sequencer;
        SPI_wrapper_config_obj SPI_wrapper_agent_config_obj;
        uvm_analysis_port #(SPI_wrapper_seq_item) SPI_wrapper_agent_aport;
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!(uvm_config_db #(SPI_wrapper_config_obj)::get(this,"","SPI_WRAPPER_CFG",SPI_wrapper_agent_config_obj)))begin
                `uvm_fatal("build_phase","agent - wrapper - Unable to get the configuration object")
            end 
            if(SPI_wrapper_agent_config_obj.is_active == UVM_ACTIVE)begin
                driver = SPI_wrapper_driver::type_id::create("driver", this);
                sequencer = SPI_wrapper_sequencer::type_id::create("sequencer", this); 
            end
            
            monitor = SPI_wrapper_monitor::type_id::create("monitor", this);
            SPI_wrapper_agent_aport = new("SPI_wrapper_agent_aport", this);
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(SPI_wrapper_agent_config_obj.is_active == UVM_ACTIVE)begin
                driver.SPI_wrapper_driver_vif = SPI_wrapper_agent_config_obj.SPI_wrapper_vif;
                driver.seq_item_port.connect(sequencer.seq_item_export);
            end
            
            monitor.SPI_wrapper_monitor_vif = SPI_wrapper_agent_config_obj.SPI_wrapper_vif;
            monitor.SPI_wrapper_monitor_aport.connect(SPI_wrapper_agent_aport);
        endfunction

    endclass

endpackage