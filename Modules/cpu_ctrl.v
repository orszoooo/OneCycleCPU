`timescale 1ns/100ps

module cpu_ctrl #(
    parameter WIDTH = 13,
    parameter IWIDTH = 5, //Instruction width
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    CLK,
    Z,
    ALU_OUT,
    IMM,
    IN_B_SEL,
    REG_F_SEL,
    EN_REG_F,
    D_MEM_ADDR,
    D_MEM_ADDR_MODE,  
    EN_D_MEM,
    EN_ACC
);

input CLK, Z;
wire PC_RST, PC_LD; 
wire [(WIDTH-IWIDTH)-1:0] ROM_ADDR;
wire [WIDTH-1:0] ROM_DATA;
wire [1:0] JMP_MODE;   
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_OFFSET;
wire BASE_REG_LD;
wire [(WIDTH-IWIDTH)-1:0] BASE_REG_DATA;
wire [(WIDTH-IWIDTH)-1:0] JMP_ADDRESS_PC;
wire LR_LD;
wire [(WIDTH-IWIDTH)-1:0] LR_JMP_ADDRESS;

output [IWIDTH-2:0] ALU_OUT; //4 bit
output [(WIDTH-IWIDTH)-1:0] IMM; //Immediate data
output [IN_B_SEL_SIZE-1:0] IN_B_SEL;
output [REG_F_SEL_SIZE-1:0] REG_F_SEL;
output EN_REG_F;
output [(WIDTH-IWIDTH)-1:0] D_MEM_ADDR;
output D_MEM_ADDR_MODE;
output EN_D_MEM;
output EN_ACC;    


cpu_pc #(.WIDTH((WIDTH-IWIDTH))) 
pc_module (
    .CLK(CLK),
    .RST(PC_RST),
    .LD(PC_LD),
    .ADDR(JMP_ADDRESS_PC),
    .PC_OUT(ROM_ADDR)
);

ROM #(.AWIDTH(WIDTH-IWIDTH),.DWIDTH(WIDTH))
rom (
    .ADDR(ROM_ADDR),
    .DATA(ROM_DATA)
);

cpu_id #(.WIDTH(WIDTH),.IWIDTH(IWIDTH),.REG_F_SEL_SIZE(REG_F_SEL_SIZE), .IN_B_SEL_SIZE(IN_B_SEL_SIZE))
id_module (
    .IN(ROM_DATA),
    .Z(Z),
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

cpu_jmp #(.WIDTH((WIDTH-IWIDTH)))
jmp_module (
    .JMP_MODE(JMP_MODE),
    .BASE_REG_OFFSET(BASE_REG_OFFSET),
    .BASE_REG_LD(BASE_REG_LD),
    .BASE_REG_DATA(BASE_REG_DATA),
    .LR_ADDRESS(LR_JMP_ADDRESS),
    .ADDRESS_OUT(JMP_ADDRESS_PC)
);

cpu_lr #(.WIDTH((WIDTH-IWIDTH)))
lr_module (
    .CLK(CLK),
    .LR_LD(LR_LD),
    .LR_DATA(ROM_ADDR),
    .LR_OUT(LR_JMP_ADDRESS)   
);

endmodule