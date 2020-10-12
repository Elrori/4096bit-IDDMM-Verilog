iverilog -o mmp_iddmm_addfirst_tb.vvp -y../../src/ -y../../src/common/ ../../src/mmp_iddmm_addfirst_tb.v
vvp mmp_iddmm_addfirst_tb.vvp
pause
gtkwave mmp_iddmm_addfirst_tb.gtkw