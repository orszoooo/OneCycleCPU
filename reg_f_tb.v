`timescale 1ns/100ps

module reg_f_tb;

reg CLK;
parameter W = 4;
parameter S = 8;
reg [W-1:0] IN;
reg EN, WR;
reg [$clog2(S)-1:0] SEL;
wire [W-1:0] OUT;
integer i;

reg_f #(
    .WIDTH(W),
    .SIZE(S)
) UUT (
    .IN(IN),
    .EN(EN),
    .WR(WR),
    .CLK(CLK),
    .SEL(SEL),
    .OUT(OUT)
);

initial begin
    $display("Simulation of %m started.");
    IN = 4'b0001;
    EN = 1'b0;
    WR = 1'b0;
    SEL = 3'b000;
    WAIT(5);

    EN = 1'b1;
    WAIT(5);
    WR = 1'b1;
    for(i = 0; i < S-1; i++) begin
        SEL = SEL + 3'd1;
        IN = IN + 4'd1;
        WAIT(5);
    end

    SEL = 3'b000;
    IN = 4'b0000;
    EN = 1'b1;
    WR = 1'b0;
    WAIT(20);

    for(i = 0; i < S; i++) begin
        SEL = SEL + 4'd1;
        WAIT(5);
    end

    WAIT(10);   

    SEL = 3'b000;
    IN = 4'b0000;
    EN = 1'b0;
    WR = 1'b0;
    WAIT(20);

    for(i = 0; i < S; i++) begin
        SEL = SEL + 3'd1;
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