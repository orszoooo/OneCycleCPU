`timescale 1ns/100ps

module alu_sub #(
    parameter WIDTH = 8
) (
    EN,
    IN_A,
    IN_B,
    IN_Bin,
    OUT,
    B_OUT
);
input EN; 
input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input IN_Bin;
output reg [WIDTH-1:0] OUT;
output reg B_OUT;

always @(*) begin
    if(EN) {B_OUT,OUT} = IN_A - IN_B - IN_Bin;
end

endmodule