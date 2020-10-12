`timescale  1ns / 1ps

module mmp_iddmm_addend_tb;

// mmp_iddmm_addend Parameters
parameter PERIOD   = 10      ;
parameter LATENCY  = 0       ;
parameter METHOD   = "3-2_DELAY2";

// mmp_iddmm_addend Inputs
reg clk2=0;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [128:0]  a_in                        = {129{1'd1}} ;
reg   [255:0]  b_in                        = {256{1'd1}} ;
reg   [255:0]  c_in                        = {256{1'd1}} ;

// mmp_iddmm_addend Outputs
wire  [256:0]  d_out                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
initial
begin
    #(PERIOD/2) 
    forever #(PERIOD)  clk2=~clk2;
end
initial
begin
    #(PERIOD*2) rst_n  =  1;
end
reg  [257:0]sim_ret='d0;
reg  b;
always@(posedge clk2)begin
    a_in={b,$random,$random,$random,$random} ;
    b_in={$random,$random,$random,$random,$random,$random,$random,$random} ;
    c_in={$random,$random,$random,$random,$random,$random,$random,$random} ;
end
always@* begin
    sim_ret=a_in+b_in+c_in;
    b={$random}%2;
end

mmp_iddmm_addend #(
    .LATENCY ( LATENCY ),
    .METHOD  ( METHOD  ))
 u_mmp_iddmm_addend (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .a_in                    ( a_in   [128:0] ),
    .b_in                    ( b_in   [255:0] ),
    .c_in                    ( c_in   [255:0] ),

    .d_out                   ( d_out  [256:0] )
);
integer sim_times=0;
initial
begin
    $dumpfile("mmp_iddmm_addend_tb.vcd");
    $dumpvars(0, mmp_iddmm_addend_tb);
    #(PERIOD*100)

    while (1) begin
        @(posedge clk2)
        sim_times=sim_times+1;
        if (sim_ret[256:0]!=d_out) begin
            $display("error");
            $display("a=0x%x b=0x%x c=0x%x",a_in,b_in,c_in);
            $stop;
        end else begin
            // $display("%5d:0x%x == 0x%x",sim_times,sim_ret,d_out);
            $write(".");
        end
        if (sim_times==10000) begin
            $finish;
        end
    end

    $finish;
end

endmodule