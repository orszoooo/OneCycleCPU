`timescale 1ns/100ps

module cpu_main #(
    parameter WIDTH = 13,
    parameter IWIDTH = 5,
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    CLK
);

input CLK;
wire RST, PC_LD; 
wire [(WIDTH-IWIDTH)-1:0] PC_OUT;
wire [WIDTH-1:0] DATA_TO_ID;
wire [IWIDTH-2:0] ALU_OUT;
wire [(WIDTH-IWIDTH)-1:0] IMM;
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;
wire [(WIDTH-IWIDTH)-1:0] D_MEM_ADDR;
wire D_MEM_ADDR_MODE;
wire EN_D_MEM;
wire EN_ACC;    
wire JMP_MODE;   
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_OFFSET;
wire BASE_REG_LD;
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_DATA;

cpu_pc #(.WIDTH((WIDTH-IWIDTH))) 
PC (
    .CLK(CLK),
    .RST(RST),
    .LD(PC_LD),
    .ADDR(BASE_REG_OFFSET),
    .PC_OUT(PC_OUT)
);

ROM #(.AWIDTH(WIDTH-IWIDTH),.DWIDTH(WIDTH))
rom (
    .ADDR(PC_OUT),
    .DATA(DATA_TO_ID)
);

cpu_id #(.WIDTH(WIDTH),.IWIDTH(IWIDTH),.REG_F_SEL_SIZE(REG_F_SEL_SIZE), .IN_B_SEL_SIZE(IN_B_SEL_SIZE))
id (
    .IN(DATA_TO_ID),
    .RST(RST),
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
    .BASE_REG_DATA(BASE_REG_DATA)  
);


endmodule