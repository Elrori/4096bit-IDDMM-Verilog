del mmp_iddmm_sp_tb.vvp
iverilog -D_VIEW_WAVEFORM_x -y../../src/ -y../../src/common -y../../src/common/mult32x32 -o mmp_iddmm_sp_tb.vvp ../../src/mmp_iddmm_sp_tb.v
vvp mmp_iddmm_sp_tb.vvp
pause
gtkwave wave.gtkw