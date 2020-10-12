iverilog -y../../src/common -o simple_vedic_64bit_tb.vvp ../../src/common/simple_vedic_64bit_tb.v
vvp simple_vedic_64bit_tb.vvp
gtkwave simple_vedic_64bit_tb.gtkw