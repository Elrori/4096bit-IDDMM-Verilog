/*
*   Name        :IDDMM algorithm,process element testbench
*   Description :该testbench返回x*y*2^(-K)modm结果。
*                mm_iddmm_pe.v属于IDDMM算法中的部分算法模块,IDDMM算法还应该包含save_carry2an和make_finalsub两个步骤.
*                无论是产生基础时序make_jline,还是save_carry2an和make_finalsub步骤,都没有使用可综合代码编写,这里只是
*                做简单的正确性验证.
*   Orirgin     :20200707
*   Author      :helrori
*/
`timescale  1ns / 1ps
// define NEW_ARRAY_PACK_UNPACK frist
`define NEW_ARRAY_PACK_UNPACK genvar pk_idx; genvar unpk_idx;
// pack 2D-array to 1D-array
`define PACK_ARRAY(PK_WIDTH,PK_LEN,PK_SRC,PK_DEST,name) \
                generate \
                for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) \
                begin:name \
                        assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; \
                end \
                endgenerate
// unpack 1D-array to 2D-array
`define UNPACK_ARRAY(PK_WIDTH,PK_LEN,PK_DEST,PK_SRC,name) \
                generate \
                for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) \
                begin:name \
                        assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; \
                end \
                endgenerate

module mm_iddmm_pe_tb;

//----------------------------------------------------------------------------------------------------------
parameter PERIOD = 10 ;
parameter K  = 128;
parameter N  = 32 ;
//----------------------------------------------------------------------------------------------------------

reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [$clog2(N)-1  :0]  i                 = 0 ;
reg   [$clog2(N)    :0]  j                 = 0 ;
reg   j00                                  = 0 ;
wire  carry;
wire  [K*N+K-1:0]x ;
wire  [K*N-1:0]y ;
wire  [K*N+K-1:0]m ;

//----------------------------------------------------------------------------------------------------------
reg   [K-1  :0]  m1 = 'hda2f2fa16ac3f68b24214ac8e5b2221f;//m1=(-1*(mod_inv(m,2**K)))%2**K 
assign x = {{K{1'd0}},4096'h3ffffffef380fcff68e38a9fcc30b4c64e94dbc4f2b03a88ae0650f51f467e1f4f10ba102d77eb77c1547e0c40e6d7aeb05539c308ea01dafb6da33649210fab2cdd38a580091aaec64d74192431c00cce4f4c752498e88aaa5ccc010b2317db8e01cf660e1dc9ba01154024448965f8209721d391f8422ef2e1817ac4240be53bfc0f05b7336e172e271c9e9fcd38057746bbe8f5bb1907ab681ae012395e78e531f5291340108b4f8b182614a29fa0c7a44032229fe3fb3af01a5577cf335f318c1ecc70b613e7532ab85dc087c618020e949640cb14a3dbf634fa0b48f0098c9e9ee4861a5e6193f2a9241e28d1f4d3c9a8f11c460943dbd7b7b06f18fe75454e20593388dcaa8b98aabe293987d22e2725251d6ebf2729cde05db076ed775b7f369d1f9e1109812960b8b76e333bcca8aaa98931c2937cadb68a4ffc6c54eff9a6bcb77da76dc02fcb83167105319dd5a25f19d6ef0b214927120635e665afe46f681259247978d4a6853bb3cac03bc554d07003496f6b8b624bfec45f4cfb24acded0aeb074e8f70df1813ebb26bd5fe26be2a627684d793a8a052e3a9476a1d9697dd9e27beb4db7ad01eb8b0a3b5c7717d716ebd30727cc7786a17f09b04d6b94a56d9f70ac514e026f42834486e6a0852ce00808c7222cc02f90802ab22509fe316612d10d60359087ab7a23be6348b73f6704e6fde2ed070c500db0};
assign y =            4096'h3ffff4f73caff09ff67fc823e8f5988fe76cff5b4241b1f3f3f4ccb35f29ff3573f617bc077c80165ec5270c0b863fc231ae96dd5d933e9a98abdaf3d6e852e98149945ab1a9a90e38e07c3017c1273b18598d87b59a289de9d7c5bc5c6f64cccdbcbec42c289c8b1b799f8454cba6b89e5976a84c19217d64ddde5af42e37ab465928d068deaa3a0270b8d062dbe0b737667c3afd065871532081e72bc1f79e1d7ebd1fb933ec3555a8e986f949f72ca11bc2fbe4c704b20838c68b707d9f3db1d8ae45b44b6bd36a58bfbf7d565347a6c6e20130c84f1bad77f6251e81dfb6ffa9a508d64db7d2fe48b5e4ebe68e7c8d62cdf5ab1c2ca8c2d2e835a1423acbef65956c980dfb62b3a405b9efbc93283d5071c2129b831481c537cc5be8f1d2723f1168f797bde736c1f73054d7d0dc97538fba25bb3e38703934d8fc46ad22eb23ea409184c3dba8241efc92ce5a6728f4385da637bc23ef7acb506d0543804ae7d660926a82406f9d3206376d5454466ecde2246a125c99aebdf16743d55cfb1c4ab0fdb8387320d541a94e3c5aa6038466eaa18682a163d571db3214de448b3d4d7a632bc60f0a524a041cd6e72a75dbc9f6bb63743df3c3c0d4649a28bd0bbeee569182303a66b830a2273b8df05c712adadf2bcb75244a66826265da778e0c3b45a20d6c962fd203e708ff62dd29b9edd90f2afd2bfe92014968e4396a;
assign m = {{K{1'd0}},4096'hf45f4906ed176bc241535c78955d02f4d0acf376d736ae280077887200c758b7781b4432fa8baca2a81ad6fb0817051a00fccf8e15c63048681bcf8342b56433abd550affa489b289cd4f0482adce321c8cf4374ce15267692dfc8b0da108f4bb0e922d4a28402ef785c2516f6296486f8505ac3df05c0f953acce65e2dc5f1e59965ded73fa18ffb482ad1a2e5433d4df8211de12a3e7a71a1a084fed671fb11eeaf76f640c4fd549ea307b6622f798f027786e79232206de1507281d84c719209d408bc85f9ed2e1b82ecf72ff805a45221dc712c45a8dbc375e9b64227ec6b659a75fc5b5e051e776bcd9f4f6d82ebaff89a48c8494d6ed072372b846156af229994baab390ec57c00130255acc2cdf975783df4678153f0ca51b854425b1568b5b8b53239f50dd39fc53c3d41827a0687c435f6de5e98843def3fb7b0f7e701cdfb51517d6628392bd9291c16282556f5581766dd6a0a426a35312237399f93ad69502592c0f6d1864ba0b75600ee04cb406bcb833bc98527a0ac1249c6a918456b06f24611770c1708426b4d9041f7fe83be68fbc7018e461951d234ebf00227b4301911e24055c745203c888276f4db0c05f66514ae4e6b4bf4c8914e36c4a94bf57bf807dd40c7572d1a99c27d9f58af0877bb217c081d750d5edbe3c45eafc3ea6786560fa819873452cc8bffc7ab998ab70496b77fdadffb7e72621};

//----------------------------------------------------------------------------------------------------------

`NEW_ARRAY_PACK_UNPACK
wire [K-1:0] x_2D [0  :N];
`UNPACK_ARRAY(K,N+1,x_2D,x,a)

wire [K-1:0] y_2D [0:N-1];
`UNPACK_ARRAY(K,N,y_2D,y,b)

wire [K-1:0] m_2D [0  :N];
`UNPACK_ARRAY(K,N+1,m_2D,m,c)

reg [K-1:0]mem[0:N];

wire  [K-1  :0]  xj                        ;
wire  [K-1  :0]  yi                        ;
wire  [K-1  :0]  mj                        ;
wire  [K-1  :0]  aj                        ;
wire  [K-1  :0]  uj                        ;
assign           xj                        =x_2D[j];
assign           yi                        =y_2D[i];
assign           mj                        =m_2D[j];
assign           aj                        =mem [j];


genvar idx;
generate 
    for (idx= 0;idx< N+1;idx= idx+ 1) begin:mx
        wire [K-1:0]mmm;
        assign mmm=mem[idx];
    end
endgenerate
wire [(N+1)*K-1:0]mem_assign;
reg  [(N  )*K-1:0]result;
generate 
    for (idx= 0;idx< N+1;idx= idx+ 1) begin:res
        assign mem_assign[  idx*K+K-1  :  idx*K  ]=mem[idx];
    end
endgenerate

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


mm_iddmm_pe #(
    .K ( K ),
    .N ( N ))
mm_iddmm_pe_0 (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .xj                      ( xj     [K-1  :0] ),
    .yi                      ( yi     [K-1  :0] ),
    .mj                      ( mj     [K-1  :0] ),
    .m1                      ( m1     [K-1  :0] ),
    .aj                      ( aj     [K-1  :0] ),
    .i                       ( i        ),
    .j                       ( j        ),
    .j00                     ( j00              ),

    .carry                   ( carry            ),
    .uj                      ( uj     [K-1  :0] )
);
integer ii;
wire wr_a_ena;
assign #0 wr_a_ena = (j!=0);
always@(posedge clk or rst_n)begin
    if(!rst_n)begin
        for (ii = 0; ii<N+1;ii=ii+1 ) begin:nn
            mem[ii] <= {K{1'd0}};
        end
    end else if (wr_a_ena) begin
        mem[j-1] <= uj;
        $display("wr uj@%d:%x",j-1,uj);
    end
end

task make_jline;
    begin
        j00= 1;
        j  = 0;
        @(posedge clk)
        j00= 0;
        while(j!=N)begin
            @(posedge clk)
            #0 j=j+1;
        end
    end
endtask

task make_pe_task;
    begin
        @(posedge clk)
        for (ii = 0;ii<N ;ii=ii+1 ) begin
            make_jline;
            @(posedge clk)
            #0 i=i+1;
        end
        #0 j=0;
        #0 i=0;
    end
endtask
task save_carry2an;
    begin
        @(posedge clk)
        mem[N]<=carry;
    end
endtask
task make_finalsub;
    begin
        @(posedge clk)
        if (mem_assign>=m) begin
            result <= mem_assign-m;
        end else begin
            result <= mem_assign[K*N-1:0];
        end
    end
endtask
task clear_mem;
    begin
        @(posedge clk)
        for (ii = 0;ii<N+1 ;ii=ii+1 ) begin
            mem[ii] <= {K{1'd0}};
        end
    end
endtask
task make_main_task;
    begin
        #(PERIOD*10)
        make_pe_task;
        save_carry2an;
        make_finalsub;
        #(PERIOD*10)
        $display("mem_assign:\n0x%x",mem_assign);
        $display("x*y*2^(-K)modm result:\n0x%x",result    );
        clear_mem;
    end
endtask

initial
begin
    $dumpfile("wave.vcd");      //for iverilog gtkwave.exe
    $dumpvars(0,mm_iddmm_pe_tb);//for iverilog select signal   
    #(PERIOD*2) rst_n  =  1;

    make_main_task;
    make_main_task;

    #(PERIOD*50)
    $finish;
end

endmodule