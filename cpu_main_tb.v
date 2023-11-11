`timescale 1ns/100ps

module cpu_main_tb;
reg CLK;

cpu_main UUT (
    .CLK(CLK)
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