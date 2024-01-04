`timescale 1ns/100ps

module rom_tb;
reg CLK;
parameter WIDTH = 8;
reg [WIDTH-1:0] ADDR;
wire [(WIDTH*2)-1:0] DATA;

rom #(
    .WIDTH(WIDTH))
UUT (
    .addr(ADDR),
    .data(DATA)
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
	$dumpfile("./Output/rom_sim.vcd");
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