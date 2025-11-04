package SPI_wrapper_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_wrapper_agent_pkg::*;
    import SPI_wrapper_scoreboard_pkg::*;
    import SPI_wrapper_coverage_pkg::*;

    class SPI_wrapper_env extends uvm_env;
        `uvm_component_utils(SPI_wrapper_env)
        
        SPI_wrapper_agent agent;
        SPI_wrapper_scoreboard scoreboard;
        SPI_wrapper_coverage coverage;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = SPI_wrapper_agent::type_id::create("agent", this);
            scoreboard = SPI_wrapper_scoreboard::type_id::create("scoreboard", this);
            coverage = SPI_wrapper_coverage::type_id::create("coverage", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.SPI_wrapper_agent_aport.connect(scoreboard.SPI_wrapper_scoreboard_aexport);
            agent.SPI_wrapper_agent_aport.connect(coverage.SPI_wrapper_coverage_aexport);
        endfunction

    endclass

endpackage