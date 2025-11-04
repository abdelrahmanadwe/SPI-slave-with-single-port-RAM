package SPI_wrapper_test_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_env_pkg::*;
    import SPI_slave_env_pkg::*;
    import RAM_environment_pkg::*;
    import SPI_wrapper_config_obj_pkg::*;
    import SPI_slave_config_pkg::*;
    import RAM_configer_pkg::*;
    import SPI_wrapper_sequence_pkg::*;

    class SPI_wrapper_test extends uvm_test;
        `uvm_component_utils(SPI_wrapper_test)

        SPI_wrapper_env wrapper_env;
        SPI_slave_env slave_env;
        RAM_environment ram_env;
        SPI_wrapper_config_obj wrapper_config_obj_test;
        SPI_slave_config slave_config_obj_test;
        RAM_configer ram_config_obj_test;
        
        SPI_wrapper_reset_sequence reset_seq;
        SPI_wrapper_write_sequence write_seq;
        SPI_wrapper_read_sequence read_seq;
        SPI_wrapper_read_write_sequence read_write_seq;

        function new (string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            wrapper_env = SPI_wrapper_env::type_id::create("wrapper_env", this);
            slave_env   = SPI_slave_env::type_id::create("slave_env", this);
            ram_env     = RAM_environment::type_id::create("ram_env", this);

            reset_seq   = SPI_wrapper_reset_sequence::type_id::create("reset_seq");
            write_seq   = SPI_wrapper_write_sequence::type_id::create("write_seq");
            read_seq    = SPI_wrapper_read_sequence::type_id::create("read_seq");
            read_write_seq = SPI_wrapper_read_write_sequence::type_id::create("read_write_seq");


            wrapper_config_obj_test = SPI_wrapper_config_obj::type_id::create("wrapper_config_obj_test");
            slave_config_obj_test = SPI_slave_config::type_id::create("slave_config_obj_test");
            ram_config_obj_test = RAM_configer::type_id::create("ram_config_obj_test");

            if(!( uvm_config_db #(virtual SPI_wrapper_if)::get(this,"","SPI_WRAPPER_VIF",wrapper_config_obj_test.SPI_wrapper_vif)))begin
                `uvm_fatal("build_phase","Test - wrapper - Unable to get the virtual interface");
            end
            if(!( uvm_config_db #(virtual SPI_slave_if)::get(this,"","SPI_SLAVE_VIF",slave_config_obj_test.SPI_slave_vif)))begin
                `uvm_fatal("build_phase","Test - slave - Unable to get the virtual interface");
            end
            if(!( uvm_config_db #(virtual RAM_if)::get(this,"","RAM_VIF",ram_config_obj_test.RAM_vif)))begin
                `uvm_fatal("build_phase","Test - RAM - Unable to get the virtual interface");
            end
            uvm_config_db #(SPI_wrapper_config_obj)::set(this,"wrapper_env.*","SPI_WRAPPER_CFG",wrapper_config_obj_test);
            wrapper_config_obj_test.is_active = UVM_ACTIVE;

            uvm_config_db #(SPI_slave_config)::set(this,"slave_env.*","SPI_SLAVE_CFG",slave_config_obj_test);
            slave_config_obj_test.is_active = UVM_PASSIVE;

            uvm_config_db #(RAM_configer)::set(this,"ram_env.*","RAM_CFG",ram_config_obj_test);
            ram_config_obj_test.is_active = UVM_PASSIVE;


        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            //reset sequence 
            `uvm_info("run_phase", "Reset asserted", UVM_LOW);
            reset_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Reset deasserted", UVM_LOW);
        
            //write sequence 
            `uvm_info("run_phase", "write sequence started", UVM_LOW);
            write_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "write sequence ended", UVM_LOW);
            
            //reset sequence 
            `uvm_info("run_phase", "Reset asserted", UVM_LOW);
            reset_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Reset deasserted", UVM_LOW);
        
            //read sequence 
            `uvm_info("run_phase", "read sequence started", UVM_LOW);
            read_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "read sequence ended", UVM_LOW);

            //reset sequence 
            `uvm_info("run_phase", "Reset asserted", UVM_LOW);
            reset_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "Reset deasserted", UVM_LOW);
        
            //read_write sequence 
            `uvm_info("run_phase", "read_write sequence started", UVM_LOW);
            read_write_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("run_phase", "read_write sequence ended", UVM_LOW);
            
            phase.drop_objection(this);
        endtask

    endclass

endpackage