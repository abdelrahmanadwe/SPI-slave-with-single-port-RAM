package RAM_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)
        rand logic      [9:0] din;
        rand logic            rst_n,   rx_valid;
        logic                 tx_valid,ex_tx_valid;
        logic           [7:0] dout,    ex_dout;
        logic           [1:0] old=0; 

        function new(string name = "RAM_seq_item");
            super.new(name);
        endfunction

        function string convert2string ();
            return $sformatf ("%0s din = %0d,rst_n = %0d, rx_valid = %0d, dout = %0d, tx_valid = %0b", super.convert2string(),
                            din,rst_n,rx_valid, dout, tx_valid);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("din = %0d,rst_n = %0d, rx_valid = %0d",din,rst_n,rx_valid);
        endfunction

        constraint reset{ rst_n dist{0:= 1, 1:= 99};}
        constraint rxvalid{rx_valid dist{0:= 1, 1:= 99};}

        function void post_randomize;
          old = din[9:8];
        endfunction
    endclass
endpackage