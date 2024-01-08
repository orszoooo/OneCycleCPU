`timescale 1ns/100ps

module main_tb;
parameter WIDTH = 8;

reg CLK;
reg [WIDTH-1:0] PORT;

wire [WIDTH-1:0] PC;
wire [WIDTH-1:0] INSTR;
wire [WIDTH-1:0] ARG;
wire [WIDTH-1:0] ACC;

main UUT (
    .clk(CLK),
	.port(PORT),
	.pc(PC),
	.instr(INSTR),
	.arg(ARG),
	.acc(ACC)
);

initial begin
    $display("Simulation of %m started.");
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
	$dumpfile("./Output/main_sim.vcd");
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