`timescale 1ns/100ps

module alu #(
    parameter DWIDTH = 8
)(
    IN_INSTR,
    IN_A,
    IN_B,
    EN_C,
    EN_B,
    Cin,
    Cout,
    Bin,
    Bout,
    OUT
);

parameter IWIDTH = 4;
input [IWIDTH-1:0] IN_INSTR;
input [DWIDTH-1:0] IN_A;
input [DWIDTH-1:0] IN_B;
input Cin;
input Bin;

output reg EN_C;
output reg EN_B;
output Cout;
output Bout;
output reg [DWIDTH-1:0] OUT;

reg [DWIDTH-1:0] IN_ADD_SUB;
reg EN_ADD_nSUB;
wire [DWIDTH-1:0] OUT_ADD;
wire [DWIDTH-1:0] OUT_SUB;
wire [DWIDTH-1:0] OUT_ADD_SUB;

alu_add #(
    .WIDTH(DWIDTH)
)
adder (
    .IN_A(IN_A),
    .IN_B(IN_ADD_SUB),
    .IN_C(Cin), 
    .OUT(OUT_ADD),
    .C_OUT(Cout)
);

alu_sub #(
    .WIDTH(DWIDTH)
)
subtactor (
    .IN_A(IN_A),
    .IN_B(IN_ADD_SUB),
    .IN_Bin(Bin), 
    .OUT(OUT_SUB),
    .B_OUT(Bout)
);

assign OUT_ADD_SUB = (EN_ADD_nSUB ? OUT_ADD : OUT_SUB);

always @(*) begin
    EN_C = 1'b0;
    EN_B = 1'b0;
    EN_ADD_nSUB = 1'b1; //uses ADDER
    IN_ADD_SUB = IN_B;

    case(IN_INSTR)
        4'h0: begin  //NOT
            OUT = ~IN_A;
        end
        
        4'h1: begin //XOR
            OUT = IN_A ^ IN_B;
        end
        
        4'h2: begin //OR
            OUT = IN_A | IN_B;
        end
        4'h3: begin //AND
            OUT = IN_A & IN_B;
        end
        
        4'h4: begin //SUB 
            EN_B = 1'b1;
            EN_ADD_nSUB = 1'b0;
            OUT = OUT_ADD_SUB;
        end
        
        4'h5: begin //ADD
            EN_C = 1'b1;
            OUT = OUT_ADD_SUB;
        end
        
        4'h6: begin //RR
            OUT = {1'b0,IN_A[DWIDTH-1:1]};
        end
        
        4'h7: begin //RL
            OUT = {IN_A[DWIDTH-2:0],1'b0};
        end
        
        4'h8: begin // DEC
            EN_B = 1'b1;
            EN_ADD_nSUB = 1'b0;
            IN_ADD_SUB = {{DWIDTH{1'b0}},1'b1}; 
            OUT = OUT_ADD_SUB;
        end

        4'h9: begin //INC
            EN_C = 1'b1;
            IN_ADD_SUB = {{DWIDTH{1'b0}},1'b1}; 
            OUT = OUT_ADD_SUB;
        end
        default: begin //LD, ST, NOP, RST
            OUT = IN_B;
        end
    endcase
end

endmodule