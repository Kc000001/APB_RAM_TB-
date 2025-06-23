//Define the testbench module
//mention timescale
`timescale 1ns/1ns
`include "uvm_macros.svh"
`include "apb_pkg.sv"
import uvm_pkg::*;
import apb_pkg::*;
//`include "apb_pkg.sv"
`include "apb_if.sv"
`include "./../DUT/apb_ram.sv"
 
module apb_testbench;

  //control signals
	logic pclk;
	logic presetn; 
  //signals
	logic [`ADDR_WIDTH-1:0] paddr;
	logic        psel;
	logic        penable;
	logic        pwrite;
	logic [`DATA_WIDTH-1:0] prdata;
	logic [`DATA_WIDTH-1:0] pwdata;
  
  //initialize the clock and reset signals
	initial begin
		pclk=0;
	end
	
	initial begin
		presetn=1; 
		#40; 
		presetn=0;
//		#300;
//		presetn=1;
//		#40;
//		presetn=0;
	end	

	//Generate a clock
	always begin
		#10 pclk = ~pclk;
	end	
	
	// instantiate a physical interface foe apb interface
	apb_if  apb_if(pclk,presetn);


	apb_ram #(.ADDR_WIDTH(`ADDR_WIDTH),
			.DATA_WIDTH(`DATA_WIDTH),						
			.RAM_SIZE(`APB_RAM_SIZE),
			.EN_WAIT_DELAY_FUNC(`APB_EN_WAIT_DELAY_FUNC),
			.MIN_RAND_WAIT_CYC (`APB_MIN_RAND_WAIT_CYC),
			.MAX_RAND_WAIT_CYC (`APB_MAX_RAND_WAIT_CYC)
			
						) DUT(.pclk(pclk),
						.presetn(presetn),
						.penable(apb_if.PENABLE),
						.pwrite(apb_if.PWRITE),
						.psel(apb_if.PSEL),
						.pwdata(apb_if.PWDATA),
						.prdata(apb_if.PRDATA),
						.paddr(apb_if.PADDR),
						.pready(apb_if.PREADY),
						.pslverr(apb_if.PSLVERR));
  
	initial begin
	//	uvm_top.set_report_verbosity_level(UVM_NONE);
    //uvm configuration : set the interface instance as the virtual interface
		uvm_config_db#(virtual apb_if)::set( null,"*", "apb_vif", apb_if);
		run_test("apb_test_wr"); //include test class name
	end
//	initial begin
	//	$dumpfile("apb_test_wr_vcd.vcd");
	//	$dumpvars(0);
	//end
	
endmodule // end of the module
