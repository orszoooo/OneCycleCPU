`timescale 1ns/100ps

module reg_f_tb;

reg CLK;
parameter W = 8;
parameter S = 9;
reg [W-1:0] IN;
reg EN;
reg [$clog2(S)-1:0] SEL;
wire [W-1:0] PORT;
reg [W-1:0] PORT_REG;
wire [W-1:0] PORT_RECV;
wire [W-1:0] OUT;
integer i;

reg_f #(
    .WIDTH(W),
    .SIZE(S)
) UUT (
    .CLK(CLK),
    .IN(IN),
    .EN(EN),
    .SEL(SEL),
    .PORT(PORT),
    .OUT(OUT)
);

assign PORT = PORT_REG;
assign PORT_RECV = PORT;

initial begin
    $display("Simulation of %m started.");
    IN = 8'hDE;
    EN = 1'b0;
    SEL = 4'h0; //R0
    PORT_REG = 8'hAC;
    WAIT(5);

    EN = 1'b1;
    WAIT(1);
    EN = 1'b0;
    WAIT(5);

    IN = 8'hAB;
    EN = 1'b1;
    SEL = 4'h3; //R3
    WAIT(1);
    EN = 1'b0;
    WAIT(5);   

    SEL = 4'h8; //PORT Read
    WAIT(5);   

    EN = 1'b1;
    IN = 8'hDC;
    PORT_REG = 8'hZZ;
    SEL = 4'hF; //PORT Write
    WAIT(1);
    EN = 1'b1;

    WAIT(5);  
    $display("PORT_RECV: %0h", PORT_RECV);
    $display("PORT: %0h", PORT);
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