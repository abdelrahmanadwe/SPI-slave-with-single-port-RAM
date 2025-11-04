package SPI_slave_rst_seq_pkg;
    import uvm_pkg::*;
    import SPI_slave_item_pkg::*;
    `include "uvm_macros.svh"
        class SPI_slave_rst_seq extends uvm_sequence #(SPI_slave_item);
        `uvm_object_utils(SPI_slave_rst_seq)
        SPI_slave_item seq_item;
    
        function new (string name = "SPI_slave_rst_seq");
            super.new(name);
        endfunction
    
        task body;
            repeat(5)begin
                seq_item = SPI_slave_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n = 0;
                seq_item.MOSI = 0;
                seq_item.tx_data = 0;
                seq_item.tx_valid = 0;
                seq_item.SS_n = 1;
                finish_item(seq_item);
            end

            repeat(1)begin
                seq_item = SPI_slave_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n = 1;
                seq_item.MOSI = 0;
                seq_item.tx_data = 0;
                seq_item.tx_valid = 0;
                seq_item.SS_n = 0;
                finish_item(seq_item);
            end
            repeat(1)begin
                seq_item = SPI_slave_item::type_id::create("seq_item");
                start_item(seq_item);
                seq_item.rst_n = 1;
                seq_item.MOSI = 0;
                seq_item.tx_data = 0;
                seq_item.tx_valid = 0;
                seq_item.SS_n = 1;
                finish_item(seq_item);
            end
           
        endtask
    
    endclass
endpackage
