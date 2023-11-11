`timescale 1ns/100ps

module acc #(
    parameter WIDTH = 4
)(  CLK,
    CE,
    IN,
    OUT
);

input CLK, CE;
input [WIDTH-1:0] IN;
output reg [WIDTH-1:0] OUT;

always @(posedge CLK) begin
    if(CE) begin
        OUT <= IN;
    end
    else begin
        OUT <= OUT;
    end
end

endmodule