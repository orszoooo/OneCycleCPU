`timescale 1ns/100ps

module cpu_data #(
    parameter WIDTH = 8,
    parameter IWIDTH = 5,
    parameter REG_SIZE = 9,
    parameter REG_F_SEL_SIZE = 4,
    parameter IN_B_SEL_SIZE = 2
)
(
    CLK,

    //REG_F
    REG_F_SEL,
    EN_REG_F,
    PORT,

    //DATA_MEM
    D_MEM_ADDR,
    D_MEM_ADDR_MODE, 
    EN_D_MEM,

    ALU_OUT,
    EN_ACC
);

input CLK;

//REG_F
input [REG_F_SEL_SIZE-1:0] REG_F_SEL;
input EN_REG_F;
inout [WIDTH-1:0] PORT;

//DATA_MEM
input [WIDTH-1:0] D_MEM_ADDR;
input EN_D_MEM;

//INPUT B SOURCE CTRL
input [IN_B_SEL_SIZE-1:0] IN_B_SEL;
input [WIDTH-1:0] IMM; //Immediate data
wire [WIDTH-1:0] IN_B;

//DATA_MEM ADDRESS SOURCE CTRL
input D_MEM_ADDR_MODE; //0 - ADDR from operand, 1 - ADDR form R0-R7
wire [WIDTH-1:0] DATA_MEM_ADDR_IN;

input [IWIDTH-2:0] ALU_OUT;
input EN_ACC;   

wire [WIDTH-1:0] DATA_BUS;
wire [WIDTH-1:0] REG_F_OUT;
wire [WIDTH-1:0] DATA_MEM_OUT;
wire [WIDTH-1:0] ACC_IN;

reg_f #(.WIDTH(WIDTH), .SIZE(REG_SIZE))
reg_f_module (
    .CLK(CLK),
    .IN(DATA_BUS),
    .EN(EN_REG_F),
    .SEL(REG_F_SEL),
    .PORT(PORT),
    .OUT(REG_F_OUT)
);

data_mem #(.WIDTH(WIDTH))
data_mem_module (
    .CLK(CLK),
    .EN(EN_D_MEM),
    .ADDR(DATA_MEM_ADDR_IN),
    .D_IN(DATA_BUS),
    .D_OUT(DATA_MEM_OUT)
);

//IN_B MUX
assign IN_B = (IN_B_SEL[1] ? DATA_MEM_OUT : (IN_B_SEL[0] ? REG_F_OUT : IMM));

//DATA_MEM_ADDR MUX
assign DATA_MEM_ADDR_IN = (D_MEM_ADDR_MODE ? REG_F_OUT : D_MEM_ADDR);

alu #(.DWIDTH(WIDTH))
alu_module (
    .IN_INSTR(ALU_OUT),
    .IN_A(DATA_BUS),
    .IN_B(IN_B),
    .OUT(ACC_IN)
);

acc #(.WIDTH(WIDTH))
acc_module (
    .CLK(CLK),
    .EN(EN_ACC),
    .IN(ACC_IN),
    .OUT(DATA_BUS)
);

endmodule