`timescale 1ns/100ps
`include "instr_set.v"

module id_tb;
reg CLK;
parameter WIDTH = 8;
parameter ALU_INSTR_WIDTH = 4;
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg [WIDTH-1:0] INSTR;
reg [WIDTH-1:0] ARG;
reg Z_FLAG;

wire PC_RST;
wire PC_LD;
wire [ALU_INSTR_WIDTH-1:0] ALU_OUT;
wire [WIDTH-1:0] IMM;
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;
wire [WIDTH-1:0] D_MEM_ADDR;
wire D_MEM_ADDR_MODE;
wire EN_D_MEM;
wire EN_ACC;    
wire [1:0] JMP_MODE;   
wire [WIDTH-1:0] BASE_REG_OFFSET;
wire BASE_REG_LD;
wire [WIDTH-1:0] BASE_REG_DATA;
wire LR_LD;

id #(
    .WIDTH(WIDTH),
    .ALU_INSTR_WIDTH(ALU_INSTR_WIDTH),
    .REG_F_SEL_SIZE(REG_F_SEL_SIZE), //8 reg + PORT = 9 -> 4 bit
    .IN_B_SEL_SIZE(IN_B_SEL_SIZE) // 00 - IMM, 01 - REG_F, 10 - DATA_MEM
)
UUT(
    .instr(INSTR),
    .arg(ARG),
    .z_flag(Z_FLAG),
    .pc_rst(PC_RST),
    .pc_ld(PC_LD),
    .alu_out(ALU_OUT),
    .imm(IMM),
    .in_b_sel(IN_B_SEL),
    .reg_f_sel(REG_F_SEL),
    .en_reg_f(EN_REG_F),
    .d_mem_addr(D_MEM_ADDR),
    .d_mem_addr_mode(D_MEM_ADDR_MODE),
    .en_d_mem(EN_D_MEM),
    .en_acc(EN_ACC),
    .jmp_mode(JMP_MODE),   
    .base_reg_offset(BASE_REG_OFFSET),
    .base_reg_ld(BASE_REG_LD),
    .base_reg_data(BASE_REG_DATA),
    .lr_ld(LR_LD)  
);

initial begin
    $display("Simulation of %m started.");
    Z_FLAG = 1'b0;
    {INSTR, ARG} = {`NOP, 8'h00};
    WAIT(10);
    {INSTR, ARG} = {`RST, 8'h00};
    WAIT(10);
    {INSTR, ARG} = {`LD, 8'h09};
    WAIT(10);
    {INSTR, ARG} = {`ST, 8'h06};
    WAIT(10);
    {INSTR, ARG} = {`LDR, 8'h02};
    WAIT(10);
    {INSTR, ARG} = {`STR, 8'h07};
    WAIT(10);
    {INSTR, ARG} = {`BAR, 8'hA1};
    WAIT(10);
    {INSTR, ARG} = {`JMP, 8'h2B};
    WAIT(10);
    {INSTR, ARG} = {`JMPO, 8'h0C};
    WAIT(10);
    {INSTR, ARG} = {`LDI, 8'h0F};
    WAIT(10);
    {INSTR, ARG} = {`LDAR, 8'h02};
    WAIT(10);
    {INSTR, ARG} = {`XORR, 8'h01};
    WAIT(10);
    {INSTR, ARG} = {`ORR, 8'h03};
    WAIT(10);
    {INSTR, ARG} = {`ANDR, 8'h04};
    WAIT(10);
    {INSTR, ARG} = {`ADDR, 8'h05};
    WAIT(10);
    {INSTR, ARG} = {`SUBR, 8'h06};
    WAIT(10);
    {INSTR, ARG} = {`CALL, 8'h06};
    WAIT(10);
    {INSTR, ARG} = {`NOP, 8'h00};
    WAIT(10);
    {INSTR, ARG} = {`CALL, 8'h06};
    WAIT(10);
    {INSTR, ARG} = {`RET, 8'h00};
    WAIT(50);
    $finish;
end

// Clock generator
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

// Writing VCD waveform
initial begin
	$dumpfile("./Output/id_sim.vcd");
	$dumpvars(0, UUT);
	$dumpon;
end


task WAIT;
input [31:0] DY;
begin
	repeat(DY) @(posedge CLK);
end
endtask

endmodule