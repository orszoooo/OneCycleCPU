`timescale 1ns/100ps

module data_mem_tb;

parameter W = 8;
reg CLK, EN, WR, RD;
reg [W-1:0] ADDR;
reg [W-1:0] D_IN;
wire [W-1:0] D_OUT;
integer i;

data_mem #(
    .WIDTH(W)
) UUT (
    .CLK(CLK),
    .EN(EN),
    .ADDR(ADDR),
    .D_IN(D_IN),
    .D_OUT(D_OUT)
);

initial begin
    $display("Simulation of %m started.");
    ADDR = 8'h00;
    D_IN = 8'h00;
    EN = 1'b1;
    WAIT(5);

    for(i = 0; i < $pow(2,W)-1; i++) begin
        ADDR = ADDR + 8'h01;
        D_IN = D_IN + 8'h05;
        WAIT(5);
    end

    ADDR = 8'h00;
    D_IN = 8'h00;
    EN = 1'b0;
    WAIT(20);

    for(i = 0; i < $pow(2,W)-1; i++) begin
        ADDR = ADDR + 8'h01;
        WAIT(5);
    end

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