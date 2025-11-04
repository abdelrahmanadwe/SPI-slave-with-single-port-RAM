interface SPI_wrapper_if(clk);
    input bit clk;
    logic  MOSI, SS_n, rst_n;
    logic  MISO;

    logic MISO_GM;

    modport DUT (
    input clk,SS_n,MOSI,rst_n,
    output MISO
    );

    // modport GOLDEN_MODEL (
    // input clk,SS_n,MOSI,rst_n,
    // output MISO_GM
    // );
    
endinterface