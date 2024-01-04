module cpu_lr #(
    parameter WIDTH = 8
) (
    CLK,
    LR_LD,
    LR_DATA,
    LR_OUT
);  

input CLK, LR_LD;
input [WIDTH-1:0] LR_DATA;
output reg [WIDTH-1:0] LR_OUT;

reg [WIDTH-1:0] LR_REG;

always @(posedge CLK) begin
    if(LR_LD) begin
        LR_REG = LR_DATA;
    end
    LR_OUT = LR_REG;
end

endmodule