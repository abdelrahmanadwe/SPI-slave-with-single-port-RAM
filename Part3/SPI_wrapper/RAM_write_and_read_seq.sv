package RAM_write_and_read_seq_pkg;
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class RAM_write_and_read_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_write_and_read_seq)
        RAM_seq_item s_item;

        function new(string name = "RAM_write_and_read_seq");
            super.new(name);
        endfunction

        task body ();
            s_item = RAM_seq_item::type_id::create("s_item");
            repeat(1000) begin 
            start_item(s_item);
            assert(s_item.randomize() with{ if(old==2'b00) {
                                                din[9:8] inside {2'b00, 2'b01}; 
                                            }
                                            else if(old==2'b01){ 
                                                din[9:8] dist {2'b00 :=40, 2'b10 :=60};
                                            }
                                            else if(old==2'b10){
                                                din[9:8] inside {2'b10, 2'b11};
                                            }
                                            else if(old==2'b11){ 
                                            din[9:8] dist {2'b00 :=60, 2'b10 :=40};
                                            }
                                            }
                                            );
            finish_item(s_item);
            end
        endtask
    endclass
endpackage