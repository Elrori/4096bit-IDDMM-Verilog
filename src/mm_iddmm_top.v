/*
*   Name        :IDDMM algorithm,FPGA top 
*   Description :mm_iddmm_sp
*   Orirgin     :20200716
*   Author      :helrori
*/

module mm_iddmm_top
#(
    parameter K  = 128,
    parameter N  = 32 
)
(
    input clk_200mhz_p,
    input clk_200mhz_n,
    input reset,
    
    output [7:0]led
);
wire rst_n=~reset;
reg task_req=0;
wire task_end;
reg [3:0]st=0;
reg [31:0]cnt=0;
wire res_val;
wire [K-1:0]res;
wire clk;

assign led=res[7:0];
IBUFGDS
clk_200mhz_ibufgds_inst(
    .I(clk_200mhz_p),
    .IB(clk_200mhz_n),
    .O(clk)
);

always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        st<=0;
        task_req<=0;
        cnt<=0;
    end else begin
        case (st)
            0:begin
                if (cnt==50_000_000-1) begin
                    cnt<=0;
                    st  <=  1;
                    task_req<=1;
                end else begin
                    cnt<=cnt+1;
                end
            end
            1:begin
                if (task_end) begin
                    task_req<=0;
                    st  <=  2;
                end
            end 
            2:begin
                st  <=  0;
            end 
            default:; 
        endcase
    end
end
mm_iddmm_sp #(
    .K      ( K      ),
    .N      ( N      ))
mm_iddmm_sp_0 (
    .clk                     ( clk      ),
    .rst_n                   ( rst_n    ),

    .wr_ena                  ( 1'd0     ),
    .wr_addr                 ( 'd0      ),
    .wr_x                    ( 'd0      ),
    .wr_y                    ( 'd0      ),
    .wr_m                    ( 'd0      ),
    .wr_m1                   ( 'd0      ),

    .task_req                ( task_req                   ),
    .task_end                ( task_end                   ),
    .res_val                 ( res_val                    ),
    .res                     ( res        [K-1:0]         )
);
endmodule