`timescale 1ns/100ps
`include "instr_set.v"

module id #(
    parameter WIDTH = 8,
    parameter ALU_INSTR_WIDTH = 4,
    parameter REG_F_SEL_SIZE = 4, //8 reg + PORT -> 4 bit
    parameter IN_B_SEL_SIZE = 2 // 00 - imm, 01 - REG_F, 10 - DATA_MEM
)(
    instr,
    arg,
    z_flag,

    pc_rst,
    pc_ld,
    alu_out,
    imm,
    in_b_sel,
    reg_f_sel,
    en_reg_f,
    d_mem_addr,
    d_mem_addr_mode,  
    en_d_mem,
    en_acc,
    jmp_mode,   
    base_reg_data,
    base_reg_ld,
    base_reg_offset,
    lr_ld
);

input [WIDTH-1:0] instr;
input [WIDTH-1:0] arg;
input z_flag;

output reg pc_rst;
output reg pc_ld;
output reg [ALU_INSTR_WIDTH-1:0] alu_out; //4 bit
output reg [WIDTH-1:0] imm;
output reg [IN_B_SEL_SIZE-1:0] in_b_sel;

//REG_F
output reg [REG_F_SEL_SIZE-1:0] reg_f_sel;
output reg en_reg_f;

//DATA_MEM
output reg [WIDTH-1:0] d_mem_addr;
output reg d_mem_addr_mode; //0 - ADDR from operand, 1 - ADDR form R0-R7
output reg en_d_mem;

output reg en_acc;
output reg [1:0] jmp_mode; // 00 - absolute and CALL, 01 - relative to base address register, 11 - RET

//BASE ADDRESS REGISTER
output reg [WIDTH-1:0] base_reg_offset;
output reg base_reg_ld;
output reg [WIDTH-1:0] base_reg_data;
output reg lr_ld;

always @(*) begin
    alu_out = {ALU_INSTR_WIDTH{1'b1}}; //4'hF
    
    pc_rst = 1'b0;
    pc_ld = 1'b0;
    en_acc = 1'b0;
    jmp_mode = 2'b00;
    
    in_b_sel = 2'b10; //DATA_MEM
    imm = {WIDTH{1'b0}};

    reg_f_sel = {REG_F_SEL_SIZE{1'b0}}; // R0
    en_reg_f = 1'b0;

    d_mem_addr = {WIDTH{1'b0}};
    d_mem_addr_mode = 1'b0;
    en_d_mem = 1'b0;

    base_reg_offset = {WIDTH{1'b0}};
    base_reg_ld = 1'b0;
    base_reg_data = {WIDTH{1'b0}};
    lr_ld = 1'b0;

    if(instr == `RST) begin
        pc_rst = 1'b1;
    end
    else if(instr == `LD) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        d_mem_addr = arg;
        in_b_sel = 2'b10; 
        en_acc = 1'b1;
    end
    else if(instr == `ST) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        d_mem_addr = arg;
        en_d_mem = 1'b1;
    end
    else if(instr == `LDR) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        reg_f_sel = arg; //LAST 4 bits of instr
        in_b_sel = 2'b01;
        en_acc = 1'b1;
    end
    else if(instr == `STR) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        reg_f_sel = arg;
        en_reg_f = 1'b1;
    end
    else if(instr == `BAR) begin
        base_reg_data = arg;
        base_reg_ld = 1'b1;
    end
    else if(instr == `JMP) begin
        base_reg_offset = arg;
        jmp_mode = 2'b00;
        pc_ld = 1'b1;
    end
    else if(instr == `JMPO) begin
        base_reg_offset = arg;
        jmp_mode = 2'b01;
        pc_ld = 1'b1;
    end
    else if(instr == `NOT ||
            instr == `XOR ||
            instr == `OR ||
            instr == `AND ||
            instr == `SUB ||
            instr == `ADD ||
            instr == `RR ||
            instr == `RL ||
            instr == `DEC ||
            instr == `INC 
    ) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        en_acc = 1'b1;
    end 
    else if(instr == `XORR ||
            instr == `ORR  ||
            instr == `ANDR ||
            instr == `ADDR ||
            instr == `SUBR
    ) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        reg_f_sel = arg; 
        in_b_sel = 2'b01;
        en_acc = 1'b1;
    end
    else if(instr == `CALL) begin
        lr_ld = 1'b1;
        base_reg_offset = arg;
        jmp_mode = 2'b00;
        pc_ld = 1'b1;
    end
    else if(instr == `RET) begin
        jmp_mode = 2'b11;
        base_reg_offset = {{(WIDTH-1){1'b0}},{1'b1}};
        pc_ld = 1'b1;
    end
    else if(instr == `JZ) begin
        if(z_flag) begin 
            base_reg_offset = arg;
            jmp_mode = 2'b00;
            pc_ld = 1'b1;
        end
    end
    else if(instr == `JZO) begin
        if(z_flag) begin 
            base_reg_offset = arg;
            jmp_mode = 2'b01;
            pc_ld = 1'b1;
        end
    end
    else if(instr == `LDI) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        imm = arg;
        in_b_sel = 2'b00; 
        en_acc = 1'b1;
    end
    else if(instr == `LDAR) begin
        alu_out = instr[ALU_INSTR_WIDTH-1:0];
        reg_f_sel = arg;
        d_mem_addr_mode = 1'b1;
        in_b_sel = 2'b10; 
        en_acc = 1'b1;
    end
end

endmodule