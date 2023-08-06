


interface Interface (input logic i_Clk);


	         

   logic         i_Rst;  
   logic[7:0]    i_TX_Byte;
   logic         i_TX_Valid;
   logic         o_TX_Ready;   
   logic         o_RX_Valid; 
   logic[7:0]    o_RX_Byte; 
   logic         SCLK;
   logic         MISO;
   logic         MOSI;   
   



endinterface 