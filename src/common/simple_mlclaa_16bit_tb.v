`timescale  1ns / 1ps

module simple_mlclaa_16bit_tb;

// simple_mlclaa_16bit Parameters
parameter PERIOD  = 10;


// simple_mlclaa_16bit Inputs
reg   cin                                  = 0 ;
reg   [15:0]  a                            = 0 ;
reg   [15:0]  b                            = 0 ;

// simple_mlclaa_16bit Outputs
wire  [15:0]  sum                          ;
wire  cout                                 ;
reg clk=0;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

// initial
// begin
//     #(PERIOD*2) rst_n  =  1;
// end
reg  [16:0]sim_ret='d0;
wire [16:0]sum_ret={cout,sum};
always@(posedge clk)begin
    a={$random} % 65536;
    b={$random} % 65536;
    cin={$random} % 2;
end
always@* begin
    sim_ret=a+b+cin;
end
simple_mlclaa_16bit  u_simple_mlclaa_16bit (
    .cin                     ( cin           ),
    .a                       ( a      [15:0] ),
    .b                       ( b      [15:0] ),

    .sum                     ( sum    [15:0] ),
    .cout                    ( cout          )
);
integer sim_times=0;
initial
begin
    $dumpfile("simple_mlclaa_16bit_tb.vcd");
    $dumpvars(0, simple_mlclaa_16bit_tb);
    while (1) begin
        @(negedge clk)
        sim_times=sim_times+1;
        if (sim_ret!=sum_ret) begin
            $display("error");
        end else begin
            $display("%5d:0x%x == 0x%x",sim_times,sim_ret,sum_ret);
        end
        if (sim_times==10000) begin
            $finish;
        end
    end
    
end

endmodule