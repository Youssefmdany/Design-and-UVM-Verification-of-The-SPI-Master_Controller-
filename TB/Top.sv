`timescale 1ns/1ns


`include "Interface.sv"



module Top();


import SPI_pkg::*;

import uvm_pkg::*;


logic clk;




Interface intf(.i_Clk(clk));




SPI_Master DUT   (    

                .i_Clk(clk),
                .i_Rst(intf.i_Rst),
				        .i_TX_Byte(intf.i_TX_Byte),
				        .i_TX_Valid(intf.i_TX_Valid),
				        .o_TX_Ready(intf.o_TX_Ready),
				        .o_RX_Valid(intf.o_RX_Valid),
				        .o_RX_Byte(intf.o_RX_Byte),
				        .SCLK(intf.SCLK),
				        .MISO(intf.MISO),
                .MOSI(intf.MOSI)
				                                       );




 


initial begin 


  clk = 0;
  
  forever  #5 clk = ~clk;


end







initial begin 


  uvm_config_db #(virtual Interface)::set(null,"*","intf",intf);
  
  
  run_test("SPI_Test");
  

end







initial begin 


  #800000

  $finish();


end



property Start_Of_SCLK;
  
  
  @(posedge intf.i_Clk) disable iff(intf.i_Rst) intf.i_TX_Valid==1  |-> ##[1:$] $rose(intf.SCLK) ; 
  
  
endproperty 


cover property (Start_Of_SCLK);





property End_Of_SCLK;
  
  
  @(posedge intf.i_Clk) disable iff(intf.i_Rst) intf.o_TX_Ready==1  |-> !intf.SCLK ; 
  
  
endproperty 


cover property (End_Of_SCLK);




property Not_Ready;
  
  
  @(posedge intf.SCLK) disable iff(intf.i_Rst) !intf.o_TX_Ready ; 
  
  
endproperty 


cover property (Not_Ready);






property Valid_Receiving;
  
  
  @(posedge intf.i_Clk) disable iff(intf.i_Rst) $rose(intf.o_RX_Valid) |-> ##[1:$] !intf.SCLK ; 
  
  
endproperty 


cover property (Valid_Receiving);





endmodule 