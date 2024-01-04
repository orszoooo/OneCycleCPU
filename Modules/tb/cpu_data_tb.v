`timescale 1ns/100ps

module cpu_data_tb;

parameter WIDTH = 8;
parameter IWIDTH = 5;
parameter REG_SIZE = 9;
parameter REG_F_SEL_SIZE = 4;
parameter IN_B_SEL_SIZE = 2;

reg CLK;

//REG_F
reg [REG_F_SEL_SIZE-1:0] REG_F_SEL;
reg EN_REG_F;
wire [WIDTH-1:0] PORT;

//DATA_MEM
reg [WIDTH-1:0] D_MEM_ADDR;
reg D_MEM_ADDR_MODE; //0 - ADDR from operand, 1 - ADDR form R0-R7
reg EN_D_MEM;

reg [IN_B_SEL_SIZE-1:0] IN_B_SEL;
reg [WIDTH-1:0] IMM; //Immediate data

reg [IWIDTH-2:0] ALU_OUT;
reg EN_ACC;   
wire Z;
cpu_data #(.WIDTH(WIDTH),.IWIDTH(IWIDTH),.REG_SIZE(REG_SIZE),.REG_F_SEL_SIZE(REG_F_SEL_SIZE),.IN_B_SEL_SIZE(IN_B_SEL_SIZE))
UUT(
    .CLK(CLK),

    //REG_F
    .REG_F_SEL(REG_F_SEL),
    .EN_REG_F(EN_REG_F),
    .PORT(PORT),

    //DATA_MEM
    .D_MEM_ADDR(D_MEM_ADDR),
    .D_MEM_ADDR_MODE(D_MEM_ADDR_MODE), 
    .EN_D_MEM(EN_D_MEM),

    .IN_B_SEL(IN_B_SEL),
    .IMM(IMM),

    .ALU_OUT(ALU_OUT),
    .EN_ACC(EN_ACC),
    .Z(Z)
);


initial begin
    $display("Simulation of %m started.");

    REG_F_SEL = 4'h0;
    D_MEM_ADDR = 8'h00;
    D_MEM_ADDR_MODE = 1'b0;
    EN_D_MEM = 1'b0;
    IN_B_SEL = 2'b00;
    IMM = 8'h00;
    ALU_OUT = 4'hF;
    EN_ACC = 1'b0; 
    WAIT(1);
    EN_ACC = 1'b1;
    WAIT(1);
    EN_ACC = 1'b0; 
    WAIT(2);

    //LDI TEST
    IMM = 8'h69;
    IN_B_SEL = 2'b00; 
    EN_ACC = 1'b1;
    WAIT(1);
    EN_ACC = 1'b0;
    IMM = 8'h00;
    WAIT(2);

    //ST TEST
    D_MEM_ADDR = 8'h00;
    EN_D_MEM = 1'b1;
    WAIT(1);
    EN_D_MEM = 1'b0;
    WAIT(2);

    //LDI TEST
    IMM = 8'h11;
    IN_B_SEL = 2'b00; 
    EN_ACC = 1'b1;
    WAIT(1);
    EN_ACC = 1'b0;
    IMM = 8'h00;
    WAIT(2);

    //STR TEST
    REG_F_SEL = 8'h03;
    EN_REG_F = 1'b1;
    WAIT(1);
    EN_REG_F = 1'b0;
    WAIT(2);

    //LDR TEST
    REG_F_SEL = 8'h03; //LAST 4 bits of IN
    IN_B_SEL = 2'b01;
    EN_ACC = 1'b1;
    WAIT(1);
    EN_ACC = 1'b0;
    IN_B_SEL = 2'b00;
    D_MEM_ADDR = 8'hFF;
    WAIT(2);

    //ADD TEST
    D_MEM_ADDR = 8'h00;
    IN_B_SEL = 2'b10;
    ALU_OUT = 4'h5;
    EN_ACC = 1'b1;
    WAIT(1);
    EN_ACC = 1'b0;
    WAIT(2);

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