//Define apb_master sequencer
`ifndef apb_master_seqr
`define apb_master_seqr
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

class apb_master_sequencer extends uvm_sequencer#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_component_utils(apb_master_sequencer)
  
  //constructor
	function new(string name = "apb_master_sequencer", uvm_component parent = null);
   //call the base class constructorr
		super.new(name, parent);
	endfunction
  
endclass //end of the class
`endif
