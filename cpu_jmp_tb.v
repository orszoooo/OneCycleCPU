`timescale 1ns/100ps

module cpu_jmp_tb;
parameter WIDTH = 8;
reg CLK, JMP_MODE;
reg [WIDTH-1:0] BASE_REG_OFFSET;
reg BASE_REG_LD;
reg [WIDTH-1:0] BASE_REG_DATA;
wire [WIDTH-1:0] ADDRESS_OUT;

cpu_jmp #(.WIDTH(WIDTH))
UUT (
    .JMP_MODE(JMP_MODE),
    .BASE_REG_OFFSET(BASE_REG_OFFSET),
    .BASE_REG_LD(BASE_REG_LD),
    .BASE_REG_DATA(BASE_REG_DATA),
    .ADDRESS_OUT(ADDRESS_OUT)
);

initial begin
    $display("Simulation of %m started.");
    JMP_MODE = 1'b0;
    BASE_REG_OFFSET = 8'h00;
    BASE_REG_LD = 1'b0;
    BASE_REG_DATA = 8'h00;
    WAIT(2);

    BASE_REG_OFFSET = 8'hA7;
    WAIT(2);

    BASE_REG_OFFSET = 8'h12;
    WAIT(2);

    BASE_REG_OFFSET = 8'h00;    
    BASE_REG_LD = 1'b1;
    BASE_REG_DATA = 8'h0A;
    WAIT(2);
    
    BASE_REG_LD = 1'b0;
    BASE_REG_DATA = 8'h00;
    WAIT(2);

    JMP_MODE = 1'b1;
    BASE_REG_OFFSET = 8'hA7;
    WAIT(2);

    BASE_REG_OFFSET = 8'h12;
    WAIT(2);

    JMP_MODE = 1'b0;

    WAIT(20);
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