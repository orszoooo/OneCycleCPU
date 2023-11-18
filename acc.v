`timescale 1ns/100ps

module acc #(
    parameter WIDTH = 8
)(  
    CLK,
    EN,
    IN,
    OUT
);

input CLK, EN;
input [WIDTH-1:0] IN;
output reg [WIDTH-1:0] OUT;

always @(posedge CLK) begin
    if(EN) begin
        OUT <= IN;
    end
    else begin
        OUT <= OUT;
    end
end

endmodule