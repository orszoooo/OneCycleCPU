`timescale 1ns/100ps

module alu_add #(
    parameter WIDTH = 8
) (
    IN_A,
    IN_B,
    IN_C,
    OUT,
    C_OUT
);

input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input IN_C;
output [WIDTH-1:0] OUT;
output C_OUT;

assign {C_OUT, OUT} = IN_A + IN_B + IN_C;

endmodule