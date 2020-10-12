#   Name        :modelsim do file
#   Description :
#   Orirgin     :20200721
#   EE          :helrori
vlib work
vlog +define+_VIEW_WAVEFORM_x -sv ../../src/*.v ../../src/common/*.v ../../src/common/mult32x32/mult.v
vsim mmp_iddmm_sp_tb
#add wave /mmp_iddmm_sp_tb/*
do wave.do 
radix hex
run -all