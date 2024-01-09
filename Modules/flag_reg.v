`timescale 1ns/100ps

module flag_reg (
    clk,
    flag_rst,
    flag_cb_valid,
    flag_c_in,
    flag_z_in,
    flag_b_in, 
    flag_c,
    flag_z,
    flag_b
);

input clk, flag_rst, flag_cb_valid, flag_c_in, flag_z_in, flag_b_in;

output reg flag_c; //Carry
output reg flag_z; //Zero
output reg flag_b; //Borrow

initial begin
    flag_c = 1'b0;
    flag_z = 1'b0;
    flag_b = 1'b0;
end

always @(posedge clk) begin
    if(flag_rst) begin
        flag_c <= 1'b0;
        flag_z <= 1'b0;
        flag_b <= 1'b0;
    end
    else begin 
        if(flag_cb_valid) begin
            flag_c <= flag_c_in;
            flag_b <= flag_b_in;
        end
        flag_z <= flag_z_in;
    end
end

always @(negedge clk) begin
    flag_z <= flag_z_in;
end

endmodule