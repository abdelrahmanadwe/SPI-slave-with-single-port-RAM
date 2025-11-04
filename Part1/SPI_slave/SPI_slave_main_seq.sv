package SPI_slave_main_seq_pkg;
    import SPI_slave_item_pkg::*;
    import shared_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_write_sequence extends uvm_sequence #(SPI_slave_item);
        `uvm_object_utils(SPI_slave_write_sequence)

        SPI_slave_item item;
        
        function new(string name = "SPI_slave_write_sequence");
            super.new(name);
        endfunction

        task body();
            
            item = SPI_slave_item::type_id::create("item");
            repeat(2000)begin
                
                assert(item.randomize() with{
                    operation inside{write_addr, write_data};
                    
                });
                send_transaction(item);
                   
            end
            
        endtask

        task send_transaction(SPI_slave_item trans_item);
            SPI_slave_item item;
            int transaction_cycle = trans_item.cycle_count;
            item = SPI_slave_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with{
                SS_n == 0;
                rst_n == 1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
                
            });
            finish_item(item);

            for(int j = 0; j < transaction_cycle-1; j++)begin
                
                start_item(item);
                assert(item.randomize() with{
                    SS_n == 0;
                    rst_n == 1;
                    operation == trans_item.operation;
                    tx_data   == trans_item.tx_data;
                    
                    MOSI == trans_item.MOSI_data[j];
                });
                finish_item(item);   
            end
            
            start_item(item);
            assert(item.randomize() with{
                SS_n  == 1;
                rst_n == 1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
                
            });
            finish_item(item);
            
        endtask
    endclass

    class SPI_slave_read_sequence extends uvm_sequence #(SPI_slave_item);
        `uvm_object_utils(SPI_slave_read_sequence)

        SPI_slave_item item;
        
        function new(string name = "SPI_slave_read_sequence");
            super.new(name);
        endfunction

        task body();
            
            item = SPI_slave_item::type_id::create("item");
            
            
            repeat(1000)begin
                

                assert(item.randomize() with{
                    operation inside{read_addr, read_data};
                    
                    if(pre_operation == read_addr){
                        operation == read_data;
                    }
                    else if(pre_operation == read_data){
                        operation == read_addr;
                    }
                    else{
                        operation == read_addr;
                    }

                         
                });
                
                
                send_transaction(item);
                   
            end
            
        endtask 

        task send_transaction(SPI_slave_item trans_item);
            SPI_slave_item item;
            int transaction_cycle = trans_item.cycle_count;
            item = SPI_slave_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with{
                SS_n == 0;
                rst_n ==1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
                
            });
            finish_item(item);

            for(int j = 0; j< transaction_cycle-1; j++)begin
                
                start_item(item);
                assert(item.randomize() with{
                    SS_n == 0;
                    rst_n == 1;
                    operation == trans_item.operation;
                    tx_data   == trans_item.tx_data;
                    
                    MOSI == trans_item.MOSI_data[j];
                });
                finish_item(item);   
            end
            
            start_item(item);
            assert(item.randomize() with{
                SS_n == 1;
                rst_n ==1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
               
            });
            finish_item(item);
            
        endtask 
    endclass


    class SPI_slave_read_write_sequence extends uvm_sequence #(SPI_slave_item);
        `uvm_object_utils(SPI_slave_read_write_sequence)

        SPI_slave_item item;
        
        function new(string name = "SPI_slave_read_write_sequence");
            super.new(name);
        endfunction

        task body();
            
            item = SPI_slave_item::type_id::create("item");
            repeat(2000)begin
                

                assert(item.randomize() with{
                    if(pre_operation == write_addr){
                        operation inside {write_addr, write_data};
                    }
                    else if (pre_operation == write_data){
                        operation dist {write_addr :/40, read_addr :/60, read_data :/0, write_data :/0};
                       
                    }
                    else if(pre_operation == read_addr){
                        operation == read_data;
                    }
                    else if(pre_operation == read_data){
                       operation dist {write_addr :/60, read_addr :/40, read_data :/0, write_data :/0};
                        
                    }
                    else{
                        operation == write_addr;
                    }
                         
                });
               
                send_transaction(item);
                
            end
            
        endtask 

        task send_transaction(SPI_slave_item trans_item);
            SPI_slave_item item;
            int transaction_cycle = trans_item.cycle_count;
            item = SPI_slave_item::type_id::create("item");
            start_item(item);
            assert(item.randomize() with{
                SS_n == 0;
                rst_n ==1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
                
            });
            finish_item(item);

            for(int j = 0; j< transaction_cycle-1; j++)begin
                
                start_item(item);
                assert(item.randomize() with{
                    SS_n == 0;
                    rst_n ==1;
                    operation == trans_item.operation;
                    tx_data   == trans_item.tx_data;
                    
                    MOSI == trans_item.MOSI_data[j];
                });
                finish_item(item);   
            end
            
            start_item(item);
            assert(item.randomize() with{
                SS_n == 1;
                rst_n ==1;
                operation == trans_item.operation;
                tx_data   == trans_item.tx_data;
                
            });
            finish_item(item);
            
        endtask 
    endclass

endpackage