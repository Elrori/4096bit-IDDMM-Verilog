`timescale  1ns / 1ps

module mm_r2mm_2n_tb;

parameter PERIOD = 10  ;
parameter K      = 4096;

reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   req                                  = 0 ;
reg   [128-1  :0]  m[0:32-1]                    ;
reg   [128-1  :0]  y[0:32-1]                    ;
reg   [128-1  :0]  x[0:32-1]                    ;
wire  [K-1  :0]  res                       ;
wire             val                       ;



initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end
wire [K-1:0]xx;
wire [K-1:0]yy;
wire [K-1:0]mm;
assign xx={x[31],x[30],x[29],x[28],x[27],x[26],x[25],x[24],x[23],x[22],x[21],x[20],x[19],x[18],x[17],x[16],x[15],x[14],x[13],x[12],x[11],x[10],x[9],x[8],x[7],x[6],x[5],x[4],x[3],x[2],x[1],x[0]};
assign yy={y[31],y[30],y[29],y[28],y[27],y[26],y[25],y[24],y[23],y[22],y[21],y[20],y[19],y[18],y[17],y[16],y[15],y[14],y[13],y[12],y[11],y[10],y[9],y[8],y[7],y[6],y[5],y[4],y[3],y[2],y[1],y[0]};
assign mm={m[31],m[30],m[29],m[28],m[27],m[26],m[25],m[24],m[23],m[22],m[21],m[20],m[19],m[18],m[17],m[16],m[15],m[14],m[13],m[12],m[11],m[10],m[9],m[8],m[7],m[6],m[5],m[4],m[3],m[2],m[1],m[0]};
mm_r2mm_2n #(
    .K ( K ))
mm_r2mm_2n (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .x                       ( xx               ),
    .y                       ( yy               ),
    .m                       ( mm               ),
    .req                     ( req              ),
    .res                     ( res    [K-1  :0] ),
    .val                     ( val              )
); 
task make_r2mm;
    begin
        @(posedge clk);
        #0 req=1;
        @(posedge clk);
        #0 req=0;
        wait(val);
        @(posedge clk);
        $display("res0:\n0x%x\n",res);
    end
endtask

integer fp;
initial
begin
    // $dumpfile("wave.vcd");      //for iverilog gtkwave.exe
    // $dumpvars(0,mm_r2mm_2n_tb);         //for iverilog select signal   
    $readmemh("../../src/m.mem",m);
    $readmemh("../../src/x.mem",x);
    $readmemh("../../src/y.mem",y);
    $display("m:\n%x...\n",m[0]);
    $display("x:\n%x...\n",x[0]);
    $display("y:\n%x...\n",y[0]);
    #(PERIOD*20)
    make_r2mm;
    // fp=$fopen("../../src/res.txt","w");
    // #(PERIOD*20)
    // req=1;
    // #(PERIOD*1)
    // req=0;
    // $display("wait...");
    // wait(val)begin
    //     #(PERIOD*20)
    //     $display("res0:\n0x%x\n",res);
    //     $fwrite(fp,"%x",res);
    //     $fclose(fp);
    //     req=1;
    //     #(PERIOD*1)
    //     req=0;
    //     wait(val)begin
    //         #(PERIOD*20)
    //         $display("res1:\n0x%x\n",res);
    //         $finish;
    //     end
    // end
    $finish;
end

endmodule