class SPI_Test  extends uvm_test;



  `uvm_component_utils(SPI_Test)
  
  
  
  Environment SPI_environment;
  
  
  
  Reset_seq reset_seq;
  
  SPI_seq seq;


  
  
  
  function new(string name = "SPI_Test" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of SPI Test Class",UVM_LOW)
  
  
  endfunction :new
  
  
  
  
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of SPI Test Class",UVM_LOW)

	 
	 SPI_environment = Environment::type_id::create("SPI_environment",this);
	 
	 
  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of SPI Test Class",UVM_LOW)
	 
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of SPI Test Class",UVM_LOW)
  
   
	
	 phase.raise_objection(this);
  
    
	    //apply reset sequence
	    
      
      reset_seq = Reset_seq::type_id::create("reset_seq");
	 
	    reset_seq.start(SPI_environment.SPI_Agent.SPI_sequencer);
		 
      #300
		 
		 
		 repeat(500) begin 
		 
      
		  		 
		  seq = SPI_seq::type_id::create("seq");
	 
	    seq.start(SPI_environment.SPI_Agent.SPI_sequencer);
	    
		  #150;		 

		 
		 
		 end
	 
	 
	 
	 phase.drop_objection(this);
  
  
  
  
 
  endtask :run_phase
  
  
  
  
  
  
  
  
endclass :SPI_Test
