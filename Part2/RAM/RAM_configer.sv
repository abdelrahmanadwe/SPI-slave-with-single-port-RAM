package RAM_configer_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
class RAM_configer extends uvm_object;
    `uvm_object_utils(RAM_configer)

        virtual RAM_if RAM_vif;
        uvm_active_passive_enum is_active;
    function  new(string name = "RAM_configer");
        super.new(name);
    endfunction
endclass
endpackage