/*
*   Name        :Multiple Level Carry Look Ahead Adder
*   Description :多层结构超前进位加法器，16bit
*   Orirgin     :20200727
*   Author      :https://blog.csdn.net/moon548834/article/details/80344335
*   Modify      :helrori
*/
module simple_mlclaa_16bit
(
    input   wire            cin ,
    input   wire    [15:0]  a   ,
    input   wire    [15:0]  b   ,
    output  reg     [15:0]  sum ,
    output  reg             cout
);
wire [15:0]G=a&b;
wire [15:0]P=a|b;
reg [3:0]cin__;
reg cout1;
task ahead_adder4;

input cin__;
input [3:0]a;
input [3:0]b;
input [3:0]G;
input [3:0]P;
output  reg [3:0]sum;
output  reg cout;
reg [3:0]C;
begin
C[0]= G[0] | (cin__&P[0]);
C[1]= G[1] | (P[1]&G[0]) | (P[1]&P[0]&cin__);
C[2]= G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&cin__);
C[3]= G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&cin__);

sum[0]=a[0]^b[0]^cin__;
sum[1]=a[1]^b[1]^C[0];
sum[2]=a[2]^b[2]^C[1];
sum[3]=a[3]^b[3]^C[2];
cout=C[3];
end
endtask
task ahead_carry;

input cin__;
input [15:0]G;
input [15:0]P;
output reg [3:0]cout;
reg [3:0]G2;
reg [3:0]P2;
begin

G2[0]=G[3] | P[3]&G[2] | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0];
G2[1]=G[7] | P[7]&G[6] | P[7]&P[6]&G[5] | P[7]&P[6]&P[5]&G[4];
G2[2]=G[11] | P[11]&G[10] | P[11]&P[10]&G[9] | P[11]&P[10]&P[9]&G[8];
G2[3]=G[15] | P[15]&G[14] | P[15]&P[14]&G[13] | P[15]&P[14]&P[13]&G[12];

P2[0]=P[3]&P[2]&P[1]&P[0];
P2[1]=P[7]&P[6]&P[5]&P[4];
P2[2]=P[11]&P[10]&P[9]&P[8];
P2[3]=P[15]&P[14]&P[13]&P[12];

cout[0]=G2[0] | (cin__&P2[0]);
cout[1]=G2[1] | (P2[1]&G2[0]) | (P2[1]&P2[0]&cin__);
cout[2]=G2[2] | (P2[2]&G2[1]) | (P2[2]&P2[1]&G2[0]) | (P2[2]&P2[1]&P2[0]&cin__);
cout[3]=G2[3] | (P2[3]&G2[2]) | (P2[3]&P2[2]&G2[1]) | (P2[3]&P2[2]&P2[1]&G2[0]) | (P2[3]&P2[2]&P2[1]&P2[0]&cin__);
end
endtask

always@(*)
begin
	ahead_carry(cin,G[15:0],P[15:0],cin__[3:0]);
	ahead_adder4 (cin,a[3:0],b[3:0],G[3:0],P[3:0],sum[3:0],cout1);//因为进位值实际上已经被算出来了，所以这个cout1就没有实际意义
	ahead_adder4 (cin__[0],a[7:4],b[7:4],G[7:4],P[7:4],sum[7:4],cout1);
	ahead_adder4 (cin__[1],a[11:8],b[11:8],G[11:8],P[11:8],sum[11:8],cout1);
	ahead_adder4 (cin__[2],a[15:12],b[15:12],G[15:12],P[15:12],sum[15:12],cout);//但是这个cout有实际意义，因为超前进位算出的是四个adder的低位进位值，没有算最后一个的高位进位，所以要保留
end
endmodule
// /*
// *   Name        :Multiple Level Carry Look Ahead Adder
// *   Description :
// *   Orirgin     :20200724
// *   Author      :https://chi_gitbook.gitbooks.io/personal-note/content/addition.html
// *   Modify      :helrori
// */
// module simple_mlclaa_16bit
// (
//     input   wire            cin ,
//     input   wire    [15:0]  a   ,
//     input   wire    [15:0]  b   ,
//     output  wire    [15:0]  sum ,
//     output  wire            cout,
//     output  wire            cout_
// );
// wire [15:0]p,g;
// wire [3 :0]pp,gg,ccout,cout0,cout1,cout2,cout3;
// assign  cout_=ccout[3];
// assign  p = a^b;
// assign  g = a&b;
// assign  sum[0] = p[0]^cin,
//         sum[1] = p[1]^cout0[0],
//         sum[2] = p[2]^cout0[1],
//         sum[3] = p[3]^cout0[2],
//         sum[4] = p[4]^cout0[3],

//         sum[5] = p[5]^cout1[0],
//         sum[6] = p[6]^cout1[1],
//         sum[7] = p[7]^cout1[2],
//         sum[8] = p[8]^cout1[3],

//         sum[9]  = p[ 9]^cout2[0],
//         sum[10] = p[10]^cout2[1],
//         sum[11] = p[11]^cout2[2],
//         sum[12] = p[12]^cout2[3],
  
//         sum[13] = p[13]^cout3[0],
//         sum[14] = p[14]^cout3[1],
//         sum[15] = p[15]^cout3[2];
// assign  cout    = cout3[3];
// clau clau_0
// (
//     .p      ( p[3 :0] )  ,
//     .g      ( g[3 :0] )  ,
//     .cin    ( cin )  ,
//     .cout   ( cout0 )  ,
//     .pp     ( pp[0] )  ,
//     .gg     ( gg[0] )
// );
// clau clau_1
// (
//     .p      ( p[7 :4] )  ,
//     .g      ( g[7 :4] )  ,
//     .cin    ( ccout[0])  ,
//     .cout   ( cout1 )  ,
//     .pp     ( pp[1] )  ,
//     .gg     ( gg[1] )
// );
// clau clau_2
// (
//     .p      ( p[11:8] )  ,
//     .g      ( g[11:8] )  ,
//     .cin    ( ccout[1])  ,
//     .cout   ( cout2 )  ,
//     .pp     ( pp[2] )  ,
//     .gg     ( gg[2] )
// );
// clau clau_3
// (
//     .p      ( p[15:12] )  ,
//     .g      ( g[15:12] )  ,
//     .cin    ( ccout[2])  ,
//     .cout   ( cout3 )  ,
//     .pp     ( pp[3] )  ,
//     .gg     ( gg[3] )
// );
// clau clau_top
// (
//     .p      ( pp )  ,
//     .g      ( gg )  ,
//     .cin    ( cin )  ,
//     .cout   ( ccout )  ,
//     .pp     (  )  ,
//     .gg     (  )
// );
// endmodule
// /*
// *   4bit Carry Look Ahead Uint
// */
// module clau 
// (
//     input   wire    [3:0]p      ,
//     input   wire    [3:0]g      ,
//     input   wire         cin    ,

//     output  wire    [3:0]cout   ,
//     output  wire         pp     ,
//     output  wire         gg   
// );
// assign  gg=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);
// assign  pp=p[3]&p[2]&p[1]&p[0];
// assign  cout[0]=g[0]|(p[0]&cin),
//         cout[1]=g[1]|(p[1]&g[0])|(p[1]&p[0]&cin),
//         cout[2]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[1]&p[1]&p[0]&cin),
//         cout[3]=gg|(pp&cin);
// endmodule