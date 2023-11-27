`timescale 1ns/100ps

module alu_sub #(
    parameter WIDTH = 8
) (
    IN_A,
    IN_B,
    IN_Bin,
    OUT,
    B_OUT
);

input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input IN_Bin;
output [WIDTH-1:0] OUT;
output B_OUT;

assign {B_OUT,OUT} = IN_A - IN_B - IN_Bin;

endmodule