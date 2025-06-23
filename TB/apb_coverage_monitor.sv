`ifndef apb_coverage
`define apb_coverage
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;
`include "tb_defines.sv"

class apb_coverage_monitor extends uvm_subscriber#(apb_base_seq_item);
	`uvm_component_utils(apb_coverage_monitor)

	apb_base_seq_item item;

	localparam MAX_POSS_ADDR = 2**`ADDR_WIDTH-1;

	localparam DATA_BOUND_1 = (2**`DATA_WIDTH)/4;	
	localparam DATA_BOUND_2 = 2*((2**`DATA_WIDTH)/4); 
	localparam DATA_BOUND_3 = 3*((2**`DATA_WIDTH)/4);
	localparam DATA_BOUND_4 = 4*((2**`DATA_WIDTH)/4);

	covergroup apb_cg;
		ADDRESS:coverpoint item.addr{
					option.auto_bin_max=`APB_RAM_SIZE;
					bins valid_addr[`APB_RAM_SIZE]= {[`APB_RAM_SIZE-1:0]} iff(`APB_RAM_SIZE < MAX_POSS_ADDR);
					ignore_bins out_of_bound_addr[] = {[MAX_POSS_ADDR:`APB_RAM_SIZE]} iff(`APB_RAM_SIZE < MAX_POSS_ADDR);
				}
		
		WDATA: coverpoint item.wdata{
			bins low_val_data = {[DATA_BOUND_1-1:0]};
			bins mid_val_data = {[DATA_BOUND_2-1 : DATA_BOUND_1]};
			bins mid_high_val_data = {[DATA_BOUND_3-1:DATA_BOUND_2]};		   bins high_val_data   = {[DATA_BOUND_4-1 : DATA_BOUND_3]};		}
		RDATA: coverpoint item.rdata{
			bins low_val_data = {[DATA_BOUND_1-1:0]};
			bins mid_val_data = {[DATA_BOUND_2-1 : DATA_BOUND_1]};
			bins mid_high_val_data = {[DATA_BOUND_3-1:DATA_BOUND_2]};		   bins high_val_data   = {[DATA_BOUND_4-1 : DATA_BOUND_3]};		}
		APB_TRANS: coverpoint item.apb_tr{
			bins  WRITE_TR = {1};
			bins  READ_TR  = {0};	
			}

	 READ_CROSS : cross ADDRESS ,RDATA, APB_TRANS {bins read = binsof(APB_TRANS.READ_TR);}

	WRITE_CROSS : cross ADDRESS, WDATA, APB_TRANS {bins write =binsof(APB_TRANS.WRITE_TR);}


	endgroup
	//	apb_cg cg;
	function new(string name = "apb_coverage_monitor", uvm_component parent=null);
		super.new(name,parent);
		
	 apb_cg = new();
	
	endfunction

	virtual function void write(apb_base_seq_item t);
		item = apb_base_seq_item::type_id::create("item");
		
		item.addr = t.addr;
		item.wdata = t.wdata;
		item.rdata = t.rdata;
		item.apb_tr = t.apb_tr;


		apb_cg.sample();
	endfunction:write

	


endclass:apb_coverage_monitor
`endif
