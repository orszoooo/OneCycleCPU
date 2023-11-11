`timescale 1ns/100ps

module data_mem_tb;

parameter AW = 4;
parameter DW = 4;
reg CLK, EN, WR, RD;
reg [AW-1:0] ADDR;
reg [DW-1:0] D_IN;
wire [DW-1:0] D_OUT;
integer i;

data_mem #(
    .AWIDTH(AW),
    .DWIDTH(DW)
) UUT (
    .CLK(CLK),
    .EN(EN),
    .WR(WR),
    .RD(RD),
    .ADDR(ADDR),
    .D_IN(D_IN),
    .D_OUT(D_OUT)
);

initial begin
    $display("Simulation of %m started.");
    ADDR = 2'b00;
    D_IN = 4'b0000;
    EN = 1'b0;
    WR = 1'b1;
    RD = 1'b0;
    WAIT(5);

    EN = 1'b1;
    WAIT(5);

    for(i = 0; i < $pow(2,AW)-1; i++) begin
        ADDR = ADDR + 2'd1;
        D_IN = D_IN + 'd1;
        WAIT(5);
    end

    ADDR = 2'b00;
    D_IN = 4'b0000;
    EN = 1'b1;
    WR = 1'b0;
    RD = 1'b1;
    WAIT(20);

    for(i = 0; i < $pow(2,AW)-1; i++) begin
        ADDR = ADDR + 2'd1;
        WAIT(5);
    end

    WAIT(10);   

    ADDR = 2'b00;
    D_IN = 4'b0000;
    EN = 1'b0;
    WR = 1'b0;
    RD = 1'b1;
    WAIT(20);

    for(i = 0; i < $pow(2,AW)-1; i++) begin
        ADDR = ADDR + 2'd1;
        WAIT(5);
    end

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