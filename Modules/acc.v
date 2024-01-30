`timescale 1ns/1ps

module acc #(
    parameter WIDTH = 8
)(  
    clk,
    en,
    in,
    out,
    z_out
);

input clk, en;
input [WIDTH-1:0] in;
output reg [WIDTH-1:0] out;
output z_out;

initial begin
    out = {WIDTH{1'b0}};
end

always @(posedge clk) begin
    if(en) begin
        out <= in;
    end
    else begin
        out <= out;
    end
end

assign z_out = ((in == {WIDTH{1'b0}} && en) || (out == {WIDTH{1'b0}})) ? 1'b1 : 1'b0; 

endmodule