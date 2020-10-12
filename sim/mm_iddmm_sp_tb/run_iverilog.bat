iverilog -y../../src/ -y../../src/common -o mm_iddmm_sp_tb.vvp ../../src/mm_iddmm_sp_tb.v
vvp mm_iddmm_sp_tb.vvp
gtkwave wave.gtkw