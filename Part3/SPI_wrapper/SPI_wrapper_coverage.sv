package SPI_wrapper_coverage_pkg;

    import uvm_pkg::*;
    import SPI_wrapper_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class SPI_wrapper_coverage extends uvm_component;
        `uvm_component_utils(SPI_wrapper_coverage)

        uvm_analysis_export #(SPI_wrapper_seq_item) SPI_wrapper_coverage_aexport;
        uvm_tlm_analysis_fifo #(SPI_wrapper_seq_item) cov_fifo;
        SPI_wrapper_seq_item cov_item;

      function new (string name = "SPI_wrapper_coverage",uvm_component parant = null);
        super.new(name,parant);
      endfunction

      function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            SPI_wrapper_coverage_aexport = new("SPI_wrapper_coverage_aexport",this);
            cov_fifo = new("cov_fifo",this);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            SPI_wrapper_coverage_aexport.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_item);
            end

        endtask

    endclass

endpackage