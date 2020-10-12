/*
*   Name        :IDDMM algorithm,process element
*   Description :
*   Orirgin     :20200707
*   Author      :
*/
module mm_iddmm_pe
#(
    parameter K = 128   ,// K bits in every group
    parameter N = 32     // number of groups 
)
(
    input   wire                    clk ,
    input   wire                    rst_n,

    input   wire [K-1          :0]  xj  ,
    input   wire [K-1          :0]  yi  ,
    input   wire [K-1          :0]  mj  ,
    input   wire [K-1          :0]  m1  ,
    input   wire [K-1          :0]  aj  ,
    input   wire [$clog2(N)-1  :0]  i   ,//[0-n-1]
    input   wire [$clog2(N)    :0]  j   ,//[0-n]
    input   wire                    j00 ,//当j==0时需要有两个时钟出结果，在第一个时钟置高此位

    output  reg                     carry,
    output  wire [K-1          :0]  uj  
);
//-------------------------------------------------------------------------------
reg  [K-1  :0] q;
reg  [K    :0] c_pre;
wire [K    :0] c;
wire [2*K-1:0] s;
wire [2*K-1:0] r;

wire [2*K-1:0] xy ;//x*y
wire [K-1  :0] m1s;//m1*s%beta
wire [2*K  :0] u_c;//s+r+c
wire carry_clr = (j==0 && i==0);
wire carry_ena = (j==N);
wire c_pre_clr = (j==0 && j00);
wire q_ena     = (j==0 && j00);
//-------------------------------------------------------------------------------

assign  xy = xj * yi ;
assign  s  = xy + aj + (carry_ena?carry:1'd0);
assign  m1s= m1 * s[K-1:0];//k bits <= k bits * k bits
assign  r  = mj * q;
assign  u_c= s  + r  + c_pre; 
assign  c  = u_c[2*K+1-1:K];
assign  uj = u_c[K-1    :0];

always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        carry <= 1'd0;
    end else if(carry_clr)begin
        carry <= 1'd0;
    end else if(carry_ena)begin
        carry <= c[0];
    end
end
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        q <= {(K){1'd0}};
    end else if(q_ena)begin
        q <= m1s;
    end
end
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        c_pre <= {(K+1){1'd0}};
    end else if(c_pre_clr)begin
        c_pre <= {(K+1){1'd0}};
    end else begin
        c_pre <= c;
    end
end
endmodule