`timescale 1ns/100ps

module pc_tb;
parameter WIDTH = 8;
reg CLK, RST, LD;
reg [WIDTH-1:0] ADDR;
wire [WIDTH-1:0] PC_OUT;

pc #(.WIDTH(WIDTH)) 
UUT (
    .clk(CLK),
    .rst(RST),
    .ld(LD),
    .addr(ADDR),
    .pc_out(PC_OUT)
);

initial begin
    $display("Simulation of %m started.");
    RST = 1'b0;
    LD = 1'b0;
    ADDR = 8'h00;

    WAIT(10);
    
    RST = 1'b1;
    WAIT(1);

    RST = 1'b0;

    WAIT(10);
    LD = 1'b1;
    WAIT(1);
    LD = 1'b0;
    ADDR = 8'hA7;
    
    WAIT(1);

    LD = 1'b0;
    WAIT(10);
    LD = 1'b1;
    WAIT(1);
    LD = 1'b0;
    ADDR = 8'h69;
    
    WAIT(1);

    LD = 1'b0;

    WAIT(20);
    $finish;
end

// Clock generator
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

// Writing VCD waveform
initial begin
	$dumpfile("./Output/pc_sim.vcd");
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