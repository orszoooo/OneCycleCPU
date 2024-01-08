`timescale 1ns/100ps

module main_visual #(
    parameter PORT_WIDTH = 10,
    parameter DISP_WIDTH = 7
)
(
    clk,
    port_sw,

    pc_led,
    instr_disp,
    arg_disp,
    acc_disp,
);

input clk;
input [PORT_WIDTH-1:0] port_sw;

output [PORT_WIDTH-1:0] pc_led;
output [DISP_WIDTH-1:0] instr_disp;
output [DISP_WIDTH-1:0] arg_disp;
output [DISP_WIDTH-1:0] acc_disp;

wire [DISP_WIDTH-1:0] instr_hex;
wire [DISP_WIDTH-1:0] arg_hex;
wire [DISP_WIDTH-1:0] acc_hex;

main main_module(
    .clk(clk),
    .port(port_sw),

    .pc(pc_led),
    .instr(instr_hex),
    .arg(arg_hex),
    .acc(acc_hex)
);

led_disp instr_disp(
    .in(instr_hex),
    .out(instr_disp)
);

led_disp arg_disp(
    .in(arg_hex),
    .out(arg_disp)
);

led_disp acc_disp(
    .in(acc_hex),
    .out(acc_disp)
);

endmodule