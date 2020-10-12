iverilog -y../../src/common -o simple_cclaa_x4bit_tb.vvp ../../src/common/simple_cclaa_x4bit_tb.v
vvp simple_cclaa_x4bit_tb.vvp
gtkwave simple_cclaa_x4bit_tb.gtkw