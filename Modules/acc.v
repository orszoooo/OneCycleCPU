`timescale 1ns/100ps

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
output reg z_out;

initial begin
    out = {WIDTH{1'b0}};
    z_out = 1'b0;
end

always @(posedge clk) begin
    if(en) begin
        out <= in;

        if(in == {WIDTH{1'b0}}) begin
            z_out <= 1'b1;
        end
        else begin
            z_out <= 1'b0;
        end
    end
    else begin
        out <= out;
    end
end

endmodule