`timescale  1ns / 1ps

module mmp_iddmm_addfirst_tb;

// mmp_iddmm_addfirst Parameters
parameter PERIOD   = 10      ;
parameter LATENCY  = 2       ;
parameter METHOD   = "3-2_PIPE2";

// mmp_iddmm_addfirst Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [255:0]  a_in                        = {256{1'd1}} ;
reg   [127:0]  b_in                        = {128{1'd1}}  ;
reg   c_in                                 = 1'd1 ;

// mmp_iddmm_addfirst Outputs
wire  [255:0]  d_out                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end
always@(posedge clk)begin
    a_in<={$random,$random,$random,$random,$random,$random,$random,$random} ;
    b_in<={$random,$random,$random,$random} ;
    c_in<={$random} %2;
end
reg  [257:0] sim_ret_,sim_ret;
always@(posedge clk)begin
    sim_ret_<=a_in+b_in+c_in;
    sim_ret <=sim_ret_;
end
mmp_iddmm_addfirst #(
    .LATENCY ( LATENCY ),
    .METHOD  ( METHOD  ))
 u_mmp_iddmm_addfirst (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .a_in                    ( a_in   [255:0] ),
    .b_in                    ( b_in   [127:0] ),
    .c_in                    ( c_in           ),

    .d_out                   ( d_out  [255:0] )
);
integer sim_times=0;
initial
begin
    $dumpfile("mmp_iddmm_addfirst_tb.vcd");
    $dumpvars(0, mmp_iddmm_addfirst_tb);
    #(PERIOD*100)
    while (1) begin
        @(negedge clk)
        sim_times=sim_times+1;
        if (sim_ret!=u_mmp_iddmm_addfirst.pipe2.mmp_iddmm_addfirst_3_2.simple_padder256_3_2.full_sum) begin
            $display("error");
            $display("a=0x%x b=0x%x c=0x%x",a_in,b_in,c_in);
            $stop;
        end else begin
            // $display("%5d:0x%x == 0x%x",sim_times,sim_ret,d_out);
            if (sim_times%1000==0) begin
                $write("%0d\n",sim_times);
            end
        end
        if (sim_times==1000) begin
            // $finish;
        end
    end
    $finish;
end

endmodule