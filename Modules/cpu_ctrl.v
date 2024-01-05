`timescale 1ns/100ps

module cpu_ctrl #(
    parameter WIDTH = 8,
    parameter ALU_INSTR_WIDTH = 4,
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    clk,
    flag_z,
    alu_out,
    imm,
    in_b_sel,
    reg_f_sel,
    en_reg_f,
    d_mem_addr,
    d_mem_addr_mode,  
    en_d_mem,
    en_acc
);

input clk, flag_z;
wire pc_rst, pc_ld; 
wire [WIDTH-1:0] rom_addr;
wire [WIDTH-1:0] rom_instr;
wire [WIDTH-1:0] rom_arg;
wire [1:0] jmp_mode;   
wire [WIDTH-1:0] base_reg_offset;
wire base_reg_ld;
wire [WIDTH-1:0] base_reg_data;
wire [WIDTH-1:0] jmp_addr_pc;
wire lr_ld;
wire [WIDTH-1:0] lr_jmp_addr;

output [ALU_INSTR_WIDTH-1:0] alu_out; 
output [WIDTH-1:0] imm; //Immediate data
output [IN_B_SEL_SIZE-1:0] in_b_sel;
output [REG_F_SEL_SIZE-1:0] reg_f_sel;
output en_reg_f;
output [WIDTH-1:0] d_mem_addr;
output d_mem_addr_mode;
output en_d_mem;
output en_acc;    


pc #(.WIDTH(WIDTH)) 
pc_module (
    .clk(clk),
    .rst(pc_rst),
    .ld(pc_ld),
    .addr(jmp_addr_pc),
    .pc_out(rom_addr)
);

rom #(.WIDTH(WIDTH))
rom_module (
    .addr(rom_addr),
    .instr(rom_instr),
    .arg(rom_arg)
);

id #(.WIDTH(WIDTH), .ALU_INSTR_WIDTH(ALU_INSTR_WIDTH), .REG_F_SEL_SIZE(REG_F_SEL_SIZE), .IN_B_SEL_SIZE(IN_B_SEL_SIZE))
id_module (
    .instr(rom_instr),
    .arg(rom_arg),
    .flag_z(flag_z),
    .pc_rst(pc_rst),
    .pc_ld(pc_ld),
    .alu_out(alu_out),
    .imm(imm),
    .in_b_sel(in_b_sel),
    .reg_f_sel(reg_f_sel),
    .en_reg_f(en_reg_f),
    .d_mem_addr(d_mem_addr),
    .d_mem_addr_mode(d_mem_addr_mode),
    .en_d_mem(en_d_mem),
    .en_acc(en_acc),
    .jmp_mode(jmp_mode),   
    .base_reg_data(base_reg_data),
    .base_reg_ld(base_reg_ld),
    .base_reg_offset(base_reg_offset),
    .lr_ld(lr_ld)
);

jmp #(.WIDTH(WIDTH))
jmp_module (
    .jmp_mode(jmp_mode),
    .base_reg_data(base_reg_data),
    .base_reg_ld(base_reg_ld),
    .base_reg_offset(base_reg_offset),
    .lr_addr(lr_jmp_addr),
    .out_addr(jmp_addr_pc)
);

lr #(.WIDTH(WIDTH))
lr_module (
    .clk(clk),
    .ld(lr_ld),
    .data(base_reg_offset),
    .out(lr_jmp_addr)   
);

endmodule