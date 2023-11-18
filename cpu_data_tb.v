`timescale 1ns/100ps

module cpu_data_tb;

parameter WIDTH = 8;
parameter REG_SIZE = 9;
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg CLK;
reg [REG_F_SEL_SIZE-1:0] REG_F_SEL;
wire EN_REG_F;

inout [WIDTH-1:0] PORT;

input [WIDTH-1:0] IN;
output [WIDTH-1:0] OUT;

cpu_data #(.WIDTH(WIDTH),.IWIDTH(IWIDTH),.REG_F_SEL_SIZE(REG_F_SEL_SIZE),.IN_B_SEL_SIZE(IN_B_SEL_SIZE))
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