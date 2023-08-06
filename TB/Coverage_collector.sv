
class Coverage_collector  extends uvm_subscriber #(SPI_seq_item);





  `uvm_component_utils(Coverage_collector)
  
  
  
  
  
  SPI_seq_item item;
  
  
  
  
  
  
  covergroup SPI_cover_signals ; 
  


        TX_Byte_cov: coverpoint item.i_TX_Byte ;

        MISO_cov: coverpoint item.MISO ;

     	      
  
  endgroup: SPI_cover_signals
  
  
  




  
  function new(string name = "Coverage_collector" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of coverage collector Class",UVM_LOW)
  
    SPI_cover_signals = new();
    
    
    
  endfunction :new
    
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of coverage collector Class",UVM_LOW)
	 
  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of coverage collector Class",UVM_LOW)
	 
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of coverage collector Class",UVM_LOW)
    
  
 
  endtask :run_phase
  
  
  
  
  
  
  
  
  
  function void write (SPI_seq_item  t);


      item = SPI_seq_item::type_id::create("item");
      
      $cast(item,t);
      
      SPI_cover_signals.sample();
	 
	    
  
     
     
  endfunction: write
  
  
  
  
  
  
  
  
  
  
  
  
  
  
endclass :Coverage_collector