package RAM_agent_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import RAM_driver_pkg::*;
    import RAM_monitor_pkg::*;
    import RAM_seqr_pkg::*;
    import RAM_configer_pkg::*;
    import RAM_seq_item_pkg::*;
    class RAM_agent extends uvm_agent;
        `uvm_component_utils(RAM_agent)
        RAM_seqr sqr;
        RAM_driver driv;
        RAM_monitor mon;
        RAM_configer cfg;
        uvm_analysis_export #(RAM_seq_item) agent_ap;
        
        function new(string name = "agent", uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(RAM_configer)::get(this,"","CFG",cfg))begin
                `uvm_fatal("build_phase","unable to configuration object");
            end
            if (cfg.is_active==UVM_ACTIVE) begin 
                sqr=RAM_seqr::type_id::create("sqr",this);
                driv=RAM_driver::type_id::create("driv",this);
            end
            
            mon=RAM_monitor::type_id::create("mon",this);
            agent_ap=new("agent_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if (cfg.is_active==UVM_ACTIVE) begin 
                driv.seq_item_port.connect(sqr.seq_item_export);
                driv.RAM_vif=cfg.RAM_vif;
            end
            mon.RAM_vif=cfg.RAM_vif;
            mon.mon_ap.connect(agent_ap);
        endfunction
    endclass
endpackage