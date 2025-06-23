`ifndef apb_scoreboard
`define apb_scoreboard
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;
`include "tb_defines.sv"
`uvm_analysis_imp_decl(_drv2scb)
`uvm_analysis_imp_decl(_mntr2scb)
class apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_scoreboard)
    
    apb_base_seq_item            exp_seq_item;       // expected data queue
    apb_base_seq_item            exp_seq_item_q[$];  // expected seq_item_data_q
    apb_base_seq_item            rcvd_seq_item_q[$]; // received seq_item_data_q
	reg [`DATA_WIDTH-1:0] ref_mem [0:`APB_RAM_SIZE-1];
	int errors;
    
    // analysis port declaration
    uvm_analysis_imp_drv2scb#(apb_base_seq_item, apb_scoreboard)     ap_drv2scb;     // driver to scoreboard
    uvm_analysis_imp_mntr2scb#(apb_base_seq_item, apb_scoreboard)    ap_mntr2scb;    /// monitor to scoreboard

    // constructor function
    function new(string name="apb_scoreboard", uvm_component parent);
        super.new(name, parent);
        // create analysis ports
        ap_drv2scb = new("ap_drv2scb", this);
        ap_mntr2scb = new("ap_mntr2scb", this);
    endfunction: new
    
    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
		foreach(ref_mem[i])	ref_mem[i]=i;
    endfunction: build_phase
    
    // connect_phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction: connect_phase
    
    // run_phase
    virtual task run_phase(uvm_phase phase);
        apb_base_seq_item  exp_pkt, rcvd_pkt; // APB PADDR BUS wi  vd_pkt;
        super.run_phase(phase);
        
      forever begin
            wait(rcvd_seq_item_q.size() !=0);
              //  exp_pkt = exp_seq_item_q.pop_front();
                rcvd_pkt = rcvd_seq_item_q.pop_front();
                compare_pkt(rcvd_pkt);                
        end  
      
    endtask: run_phase
    
    // driver to scoreboard write function
    function void write_drv2scb(apb_base_seq_item item);
        // print seq_item details received from driver
		$display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        `uvm_info("SCB", $sformatf("Seq_item written from driver: \n"), UVM_NONE)
        item.print();
        $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        // push the expected seq_item in queue
        //exp_seq_item_q.push_back(item);
		ref_mem[item.addr] = item.data;
    endfunction: write_drv2scb
    
    // monitor to scoreboard write function
    function void write_mntr2scb(apb_base_seq_item item);
        // print seq_item details received from monitor
		$display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
        `uvm_info("SCB", $sformatf("Seq_item written from monitor: \n"), UVM_NONE)
        item.print();
        $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
        // push captured seq_item into queue
        rcvd_seq_item_q.push_back(item);
    endfunction: write_mntr2scb
    
    // compare packets
    function void compare_pkt(/*input apb_base_seq_item exp_pkt,*/ apb_base_seq_item rcvd_pkt);
       // if(exp_pkt.addr == rcvd_pkt.addr) begin
            if(ref_mem[rcvd_pkt.addr] != rcvd_pkt.data) begin
				errors++;
                `uvm_error("data MISMATCH ERROR", $sformatf("SCB:: For addr: %0h Expecting data:%0h but Received data: %0h ERROR_COUNT =%0d", rcvd_pkt.addr, ref_mem[rcvd_pkt.addr],  rcvd_pkt.data,errors))
            end
       // end
        else begin
           // `uvm_error("addr MISMATCH ERROR", $sformatf("SCB:: Expected addr:%0h But received addr: %0h", exp_pkt.addr, rcvd_pkt.addr))
			`uvm_info(get_full_name(),$sformatf("SCB:: [MATCH] For addr: %0h Expecting data:%0h  Received data: %0h", rcvd_pkt.addr, ref_mem[rcvd_pkt.addr],  rcvd_pkt.data),UVM_NONE)
        end
    endfunction: compare_pkt
    
    // construct expected data pkt
    function void construct_nd_push_exp_pkt(input reg [`ADDR_WIDTH-1:0] addr, input reg [`DATA_WIDTH-1:0] data);
        // construct seq_item
        exp_seq_item = apb_base_seq_item::type_id::create("exp_seq_item");
        // add exp value to fields
        exp_seq_item.addr = addr;
        exp_seq_item.data = data;
        // push exp_pkt in queue
        exp_seq_item_q.push_back(exp_seq_item);
    endfunction: construct_nd_push_exp_pkt
endclass: apb_scoreboard

`endif
