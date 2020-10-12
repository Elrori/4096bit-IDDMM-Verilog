iverilog -y../../src/ -o mm_r2mm_2n_tb.vvp ../../src/mm_r2mm_2n_tb.v
vvp mm_r2mm_2n_tb.vvp
pause
gtkwave wave.vcd