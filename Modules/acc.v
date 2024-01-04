`timescale 1ns/100ps

module acc #(
    parameter WIDTH = 8
)(  
    CLK,
    EN,
    IN,
    OUT,
    Z
);

input CLK, EN;
input [WIDTH-1:0] IN;
output reg [WIDTH-1:0] OUT;
output reg Z;

always @(posedge CLK) begin
    if(EN) begin
        OUT <= IN;

        if(IN == {WIDTH{1'b0}}) begin
            Z <= 1'b1;
        end
        else begin
            Z <= 1'b0;
        end
    end
    else begin
        OUT <= OUT;
    end
end

endmodule