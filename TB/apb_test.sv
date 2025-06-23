//Top level test class that instanties environment , configurations and start stimulus

`ifndef apb_test
`define apb_test
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

class apb_test_lib extends uvm_test;
 	`uvm_component_utils(apb_test_lib)
	
	apb_env env;
	apb_master_config 	m_apb_master_config;
	apb_env_config		d_apb_env_config;
	
	virtual apb_if vif;
	
  function new(string name = "apb_test_lib", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
      env = apb_env::type_id::create("env", this);	
	  m_apb_master_config = apb_master_config::type_id::create("m_apb_master_config"); 	
	  d_apb_env_config = apb_env_config::type_id::create("d_apb_env_config");	
		
	  uvm_config_db#(apb_master_config)::set(null, "","apb_master_config", m_apb_master_config);
	  uvm_config_db#(apb_env_config)::set(null,"","apb_env_config",d_apb_env_config);
	
	  if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		  `uvm_fatal(get_full_name(), "No virtual interface specified for this test instance")
	  end 
  endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

endclass

class apb_test extends apb_test_lib;

	//Register with factory
	`uvm_component_utils(apb_test)
  
		
	apb_master_seq master_seq;
  
  //constructor for the class
  function new(string name = "apb_test", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
  


task run_phase( uvm_phase phase );
	  super.run_phase(phase);
	  master_seq = apb_master_seq::type_id::create("master_seq");

	  phase.raise_objection( this, "Starting apb_test run phase" );
	  repeat(1) begin
			  master_seq.start(env.master_agent.m_sequencer);
	  end	
	  #100ns;
	  phase.drop_objection( this , "Finished apb_test in run phase" );
  endtask	

endclass // end of the class

class apb_test_wr extends apb_test_lib;
	`uvm_component_utils(apb_test_wr)

	apb_master_write_seq master_write_seq;

  function new(string name = "apb_test_wr", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
task run_phase( uvm_phase phase );
	  super.run_phase(phase);
	  master_write_seq = apb_master_write_seq::type_id::create("master_write_seq");

	  phase.raise_objection( this, "Starting apb_test run phase" );
	  repeat(1) begin
			  master_write_seq.start(env.master_agent.m_sequencer);
	  end	
	  #100ns;
	  phase.drop_objection( this , "Finished apb_test in run phase" );
  endtask

endclass

class apb_test_rd extends apb_test_lib;
	`uvm_component_utils(apb_test_rd)

	apb_master_read_seq master_read_seq;

  function new(string name = "apb_test_rd", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
task run_phase( uvm_phase phase );
	  super.run_phase(phase);
	  master_read_seq = apb_master_read_seq::type_id::create("master_read_seq");

	  phase.raise_objection( this, "Starting apb_test run phase" );
	  repeat(1) begin
			  master_read_seq.start(env.master_agent.m_sequencer);
	  end	
	  #100ns;
	  phase.drop_objection( this , "Finished apb_test in run phase" );
  endtask


endclass

	//
class apb_test_error extends apb_test_lib;
	`uvm_component_utils(apb_test_error)

	apb_master_error_seq master_error_seq;

  function new(string name = "apb_test_error", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
task run_phase( uvm_phase phase );
	  super.run_phase(phase);
	  master_error_seq = apb_master_error_seq::type_id::create("master_error_seq");

	  phase.raise_objection( this, "Starting apb_test run phase" );
	  repeat(1) begin
			  master_error_seq.start(env.master_agent.m_sequencer);
	  end	
	  #100ns;
	  phase.drop_objection( this , "Finished apb_test in run phase" );
  endtask


endclass
`endif
