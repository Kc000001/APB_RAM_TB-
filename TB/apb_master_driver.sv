
//define uvm driver class named apb_maser_driver
`ifndef apb_master_driver
`define apb_master_driver
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

class apb_master_driver extends uvm_driver#(apb_base_seq_item);

  //register the class with uvm factory
	`uvm_component_utils(apb_master_driver)
	uvm_analysis_port#(apb_base_seq_item) drv2scb;	
  //declare a virtual interface instance 
	virtual apb_if 			vif;
  //handle for base sequence
	apb_base_seq_item 	m_apb_base_seq_item;
	
  //constructor
  function new(string name = "apb_master_driver", uvm_component parent = null);
    //call the base class constructor
	  super.new(name, parent);
	  drv2scb = new("drv2scb", this);
  endfunction: new	
	
  //build phase : set up the virtual interface connection
  function void build_phase(uvm_phase phase);
  //call the base class build phase
  	super.build_phase(phase);
	  if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		  `uvm_fatal(get_full_name(), "No virtual interface specified for apb_master_driver")
  	end 	
  endfunction
	
  //run_phase
  task run_phase(uvm_phase phase);
	  super.run_phase(phase);			
	  	vif.master.PSEL    	<= 1'b0; //init_signals();
	    vif.master.PENABLE  <= 1'b0;
	    wait(!vif.PRESET_N);        //wait signal
	    master_get_drive();	
  endtask
	
// Task: master_get_drive
// Definition: this task select the transfer type
task master_get_drive();
//	forever begin
	//	if (vif.PRESET_N) disable driver_forever;
		//@(posedge vif.PCLK);
	//end
  //forever loop to handle incoming sequence items
	forever begin : driver_forever
		m_apb_base_seq_item = apb_base_seq_item::type_id::create("m_apb_base_seq_item",this);
		seq_item_port.get_next_item(m_apb_base_seq_item);
		@(posedge vif.PCLK);
		vif.master.PSEL    <= 1'b1;
		vif.master.PADDR   <= m_apb_base_seq_item.addr;
		vif.master.PWRITE  <= m_apb_base_seq_item.apb_tr;
		if(m_apb_base_seq_item.apb_tr == 1)
		vif.master.PWDATA  <= m_apb_base_seq_item.wdata;
		
		@ (posedge vif.PCLK);
		vif.master.PENABLE <= '1;
		
		wait(vif.master.PREADY);	
		@ (posedge vif.PCLK);
		

		vif.master.PSEL    <= '0; 
		vif.master.PENABLE <= '0;
		m_apb_base_seq_item.data = m_apb_base_seq_item.wdata;
		if(m_apb_base_seq_item.apb_tr == 1)
		drv2scb.write(m_apb_base_seq_item);
		
	seq_item_port.item_done();
    uvm_report_info("APB_MASTER_DRIVER ", $sformatf(" %s",m_apb_base_seq_item.apb_master()));
	  m_apb_base_seq_item.print();
	end	:driver_forever
		
endtask


endclass // end of the class
`endif
