
class Driver  extends uvm_driver #(SPI_seq_item);



  `uvm_component_utils(Driver)
  
  
  virtual Interface intf;
  
  
  SPI_seq_item item;
  
  
  
  
  
  
  
  function new(string name = "Driver" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of Driver Class",UVM_LOW)
  
  
  endfunction :new
  
  
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of Driver Class",UVM_LOW)
   
   
   if(!(uvm_config_db #(virtual Interface)::get(this,"*","intf",intf)))
	 
	     `uvm_error(get_type_name(),"failed to get virtual interface inside Driver class")
  


  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of Driver Class",UVM_LOW)
	 
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  task run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of Driver Class",UVM_LOW)
    
	 
	 
	 
	 forever begin 
	 
	 
	 
	  item = SPI_seq_item::type_id::create("item");

	 
	  seq_item_port.get_next_item(item);
	  
	  
	  drive(item);
	  
	  
	  
	  seq_item_port.item_done();
	  
	  
	 
	 end
	 
 
 
 
  endtask :run_phase
  
  
  
  
  
  
  
  
  task  drive (SPI_seq_item item);
  
  
  if(item.i_Rst==1)begin
  
          intf.i_Rst = item.i_Rst;
          intf.i_TX_Byte = item.i_TX_Byte;
          intf.i_TX_Valid = item.i_TX_Valid;     
            
   end  
  
  
  else begin 
  
   	fork
 	
 	
 	      begin
 	        
	        intf.i_Rst = item.i_Rst;
          intf.i_TX_Byte = item.i_TX_Byte;
          intf.i_TX_Valid = 1;
          
          @(posedge intf.i_Clk);
          
          intf.i_TX_Valid = 0;
          
          @(posedge intf.o_TX_Ready);
           
        end  
        
        
        
        
        
        begin
          
          
          
          repeat(8) begin 
            
          intf.MISO = $urandom_range(0,1);  
                 
          @(posedge intf.SCLK);
          
          repeat(3) @(posedge intf.i_Clk); // make some delay between posedge of sclk and miso signal
          
           end
          
          
        end
          

    join
  
  intf.MISO = 0;
  
  
  end
  
  
  
  
  endtask: drive

  
  
  
 
  
  
  
endclass :Driver