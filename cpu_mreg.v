`timescale 1ns/100ps

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

//Reset
always @(RST) begin
    C <= 1'b0;
    Z <= 1'b0;
    B <= 1'b0;
end

//Zero
always @(Zin) begin
    Z <= Zin;
end

//Set C
always @(Cin) begin
    if(Cin || C_LAST) begin
        C = 1'b1; 
    end
    else begin
        C = 1'b0;
    end
end

//Set B
always @(Bin) begin
    if(Bin || B_LAST) begin
        B = 1'b1; 
    end
    else begin
        B = 1'b0;
    end
end

//Reset C/B
always @(posedge CLK) begin
    if(!Cin && C_LAST) begin
        C <= 1'b0; 
    end
    C_LAST <= Cin;

    if(!Bin && B_LAST) begin
        B <= 1'b0; 
    end
    B_LAST <= Bin;
end

endmodule