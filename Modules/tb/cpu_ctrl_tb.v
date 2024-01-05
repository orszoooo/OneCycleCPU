`timescale 1ns/100ps

module cpu_ctrl_tb;

parameter WIDTH = 8;
parameter ALU_INSTR_WIDTH = 4;
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg CLK;
reg Z_FLAG;
wire [ALU_INSTR_WIDTH-1:0] ALU_OUT; 
wire [WIDTH-1:0] IMM; //Immediate data
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;
wire [WIDTH-1:0] D_MEM_ADDR;
wire D_MEM_ADDR_MODE;
wire EN_D_MEM;
wire EN_ACC;    

cpu_ctrl #(.WIDTH(WIDTH),.ALU_INSTR_WIDTH(ALU_INSTR_WIDTH),.REG_F_SEL_SIZE(REG_F_SEL_SIZE),.IN_B_SEL_SIZE(IN_B_SEL_SIZE))
UUT(
    .clk(CLK),
    .z_flag(Z_FLAG),
    .alu_out(ALU_OUT),
    .imm(IMM),
    .in_b_sel(IN_B_SEL),
    .reg_f_sel(REG_F_SEL),
    .en_reg_f(EN_REG_F),
    .d_mem_addr(D_MEM_ADDR),
    .d_mem_addr_mode(D_MEM_ADDR_MODE),  
    .en_d_mem(EN_D_MEM),
    .en_acc(EN_ACC)
);


initial begin
    $display("Simulation of %m started.");
    Z_FLAG = 1'b0;
    WAIT(200);
    $finish;
end

// Clock generator
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

// Writing VCD waveform
initial begin
	$dumpfile("./Output/cpu_ctrl_sim.vcd");
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