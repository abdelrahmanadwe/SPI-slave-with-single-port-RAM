import shared_pkg::*;

module SLAVE (SPI_slave_if.DUT SPI_slaveif);

    reg [3:0] counter;
    reg received_address;
    
    state_t cs, ns;


    always @(posedge SPI_slaveif.clk) begin
        if (~SPI_slaveif.rst_n) begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    always @(*) begin
        case (cs)
            IDLE : begin
                if (SPI_slaveif.SS_n)
                    ns = IDLE;
                else
                    ns = CHK_CMD;
            end
            CHK_CMD : begin
                if (SPI_slaveif.SS_n)
                    ns = IDLE;
                else begin
                    if (~SPI_slaveif.MOSI)
                        ns = WRITE;
                    else begin
                        if (!received_address) 
                            ns = READ_ADD; 
                        else
                            ns = READ_DATA;
                    end
                end
            end
            WRITE : begin
                if (SPI_slaveif.SS_n)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
            READ_ADD : begin
                if (SPI_slaveif.SS_n)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end
        READ_DATA : begin
                if (SPI_slaveif.SS_n)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
            default : ns = IDLE;
        endcase
    end

    always @(posedge SPI_slaveif.clk) begin
        if (~SPI_slaveif.rst_n) begin 
            SPI_slaveif.rx_data <= 0;
            SPI_slaveif.rx_valid <= 0;
            received_address <= 0;
            SPI_slaveif.MISO <= 0;
            
        end
        else begin
            case (cs)
                IDLE : begin
                    SPI_slaveif.rx_valid <= 0;
                    SPI_slaveif.rx_data <= 0;
                    
                end
                CHK_CMD : begin
                    counter <= 10; 
                    
                end
                WRITE : begin
                    if (counter > 0 && !SPI_slaveif.rx_valid) begin
                    SPI_slaveif.rx_data[counter-1] <= SPI_slaveif.MOSI;
                        counter <= counter - 1;
                        
                    end
                    else begin
                        
                        SPI_slaveif.rx_valid <= 1;
                        
                        
                    end
                end
                READ_ADD : begin
                    if (counter > 0 && !SPI_slaveif.rx_valid) begin
                        SPI_slaveif.rx_data[counter-1] <= SPI_slaveif.MOSI;
                        counter <= counter - 1;
                        
                    end
                    else begin
                        
                        SPI_slaveif.rx_valid <= 1;
                        received_address <= 1;
                    
                    end
                end
            READ_DATA : begin
                    if (SPI_slaveif.tx_valid && (SPI_slaveif.rx_valid)) begin
                        
                        if (counter > 0) begin
                            SPI_slaveif.MISO <= SPI_slaveif.tx_data[counter-1];
                            counter <= counter - 1;

                        end
                        else begin
                            received_address <= 0;
                            
                        end
                    end
                    else begin
                        if (counter > 0 && !SPI_slaveif.rx_valid) begin
                            SPI_slaveif.rx_data[counter-1] <= SPI_slaveif.MOSI;
                            counter <= counter - 1;
                            
                        end
                        else begin
                            
                            SPI_slaveif.rx_valid <= 1;
                            counter <= 8;
                            
                        end
                    end
                end
                default : ns = IDLE;
            endcase
        end
    end

    `ifdef SIM
        property IDLE_to_CHK_CMD;
        @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) ( $fell(SPI_slaveif.SS_n) && cs == IDLE)|-> (ns == CHK_CMD);
        endproperty

        assert property (IDLE_to_CHK_CMD);
        cover  property (IDLE_to_CHK_CMD);

        property CHK_CMD_to_write;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (!SPI_slaveif.SS_n && cs == CHK_CMD && !SPI_slaveif.MOSI) |-> (ns == WRITE);
        endproperty

        assert property (CHK_CMD_to_write);
        cover  property (CHK_CMD_to_write);

        property CHK_CMD_read_address;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (!SPI_slaveif.SS_n && cs == CHK_CMD && SPI_slaveif.MOSI && !received_address) |-> (ns == READ_ADD);
        endproperty

        assert property (CHK_CMD_read_address);
        cover  property (CHK_CMD_read_address);

        property CHK_CMD_to_read_data;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (!SPI_slaveif.SS_n && cs == CHK_CMD && SPI_slaveif.MOSI && received_address) |-> (ns == READ_DATA);
        endproperty

        assert property (CHK_CMD_to_read_data);
        cover  property (CHK_CMD_to_read_data);


        property WRITE_to_IDLE;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (SPI_slaveif.SS_n && cs == WRITE) |-> (ns == IDLE);
        endproperty

        assert property (WRITE_to_IDLE);
        cover  property (WRITE_to_IDLE);

        property READ_ADD_to_IDLE;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (SPI_slaveif.SS_n && cs == READ_ADD) |-> (ns == IDLE);
        endproperty

        assert property (READ_ADD_to_IDLE);
        cover  property (READ_ADD_to_IDLE);

        property READ_DATA_to_IDLE;
            @(posedge SPI_slaveif.clk) disable iff (!SPI_slaveif.rst_n) (SPI_slaveif.SS_n && cs == READ_DATA) |-> (ns == IDLE);
        endproperty

        assert property (READ_DATA_to_IDLE);
        cover  property (READ_DATA_to_IDLE);
    `endif

endmodule