`timescale 1ns/100ps

module cpu_data #(
    parameter WIDTH = 8,
    parameter IWIDTH = 4,
    parameter REG_SIZE = 9,
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    clk,
    pc_rst,

    //REG_F
    reg_f_sel,
    en_reg_f,
    port,

    //DATA_MEM
    d_mem_addr,
    d_mem_addr_mode, 
    en_d_mem,

    in_b_sel,
    imm,

    alu_out,
    en_acc,
    flag_z_out
);

input clk;
input pc_rst;

//REG_F
input [REG_F_SEL_SIZE-1:0] reg_f_sel;
input en_reg_f;
inout [WIDTH-1:0] port;

//DATA_MEM
input [WIDTH-1:0] d_mem_addr;
input en_d_mem;

//INPUT B SOURCE CTRL
input [IN_B_SEL_SIZE-1:0] in_b_sel;
input [WIDTH-1:0] imm; //Immediate data
wire [WIDTH-1:0] in_b;

//DATA_MEM ADDRESS SOURCE CTRL
input d_mem_addr_mode; //0 - addr from operand, 1 - addr form R0-R7
wire [WIDTH-1:0] data_mem_addr_in;

input [IWIDTH-1:0] alu_out;
input en_acc;   

wire [WIDTH-1:0] data_bus;
wire [WIDTH-1:0] reg_f_out;
wire [WIDTH-1:0] data_mem_out;
wire [WIDTH-1:0] acc_in;
wire z_acc_flag_reg, c_alu_flag_reg, c_flag_reg_alu, b_alu_flag_reg, b_flag_reg_alu;
wire alu_flag_valid;
output flag_z_out;

reg_f #(.WIDTH(WIDTH), .SIZE(REG_SIZE))
reg_f_module (
    .clk(clk),
    .in(data_bus),
    .en(en_reg_f),
    .sel(reg_f_sel),
    .port(port),
    .out(reg_f_out)
);

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

//DATA_MEM_ADDR MUX
assign data_mem_addr_in = (d_mem_addr_mode ? reg_f_out : d_mem_addr);

alu #(.WIDTH(WIDTH), .IWIDTH(IWIDTH))
alu_module (
    .instr(alu_out),
    .in_a(data_bus),
    .in_b(in_b),
    .alu_c_in(c_flag_reg_alu),
    .alu_c_out(c_alu_flag_reg),
    .alu_b_in(b_flag_reg_alu),
    .alu_b_out(b_alu_flag_reg),
    .alu_flag_valid(alu_flag_valid),
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
    .flag_cb_valid(alu_flag_valid),
    .flag_c_in(c_alu_flag_reg),
    .flag_z_in(z_acc_flag_reg),
    .flag_b_in(b_alu_flag_reg),
    .flag_c(c_flag_reg_alu),
    .flag_z(flag_z_out),
    .flag_b(b_flag_reg_alu)
);

endmodule