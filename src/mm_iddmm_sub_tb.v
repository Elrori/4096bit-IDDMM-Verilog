/*
*   Name        :IDDMM algorithm,compare and sub testbench
*   Description :mm_iddmm_sub_tb
*   Orirgin     :20200707
*   Author      :helrori2011@gmail.com
*/

`timescale  1ns / 1ps

module mm_iddmm_sub_tb;

parameter PERIOD    = 10 ;
parameter K         = 128;
parameter N         = 32 ;
parameter DEBUG     = 1'b0; // DEBUG messages : 1 = On
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   task_req                             = 0 ;
wire  task_end                             ;
reg   an                                   =1'd0;
wire  [K-1        :0]  aj                  ;
wire  [K-1        :0]  mj                  ;
wire  [$clog2(N)-1:0]  addr_a              ;
wire  [$clog2(N)-1:0]  addr_m              ;
wire  [K-1        :0]  res                 ;
wire                   res_val             ;
wire                   clra_mem            ;
wire                   clra_wren           ;
wire  [$clog2(N)-1:0]  clra_addr           ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mm_iddmm_sub #(
    .K ( K ),
    .N ( N ),
    .DEBUG(DEBUG))
mm_iddmm_sub_0 (
    .clk                     ( clk                       ),
    .rst_n                   ( rst_n                     ),

    .task_req                ( task_req                  ),
    .task_end                ( task_end                  ),
    .res                     ( res                       ),
    .res_val                 ( res_val                   ),

    .clra_mem                ( clra_mem                  ),
    .clra_wren               ( clra_wren                 ),
    .clra_addr               ( clra_addr                 ),

    .aj                      ( aj        [K-1        :0] ),
    .an                      ( {{(K-1){1'd0}},an}        ),
    .mj                      ( mj        [K-1        :0] ),
    .addr_a                  ( addr_a    [$clog2(N)-1:0] ),
    .addr_m                  ( addr_m    [$clog2(N)-1:0] )
);
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( $clog2(N)        ),//N words will be used
    .filename                ( "a.mem"))
simple_ram_A(
    .clk                     ( clk              ),
    .wraddress               ( (clra_mem)?clra_addr :5'dx ),
    .wren                    ( (clra_mem)?clra_wren :1'dx ),
    .data                    ( (clra_mem)?{K{1'd0}} :{K{1'd0}}),
    .rdaddress               ( addr_a           ),
    .q                       ( aj               )
);
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( $clog2(N)        ),//N words will be used
    .filename                ( "m.mem"))
simple_ram_M(
    .clk                     ( clk              ),
    .wraddress               ( {$clog2(N){1'd0}}),
    .wren                    ( 1'd0             ),
    .data                    ( {K{1'd0}}        ),
    .rdaddress               ( addr_m           ),
    .q                       ( mj               )
);
reg [K*N-1:0]big_number = 'd0;
reg [K*N-1:0]big_a      = 'd0;
reg [K*N-1:0]big_m      = 'd0;
reg [K*N-1:0]bf0        = 'd0;
integer i;
always@(posedge clk)begin
    if (res_val) begin
        big_number <= {res,big_number[K*N-1:K]};
    end
end

task mem2big_ma;
    begin
        for (i = N-1;i>=0 ;i=i-1 ) begin
            big_m[(i*K+K-1)-:K]=simple_ram_M.mem[i];
            big_a[(i*K+K-1)-:K]=simple_ram_A.mem[i];
        end
    end
endtask  

task rand2mem;
    begin
        for (i = N-1;i>=0 ;i=i-1 ) begin
            simple_ram_M.mem[i]={$random,$random,$random,$random};
            simple_ram_A.mem[i]={$random,$random,$random,$random};
            an={$random}%2;
        end
        
    end
endtask 

task expect_value2bf0;
    begin
        mem2big_ma;
        if ({{{(K-1){1'd0}},an},big_a}>=big_m)begin   
            bf0={{{(K-1){1'd0}},an},big_a}-{{K{1'd0}},big_m};
            if(DEBUG) $display("\n[expect  A >= M]:\n0x%x",bf0);
        end else begin
            bf0=big_a;
            if(DEBUG) $display("\n[expect  A <  M]:\n0x%x",bf0);
        end
    end
endtask 

task display_mem_value;
    begin
        mem2big_ma;
        $display("[RAM value]:");
        $write("A:0x%x",{{(K-1){1'd0}},an});
        $display("%x",big_a);
        $write("M:0x%x",{K{1'd0}});
        $display("%x",big_m);
    end
endtask 

task make_req2big_number;
    begin
        @(posedge clk)
        task_req=1;
        wait(task_end)begin
            @(posedge clk)
            task_req=0; 
        end
        @(posedge clk);
    end
endtask 

task match_test;
    begin
        rand2mem;           // random -> memory
        expect_value2bf0;   // memory -> expect result saved in bf0
        make_req2big_number;// memory -> logic  result saved in big_number
        if(DEBUG) $display("[mm_iddmm_sub_tb.v sim return]:\n0x%x",big_number);
        if(DEBUG) $display("[mm_iddmm_sub_tb.v sim result]:\n%s",(bf0==big_number)?"Match!":"Wrong");
        if (bf0!=big_number) begin
            #(PERIOD*500)
            $display("error");
            $stop;
        end
    end
endtask 
integer times=0;
initial
begin
    if (!DEBUG) begin
        $dumpfile("wave.vcd");       
        $dumpvars(0,mm_iddmm_sub_tb);  
    end
    #(PERIOD*100)


    $display("-------------------------------------------------------------------");
    while (1) begin
        times=times+1;
        match_test;
        if (times%100==0) begin
            $display("Pass %0d",times);
        end
    end
    $display("-------------------------------------------------------------------");

    #(PERIOD*100)

    $finish;
end

endmodule