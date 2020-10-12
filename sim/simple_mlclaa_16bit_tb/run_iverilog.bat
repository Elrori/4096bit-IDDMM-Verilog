iverilog -y../../src/common -o simple_mlclaa_16bit_tb.vvp ../../src/common/simple_mlclaa_16bit_tb.v
vvp simple_mlclaa_16bit_tb.vvp
gtkwave simple_mlclaa_16bit_tb.gtkw