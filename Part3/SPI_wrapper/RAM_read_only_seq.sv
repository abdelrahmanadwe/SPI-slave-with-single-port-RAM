package RAM_read_only_seq_pkg;
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class RAM_read_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_read_only_seq)
        RAM_seq_item s_item;

        function new(string name = "RAM_read_only_seq");
            super.new(name);
        endfunction

        task body ();
            s_item = RAM_seq_item::type_id::create("s_item");
            repeat(1000) begin 
            start_item(s_item);
            assert(s_item.randomize() with{ if (din[9:8]==2'b10)  (din[9:8]==2'b11) ;
                                            if (din[9:8]==2'b11)  (din[9:8]==2'b10); });
            finish_item(s_item);
            end
        endtask
    endclass
endpackage