`timescale 1ns/100ps

module lr_tb;

parameter WIDTH = 8;
reg CLK, LR_LD;
reg [WIDTH-1:0] LR_DATA;
wire [WIDTH-1:0] LR_OUT;
 
    
lr #(
    .WIDTH(WIDTH)
) 
UUT (
    .clk(CLK),
    .ld(LR_LD),
    .data(LR_DATA),
    .out(LR_OUT)
);  


initial begin
    $display("Simulation of %m started.");
    LR_LD = 1'b1;
    LR_DATA = {WIDTH{1'b0}};
    WAIT(1);
    LR_LD = 1'b0;
    WAIT(5);

    LR_LD = 1'b1;
    LR_DATA = {8'hA7};
    WAIT(1);
    LR_LD = 1'b0;
    WAIT(5);

    LR_DATA = {8'h13};
    WAIT(5);

    WAIT(50);
    $finish;
end

// Clock generator
initial begin
	CLK = 1'b0;
	forever #5 CLK = ~CLK;
end

// Writing VCD waveform
initial begin
	$dumpfile("./Output/lr_sim.vcd");
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