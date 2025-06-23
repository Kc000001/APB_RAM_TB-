//define apb_master sequence class
`ifndef apb_master_seq
`define apb_master_seq
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

class apb_master_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_seq)
  
  //constructor
  function new(string name ="apb_master_seq");
    //call thebase class constructor
	  super.new(name);
  endfunction

  //task for defining the sequence body
  task body();
    //declare an instance of the apb_base_sequence item transaction
	  apb_base_seq_item m_apb_base_seq_item;	
    //create 10 random apb master sequences and send to master driver
  	repeat(20) begin
      //create a new instance of the apb_base_seq_item transaction
		  m_apb_base_seq_item = apb_base_seq_item::type_id::create("m_apb_base_seq_item");
		  /*start_item(m_apb_base_seq_item);          //start the transaction item
		  assert (m_apb_base_seq_item.randomize());   //randomize the transaction item
		  finish_item(m_apb_base_seq_item);*/         //finish the transaction item
      `uvm_do(m_apb_base_seq_item)
	  end
  endtask
	
endclass  // end of the class

class apb_master_write_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_write_seq)
  
  //constructor
  function new(string name ="apb_master_write_seq");
    //call thebase class constructor
	  super.new(name);
  endfunction

  //task for defining the sequence body
  task body();
    //declare an instance of the apb_base_sequence item transaction
	  apb_base_seq_item m_apb_base_seq_item;	
    //create 10 random apb master sequences and send to master driver
  	repeat(20) begin
      //create a new instance of the apb_base_seq_item transaction
		  m_apb_base_seq_item = apb_base_seq_item::type_id::create("m_apb_base_seq_item");
//		  start_item(m_apb_base_seq_item);          //start the transaction item
//		  assert (m_apb_base_seq_item.randomize());   //randomize the transaction item
//	  m_apb_base_seq_item.apb_tr = apb_base_seq_item::READ;
//	  finish_item(m_apb_base_seq_item);         //finish the transaction item
      `uvm_do_with(m_apb_base_seq_item,{apb_tr == apb_base_seq_item::WRITE;})
	  end
  endtask
	
endclass

 class apb_master_read_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_read_seq)
  
  //constructor
  function new(string name ="apb_master_read_seq");

    //call thebase class constructor
	  super.new(name);
  endfunction

  //task for defining the sequence body
  task body();
    //declare an instance of the apb_base_sequence item transaction
	  apb_base_seq_item m_apb_base_seq_item;	
    //create 10 random apb master sequences and send to master driver
  	repeat(20) begin
      //create a new instance of the apb_base_seq_item transaction
		  m_apb_base_seq_item = apb_base_seq_item::type_id::create("m_apb_base_seq_item");
//		  start_item(m_apb_base_seq_item);          //start the transaction item
//		  assert (m_apb_base_seq_item.randomize());   //randomize the transaction item
//	  m_apb_base_seq_item.apb_tr = apb_base_seq_item::READ;
//	  finish_item(m_apb_base_seq_item);         //finish the transaction item
      `uvm_do_with(m_apb_base_seq_item,{apb_tr == apb_base_seq_item::READ;})
	  end
  endtask
	
endclass 

 class apb_master_error_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_error_seq)
  
  //constructor
  function new(string name ="apb_master_error_seq");

    //call thebase class constructor
	  super.new(name);
  endfunction

  //task for defining the sequence body
  task body();
    //declare an instance of the apb_base_sequence item transaction
	  apb_base_seq_item m_apb_base_seq_item;	
    //create 10 random apb master sequences and send to master driver
  	repeat(20) begin
      //create a new instance of the apb_base_seq_item transaction
		  m_apb_base_seq_item = apb_base_seq_item::type_id::create("m_apb_base_seq_item");
//		  start_item(m_apb_base_seq_item);          //start the transaction item
//		  assert (m_apb_base_seq_item.randomize());   //randomize the transaction item
//	  m_apb_base_seq_item.apb_tr = apb_base_seq_item::READ;
//	  finish_item(m_apb_base_seq_item);         //finish the transaction item
      `uvm_do_with(m_apb_base_seq_item,{addr >60;})
	  end
  endtask
	
endclass 
`endif
