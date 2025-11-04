////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package SPI_slave_test_pkg;
  import SPI_slave_env_pkg::*;
  import SPI_slave_sequencer_pkg::*;
  import SPI_slave_config_pkg::*;
  import SPI_slave_rst_seq_pkg::*;
  import SPI_slave_main_seq_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class SPI_slave_test extends uvm_test;

    `uvm_component_utils(SPI_slave_test);

    SPI_slave_env slave_env;
    SPI_slave_config SPI_slave_cfg;
    SPI_slave_rst_seq reset_sq;
    SPI_slave_write_sequence main_wr_sq;
    SPI_slave_read_sequence main_rd_sq;
    SPI_slave_read_write_sequence main_rd_wr_seq;

    function new(string name = "SPI_slave_test" ,uvm_component parant = null);
      super.new(name,parant);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      slave_env = SPI_slave_env::type_id::create("slave_env",this);
      SPI_slave_cfg = SPI_slave_config::type_id::create("SPI_slave_cfg");
      reset_sq = SPI_slave_rst_seq::type_id::create("reset_sq");
      main_wr_sq = SPI_slave_write_sequence::type_id::create("main_wr_sq");
      main_rd_sq = SPI_slave_read_sequence::type_id::create("main_rd_sq");
      main_rd_wr_seq = SPI_slave_read_write_sequence::type_id::create("main_rd_wr_seq");
      if(!uvm_config_db #(virtual SPI_slave_if)::get(this,"","SPI",SPI_slave_cfg.SPI_slave_vif))
        `uvm_fatal("build_phase", "Test - slave - Unable to get configration object");

      SPI_slave_cfg.is_active = UVM_ACTIVE;
      uvm_config_db #(SPI_slave_config)::set(this,"slave_env.*","CFG",SPI_slave_cfg);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);

      `uvm_info("run_phase","reset asserted",UVM_LOW)
      reset_sq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","reset deasserted",UVM_LOW)

      `uvm_info("run_phase","stimulus generation write sequence started",UVM_LOW)
      main_wr_sq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","stimulus generation write sequence ended",UVM_LOW)

      `uvm_info("run_phase","reset asserted",UVM_LOW)
      reset_sq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","reset deasserted",UVM_LOW)

      `uvm_info("run_phase","stimulus generation read squence started",UVM_LOW)
      main_rd_sq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","stimulus generation read sequence ended",UVM_LOW)
      
      `uvm_info("run_phase","reset asserted",UVM_LOW)
      reset_sq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","reset deasserted",UVM_LOW)

      `uvm_info("run_phase","stimulus generation read write squence started",UVM_LOW)
      main_rd_wr_seq.start(slave_env.agt.sqr);
      `uvm_info("run_phase","stimulus generation read write sequence ended",UVM_LOW)

      phase.drop_objection(this);

    endtask

  endclass
endpackage