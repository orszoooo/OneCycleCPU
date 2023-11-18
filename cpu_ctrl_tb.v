`timescale 1ns/100ps

module cpu_ctrl_tb;

parameter WIDTH = 13;
parameter IWIDTH = 5; //Instruction width
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg CLK;
wire [IWIDTH-2:0] ALU_OUT; //4 bit
wire [(WIDTH-IWIDTH)-1:0] IMM; //Immediate data
wire [IN_B_SEL_SIZE-1:0] IN_B_SEL;
wire [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;
wire [(WIDTH-IWIDTH)-1:0] D_MEM_ADDR;
wire D_MEM_ADDR_MODE;
wire EN_D_MEM;
wire EN_ACC;    

cpu_ctrl #(.WIDTH(WIDTH),.IWIDTH(IWIDTH),.REG_F_SEL_SIZE(REG_F_SEL_SIZE),.IN_B_SEL_SIZE(IN_B_SEL_SIZE))
UUT(
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


initial begin
    $display("Simulation of %m started.");
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