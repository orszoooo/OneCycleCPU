`timescale 1ns/100ps

module data_mem_tb;

parameter WIDTH = 8;
reg CLK, EN, WR, RD;
reg [WIDTH-1:0] ADDR;
reg [WIDTH-1:0] D_IN;
wire [WIDTH-1:0] D_OUT;
integer i;

data_mem #(
    .WIDTH(WIDTH)
) UUT (
    .clk(CLK),
    .en(EN),
    .addr(ADDR),
    .d_in(D_IN),
    .d_out(D_OUT)
);

initial begin
    $display("Simulation of %m started.");
    ADDR = 8'h00;
    D_IN = 8'h00;
    EN = 1'b1;
    WAIT(5);

    for(i = 0; i < $pow(2,WIDTH)-1; i++) begin
        ADDR = ADDR + 8'h01;
        D_IN = D_IN + 8'h05;
        WAIT(5);
    end

    ADDR = 8'h00;
    D_IN = 8'h00;
    EN = 1'b0;
    WAIT(20);

    for(i = 0; i < $pow(2,WIDTH)-1; i++) begin
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
	$dumpfile("./Output/data_mem_sim.vcd");
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