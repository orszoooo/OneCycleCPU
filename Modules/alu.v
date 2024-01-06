`timescale 1ns/100ps
`include "instr_set.v"

module alu #(
    parameter WIDTH = 8,
    parameter IWIDTH = 4
)(
    instr,
    in_a,
    in_b,
    alu_c_in,
    alu_b_in,
    alu_c_out,
    alu_b_out,
    alu_out
);

input [IWIDTH-1:0] instr;
input [WIDTH-1:0] in_a;
input [WIDTH-1:0] in_b;

input alu_c_in;
input alu_b_in;

output reg [WIDTH-1:0] alu_out;
output reg alu_c_out;
output reg alu_b_out;

initial begin
    alu_c_out = 1'b0;
    alu_b_out = 1'b0;
end

always @(*) begin
    case({{(WIDTH-IWIDTH){1'b0}}, instr}) //Padding MSBs with zeros
        `NOT: alu_out = ~in_a;
        `XOR: alu_out = in_a ^ in_b;
        `OR: alu_out = in_a | in_b;
        `AND: alu_out = in_a & in_b;
        `SUB: {alu_b_out, alu_out} = in_a - in_b - alu_b_in;
        `ADD: {alu_c_out, alu_out} = in_a + in_b + alu_c_in;
        `RR: alu_out = {1'b0,in_a[WIDTH-1:1]};
        `RL: alu_out = {in_a[WIDTH-2:0],1'b0};
        `DEC: {alu_b_out, alu_out} = in_a - {{WIDTH{1'b0}},1'b1};
        `INC: {alu_c_out, alu_out} = in_a + {{WIDTH{1'b0}},1'b1};
        default: alu_out = in_b; //LD, ST, NOP, RST etc.
    endcase
end

endmodule