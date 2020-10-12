iverilog -y../../src/ -o mmp_iddmm_pe_tb.vvp ../../src/mmp_iddmm_pe_tb.v
vvp mmp_iddmm_pe_tb.vvp
pause
gtkwave wave.gtkw