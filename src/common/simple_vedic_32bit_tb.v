`timescale  1ns / 1ps

module simple_vedic_32bit_tb;

// simple_vedic_4bit Parameters
parameter PERIOD  = 10;


// simple_vedic_4bit Inputs
reg          clk                           = 0 ;
reg   [31:0]  a                             = 0 ;
reg   [31:0]  b                             = 0 ;

// simple_vedic_4bit Outputs
wire  [63:0]  s                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
reg [63:0]____sim_ret='d0;
reg [63:0]___sim_ret='d0;
reg [63:0]__sim_ret='d0;
reg [63:0]_sim_ret='d0;
reg [63:0]sim_ret='d0;
always@(posedge clk)begin
    a={$random} ;
    b={$random} ;
end
always@(posedge clk) begin
    #0 ____sim_ret<=a*b;  
    #0 ___sim_ret <=____sim_ret;
    #0 __sim_ret  <=___sim_ret;
    #0 _sim_ret   <=__sim_ret;
    #0  sim_ret   <=_sim_ret;
end

simple_vedic_32bit  u_simple_vedic_32bit (
    .clk                     ( clk       ),
    .a                       ( a  [31:0] ),
    .b                       ( b  [31:0] ),

    .s                       ( s  [63:0] )
);
integer runticks=0;
initial
begin
    $dumpfile("simple_vedic_32bit_tb.vcd");
    $dumpvars(0, simple_vedic_32bit_tb);
    while (1) begin
        @(negedge clk)
        if (sim_ret===s) begin
            if (runticks%1000==0) begin
                $display("ticks:%0d,check pass",runticks);
            end
            runticks=runticks+1;
        end else begin
            if (s==='dx) begin
                $display("pipeline in process...");
            end else begin
                $display("error a:%d b:%d s:%d simret:%d",a,b,s,sim_ret);
                $stop;
            end            
        end
    end
    #(PERIOD*1000)
    $finish;
end

endmodule