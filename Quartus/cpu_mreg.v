module cpu_mreg (
    CLK,
    RST,
    Cin,
    Zin,
    Bin,
    C,
    Z,
    B
);

input CLK, RST;
input Cin, Zin, Bin;

output reg C; //Carry
output reg Z; //Zero
output reg B; //Borrow

reg C_LAST = 1'b0;
reg B_LAST = 1'b0;

always @(*) begin
	if(RST) begin
		C = 1'b0;
		Z = 1'b0;
		B = 1'b0;
	end
	else begin
		if(Zin) Z = Zin;
		
		if(Cin || C_LAST) begin
        C = 1'b1; 
		end
		else begin
			  C = 1'b0;
		end
		
	   if(Bin || B_LAST) begin
        B = 1'b1; 
      end
      else begin
        B = 1'b0;
      end
	end
	
	@(posedge CLK) begin
	   if(!Cin && C_LAST) begin
        C <= 1'b0; 
		end
		C_LAST <= Cin;

		if(!Bin && B_LAST) begin
        B <= 1'b0; 
		end
		B_LAST <= Bin;
	end
end

endmodule