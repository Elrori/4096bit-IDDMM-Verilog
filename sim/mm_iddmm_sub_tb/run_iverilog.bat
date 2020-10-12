iverilog -y../../src/ -y../../src/common -o mm_iddmm_sub_tb.vvp ../../src/mm_iddmm_sub_tb.v
vvp mm_iddmm_sub_tb.vvp
pause
gtkwave wave.gtkw