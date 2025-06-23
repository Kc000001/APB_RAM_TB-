//Define a uvm_sequence_item class named apb_base_seq_item
//apb_base_sequence_item derived from base uvm_sequence_item
`ifndef apb_seq_item
`define apb_seq_item
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "tb_defines.sv"
class apb_base_seq_item extends uvm_sequence_item;
     
	//typedef for Read/Write transaction type
  typedef enum {READ, WRITE} apb_transfer_direction_t;		
	bit [`DATA_WIDTH-1:0] data;		
	//	Data Members	
	rand bit   [`ADDR_WIDTH-1:0] 	    addr;      //address
 	rand logic [`DATA_WIDTH-1:0] 	    wdata;     //data- for write response
 	rand logic [`DATA_WIDTH-1:0] 	    rdata;     //data- for read response
	rand int 					              	delay;     //delay
	randc apb_transfer_direction_t  	apb_tr;    //command type
	rand int wait_state;
	rand bit same_slave;	


	// constraints
	constraint c_addr { addr[1:0] == 0; }
	constraint c_delay { delay inside {[1:2]}; }
 	constraint const_wait { soft wait_state inside {[1:3]}; }
	constraint addr_c {soft addr inside {[0:`APB_RAM_SIZE-1]};}
  //Register with uvm factory 
  `uvm_object_utils_begin(apb_base_seq_item)
	`uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_field_enum(apb_transfer_direction_t, apb_tr, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end
    
  //constructor
  function new (string name = "apb_base_seq_item");
	  super.new(name);
  endfunction
  
  //print results for master transactions
  function string apb_master();
	  return $sformatf("APB_MASTER_TRANSFER : DIR=%s ADDR=%0h  WDATA=%0h RDATA=%0h",apb_tr,addr,wdata,rdata);
  endfunction

  //print for slave transactions
  function string apb_slave();
	  return $sformatf("APB_SLAVE_TRANSFER :  DIR=%s ADDR=%0h WDATA=%0h RDATA=%0h",apb_tr,addr,wdata,rdata);
  endfunction


endclass  //end of the class
`endif
