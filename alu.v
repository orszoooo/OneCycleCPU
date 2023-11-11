`timescale 1ns/100ps

module alu #(
    parameter IWIDTH = 4,
    parameter DWIDTH = 4
)(
    IN_INSTR,
    IN_A,
    IN_B,
    OUT
);

input [IWIDTH-1:0] IN_INSTR;
input [DWIDTH-1:0] IN_A;
input [DWIDTH-1:0] IN_B;

output reg [DWIDTH-1:0] OUT;

wire [DWIDTH-1:0] OUT_ADD_SUB;

reg [DWIDTH-1:0] IN_B_ADD_SUB;
reg EN_ADD, EN_SUB; 

alu_add #(
    .WIDTH(DWIDTH)
)
adder (
    .EN(EN_ADD),
    .IN_A(IN_A),
    .IN_B(IN_B_ADD_SUB),
    .IN_C(1'b0), //do zmiany pozniej
    .OUT(OUT_ADD_SUB),
    .C_OUT()
);

alu_sub #(
    .WIDTH(DWIDTH)
)
subtactor (
    .EN(EN_SUB),
    .IN_A(IN_A),
    .IN_B(IN_B_ADD_SUB),
    .IN_Bin(1'b0), //do zmiany pozniej
    .OUT(OUT_ADD_SUB),
    .B_OUT()
);

always @(*) begin
    EN_ADD = 1'b0;
    EN_SUB = 1'b0;
    IN_B_ADD_SUB = IN_B;

    case(IN_INSTR)
        4'b0000: begin  //NOT
            OUT = ~IN_A;
        end
        
        4'b0001: begin //XOR
            OUT = IN_A ^ IN_B;
        end
        
        4'b0010: begin //OR
            OUT = IN_A | IN_B;
        end
        4'b0011: begin //AND
            OUT = IN_A & IN_B;
        end
        
        4'b0100: begin //SUB - meh module
            EN_SUB = 1'b1;
            OUT = OUT_ADD_SUB;
        end
        
        4'b0101: begin //ADD
            EN_ADD = 1'b1;
            OUT = OUT_ADD_SUB;
        end
        
        4'b0110: begin //RR
            OUT = {1'b0,IN_A[DWIDTH-1:1]};
        end
        
        4'b0111: begin //RL
            OUT = {IN_A[DWIDTH-2:0],1'b0};
        end
        
        4'b1000: begin // DEC
            EN_SUB = 1'b1;
            IN_B_ADD_SUB = {{DWIDTH{1'b0}},1'b1}; 
            OUT = OUT_ADD_SUB;
        end

        4'b1001: begin //INC
            EN_ADD = 1'b1;
            IN_B_ADD_SUB = {{DWIDTH{1'b0}},1'b1}; 
            OUT = OUT_ADD_SUB;
        end

        default: begin //LD, ST, NOP, RST
            OUT = IN_B;
        end
    endcase
end

endmodule