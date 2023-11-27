`timescale 1ns/100ps

module cpu_mreg (
    CLK,
    RST,
    EN_C,
    EN_B,
    Cin,
    Zin,
    Bin,
    C,
    Z,
    B
);

input CLK, RST;
input EN_C, EN_B; 
input Cin;
input Zin;
input Bin;

output reg C; //Carry
output reg Z; //Zero
output reg B; //Borrow

always @(posedge CLK, posedge RST, posedge Zin) begin
    if(RST) begin
        C <= 1'b0;
        Z <= 1'b0;
        B <= 1'b0;
    end
    else begin 
        C <= C;
        Z <= Zin;
        B <= B;

        if(EN_C) C <= Cin;
        if(EN_B) B <= Bin;
    end
end

endmodule