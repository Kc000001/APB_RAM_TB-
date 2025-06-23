cmp:
	vlib work
	vlog -sv ./TB/apb_testbench.sv -l compile.txt

sim_1: 
	@echo "*********START OF SIMULATION*********************"
	vsim -c -do "vcd file ./vcds/apb_test_wr.vcd;vcd add -r /*;run -all; quit;" apb_testbench +UVM_TESTNAME=apb_test_wr -l ./logs/apb_test_wr.log 
	@echo "*********END OF SIMULATION***********************"

sim_2:
	@echo "*********START OF SIMULATION*********************"
	vsim -c -do "vcd file ./vcds/apb_test_rd.vcd;vcd add -r /*;run -all; quit;" apb_testbench +UVM_TESTNAME=apb_test_rd -l ./logs/apb_test_rd.log 
	@echo "*********END OF SIMULATION***********************"

sim_3:
	@echo "*********START OF SIMULATION*********************"
	vsim -c -do "vcd file ./vcds/apb_test_error.vcd;vcd add -r /*;run -all; quit;" apb_testbench +UVM_TESTNAME=apb_test_error -l ./logs/apb_test_error.log 
	@echo "*********END OF SIMULATION***********************"

sim_4:
	@echo "*********START OF SIMULATION*********************"
	vsim -c -do "vcd file ./vcds/apb_test.vcd;vcd add -r /*;run -all; quit;" apb_testbench +UVM_TESTNAME=apb_test -l ./logs/apb_test.log 
	@echo "*********END OF SIMULATION***********************"

clean:
	rm -f ./logs/apb_test_wr.log
	rm -f ./vcds/apb_test_wr.vcd
	rm -f ./logs/apb_test_rd.log
	rm -f ./vcds/apb_test_rd.vcd
	rm -f ./logs/apb_test_error.log
	rm -f ./vcds/apb_test_error.vcd
	rm -f ./logs/apb_test.log
	rm -f ./vcds/apb_test.vcd
	rm -rf work
		
