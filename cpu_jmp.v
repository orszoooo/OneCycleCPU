`timescale 1ns/100ps

module cpu_jmp #(
    parameter WIDTH = 8
)(
    JMP_MODE,
    BASE_REG_OFFSET,
    BASE_REG_LD,
    BASE_REG_DATA,
    ADDR_OUT
);

input JMP_MODE;
input [WIDTH-1:0] BASE_REG_OFFSET;
input BASE_REG_LD;
input [WIDTH-1:0] BASE_REG_DATA;
output reg [WIDTH-1:0] ADDR_OUT;

reg [WIDTH-1:0] BASE_ADDR;

always @(*) begin
    
end

endmodule