package SPI_slave_cover_pkg;
import uvm_pkg::*;
import shared_pkg::*;
import SPI_slave_item_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_cover extends uvm_component;
    `uvm_component_utils(SPI_slave_cover)
    
    uvm_analysis_export #(SPI_slave_item) cov_export;
    uvm_tlm_analysis_fifo #(SPI_slave_item) cov_fifo;
    SPI_slave_item cov_item;

    

    covergroup SPI_cvg;

        rx_cov: coverpoint cov_item.rx_data[9:8] iff (cov_item.SS_n){
            bins rx_wr_addr = {2'b00};
            bins rx_wr_data = {2'b01};
            bins rx_rd_addr = {2'b10};
            bins rx_read_data = {2'b11};
            bins w_address_w_data_r_address_r_data = (2'b00 => 2'b01 => 2'b10 => 2'b11);
        }

        SS_cov: coverpoint cov_item.SS_n {
                bins full_tr = (1 => 0[*13] => 1);
                bins extended_tr = (1 => 0[*23] => 1);
        }

        MOSI_cov: coverpoint cov_item.MOSI {
                bins write_addr = (0 => 0 => 0);
                bins write_data = (0 => 0 => 1);
                bins read_addr = (1 => 1 => 0);
                bins read_data = (1 => 1 => 1);
        }

        cross SS_cov,rx_cov {
            option.cross_auto_bin_max   = 0;
            bins write_addr_full_tr     = binsof(SS_cov.full_tr)&& binsof(rx_cov.rx_wr_addr);
            bins write_data_full_tr     = binsof(SS_cov.full_tr)&& binsof(rx_cov.rx_wr_data);
            bins read_addr_full_tr      = binsof(SS_cov.full_tr)&& binsof(rx_cov.rx_rd_addr);
            bins write_data_extended_tr = binsof(SS_cov.extended_tr)&& binsof(rx_cov.rx_read_data);

            ignore_bins extended_with_wr_addr = binsof(SS_cov.extended_tr)&& binsof(rx_cov.rx_wr_addr);
            ignore_bins extended_with_wr_data = binsof(SS_cov.extended_tr)&& binsof(rx_cov.rx_wr_data);
            ignore_bins extended_with_rd_addr = binsof(SS_cov.extended_tr)&& binsof(rx_cov.rx_rd_addr);
            ignore_bins full_with_rd_data = binsof(SS_cov.full_tr)&& binsof(rx_cov.rx_read_data);
        }

    endgroup

    function new (string name = "SPI_slave_cover",uvm_component parant = null);
      super.new(name,parant);
       SPI_cvg = new();
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        
        cov_export = new("cov_export",this);
        cov_fifo = new("cov_fifo",this);
        // cov_item = SPI_slave_item::type_id::create("cov_item"); 

    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(cov_item);
            SPI_cvg.sample();
        end

    endtask

endclass
endpackage
