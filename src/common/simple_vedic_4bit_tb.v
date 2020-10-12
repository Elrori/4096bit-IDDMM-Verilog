`timescale  1ns / 1ps

module simple_vedic_4bit_tb;

// simple_vedic_4bit Parameters
parameter PERIOD  = 10;


// simple_vedic_4bit Inputs
reg          clk                           = 0 ;
reg   [3:0]  a                             = 0 ;
reg   [3:0]  b                             = 0 ;

// simple_vedic_4bit Outputs
wire  [7:0]  s                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
reg [7:0]sim_ret='d0;
always@(posedge clk)begin
    a={$random} % (2**4);
    b={$random} % (2**4);
end
always@* begin
    sim_ret=a*b;    
end

simple_vedic_4bit  u_simple_vedic_4bit (
    .a                       ( a  [3:0] ),
    .b                       ( b  [3:0] ),

    .s                       ( s  [7:0] )
);

initial
begin
    $dumpfile("simple_vedic_4bit_tb.vcd");
    $dumpvars(0, simple_vedic_4bit_tb);
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