`timescale  1ns / 1ps

module simple_vedic_8bit_tb;

// simple_vedic_4bit Parameters
parameter PERIOD  = 10;


// simple_vedic_4bit Inputs
reg          clk                           = 0 ;
reg   [7:0]  a                             = 0 ;
reg   [7:0]  b                             = 0 ;

// simple_vedic_4bit Outputs
wire  [15:0]  s                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
reg [15:0]sim_ret='d0;
always@(posedge clk)begin
    a={$random} % (2**8);
    b={$random} % (2**8);
end
always@* begin
    sim_ret=a*b;    
end

simple_vedic_8bit  u_simple_vedic_8bit (
    .a                       ( a  [7:0] ),
    .b                       ( b  [7:0] ),

    .s                       ( s [15:0] )
);

initial
begin
    $dumpfile("simple_vedic_8bit_tb.vcd");
    $dumpvars(0, simple_vedic_8bit_tb);
    while (1) begin
        @(negedge clk)
        if (sim_ret!=s) begin
            $display("error");
            $stop;
        end else begin
            $write(".");
        end
    end
    #(PERIOD*1000)
    $finish;
end

endmodule