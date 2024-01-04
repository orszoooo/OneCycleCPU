`timescale 1ns/100ps

module rom_tb;
reg CLK;
parameter AW = 4;
parameter DW = 8;
reg [AW-1:0] ADDR;
wire [DW-1:0] DATA;

ROM #(
    .AWIDTH(AW),
    .DWIDTH(DW)
    ) 
UUT (
    .ADDR(ADDR),
    .DATA(DATA)
);

initial begin
    $display("Simulation of %m started.");
    ADDR = 4'b0000;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(1);
    ADDR = ADDR + 1'b1;
    WAIT(2);
    ADDR = ADDR + 1'b1;
    WAIT(10);
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