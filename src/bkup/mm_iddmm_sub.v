/*
*   Name        :IDDMM algorithm,final compare and subtract
*   Description :   分组比较、减法运算、清零RAM A，等效伪代码：
*                   if a(N,...,0)>=m(N-1,...,0):
*                      return (a - m)(N-1,...,0)
*                   else:
*                      return a(N-1,...,0)
*                   a(N-1,...,0)=0
*                   其中N是分组数，每组中有K个比特，a、m皆为正整数。低字先输出。
*   Orirgin     :20200714
*   Author      :helrori2011@gmail.com
*/
module mm_iddmm_sub 
#(
    parameter K  = 128,             //K<=128 and 2**?==K
    parameter N  = 32 ,             //N<=32  and 2**??==N 
    parameter ADDR_W = $clog2(N)
)
(
    input       wire                    clk         ,
    input       wire                    rst_n       ,
    // Result
    input       wire                    task_req    ,
    output      wire [K-1        :0]    res         ,
    output      wire                    res_val     ,
    output      wire                    task_end    ,
    // RAM A ,write side ports,clear RAM A
    output      wire                    clra_mem    ,
    output      wire                    clra_wren   ,
    output      wire [ADDR_W-1   :0]    clra_addr   ,
    // RAM A and M ,read side ports
    output      reg  [ADDR_W-1   :0]    addr_a      ,
    input       wire [K-1        :0]    aj          ,//a(N-1,..,0)
    input       wire [K-1        :0]    an          ,//a(N)
    output      wire [ADDR_W-1   :0]    addr_m      ,
    input       wire [K-1        :0]    mj           //m(N-1,..,0)

);

//----------------------------------------------------------------------------------------------------------

assign     addr_m = addr_a;
//----------------------------------------------------------------------------------------------------------

reg  [3  :0]st;
reg         carry = 1'd0;
reg  [K-1:0]bf0   = {K{1'd0}};
reg         bf1,sub_val,nop_val;
localparam  IDLE            =   0  ,
            COMP_MSW        =   1  ,
            COMP_PROCESS    =   2  ,
            COMP_PROCESS2   =   3  ,
            COMP_FIN_SUB    =   4  ,
            COMP_FIN_NOP    =   5  ,
            OUT_NOP         =   6  ,
            OUT_NOP_END     =   7  ,

            OUT_SUB         =   8  ,
            OUT_SUB_END     =   9  ;
assign     res    = (nop_val)?aj:
                    (sub_val)?bf0:
                    'd0;
assign  task_end = (st==OUT_NOP_END||(st==OUT_SUB_END&&(~bf1)));
assign  res_val  = (nop_val||sub_val); 
assign  clra_wren= (st==OUT_SUB||st==OUT_NOP);
assign  clra_mem = clra_wren;
assign  clra_addr= addr_a;
wire    plus1       = (addr_m=='d1)?1'd1:1'd0;
wire    [K:0]adderK = {1'd0,~mj} + {1'd0,aj};//129+129=130->129
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        st          <= 'd0;
        addr_a      <= {(ADDR_W){1'd1}};
        carry       <= 1'd0;
        bf0         <= {K{1'd0}};
        bf1         <= 1'd0;
        nop_val     <= 1'd0;
        sub_val     <= 1'd0;
    end else begin
        nop_val     <= st==OUT_NOP;
        bf1         <= st==OUT_SUB;
        sub_val     <= bf1;
        {carry,bf0} <= ((bf1==1'd1) ? (adderK + carry + plus1)  :  ({(K+1){1'd0}}));
        case (st)
            IDLE:begin
                if (task_req) begin
                    st      <= COMP_MSW;
                    addr_a  <= {(ADDR_W){1'd1}};
                end
            end 
            COMP_MSW:begin // compare an and mn,mn==0
                if (an=='d1) begin
                    st      <= COMP_FIN_SUB;
                    addr_a  <= {(ADDR_W){1'd1}};
                end else begin
                    st      <= COMP_PROCESS;
                    addr_a  <= addr_a - 1;
                end
            end 
            COMP_PROCESS:begin// 从高字开始比较
                if (addr_a=='d0) begin
                    st      <=  aj > mj ? COMP_FIN_SUB :
                                aj < mj ? COMP_FIN_NOP :
                                aj ==mj ? COMP_PROCESS2:
                                IDLE;
                end else begin
                    addr_a  <=  addr_a - 1;
                    st      <=  aj > mj ? COMP_FIN_SUB :
                                aj < mj ? COMP_FIN_NOP :
                                aj ==mj ? COMP_PROCESS :
                                IDLE;
                end
                // addr_a  <= (addr_a=='d0)?addr_a:addr_a - 1;
            end 
            COMP_PROCESS2:begin
                    st      <=  aj > mj ? COMP_FIN_SUB :
                                aj < mj ? COMP_FIN_NOP :
                                aj ==mj ? COMP_FIN_SUB :
                                IDLE;
            end 
            COMP_FIN_SUB:begin
                addr_a  <= 'd0;
                st      <= OUT_SUB;
                $display("\n[mm_iddmm_sub.v sim compare]:\n A >= M");
            end 
            COMP_FIN_NOP:begin
                addr_a  <= 'd0;
                st      <= OUT_NOP;
                $display("\n[mm_iddmm_sub.v sim compare]:\n A <  M");
            end 
            OUT_NOP:begin // 从低字开始输出
                st      <= (addr_a=={(ADDR_W){1'd1}})? OUT_NOP_END : OUT_NOP;
                addr_a  <= (addr_a=={(ADDR_W){1'd1}})? addr_a:addr_a + 1;
            end 
            OUT_NOP_END:begin
                st      <= IDLE;
            end
            OUT_SUB:begin //为了减法运算必须从低字开始输出
                st      <= (addr_a=={(ADDR_W){1'd1}})? OUT_SUB_END : OUT_SUB;
                addr_a  <= (addr_a=={(ADDR_W){1'd1}})? addr_a:addr_a + 1;
            end
            OUT_SUB_END:begin
                st      <= bf1?OUT_SUB_END:IDLE;
            end
            default:st  <= IDLE;
        endcase
    end
end
endmodule