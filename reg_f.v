`timescale 1ns/100ps

module reg_f #(
    parameter WIDTH = 8,
    parameter SIZE = 9
)(
    CLK,
    IN,
    EN,
    SEL,
    PORT,
    OUT
);

input [WIDTH-1:0] IN;
input [WIDTH-1:0] PORT;
input EN, CLK;
input [$clog2(SIZE-1)-1:0] SEL;
output reg [WIDTH-1:0] OUT;

reg [WIDTH-1:0] REG_FILE [SIZE:0];

always@(posedge CLK) begin
    if(EN) begin
        REG_FILE[SEL] <= IN;
    end
    REG_FILE[8] <= PORT; //IO PORT
    OUT <= REG_FILE[SEL]
end

endmodule 