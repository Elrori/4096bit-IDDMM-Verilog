vlib work
vlog ../../src/*.v ../../src/common/simple_ram.v
vsim mm_iddmm_sp_tb
add wave /mm_iddmm_sp_tb/*
#do wave.do 
radix hex
run -all