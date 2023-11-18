`timescale 1ns/100ps

module cpu_data #(
    parameter WIDTH = 8,
    parameter REG_SIZE = 9,
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    CLK,
    REG_F_SEL,
    EN_REG_F,
    PORT,

    IN,
    OUT
);

input CLK;
input [REG_F_SEL_SIZE-1:0] REG_F_SEL;
input EN_REG_F;

inout [WIDTH-1:0] PORT;

input [WIDTH-1:0] IN;
output [WIDTH-1:0] OUT;

reg_f #(.WIDTH(WIDTH), .SIZE(REG_SIZE))
reg_f_module (
    .CLK(CLK),
    .IN(IN),
    .EN(EN_REG_F),
    .SEL(REG_F_SEL),
    .PORT(PORT),
    .OUT(OUT),
);

endmodule