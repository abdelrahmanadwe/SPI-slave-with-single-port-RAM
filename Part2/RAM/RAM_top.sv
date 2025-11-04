import uvm_pkg::*;
import RAM_test_pkg::*;
`include "uvm_macros.svh"
module top();
    bit clk;

    initial begin
        clk=0;
        forever begin 
            #1 clk=~clk;
        end
    end

    RAM_if IF(clk);
    
    RAM dut (IF.din, IF.clk, IF.rst_n, IF.rx_valid, IF.dout, IF.tx_valid);

    bind RAM assertions sva(IF.din, IF.clk, IF.rst_n, IF.rx_valid, IF.dout, IF.tx_valid);
    
    RAM_golden_model u1 (IF.din, IF.rx_valid, IF.clk, IF.rst_n, IF.ex_dout, IF.ex_tx_valid);
    
    initial begin
        uvm_config_db #(virtual RAM_if):: set (null,"uvm_test_top", "CFG",IF);
        run_test("RAM_test");
     end
endmodule