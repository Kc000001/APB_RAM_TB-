//Define parkage and include all files
package apb_pkg;
	`include "uvm_macros.svh"
	 import uvm_pkg::*;
	`include "tb_defines.sv"
    `include "apb_base_seq_item.sv"
	`include "apb_master_seq.sv"
	`include "apb_master_sequencer.sv"
	`include "apb_master_driver.sv"
	`include "apb_master_config.sv"
	`include "apb_master_monitor.sv"
	`include "apb_coverage_monitor.sv"
	`include "apb_master_agent.sv"
	`include "apb_scoreboard.sv"
	`include "apb_env_config.sv"
	`include "apb_env.sv"
	`include "apb_test.sv"
endpackage
