`timescale 1ns/100ps
`include "instr_set.v"

module cpu_id_tb;
reg CLK;
parameter WIDTH = 13;
parameter IWIDTH = 5;
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg [WIDTH-1:0] IN;
wire PC_RST;
wire PC_LD;
wire [IWIDTH-2:0] ALU_OUT;
wire [(WIDTH-IWIDTH)-1:0] IMM;
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;
wire [(WIDTH-IWIDTH)-1:0] D_MEM_ADDR;
wire D_MEM_ADDR_MODE;
wire EN_D_MEM;
wire EN_ACC;    
wire [1:0] JMP_MODE;   
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_OFFSET;
wire BASE_REG_LD;
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_DATA;
wire LR_LD;

cpu_id #(
    .WIDTH(WIDTH),
    .IWIDTH(IWIDTH), //Instruction width. WIdht of data part -> WIDTH-IWIDTH i.e 13 - 5 = 8 bit Data width
    .REG_F_SEL_SIZE(REG_F_SEL_SIZE), //8 reg + PORT = 9 -> 4 bit
    .IN_B_SEL_SIZE(IN_B_SEL_SIZE) // 00 - IMM, 01 - REG_F, 10 - DATA_MEM
)
UUT(
    .IN(IN),
    .PC_RST(PC_RST),
    .PC_LD(PC_LD),
    .ALU_OUT(ALU_OUT),
    .IMM(IMM),
    .IN_B_SEL(IN_B_SEL),
    .REG_F_SEL(REG_F_SEL),
    .EN_REG_F(EN_REG_F),
    .D_MEM_ADDR(D_MEM_ADDR),
    .D_MEM_ADDR_MODE(D_MEM_ADDR_MODE),
    .EN_D_MEM(EN_D_MEM),
    .EN_ACC(EN_ACC),
    .JMP_MODE(JMP_MODE),   
    .BASE_REG_OFFSET(BASE_REG_OFFSET),
    .BASE_REG_LD(BASE_REG_LD),
    .BASE_REG_DATA(BASE_REG_DATA),
    .LR_LD(LR_LD)  
);

initial begin
    $display("Simulation of %m started.");
    IN = {`NOP, 8'h00};
    WAIT(10);
    IN = {`RST, 8'h00};
    WAIT(10);
    IN = {`LD, 8'h09};
    WAIT(10);
    IN = {`ST, 8'h06};
    WAIT(10);
    IN = {`LDR, 8'h02};
    WAIT(10);
    IN = {`STR, 8'h07};
    WAIT(10);
    IN = {`BAR, 8'hA1};
    WAIT(10);
    IN = {`JMP, 8'h2B};
    WAIT(10);
    IN = {`JMPO, 8'h0C};
    WAIT(10);
    IN = {`LDI, 8'h0F};
    WAIT(10);
    IN = {`LDAR, 8'h02};
    WAIT(10);
    IN = {`XORR, 8'h01};
    WAIT(10);
    IN = {`ORR, 8'h03};
    WAIT(10);
    IN = {`ANDR, 8'h04};
    WAIT(10);
    IN = {`ADDR, 8'h05};
    WAIT(10);
    IN = {`SUBR, 8'h06};
    WAIT(10);
    IN = {`CALL, 8'h06};
    WAIT(10);
    IN = {`NOP, 8'h00};
    WAIT(10);
    IN = {`CALL, 8'h06};
    WAIT(10);
    IN = {`RET, 8'h00};
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
	$dumpfile("cpu_sim.vcd");
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