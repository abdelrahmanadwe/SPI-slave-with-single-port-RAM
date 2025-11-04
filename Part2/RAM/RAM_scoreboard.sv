package RAM_scoreboard_pkg;

    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class RAM_scoreboard extends uvm_scoreboard;
        //define the export and the fifo
        `uvm_component_utils(RAM_scoreboard)
        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
        RAM_seq_item s_item;
        //the expcted value
        logic [3:0] expected_value;
        //the error counter and the correct counter
        int errors=0, corrects=0;
        //the essential
        function new(string name = "RAM_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction
        //build phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo   = new("sb_fifo", this);
        endfunction
        //connect phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        //run phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(s_item);
                if((s_item.dout != s_item.ex_dout)&&(s_item.tx_valid!=s_item.ex_tx_valid)) begin
                    `uvm_error("run_phase", $sformatf("comparsion faild"));
                    errors++;
                    `uvm_info("COV", $sformatf("  stimulus %0d ", s_item.convert2string), UVM_HIGH)
                end
                else begin
                    corrects++;
                end
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("the number of errors=0d%0d",errors),UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("the number of corrects=0d%0d",corrects),UVM_MEDIUM)
        endfunction
    endclass
endpackage