`timescale 1ns/100ps

module jmp #(
    parameter WIDTH = 8
)(
    jmp_mode, // 00 - absolute, 01 - relative to base address register, 11 - CALL
    base_reg_data,
    base_reg_ld,
    base_reg_offset,
    lr_addr,
    out_addr
);

input [1:0] jmp_mode;
input [WIDTH-1:0] base_reg_offset;
input base_reg_ld;
input [WIDTH-1:0] base_reg_data;
input [WIDTH-1:0] lr_addr;
output [WIDTH-1:0] out_addr;

reg [WIDTH-1:0] BASE_ADDR = {WIDTH{1'b0}};

always @(*) begin
    if(base_reg_ld) begin
        BASE_ADDR = base_reg_data;
    end
end

assign out_addr = (jmp_mode[0] ? ((jmp_mode[1] ? lr_addr : BASE_ADDR) + base_reg_offset) : base_reg_offset);

endmodule