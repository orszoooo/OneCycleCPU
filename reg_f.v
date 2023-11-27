`timescale 1ns/100ps

module reg_f #(
    parameter WIDTH = 8,
    parameter SIZE = 9
)(
    CLK,
    IN,
    EN,
    SEL,
    PORT,
    OUT
);

input [WIDTH-1:0] IN;
inout [WIDTH-1:0] PORT;
input EN, CLK;
input [$clog2(SIZE)-1:0] SEL;
output [WIDTH-1:0] OUT;

reg [WIDTH-1:0] REG_FILE [SIZE:0];
reg PORT_EN = 1'b1;

assign PORT = (PORT_EN) ? IN : {WIDTH{1'bz}};

always@(posedge CLK) begin
    if(EN) begin
        if(SEL == {$clog2(SIZE){1'b1}}) begin //To write to PORT SEL == 4'b1111 {$clog2(SIZE){1'b1}
            PORT_EN <= 1'b1;
            REG_FILE[SIZE-1] <= IN;
        end
        REG_FILE[SEL] <= IN;
    end 
    else begin
        PORT_EN <= 1'b0;
        REG_FILE[SIZE-1] <= PORT; //To read PORT SEL == 4'b1000 - nineth reg
    end
end

assign OUT = REG_FILE[SEL];

endmodule 