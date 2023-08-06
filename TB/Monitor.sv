class Monitor  extends uvm_monitor;



  `uvm_component_utils(Monitor)
  
  
  virtual Interface intf;
  
  
  
  uvm_analysis_port #(SPI_seq_item) monitor_port;
  
  
  SPI_seq_item item;
  
  

  
  
  
  
  
  
  
  function new(string name = "Monitor" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of Monitor Class",UVM_LOW)
    
    
    
  endfunction :new
  
  
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of Monitor Class",UVM_LOW)
	 
    
	 if(!(uvm_config_db #(virtual Interface)::get(this,"*","intf",intf)))
	 
	     `uvm_error(get_type_name(),"failed to get virtual interface inside Monitor class")
  
  
    
	 monitor_port = new("monitor_port",this);
	 
	 
	 
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of Monitor Class",UVM_LOW)
	
  
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of Monitor Class",UVM_LOW)
  
    
	 item = SPI_seq_item::type_id::create("item");
  
    
	 
	 forever begin 
	 
	 
	   item = SPI_seq_item::type_id::create("item");
		
	   
           wait(!intf.i_Rst);
           
           repeat(8)   @(posedge intf.SCLK);
          

   
          item.i_Rst = intf.i_Rst;
          item.i_TX_Byte = intf.i_TX_Byte;
          item.i_TX_Valid = intf.i_TX_Valid;
          item.o_TX_Ready = intf.o_TX_Ready;
          item.o_RX_Valid = intf.o_RX_Valid;
          item.o_RX_Byte = intf.o_RX_Byte;
          item.SCLK = intf.SCLK;
          item.MISO = intf.MISO;
          item.MOSI = intf.MOSI;		   
         
          
          
   
	  monitor_port.write(item);
		


	 end
	 
	 
 
 
  endtask :run_phase
  
  
  
  
  
endclass :Monitor