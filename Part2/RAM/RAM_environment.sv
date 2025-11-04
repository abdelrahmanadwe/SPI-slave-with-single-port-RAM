package RAM_environment_pkg;
import uvm_pkg::*;
import RAM_agent_pkg::*;
import RAM_scoreboard_pkg::*;
import RAM_coverage_collector_pkg::*;
`include "uvm_macros.svh"
class RAM_environment extends uvm_env;
    `uvm_component_utils(RAM_environment)
    RAM_agent agt;
    RAM_scoreboard sc;
    RAM_coverage_collector cc;
    function new(string name = "RAM_envirnment", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = RAM_agent :: type_id :: create("agt", this);
        sc = RAM_scoreboard::type_id::create("sc", this);
        cc = RAM_coverage_collector::type_id::create("cc",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase (phase);
        agt.agent_ap.connect(sc.sb_export);
        agt.agent_ap.connect(cc.covr);
    endfunction
endclass
endpackage