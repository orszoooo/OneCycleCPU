`timescale 1ns/100ps

module main #(
    parameter WIDTH = 8,
    parameter ALU_INSTR_WIDTH = 4,
    parameter REG_F_SEL_SIZE = 4,
    parameter IWIDTH = 4,
    parameter REG_SIZE = 9,
    parameter IN_B_SEL_SIZE = 2
)
(
    clk,
    port,

    pc,
    instr,
    arg,
    acc,
	in_b_dbg
);

input clk;
input [WIDTH-1:0] port;

output [WIDTH-1:0] pc;
output [WIDTH-1:0] instr;
output [WIDTH-1:0] arg;
output [WIDTH-1:0] acc;
output [WIDTH-1:0] in_b_dbg;

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
wire [ALU_INSTR_WIDTH-1:0] alu_out; 
wire [WIDTH-1:0] imm; //Immediate data
wire [WIDTH-1:0] in_b;
wire [IN_B_SEL_SIZE-1:0] in_b_sel;
wire [REG_F_SEL_SIZE-1:0] reg_f_sel;
wire en_reg_f;
wire [WIDTH-1:0] d_mem_addr;
wire d_mem_addr_mode;
wire [WIDTH-1:0] data_mem_addr_in;
wire en_d_mem;
wire en_acc;  
wire [WIDTH-1:0] data_bus;
wire [WIDTH-1:0] reg_f_out;
wire [WIDTH-1:0] data_mem_out;
wire [WIDTH-1:0] acc_in;
wire z_acc_flag_reg, c_alu_flag_reg, c_flag_reg_alu, b_alu_flag_reg, b_flag_reg_alu;
wire flag_z_out;
wire alu_flag_reg_valid;


//=======CPU CTRL=======

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
    .z_flag(z_acc_flag_reg),
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
    .data(rom_addr),
    .out(lr_jmp_addr)   
);

//=========CPU DATA===========

reg_f #(.WIDTH(WIDTH), .SIZE(REG_SIZE))
reg_f_module (
    .clk(clk),
    .in(data_bus),
    .en(en_reg_f),
    .sel(reg_f_sel),
    .port(port),
    .out(reg_f_out)
);

//DATA_MEM_ADDR MUX
assign data_mem_addr_in = (d_mem_addr_mode ? reg_f_out : d_mem_addr);

data_mem #(.WIDTH(WIDTH))
data_mem_module (
    .clk(clk),
    .en(en_d_mem),
    .addr(data_mem_addr_in),
    .d_in(data_bus),
    .d_out(data_mem_out)
);

//in_b MUX
assign in_b = (in_b_sel[1] ? data_mem_out : (in_b_sel[0] ? reg_f_out : imm));

alu #(.WIDTH(WIDTH), .IWIDTH(IWIDTH))
alu_module (
    .instr(alu_out),
    .in_a(data_bus),
    .in_b(in_b),
    .alu_c_in(c_flag_reg_alu),
    .alu_c_out(c_alu_flag_reg),
    .alu_b_in(b_flag_reg_alu),
    .alu_b_out(b_alu_flag_reg),
    .alu_flag_valid(alu_flag_reg_valid),
    .alu_out(acc_in)
);

acc #(.WIDTH(WIDTH))
acc_module (
    .clk(clk),
    .en(en_acc),
    .in(acc_in),
    .out(data_bus),
    .z_out(z_acc_flag_reg)
);

flag_reg flag_module(
    .clk(clk),
    .flag_rst(pc_rst),
    .flag_cb_valid(alu_flag_reg_valid),
    .flag_c_in(c_alu_flag_reg),
    .flag_z_in(z_acc_flag_reg),
    .flag_b_in(b_alu_flag_reg),
    .flag_c(c_flag_reg_alu),
    .flag_z(flag_z_out),
    .flag_b(b_flag_reg_alu)
);

// Output assign
assign pc = rom_addr;
assign instr = rom_instr;
assign arg = rom_arg;
assign acc = data_bus;
assign in_b_dbg = in_b;

endmodule