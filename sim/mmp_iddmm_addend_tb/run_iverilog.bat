iverilog -o mmp_iddmm_addend_tb.vvp -y../../src/ -y../../src/common/ ../../src/mmp_iddmm_addend_tb.v
vvp mmp_iddmm_addend_tb.vvp
pause
gtkwave mmp_iddmm_addend_tb.gtkw