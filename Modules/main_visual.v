`timescale 1ns/100ps

module main_visual #(
    parameter WIDTH = 8,
    parameter DISP_WIDTH = 7
)
(
    clk,
    clk_en,
    port_sw,

    pc_led,
    instr_disp1,
    instr_disp2,
    arg_disp1,
    arg_disp2,    
    acc_disp1,
    acc_disp2,
    clk_sig
);

input clk;
input clk_en;
input [WIDTH-1:0] port_sw;

output [WIDTH-1:0] pc_led;
output [DISP_WIDTH-1:0] instr_disp1;
output [DISP_WIDTH-1:0] instr_disp2;
output [DISP_WIDTH-1:0] arg_disp1;
output [DISP_WIDTH-1:0] arg_disp2;
output [DISP_WIDTH-1:0] acc_disp1;
output [DISP_WIDTH-1:0] acc_disp2;
output clk_sig;

wire [WIDTH-1:0] instr_hex;
wire [WIDTH-1:0] arg_hex;
wire [WIDTH-1:0] acc_hex;
wire [WIDTH-1:0] in_b_hex;
wire clk_1Hz;

clk_div clk1Hz( //50 MHz to 1Hz
    .en(clk_en),
    .clk_in(clk),
    .clk_out(clk_1Hz)
);

main main_module(
    .clk(clk_1Hz),
    .port(port_sw),
    .pc(pc_led),
    .instr(instr_hex),
    .arg(arg_hex),
    .acc(acc_hex),
	.in_b_dbg(in_b_hex)
);

led_disp instr_7seg1(
    .in(instr_hex[7:4]),
    .out(instr_disp1)
);

led_disp instr_7seg2(
    .in(instr_hex[3:0]),
    .out(instr_disp2)
);

led_disp arg_7seg1(
    .in(arg_hex[7:4]),
    .out(arg_disp1)
);

led_disp arg_7seg2(
    .in(arg_hex[3:0]),
    .out(arg_disp2)
);

led_disp acc_7seg1(
    .in(acc_hex[7:4]),
    .out(acc_disp1)
);

led_disp acc_7seg2(
    .in(acc_hex[3:0]),
    .out(acc_disp2)
);

assign clk_sig = clk_1Hz;

endmodule