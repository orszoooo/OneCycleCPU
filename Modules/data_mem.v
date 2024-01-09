`timescale 1ns/100ps

module data_mem # (
    parameter WIDTH = 8
)(  
    clk,
    en,
    addr,
    d_in,
    d_out
);
input clk, en;
input [WIDTH-1:0] addr;
input [WIDTH-1:0] d_in;
output [WIDTH-1:0] d_out;

reg [WIDTH-1:0] MEM [(2**WIDTH)-1:0];

integer i = 0;

initial begin
    for(i=0;i<(2**WIDTH);i=i+1) begin
        MEM[i] = {WIDTH{1'b0}};
    end
end

always @(posedge clk) begin
    if(en) begin
        MEM[addr] <= d_in;
    end
end

assign d_out = MEM[addr];

endmodule