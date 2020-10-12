/*
*   Name        :x4bit cascaded carry look-ahead adder
*   Description :串联超前进位加法器，位宽是4的倍数
*   Orirgin     :20200727
*   Author      :helrori
*/
module simple_cclaa_x4bit
#(
    parameter W = 256
)
(
    input   wire        ci    ,
    input   wire [W-1:0]ain   ,
    input   wire [W-1:0]bin   ,
    output  wire [W-1:0]sum   ,
    output  wire        co    

);
localparam N=W/4;
generate
genvar i;
    for (i = 0;i<N ;i=i+1 ) begin:loop
        wire cout;
        simple_claa_4bit  simple_claa_4bit
        (
            .cin        ( i==0?ci:loop[i-1].cout  ),
            .a          ( ain[(i*4)+:4]             ),
            .b          ( bin[(i*4)+:4]             ),
            .sum        ( sum[(i*4)+:4]             ),
            .cout       ( cout                      )
        );        
    end
endgenerate
assign co=loop[N-1].cout;
endmodule