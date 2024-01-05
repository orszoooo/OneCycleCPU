`timescale 1ns/100ps

module lr #(
    parameter WIDTH = 8
) (
    clk,
    ld,
    data,
    out
);  

input clk, ld;
input [WIDTH-1:0] data;
output reg [WIDTH-1:0] out;

reg [WIDTH-1:0] LR_REG;

always @(posedge clk) begin
    if(ld) begin
        LR_REG = data;
    end
    out = LR_REG;
end

endmodule