/*
*   Name        :x4bit cascaded carry look-ahead adder testbench
*   Description :
*   Orirgin     :20200727
*   Author      :helrori
*/
`timescale  1ns / 1ps

module simple_cclaa_x4bit_tb;

// simple_cclaa_x4bit Parameters
parameter PERIOD = 10 ;
parameter W  = 8;

// simple_cclaa_x4bit Inputs
reg   [W-1:0]  ain                         = 'h0 ;
reg   [W-1:0]  bin                         = 'h0 ;
reg            clk                         = 0 ;
reg ci=1'd0;
// simple_cclaa_x4bit Outputs
wire  [W-1:0]  sum                         ;
wire  co                                   ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

reg [W:0]sim_ret='d0;
always@(posedge clk)begin
    ain={$random} % (2**W);
    bin={$random} % (2**W);
    ci ={$random} % (2**1);
end
always@* begin
    sim_ret=ain+bin+ci;    
end

wire [W-1:0]sim_sum=sim_ret[W-1:0];
wire        sim_cout=sim_ret[W];
simple_cclaa_x4bit #(
    .W ( W ))
 u_simple_cclaa_x4bit (
    .ci                      ( ci ),
    .ain                     ( ain  [W-1:0] ),
    .bin                     ( bin  [W-1:0] ),

    .sum                     ( sum  [W-1:0] ),
    .co                      ( co           )
);

initial
begin
    $dumpfile("simple_cclaa_x4bit_tb.vcd");
    $dumpvars(0, simple_cclaa_x4bit_tb);
    #(PERIOD*100)
    $display("checking...");
    while (1) begin
        @(negedge clk)
        if (sim_ret!={co,sum}) begin
            $display("error");
        end
    end
    $finish;
end

endmodule