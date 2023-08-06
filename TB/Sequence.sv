
///////////////////////////////
//Base_sequence/////////////////////////////
///////////////////////////////

class Base_sequence extends uvm_sequence #(SPI_seq_item);

  
  
  `uvm_object_utils(Base_sequence)
   
  
  
  
  
  function  new(string name = "Base_sequence");
  
  
     super.new(name);
	  
  
  endfunction: new
  

  

endclass: Base_sequence







///////////////////////////////
//Reset_sequence/////////////////////////////
///////////////////////////////

class Reset_seq extends Base_sequence;



  `uvm_object_utils(Reset_seq)
  
  
   SPI_seq_item reset_item;
	

   function  new(string name = "Reset_seq");
  
  
     super.new(name);
	  
  
   endfunction: new
  
  
  
  
  
  task body();
  
  
    reset_item = SPI_seq_item::type_id::create("reset_item");
  
  
    start_item(reset_item);
	 
	 
	 if(!(reset_item.randomize() with { i_Rst==1;  i_TX_Byte==0; MISO== 0;} ))
	   
		   `uvm_error(get_type_name(),"randomization failed in Reset_seq")
		
	 
	 finish_item(reset_item);
	 
  
  endtask: body
  


  
endclass: Reset_seq











class SPI_seq extends Base_sequence;



  `uvm_object_utils(SPI_seq)
  
  
   SPI_seq_item item;
	

   function  new(string name = "SPI_seq");
  
  
     super.new(name);
	  
  
   endfunction: new
  
  
  
  
  
  task body();
  
  
    item = SPI_seq_item::type_id::create("item");
  
  
    start_item(item);
	 
	 
	 if(!(item.randomize() with { i_Rst==0; } ))
	 
	    	`uvm_error(get_type_name(),"randomization failed in SPI_seq")
 
	 
	 finish_item(item);
	 
  
  endtask: body
  
  


  
endclass: SPI_seq










