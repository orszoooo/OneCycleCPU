`timescale 1ns/100ps

module alu_tb;

reg CLK;
parameter W = 8;
reg [3:0] IN_INSTR;
reg [W-1:0] IN_A;
reg [W-1:0] IN_B;
reg Cin, Bin;
wire EN_C, EN_B, Cout, Bout;
wire [W-1:0] OUT;

alu #(
    .DWIDTH(W)
)
UUT (
    .IN_INSTR(IN_INSTR),
    .IN_A(IN_A),
    .IN_B(IN_B),
    .EN_C(EN_C),
    .EN_B(EN_B),
    .Cin(Cin),
    .Cout(Cout),
    .Bin(Bin),
    .Bout(Bout),
    .OUT(OUT)
);

initial begin
    $display("Simulation of %m started.");
    
    //ADD
    IN_INSTR = 4'b0000;
    IN_A = 8'h00;
    IN_B = 8'b0000;
    Cin = 1'b0;
    Bin = 1'b0;
    WAIT(10);

    IN_INSTR = 4'h5;
    IN_A = 8'h04;
    IN_B = 8'h02;
    WAIT(2);

    IN_A = 8'h04;
    IN_B = 8'h02;
    Cin = 1'b1;
    WAIT(2);

    IN_A = 8'h0A;
    IN_B = 8'h0B;
    WAIT(2);
    Cin = 1'b0;
    WAIT(3);

    IN_A = 8'hFF;
    IN_B = 8'h01;
    WAIT(5);

    IN_INSTR = 4'b0000;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //SUB
    IN_INSTR = 4'h4;
    IN_A = 8'h04;
    IN_B = 8'h02;
    WAIT(2);

    IN_A = 8'h04;
    IN_B = 8'h02;
    Bin = 1'b1;
    WAIT(2);

    IN_A = 8'h0A;
    IN_B = 8'h0B;
    WAIT(2);
    Bin = 1'b0;
    WAIT(3);

    IN_A = 8'h03;
    IN_B = 8'h1F;
    Bin = 1'b1;
    WAIT(2);
    
    IN_INSTR = 4'b0000;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);
    
    //DEC
    IN_INSTR = 4'h8;
    IN_A = 8'h70;
    WAIT(5);

        
    IN_INSTR = 4'b0000;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);
    

    //INC
    IN_INSTR = 4'h9;
    IN_A = 8'h20;
    WAIT(5);

    IN_INSTR = 4'b0000;
    IN_A = 8'h00;
    IN_B = 8'h00;
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