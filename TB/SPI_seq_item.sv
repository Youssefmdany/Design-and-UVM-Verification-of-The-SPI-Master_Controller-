
class SPI_seq_item extends uvm_sequence_item;




  `uvm_object_utils(SPI_seq_item)
  
  
  
  
// Control & Data Signals
   rand logic        i_Rst;  
   
   // TX (MOSI) Signals
   rand logic [7:0]  i_TX_Byte;
   rand logic        i_TX_Valid;
   logic             o_TX_Ready;   
   
   // RX (MISO) Signals
   logic             o_RX_Valid; 
   logic [7:0]       o_RX_Byte; 

   // SPI Signals
   logic              SCLK;
   rand logic         MISO;
   logic              MOSI;   

  
  
  

  

 
  
  
  function new(string name = "SPI_seq_item");
  
  
    super.new(name);
  
    `uvm_info(get_type_name(),"Inside constructor of SPI seq item Class",UVM_HIGH)
  
  
  endfunction :new
  
  
  
  
  
  
  
  
  
endclass :SPI_seq_item