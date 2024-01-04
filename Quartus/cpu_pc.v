module cpu_pc 
#( parameter WIDTH = 8)
(   CLK,
    RST,
    LD,
    ADDR,
    PC_OUT
);

input CLK, RST, LD;
input [WIDTH-1:0] ADDR;
output reg [WIDTH-1:0] PC_OUT;

initial begin
    PC_OUT <= {WIDTH{1'b0}};
end


always @(posedge CLK) begin
    if(RST) begin
        PC_OUT <= {WIDTH{1'b0}};
    end
    else if(LD) begin
        PC_OUT <= ADDR;
    end
    else begin
        PC_OUT <= PC_OUT + 1'b1;
    end

end
    
endmodule