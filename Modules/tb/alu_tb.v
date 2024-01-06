`timescale 1ns/100ps

module alu_tb;

reg CLK;
parameter WIDTH = 8;
parameter IWIDTH = 4;
reg [IWIDTH-1:0] INSTR;
reg [WIDTH-1:0] IN_A;
reg [WIDTH-1:0] IN_B;
reg ALU_C_IN, ALU_B_IN;
wire ALU_C_OUT, ALU_B_OUT;
wire [WIDTH-1:0] ALU_OUT;

alu #(
    .WIDTH(WIDTH),
    .IWIDTH(IWIDTH)
)
UUT (
    .instr(INSTR),
    .in_a(IN_A),
    .in_b(IN_B),
    .alu_c_in(ALU_C_IN),
    .alu_c_out(ALU_C_OUT),
    .alu_b_in(ALU_B_IN),
    .alu_b_out(ALU_B_OUT),
    .alu_out(ALU_OUT)
);

initial begin
    $display("Simulation of %m started.");
    
    //NOT
    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    ALU_C_IN = 1'b0;
    ALU_B_IN = 1'b0;
    WAIT(2);

    IN_A = 8'hEE;
    IN_B = 8'h45;
    WAIT(2);
    
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //XOR
    INSTR = 4'h1;
    IN_A = 8'h02;
    IN_B = 8'h0A;
    WAIT(2);

    IN_A = 8'hFF;
    IN_B = 8'hAA;
    WAIT(2);

    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //OR
    INSTR = 4'h2;
    IN_A = 8'h02;
    IN_B = 8'h0A;
    WAIT(2);

    IN_A = 8'hFF;
    IN_B = 8'hAA;
    WAIT(2);

    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //AND
    INSTR = 4'h3;
    IN_A = 8'h02;
    IN_B = 8'h0A;
    WAIT(2);

    IN_A = 8'hFF;
    IN_B = 8'hAA;
    WAIT(2);

    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //ADD
    INSTR = 4'h5;
    IN_A = 8'h04;
    IN_B = 8'h02;
    WAIT(2);

    IN_A = 8'h04;
    IN_B = 8'h02;
    ALU_C_IN = 1'b1;
    WAIT(2);

    IN_A = 8'h0A;
    IN_B = 8'h0B;
    WAIT(2);
    ALU_C_IN = 1'b0;
    WAIT(3);

    IN_A = 8'hFF;
    IN_B = 8'h01;
    WAIT(5);

    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //SUB
    INSTR = 4'h4;
    IN_A = 8'h04;
    IN_B = 8'h02;
    WAIT(2);

    IN_A = 8'h04;
    IN_B = 8'h02;
    ALU_B_IN = 1'b1;
    WAIT(2);

    IN_A = 8'h0A;
    IN_B = 8'h0B;
    WAIT(2);
    ALU_B_IN = 1'b0;
    WAIT(3);

    IN_A = 8'h03;
    IN_B = 8'h1F;
    ALU_B_IN = 1'b1;
    WAIT(2);
    
    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    ALU_B_IN = 1'b0;
    WAIT(5);

    //RR
    INSTR = 4'h6;
    IN_A = 8'h0A;
    WAIT(5);
        
    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);

    //RL
    INSTR = 4'h7;
    IN_A = 8'h0A;
    WAIT(5);
        
    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);  

    //DEC
    INSTR = 4'h8;
    IN_A = 8'h70;
    WAIT(5);

        
    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);
    

    //INC
    INSTR = 4'h9;
    IN_A = 8'h20;
    WAIT(5);

    INSTR = 4'h0;
    IN_A = 8'h00;
    IN_B = 8'h00;
    WAIT(5);
    
    INSTR = 4'hA;
    WAIT(10);
    IN_B = 8'h12;

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
	$dumpfile("./Output/alu_sim.vcd");
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