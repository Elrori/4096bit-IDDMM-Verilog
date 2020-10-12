`timescale 1ns/1ps
module mult_tb();
parameter PERIOD = 10;
reg [127:0]x;
reg [127:0]y;
reg rst_n;
reg clk;
wire [127:0]ret;
wire [127:0]carry;

always #(PERIOD/2) clk <= ~clk;
initial begin
    rst_n = 0;
    clk = 0;
    #20 rst_n = 1;
    x = 128'h58e2fccefa7e3061367f1d57a4e7455a;
    y = 128'h627240212decca515feab63e27345879;
end

always @(posedge clk) begin
    x <= x + 1;
    y <= y + 1;
end

initial begin
    $dumpfile("mult_tb.vcd");
    $monitor("x:%h, y:%h, result: %h %h",x ,y, carry, ret);
    $dumpvars(0, mult_tb);
    #200 $finish;
end

mult mult_inst(
    .clk(clk),
    .rst_n(rst_n),
    .x(x),
    .y(y),
    .ret(ret),
    .carry(carry)
);



endmodule