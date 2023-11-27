`timescale 1ns/100ps

module cpu_mreg_tb;

reg CLK, RST;
reg EN_C, EN_B; 
reg Cin;
reg Zin;
reg Bin;

wire C; //Carry
wire Z; //Zero
wire B; //Borrow


cpu_mreg UUT(
    .CLK(CLK),
    .RST(RST),
    .EN_C(EN_C),
    .EN_B(EN_B),
    .Cin(Cin),
    .Zin(Zin),
    .Bin(Bin),
    .C(C),
    .Z(Z),
    .B(B)
);


initial begin
    $display("Simulation of %m started.");
    RST = 1'b0;
    EN_C = 1'b0;
    EN_B = 1'b0;
    Cin = 1'b0;
    Zin = 1'b0;
    Bin = 1'b0;
    WAIT(1);
    EN_C = 1'b1;
    EN_B = 1'b1;
    WAIT(1);
    EN_C = 1'b0;
    EN_B = 1'b0;
    WAIT(5);

    Zin = 1'b1;
    WAIT(2);
    Zin = 1'b0;
    WAIT(5);

    Cin = 1'b1;
    WAIT(1);
    EN_C = 1'b1;
    WAIT(5);

    Bin = 1'b1;
    WAIT(1);
    EN_B = 1'b1;
    WAIT(5);

    RST = 1'b1;
    
    WAIT(200);
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