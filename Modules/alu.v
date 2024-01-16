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
    alu_flag_valid,
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
output reg alu_flag_valid;

initial begin
    alu_c_out = 1'b0;
    alu_b_out = 1'b0;
    alu_flag_valid = 1'b0;
end

always @(*) begin
    case({{(WIDTH-IWIDTH){1'b0}}, instr}) //Padding MSBs with zeros
        `NOT: begin
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;    
            alu_out = ~in_a;
            alu_flag_valid = 1'b0;
        end
        `XOR: begin
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = in_a ^ in_b;
            alu_flag_valid = 1'b0;
        end
        `OR: begin
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = in_a | in_b;
            alu_flag_valid = 1'b0;
        end
        `AND: begin
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = in_a & in_b;
            alu_flag_valid = 1'b0;
        end
        `SUB: begin
            alu_c_out = 1'b0;  
            {alu_b_out, alu_out} = in_a - in_b - alu_b_in;
            alu_flag_valid = 1'b1;
        end
        `ADD: begin            
            alu_b_out = 1'b0;
            {alu_c_out, alu_out} = in_a + in_b + alu_c_in;
            alu_flag_valid = 1'b1;
        end
        `RR: begin 
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = {1'b0,in_a[WIDTH-1:1]};
            alu_flag_valid = 1'b0;
        end
        `RL: begin 
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = {in_a[WIDTH-2:0],1'b0};
            alu_flag_valid = 1'b0;
        end
        `DEC: begin 
            alu_c_out = 1'b0;  
            {alu_b_out, alu_out} = in_a - {{WIDTH{1'b0}},1'b1};
            alu_flag_valid = 1'b1;
        end
        `INC: begin 
            alu_b_out = 1'b0;
            {alu_c_out, alu_out} = in_a + {{WIDTH{1'b0}},1'b1};
            alu_flag_valid = 1'b1;
        end
        default: begin 
            alu_b_out = 1'b0;
            alu_c_out = 1'b0;  
            alu_out = in_b; //LD, ST, NOP, RST etc.
            alu_flag_valid = 1'b0;
        end
    endcase
end

endmodule