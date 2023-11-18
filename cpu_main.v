`timescale 1ns/100ps

module cpu_main #(
    parameter WIDTH = 13,
    parameter IWIDTH = 5,
    parameter REG_F_SEL_SIZE = 4,
    parameter REG_SIZE = 9,
    parameter IN_B_SEL_SIZE = 2
)
(
    CLK,
    PORT
);

input CLK;
inout [(WIDTH-IWIDTH)-1:0] PORT;   

//REG_F
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;

//DATA_MEM
wire [(WIDTH-IWIDTH)-1:0] D_MEM_ADDR;
wire EN_D_MEM;

//INPUT B SOURCE CTRL
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [(WIDTH-IWIDTH)-1:0] IMM; //Immediate data

//DATA_MEM ADDRESS SOURCE CTRL
wire D_MEM_ADDR_MODE; //0 - ADDR from operand, 1 - ADDR form R0-R7

wire [IWIDTH-2:0] ALU_OUT;
wire EN_ACC;

cpu_ctrl #(
    .WIDTH(WIDTH),
    .IWIDTH(IWIDTH), //Instruction width
    .REG_F_SEL_SIZE(REG_F_SEL_SIZE),
    .IN_B_SEL_SIZE(IN_B_SEL_SIZE)
)
cpu_ctrl_module (
    .CLK(CLK),
    .ALU_OUT(ALU_OUT),
    .IMM(IMM),
    .IN_B_SEL(IN_B_SEL),
    .REG_F_SEL(REG_F_SEL),
    .EN_REG_F(EN_REG_F),
    .D_MEM_ADDR(D_MEM_ADDR),
    .D_MEM_ADDR_MODE(D_MEM_ADDR_MODE),  
    .EN_D_MEM(EN_D_MEM),
    .EN_ACC(EN_ACC)
);

cpu_data #(
    .WIDTH(WIDTH-IWIDTH),
    .REG_SIZE(REG_SIZE),
    .REG_F_SEL_SIZE(REG_F_SEL_SIZE),
    .IN_B_SEL_SIZE(IN_B_SEL_SIZE)
)
cpu_data_module (
    .CLK(CLK),

    //REG_F
    .REG_F_SEL(REG_F_SEL),
    .EN_REG_F(EN_REG_F),
    .PORT(PORT),

    //DATA_MEM
    .D_MEM_ADDR(D_MEM_ADDR),
    .D_MEM_ADDR_MODE(D_MEM_ADDR_MODE), 
    .EN_D_MEM(EN_D_MEM),

    .ALU_OUT(ALU_OUT),
    .EN_ACC(EN_ACC)
);


endmodule