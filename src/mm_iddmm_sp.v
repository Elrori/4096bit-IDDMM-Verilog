/*
*   Name        :IDDMM algorithm,support module
*   Description :
*   Orirgin     :20200709
*   Author      :helrori
*/
`timescale  1ns / 1ps

module mm_iddmm_sp 
#(
    parameter K  = 128,
    parameter N  = 32 ,
    parameter ADDR_W = $clog2(N)
)
(
    input       wire                    clk         ,
    input       wire                    rst_n       ,
    
    input       wire                    wr_ena      ,
    input       wire [ADDR_W   -1:0]    wr_addr     ,
    input       wire [K-1:0]            wr_x        ,
    input       wire [K-1:0]            wr_y        ,
    input       wire [K-1:0]            wr_m        ,
    input       wire [K-1:0]            wr_m1       ,

    input       wire                    task_req    ,
    output      wire                    task_end    ,
    output      wire                    res_val     ,
    output      wire [K-1:0]            res         
);

//----------------------------------------------------------------------------------------------------------
initial begin
    $display("[mm_iddmm_sp.v]:\nK=%4d bits\nN=%4d groups\nOperands width=%5d bits",K,N,K*N);
end
//----------------------------------------------------------------------------------------------------------

reg   [ADDR_W   -1  :0]  _i                        = 0 ;
reg   [ADDR_W       :0]  _j                        = 0 ;
reg   [ADDR_W   -1  :0]  i                         = 0 ;
reg   [ADDR_W       :0]  j                         = 0 ;
reg   _j00                                         = 0 ;
reg   j00                                          = 0 ;
wire  carry;
reg   an   ;
reg   comp_req;
wire  comp_end;
assign  task_end=comp_end;
reg   [K-1  :0]  m1 = 'hda2f2fa16ac3f68b24214ac8e5b2221f;//m1=(-1*(mod_inv(m,2**K)))%2**K 
wire                   clra_mem    ;
wire                   clra_wren   ;
wire  [ADDR_W   -1:0]  clra_addr   ;


wire  [K-1  :0]  xj                        ;
wire  [K-1  :0]  yi                        ;
wire  [K-1  :0]  mj                        ;
wire  [K-1  :0]  aj                        ;
wire  [K-1  :0]  uj                        ;
wire  [ADDR_W   -1:0]addr_a;
wire  [ADDR_W   -1:0]addr_m;   
reg              task_en;
reg   [2    :0]  st;

//----------------------------------------------------------------------------------------------------------

always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        m1 <= 'hda2f2fa16ac3f68b24214ac8e5b2221f;
    end else begin
        m1 <= (wr_ena)?wr_m1:m1;
    end
end
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        task_en <= 1'd0;
    end else if (comp_end) begin
        task_en <= 1'd0;
    end else if (task_req) begin
        task_en <= 1'd1;
    end
end
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        i   <= 'd0;
        j   <= 'd0;
        j00 <= 'd0;
    end else begin
        i   <= _i;
        j   <= _j;
        j00 <= _j00;
    end
end
always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        st  <= 'd0;
        _j  <= 'd0;
        _i  <= 'd0;
        _j00<= 'd0;
        an  <= 'd0;
        comp_req<=1'd0;
    end else if(task_en)begin
        case (st)
            0:begin
                _j00 <= 1'd1;
                st   <= st  +   1'd1;
            end 
            1:begin
                _j00 <= 1'd0;
                st   <= st  +   1'd1;
            end 
            2:begin
                if (_i==N-1 && _j==N) begin
                    _j   <= 1'd0;
                    _i   <= 1'd0;
                    st   <= st  +   1'd1;
                end else if (_j==N) begin
                    _j   <= 1'd0;
                    _i   <= _i + 1'd1;
                    _j00 <= 1'd1;
                    st   <=  'd1;
                end else begin
                    _j   <= _j + 1'd1;
                end
            end 
            3:begin // save_carry2an
                an      <= carry;
                st      <= st  +   1'd1;
                comp_req<= 1'd1;
            end
            4:begin // make_finalsub
                if (comp_end) begin
                    comp_req<=1'd0;
                    st      <= 'd0;
                end            
            end
            default:st      <= 'd0;
        endcase
    end
end




//----------------------------------------------------------------------------------------------------------
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( ADDR_W           ),//N words will be used
    .filename                ( "../../src/x.mem"))
simple_ram_x(
    .clk                     ( clk              ),
    .wraddress               ( wr_addr          ),
    .wren                    ( wr_ena           ),
    .data                    ( wr_x             ),

    .rdaddress               ( _j[ADDR_W   -1:0]),
    .q                       ( xj )
);
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( ADDR_W           ),//N words will be used
    .filename                ( "../../src/y.mem"))
simple_ram_y(
    .clk                     ( clk              ),
    .wraddress               ( wr_addr          ),
    .wren                    ( wr_ena           ),
    .data                    ( wr_y             ),

    .rdaddress               ( _i ),
    .q                       ( yi )
);
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( ADDR_W           ),//N words will be used
    .filename                ( "../../src/m.mem"))
simple_ram_m(
    .clk                     ( clk              ),
    .wraddress               ( wr_addr          ),
    .wren                    ( wr_ena           ),
    .data                    ( wr_m             ),

    .rdaddress               ( (comp_req)?addr_m:_j[ADDR_W   -1:0]),
    .q                       ( mj               )
);
mm_iddmm_pe #(
    .K                       ( K ),
    .N                       ( N ))
mm_iddmm_pe_0 (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .xj                      ( (j==N)?({K{1'd0}}):xj ),
    .yi                      ( yi     [K-1  :0] ),
    .mj                      ( (j==N)?({K{1'd0}}):mj ),
    .m1                      ( m1     [K-1  :0] ),
    .aj                      ( (j==N)?({K{1'd0}}):aj ),
    .i                       ( i                ),
    .j                       ( j                ),
    .j00                     ( j00              ),

    .carry                   ( carry            ),
    .uj                      ( uj     [K-1  :0] )
);
wire [ADDR_W   :0]an_1_addr;
assign            an_1_addr=j-1'd1;
simple_ram#(
    .width                   ( K                ),
    .widthad                 ( ADDR_W           ),//N words will be used
    .filename                ("../../src/a0.mem"))
simple_ram_a(//a(0)~a(n-1)
    .clk                     ( clk                                            ),
    .wraddress               ( (clra_mem)?clra_addr :an_1_addr[ADDR_W   -1:0] ),
    .wren                    ( (clra_mem)?clra_wren :j!={(ADDR_W   +1){1'd0}} ),
    .data                    ( (clra_mem)?{K{1'd0}} :uj                       ),

    .rdaddress               ( (comp_req)?addr_a:_j[ADDR_W   -1:0] ),
    .q                       ( aj                                  )
);
mm_iddmm_sub #(
    .K ( K ),
    .N ( N ))
mm_iddmm_sub_0 (
    .clk                     ( clk                       ),
    .rst_n                   ( rst_n                     ),

    .task_req                ( comp_req                  ),
    .task_end                ( comp_end                  ),
    .res                     ( res                       ),
    .res_val                 ( res_val                   ),

    .clra_mem                ( clra_mem                  ),
    .clra_wren               ( clra_wren                 ),
    .clra_addr               ( clra_addr                 ),

    .aj                      ( aj        [K-1        :0] ),
    .an                      ( {{(K-1){1'd0}},an}        ),
    .mj                      ( mj        [K-1        :0] ),
    .addr_a                  ( addr_a    [ADDR_W   -1:0] ),
    .addr_m                  ( addr_m    [ADDR_W   -1:0] )
);






endmodule