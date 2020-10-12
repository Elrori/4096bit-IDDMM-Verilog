iverilog -y../../src/common -o simple_vedic_4bit_tb.vvp ../../src/common/simple_vedic_4bit_tb.v
vvp simple_vedic_4bit_tb.vvp
gtkwave simple_vedic_4bit_tb.vcd