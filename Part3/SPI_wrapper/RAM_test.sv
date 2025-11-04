package RAM_test_pkg;

    import uvm_pkg::*;
    import RAM_environment_pkg::*;
    import RAM_write_only_seq_pkg::*;
    import RAM_reset_seq_pkg::*;
    import RAM_read_only_seq_pkg::*;
    import RAM_write_and_read_seq_pkg::*;
    import RAM_configer_pkg::*;
    `include "uvm_macros.svh"
    class RAM_test extends uvm_test;
        `uvm_component_utils(RAM_test)

        RAM_environment env;
        RAM_configer conf;
        RAM_write_only_seq wr_only_seq;
        RAM_write_and_read_seq wr_and_rd_seq;
        RAM_read_only_seq rd_only_seq;
        RAM_reset_seq r_seq;

        function new(string name = "RAM_test", uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=RAM_environment::type_id::create("env",this);
            conf=RAM_configer::type_id::create("conf");
            wr_only_seq=RAM_write_only_seq::type_id::create("wr_only_seq");
            wr_and_rd_seq=RAM_write_and_read_seq::type_id::create("wr_and_rd_seq");
            rd_only_seq=RAM_read_only_seq::type_id::create("rd_only_seq");
            r_seq=RAM_reset_seq::type_id::create("r_seq");

            if (!uvm_config_db#(virtual RAM_if) ::get(this,"","CFG",conf.RAM_vif))
                `uvm_fatal("build_phase", "unable to get the interface to the config");
            conf.is_active = UVM_ACTIVE;
            uvm_config_db#(RAM_configer)::set(this,"*","CFG",conf);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","reset asserted",UVM_LOW);
            r_seq.start(env.agt.sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW);

            `uvm_info("run_phase","write_only_seq stimulus generation started",UVM_LOW);
            wr_only_seq.start(env.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW);

            `uvm_info("run_phase","reset asserted",UVM_LOW);
            r_seq.start(env.agt.sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW);
            
            `uvm_info("run_phase","write_and_read_seq stimulus generation started",UVM_LOW);
            wr_and_rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW);

            `uvm_info("run_phase","read_only_seq stimulus generation started",UVM_LOW);
            rd_only_seq.start(env.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW);

             `uvm_info("run_phase","reset asserted",UVM_LOW);
            r_seq.start(env.agt.sqr);
            `uvm_info("run_phase","reset deasserted",UVM_LOW);
            
            phase.drop_objection(this);
        endtask
    endclass
endpackage