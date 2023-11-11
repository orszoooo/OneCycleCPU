`timescale 1ns/100ps

module alu_add #(
    parameter WIDTH = 4
) (
    EN,
    IN_A,
    IN_B,
    IN_C,
    OUT,
    C_OUT
);

input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input EN, IN_C;
output [WIDTH-1:0] OUT;
output C_OUT;

assign {C_OUT, OUT} = ( EN ? IN_A + IN_B + IN_C : {1'bz, {WIDTH{1'bz}}});

endmodule