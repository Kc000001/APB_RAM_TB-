set UVM_HOME "D:/uvm-1.2/uvm-1.2/src" 
set RTL "./DUT/*.sv"
set SV  "./TB/*.sv"
set SVT "./TB/apb_testbench.sv"
set INC "+incdir+$UVM_HOME +incdir+./TB"
if [file exists work] {vdel -all -lib work}
vlog -work work  $RTL $SVT $SV  $INC  
vsim -coverage -novopt -suppress 12110 -sva -sv_seed random -l apb_test_wr.log work.apb_testbench +UVM_TESTNAME=apb_test_wr
vcd file apb_test_wr_vcd.vcd
vcd add -r /*
run 100
vcd off
vcd on
run 500
vcd off
vcd on
run 400 
vcd off
vcd on
run -all
quit -sim
vcd2wlf apb_test_wr_vcd.vcd apb_wr.wlf
vsim -view apb_wr.wlf








