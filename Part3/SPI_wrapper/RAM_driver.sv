package RAM_driver_pkg;
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class RAM_driver extends uvm_driver #(RAM_seq_item);
        `uvm_component_utils(RAM_driver)
        virtual RAM_if RAM_vif;
        RAM_seq_item s_item;

        function new(string name = "RAM_driver", uvm_component parent = null);
            super.new(name,parent);    
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                s_item = RAM_seq_item::type_id::create("s_item");
                
                seq_item_port.get_next_item(s_item);
                RAM_vif.din=s_item.din;
                RAM_vif.rx_valid=s_item.rx_valid;
                RAM_vif.rst_n=s_item.rst_n;

                @(negedge RAM_vif.clk);

                seq_item_port.item_done();
            end
        endtask
    endclass
endpackage