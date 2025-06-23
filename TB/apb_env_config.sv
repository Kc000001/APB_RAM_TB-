`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;

class apb_env_config extends uvm_object;
    `uvm_object_utils(apb_env_config)
    
    // instance of agent config
    
    //apb_mstr_agent_config   apb_mstr_agnt_cfg;
    // flag for enabling scoreboard
    bit has_scoreboard=1'b1;
    
    // constructor function
    function new(string name="apb_env_config");
        super.new(name);
    //    apb_mstr_agnt_cfg = new("apb_mstr_agnt_cfg");
    endfunction: new 
    
endclass: apb_env_config
