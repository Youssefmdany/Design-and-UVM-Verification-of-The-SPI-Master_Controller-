class Agent  extends uvm_agent;



  `uvm_component_utils(Agent)
  
  
  
  Monitor SPI_monitor;
  
  Driver SPI_driver;
  
  Sequencer SPI_sequencer;
  
  Coverage_collector  SPI_coverage_collector; 
  
  
  function new(string name = "Agent" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of Agent Class",UVM_LOW)
  
  
  endfunction :new
  
  
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of Agent Class",UVM_LOW)

         SPI_monitor = Monitor::type_id::create("SPI_monitor",this);
	 
	 SPI_driver = Driver::type_id::create("SPI_driver",this);
	 
	 SPI_sequencer = Sequencer::type_id::create("SPI_sequencer",this);
	 
         SPI_coverage_collector = Coverage_collector::type_id::create("SPI_coverage_collector",this); 
        
  
  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of Agent Class",UVM_LOW)
	 
	 
	 SPI_driver.seq_item_port.connect(SPI_sequencer.seq_item_export);
	 SPI_monitor.monitor_port.connect(SPI_coverage_collector.analysis_export); 
  
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of Agent Class",UVM_LOW)
  
 
  endtask :run_phase
  
  
endclass :Agent