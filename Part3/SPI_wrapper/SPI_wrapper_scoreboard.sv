package SPI_wrapper_scoreboard_pkg;

    import uvm_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class SPI_wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_wrapper_scoreboard)

        uvm_analysis_export #(SPI_wrapper_seq_item) SPI_wrapper_scoreboard_aexport;
        uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) sb_fifo;
        SPI_wrapper_seq_item sb_item;

        int error_count = 0,correct_count = 0;

        function new (string name = "SPI_wrapper_scoreboard",uvm_component parant = null);
            super.new(name,parant);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            SPI_wrapper_scoreboard_aexport = new("SPI_wrapper_scoreboard_aexport",this);
            sb_fifo = new("sb_fifo",this);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            SPI_wrapper_scoreboard_aexport.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_item);
                
                if (sb_item.MISO != sb_item.MISO_GM) begin
                    `uvm_error("run_phase" , $sformatf("comprsion failed, transaction recevied by the DUT %s while the ref_MISO = %d",sb_item.convert2string(),sb_item.MISO_GM))
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase",$sformatf("correct_count out : %s ",sb_item.convert2string()),UVM_HIGH);
                    correct_count++;
                end
            end

        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %0d",correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("Total failed transactions: %0d",error_count), UVM_LOW);
        endfunction

    endclass

endpackage