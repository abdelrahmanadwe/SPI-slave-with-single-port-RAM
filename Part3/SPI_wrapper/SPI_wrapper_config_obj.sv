package SPI_wrapper_config_obj_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class SPI_wrapper_config_obj extends uvm_object;
        `uvm_object_utils(SPI_wrapper_config_obj)
        virtual SPI_wrapper_if SPI_wrapper_vif;
        uvm_active_passive_enum is_active;
    
        function new(string name = "shift_reg_cfg");
            super.new(name);
        endfunction 

    endclass


endpackage