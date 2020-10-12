iverilog -y../../src/ -o mm_iddmm_pe_tb.vvp ../../src/mm_iddmm_pe_tb.v
vvp mm_iddmm_pe_tb.vvp
gtkwave wave.gtkw