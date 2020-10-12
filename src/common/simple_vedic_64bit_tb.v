`timescale  1ns / 1ps

module simple_vedic_64bit_tb;

// simple_vedic_4bit Parameters
parameter PERIOD  = 10;


// simple_vedic_4bit Inputs
reg          clk                           = 0 ;
reg   [63:0]  a                             = {64{1'd1}} ;
reg   [63:0]  b                             = {64{1'd1}} ;

// simple_vedic_4bit Outputs
wire  [127:0]  s                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
reg  [127:0]sim_ret[0:5];
wire [127:0]sim_s=sim_ret[5];
always@(posedge clk)begin
    a<={$random,$random} ;
    b<={$random,$random} ;
end
always@(posedge clk) begin
    sim_ret[0]   <=a*b;  
    sim_ret[1]   <=sim_ret[0];
    sim_ret[2]   <=sim_ret[1];
    sim_ret[3]   <=sim_ret[2];
    sim_ret[4]   <=sim_ret[3];
    sim_ret[5]   <=sim_ret[4];
end

simple_vedic_64bit  u_simple_vedic_64bit (
    .clk                     ( clk       ),
    .a                       ( a  [63:0] ),
    .b                       ( b  [63:0] ),

    .s                       ( s  [127:0] )
);
integer runticks=0;
initial
begin
    $dumpfile("simple_vedic_64bit_tb.vcd");
    $dumpvars(0, simple_vedic_64bit_tb);
    // while (1) begin
    //     @(negedge clk)
    //     if (sim_s===s) begin
    //         if (runticks%1000==0) begin
    //             $display("ticks:%0d,check pass",runticks);
    //         end
    //         runticks=runticks+1;
    //     end else begin
    //         if (s==='dx) begin
    //             $display("pipeline in process...");
    //         end else begin
    //             $display("error a:%d b:%d s:%d simret:%d",a,b,s,sim_s);
    //             $stop;
    //         end            
    //     end
    // end
    #(PERIOD*1000)
    $finish;
end

endmodule