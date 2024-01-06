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

initial begin
    LR_REG = {WIDTH{1'b0}};
end

always @(posedge ld) begin
    LR_REG <= data;
end

always @(posedge clk) begin
    out <= LR_REG;
end

endmodule