`timescale 1ns/100ps

module main_visual #(
    parameter WIDTH = 8,
    parameter DISP_WIDTH = 7
)
(
    clk,
    port_sw,

    pc_led,
    instr_disp1,
    instr_disp2,
    arg_disp1,
    arg_disp2,    
    acc_disp1,
    acc_disp2
);

input clk;
input [WIDTH-1:0] port_sw;

output [WIDTH-1:0] pc_led;
output [DISP_WIDTH-1:0] instr_disp1;
output [DISP_WIDTH-1:0] instr_disp2;
output [DISP_WIDTH-1:0] arg_disp1;
output [DISP_WIDTH-1:0] arg_disp2;
output [DISP_WIDTH-1:0] acc_disp1;
output [DISP_WIDTH-1:0] acc_disp2;

wire [WIDTH-1:0] instr_hex;
wire [WIDTH-1:0] arg_hex;
wire [WIDTH-1:0] acc_hex;

main main_module(
    .clk(clk),
    .port(port_sw),
    .pc(pc_led),
    .instr(instr_hex),
    .arg(arg_hex),
    .acc(acc_hex)
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

endmodule