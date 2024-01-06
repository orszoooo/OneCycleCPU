`timescale 1ns/100ps

module reg_f #(
    parameter WIDTH = 8,
    parameter SIZE = 9
)(
    clk,
    in,
    en,
    sel,
    port,
    out
);

input [WIDTH-1:0] in;
inout [WIDTH-1:0] port;
input en, clk;
input [$clog2(SIZE)-1:0] sel;
output [WIDTH-1:0] out;

reg [WIDTH-1:0] REG_FILE [SIZE:0];
reg PORT_EN = 1'b1;
integer i = 0;

initial begin
    for(i=0;i<SIZE;i++) begin
        REG_FILE[i] = {WIDTH{1'b0}};
    end
end

assign port = (PORT_EN) ? in : {WIDTH{1'bz}};

always@(posedge clk) begin
    if(en) begin
        if(sel == {$clog2(SIZE){1'b1}}) begin //To write to port sel == 4'b1111 {$clog2(SIZE){1'b1}
            PORT_EN <= 1'b1;
            REG_FILE[SIZE-1] <= in;
        end
        REG_FILE[sel] <= in;
    end 
    else begin
        PORT_EN <= 1'b0;
        REG_FILE[SIZE-1] <= port; //To read port sel == 4'b1000 - nineth reg
    end
end

assign out = REG_FILE[sel];

endmodule 