////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package SPI_slave_env_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import SPI_slave_agent_pkg::*;
  import SPI_slave_scoreboard_pkg::*;
  import SPI_slave_cover_pkg::*;

  class SPI_slave_env extends uvm_env;

    `uvm_component_utils(SPI_slave_env);

    SPI_slave_agent agt;
    SPI_slave_cover cov;
    SPI_slave_scoreboard sb;

    function new (string name = "SPI_slave_env",uvm_component parant = null);
      super.new(name,parant);
    endfunction

    function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      agt = SPI_slave_agent::type_id::create("agt",this);
      cov = SPI_slave_cover::type_id::create("cov",this);
      sb = SPI_slave_scoreboard::type_id::create("sb",this);
    endfunction

    function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      agt.agt_ap.connect(sb.sb_export);
      agt.agt_ap.connect(cov.cov_export);
    endfunction

  endclass
endpackage