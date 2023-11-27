`timescale 1ns/100ps

module cpu_jmp #(
    parameter WIDTH = 8
)(
    JMP_MODE, // 00 - absolute, 01 - relative to base address register, 11 - CALL
    BASE_REG_OFFSET,
    BASE_REG_LD,
    BASE_REG_DATA,
    LR_ADDRESS,
    ADDRESS_OUT
);

input [1:0] JMP_MODE;
input [WIDTH-1:0] BASE_REG_OFFSET;
input BASE_REG_LD;
input [WIDTH-1:0] BASE_REG_DATA;
input [WIDTH-1:0] LR_ADDRESS;
output [WIDTH-1:0] ADDRESS_OUT;

reg [WIDTH-1:0] BASE_ADDR = {WIDTH{1'b0}};
wire [WIDTH-1:0] ADDER_IN;
wire [WIDTH-1:0] ADDER_OUT;


alu_add #(.WIDTH(WIDTH))
ADDER (
    .IN_A(ADDER_IN),
    .IN_B(BASE_REG_OFFSET),
    .IN_C(1'b0),
    .OUT(ADDER_OUT),
    .C_OUT()
);

always @(*) begin
    if(BASE_REG_LD) begin
        BASE_ADDR = BASE_REG_DATA;
    end
end

assign ADDER_IN = (JMP_MODE[1] ? LR_ADDRESS : BASE_ADDR);
assign ADDRESS_OUT = (JMP_MODE[0] ? ADDER_OUT : BASE_REG_OFFSET);

endmodule