`include "instr_set.v"

module rom # (
    parameter AWIDTH = 8,
    parameter DWIDTH = 13
)(
    ADDR,
    DATA
);
input [AWIDTH-1:0] ADDR;
output reg [DWIDTH-1:0] DATA;

always @(*) begin
    case(ADDR) 
        8'h00: DATA = {`LDI,8'h08};
        8'h01: DATA = {`STR,8'h0F};
        8'h02: DATA = {`LDI,8'h02};
        8'h03: DATA = {`ADDR,8'h08};
        8'h04: DATA = {`STR,8'h0F};
        8'h05: DATA = {`LDI,8'hAE};
        8'h06: DATA = {`ADDR,8'h08};
        8'h07: DATA = {`STR,8'h0F};
        default: DATA = {`RST,8'h00};
    endcase
end

endmodule