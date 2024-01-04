`timescale 1ns/100ps

module pc
#( parameter WIDTH = 8)
(   clk,
    rst,
    ld,
    addr,
    pc_out
);

input clk, rst, ld;
input [WIDTH-1:0] addr;
output reg [WIDTH-1:0] pc_out;

initial begin
    pc_out <= {WIDTH{1'b0}};
end


always @(posedge clk) begin
    if(rst) begin
        pc_out <= {WIDTH{1'b0}};
    end
    else if(ld) begin
        pc_out <= addr;
    end
    else begin
        pc_out <= pc_out + 1'b1;
    end

end
    
endmodule