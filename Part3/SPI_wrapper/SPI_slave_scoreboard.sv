package SPI_slave_scoreboard_pkg;
    import uvm_pkg::*;
    import SPI_slave_item_pkg::*;

    `include "uvm_macros.svh"


    class SPI_slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_slave_scoreboard)

        uvm_analysis_export #(SPI_slave_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_slave_item) sb_fifo;
        SPI_slave_item sb_item;
        

        int error = 0,correct = 0;

      function new (string name = "SPI_slave_scoreboard",uvm_component parant = null);
        super.new(name,parant);
      endfunction

      function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
            sb_item = SPI_slave_item::type_id::create("sb_item");

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_item);
                //ref_model(sb_item);
                if (sb_item.MISO != sb_item.MISO_GM || sb_item.rx_data != sb_item.rx_data_GM || sb_item.rx_valid != sb_item.rx_valid_GM ) begin
                    `uvm_error("run_phase" , $sformatf("comprsion failed, transaction recevied by the DUT %s while the ref_rx_data = %0d, ref_rx_valid = %0b, ref_MISO = %d",sb_item.convert2string(),sb_item.rx_data_GM,sb_item.MISO_GM, sb_item.rx_valid_GM ))
                    error++;
                end
                else begin
                    `uvm_info("run_phase",$sformatf("correct out : %s ",sb_item.convert2string()),UVM_HIGH);
                    correct++;
                end
            end

        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %0d",correct), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed transactions: %0d",error), UVM_MEDIUM);
        endfunction

    endclass
endpackage