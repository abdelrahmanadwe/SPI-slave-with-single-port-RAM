package RAM_coverage_collector_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    class RAM_coverage_collector extends uvm_component;
        `uvm_component_utils(RAM_coverage_collector)
        uvm_analysis_export #(RAM_seq_item) covr;
        uvm_tlm_analysis_fifo #(RAM_seq_item) fifo;
        RAM_seq_item s_item;
        int count = 0;

    covergroup cov;
      control_bits: coverpoint s_item.din[9:8] iff (s_item.rx_valid && (count % 2 == 0) ){
        bins write_addr = {2'b00};
        bins write_data = {2'b01};
        bins read_addr = {2'b10};
        bins read_data = {2'b11};
        bins w_data_after_w_address = (2'b00 => 2'b01);
        bins r_data_after_r_adderss = (2'b10 => 2'b11);
        bins w_address_w_data_r_address_r_data = (2'b00 => 2'b01 => 2'b10 => 2'b11);
      }
      rx_valid_cp: coverpoint s_item.rx_valid; 
      tx_valid_cp: coverpoint s_item.tx_valid;
      cross_rx: cross control_bits, rx_valid_cp{
            option.cross_auto_bin_max = 0;
            bins wr_addr_rx = binsof (control_bits.write_addr) && binsof (rx_valid_cp) intersect {1};
            bins wr_data_rx = binsof (control_bits.write_data) && binsof (rx_valid_cp) intersect {1};
            bins rd_addr_rx = binsof (control_bits.read_addr) && binsof (rx_valid_cp) intersect {1};
            bins rd_data_rx = binsof (control_bits.read_data) && binsof (rx_valid_cp) intersect {1};
      }
      cross_tx: cross control_bits, tx_valid_cp{
            option.cross_auto_bin_max = 0;
            bins tx_high = binsof (control_bits.read_data) && binsof (tx_valid_cp) intersect {1};
      }

endgroup

        function new(string name = "coverage_collector", uvm_component parent = null);
            super.new(name, parent);
            cov = new ();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            covr = new("covr",this);
            fifo  = new("fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            covr.connect(fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                fifo.get(s_item);

                cov.sample();
                if(s_item.rx_valid == 1)begin
                    count++;
                end
                `uvm_info("COV", $sformatf("  stimulus%0d", s_item.convert2string_stimulus), UVM_HIGH)
            end
        endtask
    endclass
endpackage