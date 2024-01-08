`timescale 1ns/100ps

module main_visual_tb;
parameter WIDTH = 8;
parameter DISP_WIDTH = 7;

reg CLK;
reg [WIDTH-1:0] PORT;

wire [WIDTH-1:0] PC;
wire [DISP_WIDTH-1:0] INSTR1;
wire [DISP_WIDTH-1:0] INSTR2;
wire [DISP_WIDTH-1:0] ARG1;
wire [DISP_WIDTH-1:0] ARG2;
wire [DISP_WIDTH-1:0] ACC1;
wire [DISP_WIDTH-1:0] ACC2;

main_visual UUT (
    .clk(CLK),
	.port_sw(PORT),
	.pc_led(PC),
	.instr_disp1(INSTR1),
	.instr_disp2(INSTR2),
	.arg_disp1(ARG1),
	.arg_disp2(ARG2),	
	.acc_disp1(ACC1),
	.acc_disp2(ACC2)	
);

initial begin
    $display("Simulation of %m started.");
	PORT = 8'h00;
    WAIT(100);
    $finish;
end

// Clock generator
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

// Writing VCD waveform
initial begin
	$dumpfile("./Output/main_visual_sim.vcd");
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