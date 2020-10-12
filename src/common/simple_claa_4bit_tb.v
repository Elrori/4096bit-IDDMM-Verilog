/*
*   Name        :4bit Carry Look Ahead Adder
*   Description :
*   Orirgin     :20200724
*   Modify      :helrori
*/
`timescale  1ns / 1ps

module simple_claa_4bit_tb;

// simple_claa_4bit Parameters
parameter PERIOD  = 10;


// simple_claa_4bit Inputs
reg   cin                                  = 1'd1 ;
reg   [3:0]  a                             = 'h0 ;
reg   [3:0]  b                             = 'h0 ;
reg   clk                                  = 0 ;
// simple_claa_4bit Outputs
wire  [3:0]  sum                           ;
wire  cout                                 ;
reg [4:0]sim_ret='d0;
wire sim_cout=sim_ret[4];
wire [3:0]sim_sum =sim_ret[3:0];
always@(posedge clk)begin
    a={$random} % 16;
    b={$random} % 16;
end
always@* begin
    sim_ret=a+b+cin;
end
always@(negedge clk)begin
    if (sim_ret!={cout,sum}) begin
        $display("error");
    end else begin
        $display("checked");
    end
end
initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


simple_claa_4bit  u_simple_claa_4bit (
    .cin                     ( cin         ),
    .a                       ( a     [3:0] ),
    .b                       ( b     [3:0] ),

    .sum                     ( sum   [3:0] ),
    .cout                    ( cout        )
);

initial
begin
    $dumpfile("simple_claa_4bit_tb.vcd");
    $dumpvars(0, simple_claa_4bit_tb);
    #(PERIOD*10000)
    $finish;
end

endmodule