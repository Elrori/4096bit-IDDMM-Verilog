

/*
x = x3x2x1x0  y = y3y2y1y0   x0,y0 32bit x,y 128bit
x*y = 
((x3 << 96）+ (x2 << 64) + (x1 << 32) + x0 ) * ((y3 << 96) + (y2 << 64) + (y1 << 32) + y0)
= (x3*y3 << 192) + (x3*y2 << 160) + (x3*y1 << 128) + (x3*y0 << 96)
    +(x2*y3 << 160) +(x2*y2 << 128) +(x2*y1 << 96) + (x2*y0 << 64)
    +(x1*y3 << 128) + (x1*y2 << 96) + (x1*y1 << 64) + (x1*y0 << 32)
    +(x0*y3 << 96) + (x0*y2 << 64) + (x0*y1 << 32) + (x0*y0)

*/

module mult 
#(
    parameter DW = 'd128,
    parameter DW_HALF = 'd64,
    parameter DW_QUARTER = 'd32
)(
    input wire clk,
    input wire rst_n,
    // input wire load,
    input wire [DW-1:0]x,
    input wire [DW-1:0]y,
    output reg [DW-1:0]ret,
    output reg [DW-1:0]carry
);
reg[DW_HALF-1:0]x3y3, x3y2, x3y1, x3y0;
reg[DW_HALF-1:0]x2y3, x2y2, x2y1, x2y0;
reg[DW_HALF-1:0]x1y3, x1y2, x1y1, x1y0;
reg[DW_HALF-1:0]x0y3, x0y2, x0y1, x0y0;

wire [DW_QUARTER-1:0]x3 = x[DW-1:DW-DW_QUARTER];
wire [DW_QUARTER-1:0]x2 = x[DW-DW_QUARTER-1:DW_HALF];
wire [DW_QUARTER-1:0]x1 = x[DW_HALF-1:DW_HALF-DW_QUARTER];
wire [DW_QUARTER-1:0]x0 = x[DW_QUARTER-1:0];
wire [DW_QUARTER-1:0]y3 = y[DW-1:DW-DW_QUARTER];
wire [DW_QUARTER-1:0]y2 = y[DW-DW_QUARTER-1:DW_HALF];
wire [DW_QUARTER-1:0]y1 = y[DW_HALF-1:DW_HALF-DW_QUARTER];
wire [DW_QUARTER-1:0]y0 = y[DW_QUARTER-1:0];


always @(posedge clk) begin
    x3y3 <= x3 * y3;
    x3y2 <= x3 * y2;
    x3y1 <= x3 * y1;
    x3y0 <= x3 * y0;
    x2y3 <= x2 * y3;
    x2y2 <= x2 * y2;
    x2y1 <= x2 * y1;
    x2y0 <= x2 * y0;
    x1y3 <= x1 * y3;
    x1y2 <= x1 * y2;
    x1y1 <= x1 * y1;
    x1y0 <= x1 * y0;
    x0y3 <= x0 * y3;
    x0y2 <= x0 * y2;
    x0y1 <= x0 * y1;
    x0y0 <= x0 * y0;
end

//不知道1个clock能否实现多个加法器的级联相加
// 移位操作是否需要单独来一个clock操作

// `define LATENCY_2
`ifdef LATENCY_2
always @(posedge clk) begin
    {carry, ret} <= (x3y3 << 192) + ((x3y2 + x2y3) << 160) + ((x3y1 + x2y2 + x1y3) << 128) 
    + ((x3y0 + x2y1 + x1y2 + x0y3) << 96) + ((x2y0 + x1y1 + x0y2) << 64) + ((x1y0 + x0y1) <<32) + x0y0;           

end

`else  // LATENCY 3
reg [DW*2-1:0]sum_192;
reg [DW*2-1:0]sum_160;
reg [DW*2-1:0]sum_128;
reg [DW*2-1:0]sum_96;
reg [DW*2-1:0]sum_64;
reg [DW*2-1:0]sum_32;
reg [DW*2-1:0]sum_0;
always @(posedge clk) begin
    sum_192 <= x3y3 << 192;
    sum_160 <= (x3y2 + x2y3) << 160;
    sum_128 <= (x3y1 + x2y2 + x1y3) << 128;
    sum_96 <= (x3y0 + x2y1 + x1y2 + x0y3) << 96;
    sum_64 <= (x2y0 + x1y1 + x0y2) << 64;
    sum_32 <= (x1y0 + x0y1) <<32;
    sum_0 <= x0y0;
end


always @(posedge clk) begin
    {carry, ret} <= sum_192 + sum_160 + sum_128 + sum_96 + sum_64 + sum_32 + sum_0;
end
`endif
endmodule