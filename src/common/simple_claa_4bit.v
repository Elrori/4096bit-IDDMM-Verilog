/*
*   Name        :4bit Carry Look Ahead Adder
*   Description :
*   Orirgin     :20200724
*   Author      :TMP @ https://techmasterplus.com/verilog/claadder.php?i=1
*   Modify      :helrori
*/
module simple_claa_4bit
(
    input   wire            cin ,
    input   wire    [3:0]   a   ,
    input   wire    [3:0]   b   ,
    output  wire    [3:0]   sum ,
    output  wire            cout
);
wire [3:0]g;
wire [3:0]p;
wire [3:0]c;
assign p=a|b;
assign g=a&b;
assign c[0]= g[0] | (cin &p[0]);
assign c[1]= g[1] | (p[1]&g[0])  | (p[1]&p[0]&cin);
assign c[2]= g[2] | (p[2]&g[1])  | (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&cin);
assign c[3]= g[3] | (p[3]&g[2])  | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&cin);
assign sum[0]=a[0]^b[0]^cin;
assign sum[1]=a[1]^b[1]^c[0];
assign sum[2]=a[2]^b[2]^c[1];
assign sum[3]=a[3]^b[3]^c[2];
assign cout=c[3];


    //  wire[4:0] g,p,c;
    //  assign c[0]=cin;
    //  assign p=a|b;
    //  assign g=a&b;
    //  assign c[1]=g[0]|(p[0]&c[0]);
    //  assign c[2]=g[1]|(p[1]&(g[0]|(p[0]&c[0])));
    //  assign c[3]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&c[0])))));
    //  assign c[4]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&c[0])))))));
    //  assign sum=p^c[3:0];
    //  assign cout=c[4];


// wire p0,p1,p2,p3,g0,g1,g2,g3,c1,c2,c3,c4;
// assign  p0=(a[0]^b[0]),
//         p1=(a[1]^b[1]),
//         p2=(a[2]^b[2]),
//         p3=(a[3]^b[3]);
// assign  g0=(a[0]&b[0]),
//         g1=(a[1]&b[1]),
//         g2=(a[2]&b[2]),
//         g3=(a[3]&b[3]);
// assign  c0=cin,
//         c1=g0|(p0&cin),
//         c2=g1|(p1&g0)|(p1&p0&cin),
//         c3=g2|(p2&g1)|(p2&p1&g0)|(p1&p1&p0&cin),
//         c4=g3|(p3&g2)|(p3&p2&g1)|(p3&p2&p1&g0)|(p3&p2&p1&p0&cin);
// assign  sum[0]=p0^c0,
//         sum[1]=p1^c1,
//         sum[2]=p2^c2,
//         sum[3]=p3^c3;
// assign  cout=c4;
endmodule