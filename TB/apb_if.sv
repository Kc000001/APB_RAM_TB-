//APB interfcae named apb_if
              // APB PWDATA and PRDATA Bus width
`ifndef apb_interface
`define `apb_interface
`include "tb_defines.sv"
interface apb_if(input bit PCLK, PRESET_N);
	
  //signals
	logic [`ADDR_WIDTH-1:0] PADDR;
	logic [`DATA_WIDTH-1:0] PWDATA;
	logic [`DATA_WIDTH-1:0] PRDATA;	
	logic 		PSEL;
	logic 		PENABLE;
	logic 		PWRITE;
	logic 		PREADY;
	logic 		PSLVERR;
	
	//master clocking block
	clocking master_cb @(posedge PCLK);
		output PADDR, PSEL, PENABLE, PWRITE, PWDATA;
		input  PRDATA, PREADY;
	endclocking: master_cb
	
	//slave clocking block
//	clocking slave_cb @(posedge PCLK);
//		input  PADDR, PSEL, PENABLE, PWRITE, PWDATA;
//		output PRDATA, PREADY;
//	endclocking: slave_cb
	
  //master modport to define directions of master
	modport master(	input  PRDATA, PREADY,PRESET_N,
					output PADDR, PSEL, PENABLE, PWRITE, PWDATA	);
	
  //slave modport to define directions of slave
//	modport slave(	input  PADDR, PSEL, PENABLE, PWRITE, PWDATA,PRESET_N,
//					output PRDATA, PREADY);
  
endinterface // end of the interface

`endif
