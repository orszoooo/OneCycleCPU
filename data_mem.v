`timescale 1ns/100ps

module data_mem # (
    parameter WIDTH = 8
)(  
    CLK,
    EN,
    ADDR,
    D_IN,
    D_OUT
);
input CLK, EN;
input [WIDTH-1:0] ADDR;
input [WIDTH-1:0] D_IN;
output reg [WIDTH-1:0] D_OUT;

reg [WIDTH-1:0] MEM [$pow(2,WIDTH)-1:0];

always @(posedge CLK) begin
    if(EN) begin
        MEM[ADDR] <= D_IN;
    end

    D_OUT <= MEM[ADDR];
end

endmodule