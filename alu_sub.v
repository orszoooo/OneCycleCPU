`timescale 1ns/100ps

module alu_sub #(
    parameter WIDTH = 4
) (
    EN,
    IN_A,
    IN_B,
    IN_Bin,
    OUT,
    B_OUT
);

input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input EN, IN_Bin;
output [WIDTH-1:0] OUT;
output B_OUT;

assign OUT = (EN ? (IN_A ^ IN_B ^ IN_Bin) : {WIDTH{1'bz}});
assign B_OUT = (EN ? ((~IN_A & IN_B) | (~(IN_A ^ IN_B) & IN_Bin)) : 1'bz);

endmodule