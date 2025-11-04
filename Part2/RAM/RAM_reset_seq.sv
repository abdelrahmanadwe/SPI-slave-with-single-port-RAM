package RAM_reset_seq_pkg;
    import RAM_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class RAM_reset_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils (RAM_reset_seq)
        RAM_seq_item s_item;

        function  new (string name = "RAM_reset_seq");
            super.new(name);
        endfunction

        task body();
            s_item = RAM_seq_item::type_id::create("s_item");
            start_item(s_item);
            s_item.rst_n=1;
            s_item.rx_valid=0;
            s_item.din=0;
            s_item.rst_n=0;
            finish_item(s_item);
        endtask
    endclass
endpackage