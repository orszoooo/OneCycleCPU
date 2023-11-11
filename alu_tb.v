`timescale 1ns/100ps

module alu_tb;

reg CLK;
parameter W = 4;
reg [W-1:0] IN_INSTR;
reg [W-1:0] IN_A;
reg [W-1:0] IN_B;
wire [W-1:0] OUT;

alu #(
    .IWIDTH(W),
    .DWIDTH(W)
)
UUT (
    .IN_INSTR(IN_INSTR),
    .IN_A(IN_A),
    .IN_B(IN_B),
    .OUT(OUT)
);

initial begin
    $display("Simulation of %m started.");
    
    //NOT
    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(5);
    IN_A = 4'b0101;
    IN_B = 4'b0010;
    WAIT(5);
    
    //XOR
    IN_INSTR = 4'b0001;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b1111;
    WAIT(5);

    //OR
    IN_INSTR = 4'b0010;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b0100;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b1001;
    WAIT(5);
    

    //AND
    IN_INSTR = 4'b0011;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b0100;
    WAIT(2);
    IN_A = 4'b1010;
    IN_B = 4'b1001;
    WAIT(5);
    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(10);
    
    //SUB
    IN_INSTR = 4'b0100;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(2);

    IN_A = 4'b1111;
    IN_B = 4'b0010;
    WAIT(2);

    IN_A = 4'b1010;
    IN_B = 4'b0100;
    WAIT(2);

    IN_A = 4'b1010;
    IN_B = 4'b1001;
    WAIT(2);

    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(10);
    
    

    //ADD
    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(10);

    IN_INSTR = 4'b0101;
    IN_A = 4'b1000;
    IN_B = 4'b0010;
    WAIT(2);

    IN_A = 4'b1010;
    IN_B = 4'b0100;
    WAIT(2);

    IN_A = 4'b1010;
    IN_B = 4'b1011;
    WAIT(5);

    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(10);


    //RR
    IN_INSTR = 4'b0110;
    IN_A = 4'b1100;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    WAIT(2);
    IN_A = 4'b0011;
    WAIT(5);

    //RL
    IN_INSTR = 4'b0111;
    IN_A = 4'b1100;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b1010;
    WAIT(2);
    IN_A = 4'b0011;
    WAIT(5);


    //DEC
    IN_INSTR = 4'b1000;
    WAIT(1);
    IN_A = 4'b0100;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b0101;
    WAIT(2);
    IN_A = 4'b0111;
    WAIT(2);
    IN_A = 4'b0001;
    WAIT(5);
    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    WAIT(10);

    
    //INC
    IN_INSTR = 4'b1001;
    IN_A = 4'b0000;
    IN_B = 4'b0000;
    WAIT(2);
    IN_A = 4'b0001;
    WAIT(2);
    IN_A = 4'b1010;
    WAIT(5);
    IN_INSTR = 4'b0000;
    IN_A = 4'b0000;
    WAIT(10);

    
    //LD
    IN_INSTR = 4'b1010;
    IN_A = 4'b0000;
    
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