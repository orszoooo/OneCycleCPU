module alu_add #(
    parameter WIDTH = 8
) (
    EN,
    IN_A,
    IN_B,
    IN_C,
    OUT,
    C_OUT
);

input EN;
input [WIDTH-1:0] IN_A;
input [WIDTH-1:0] IN_B;
input IN_C;
output reg [WIDTH-1:0] OUT;
output reg C_OUT;

always @(*) begin
    if(EN) begin
		{C_OUT, OUT} = IN_A + IN_B + IN_C;
	 end
	 else begin
		{C_OUT, OUT} = {1'b0, {WIDTH{1'b0}}};
	 end
end

endmodule