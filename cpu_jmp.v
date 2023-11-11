`timescale 1ns/100ps

module cpu_jmp #(
    parameter WIDTH = 8
)(
    JMP_MODE,
    BASE_REG_OFFSET,
    BASE_REG_LD,
    BASE_REG_DATA,
    ADDRESS_OUT
);

input JMP_MODE;
input [WIDTH-1:0] BASE_REG_OFFSET;
input BASE_REG_LD;
input [WIDTH-1:0] BASE_REG_DATA;
output reg [WIDTH-1:0] ADDRESS_OUT;

reg [WIDTH-1:0] BASE_ADDR = {WIDTH{1'b0}};
wire [WIDTH-1:0] ADDER_OUT;

alu_add #(.WIDTH(WIDTH))
ADDER (
    .EN(1'b1),
    .IN_A(BASE_ADDR),
    .IN_B(BASE_REG_OFFSET),
    .IN_C(1'b0),
    .OUT(ADDER_OUT),
    .C_OUT()
);

always @(*) begin
    if(BASE_REG_LD) begin
        BASE_ADDR = BASE_REG_DATA;
    end

    case(JMP_MODE)
        1'b0: ADDRESS_OUT = BASE_REG_OFFSET;
        1'b1: ADDRESS_OUT = ADDER_OUT;
    endcase
end

endmodule