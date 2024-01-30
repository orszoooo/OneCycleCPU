`include "../instr_set.v"

class alu_acc_ref;
    localparam WIDTH = 8;
    localparam IWIDTH = 4;
    
    bit alu_c_out;
    bit alu_b_out;
    bit alu_flag_valid;
    bit [WIDTH-1:0] acc_out;
    bit [WIDTH-1:0] alu_out; 
    bit z_out; 

    function new;
        this.alu_c_out = 1'b0;
        this.alu_b_out = 1'b0;
        this.alu_flag_valid = 1'b0;
        this.acc_out = 8'h00;
        this.alu_out = 8'h00;
        this.z_out = 1'b1;
    endfunction

    task alu;
        input bit [IWIDTH-1:0] instr;
        input bit [WIDTH-1:0] in_a;
        input bit [WIDTH-1:0] in_b;
        input bit alu_c_in;
        input bit alu_b_in;
        input bit acc_en;

        case({{(WIDTH-IWIDTH){1'b0}}, instr}) //Padding MSBs with zeros
            `NOT: begin
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;    
                this.alu_out = ~in_a;
                this.alu_flag_valid = 1'b0;
            end
            `XOR: begin
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = in_a ^ in_b;
                this.alu_flag_valid = 1'b0;
            end
            `OR: begin
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = in_a | in_b;
                this.alu_flag_valid = 1'b0;
            end
            `AND: begin
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = in_a & in_b;
                this.alu_flag_valid = 1'b0;
            end
            `SUB: begin
                this.alu_c_out = 1'b0;  
                {this.alu_b_out, this.alu_out} = in_a - in_b - alu_b_in;
                this.alu_flag_valid = 1'b1;
            end
            `ADD: begin            
                this.alu_b_out = 1'b0;
                {this.alu_c_out, this.alu_out} = in_a + in_b + alu_c_in;
                this.alu_flag_valid = 1'b1;
            end
            `RR: begin 
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = {1'b0,in_a[WIDTH-1:1]};
                this.alu_flag_valid = 1'b0;
            end
            `RL: begin 
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = {in_a[WIDTH-2:0],1'b0};
                this.alu_flag_valid = 1'b0;
            end
            `DEC: begin 
                this.alu_c_out = 1'b0;  
                {this.alu_b_out, this.alu_out} = in_a - {{WIDTH{1'b0}},1'b1};
                this.alu_flag_valid = 1'b1;
            end
            `INC: begin 
                this.alu_b_out = 1'b0;
                {this.alu_c_out, this.alu_out} = in_a + {{WIDTH{1'b0}},1'b1};
                this.alu_flag_valid = 1'b1;
            end
            default: begin 
                this.alu_b_out = 1'b0;
                this.alu_c_out = 1'b0;  
                this.alu_out = in_b; //LD, ST, NOP, RST etc.
                this.alu_flag_valid = 1'b0;
            end
        endcase

        if((this.alu_out == {WIDTH{1'b0}} && acc_en) || (this.acc_out == {WIDTH{1'b0}}))
            this.z_out = 1'b1;
        else
            this.z_out = 1'b0;
    endtask

    task acc;
        input bit acc_en;

        if(acc_en) begin
            this.acc_out = this.alu_out;
        end
    endtask
endclass 