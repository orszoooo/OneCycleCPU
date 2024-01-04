`timescale 1ns/100ps
`include "instr_set.v"

module ROM # (
    parameter AWIDTH = 8,
    parameter DWIDTH = 13
)(
    ADDR,
    DATA
);
input [AWIDTH-1:0] ADDR;
output reg [DWIDTH-1:0] DATA;

always @(*) begin
    /*
    case(ADDR) 
        8'h00: DATA = {`LD,8'hAE};
        8'h01: DATA = {`RL,8'h00};
        8'h02: DATA = {`ST,8'hAE};
        8'h03: DATA = {`LDR,8'h04};
        8'h04: DATA = {`INC,8'h00};
        8'h05: DATA = {`STR,8'h02};
        8'h06: DATA = {`LDI,8'h11};
        8'h07: DATA = {`ADDR,8'h01};
        8'h08: DATA = {`STR,8'h01};
        8'h09: DATA = {`BAR,8'h09};
        8'h0A: DATA = {`JMPO, 8'h03};
        8'h0B: DATA = {`RST,8'h00};
        8'h0C: DATA = {`JMP,8'h0E};
        8'h0D: DATA = {`CALL,8'h11};
        8'h0E: DATA = {`JMP,8'h0D};
        8'h0F: DATA = {`NOP,8'h00};
        8'h10: DATA = {`NOP,8'h00};
        8'h11: DATA = {`LD,8'hEF};
        8'h12: DATA = {`RR,8'h00};
        8'h13: DATA = {`ST,8'hA1};
        8'h14: DATA = {`RET,8'h00};
        default: DATA = `RST;
    endcase
    */
    case(ADDR) 
        8'h01: DATA = {`LDI,8'h69};
        8'h02: DATA = {`ST,8'h00};
        8'h03: DATA = {`LDI,8'h11};
        8'h04: DATA = {`STR,8'h03};
        8'h05: DATA = {`LDR,8'h03};
        8'h06: DATA = {`ADD,8'h00};
        8'h07: DATA = {`LDI,8'h32};
        8'h08: DATA = {`STR,8'h01};
        8'h09: DATA = {`LDR,8'h03};
        8'h0A: DATA = {`ADDR,8'h01};
        8'h0B: DATA = {`LD,8'h00};
        8'h0C: DATA = {`SUBR,8'h03};
        8'h0D: DATA = {`DEC,8'h00};
        8'h0E: DATA = {`ADD,8'h00};
        8'h0F: DATA = {`INC,8'h00};
        8'h10: DATA = {`INC,8'h00};
        8'h11: DATA = {`LDI,8'h00};
        8'h12: DATA = {`JZ, 8'h15};
        8'h15: DATA = {`LDI,8'hFF};
        8'h16: DATA = {`INC,8'h00};
        8'h17: DATA = {`ADD,8'h00};
        default: DATA = {`NOP,8'h00};
    endcase
end

endmodule