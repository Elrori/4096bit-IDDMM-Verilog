/*
*   Name        :x16bit Multiple Level Carry Look Ahead Adder
*   Description :串联多层16bit超前进位加法器，位宽是16的倍数
*   Orirgin     :20200728
*   Author      :helrori
*/
module simple_mlclaa_x16bit
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
localparam N=W/16;
generate
genvar i;
    for (i = 0;i<N ;i=i+1 ) begin:loop
        wire cout;
        if (i==0) begin
            simple_mlclaa_16bit  simple_mlclaa_16bit
            (
                .cin        ( ci                      ),
                .a          ( ain[(i*16)+:16]         ),
                .b          ( bin[(i*16)+:16]         ),
                .sum        ( sum[(i*16)+:16]         ),
                .cout       ( cout                    )
            );
        end else begin
            simple_mlclaa_16bit  simple_mlclaa_16bit
            (
                .cin        ( loop[i-1].cout          ),
                .a          ( ain[(i*16)+:16]         ),
                .b          ( bin[(i*16)+:16]         ),
                .sum        ( sum[(i*16)+:16]         ),
                .cout       ( cout                    )
            );              
        end
      
    end
endgenerate
assign co=loop[N-1].cout;

endmodule