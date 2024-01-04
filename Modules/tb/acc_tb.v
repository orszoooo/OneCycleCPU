`timescale 1ns/100ps

module acc_tb;
parameter W = 8;
reg CLK, EN;
reg [W-1:0] IN;
wire [W-1:0] OUT;
wire Z;

acc #(
    .WIDTH(W)) 
UUT (
    .CLK(CLK),
    .EN(EN),
    .IN(IN),
    .OUT(OUT),
    .Z(Z)
);

initial begin
    $display("Simulation of %m started.");
    EN = 1'b0;
    IN = 4'b0101;
    WAIT(1);
    EN = 1'b1;
    WAIT(1);
    EN = 1'b0;
    WAIT(1);
    EN = 1'b1;
    IN = 4'b1111;
    WAIT(1);
    IN = 4'b0000;
    WAIT(2);
    EN = 1'b0;
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