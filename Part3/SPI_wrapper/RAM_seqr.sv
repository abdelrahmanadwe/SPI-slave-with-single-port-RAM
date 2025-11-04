package RAM_seqr_pkg;
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class RAM_seqr extends uvm_sequencer #(RAM_seq_item);
        `uvm_component_utils(RAM_seqr);

        function new (string name = "RAM_seqr", uvm_component parent = null);
            super.new(name,null);
        endfunction
    endclass    
endpackage