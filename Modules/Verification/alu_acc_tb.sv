`timescale 1ns/1ps
`include "../alu.v"
`include "../acc.v"
`include "alu_acc_ref.sv"

class transaction;
    //ALU
    rand bit [3:0]  alu_instr;  
    rand bit [7:0]  alu_in_a;  
    rand bit [7:0]  alu_in_b;
    rand bit        alu_c_in;
    rand bit        alu_b_in;   
    rand bit        alu_c_out;
    rand bit        alu_b_out;
    rand bit        alu_flag_valid;       
    rand bit [7:0]  alu_out;
    //ACC
    rand bit        acc_en;
    rand bit [7:0]  acc_in;
    rand bit [7:0]  acc_out;
    rand bit        acc_z_out;

    //constraint alu_instr_constr { alu_instr <= 4'h2; }; 

endclass

class generator;
    rand transaction trans;
    mailbox gen_mbx;
    event trans_rdy;
    int  repeat_tests;  
    
    //constructor
    function new(mailbox gen_mbx,event trans_rdy);
        this.gen_mbx = gen_mbx;
        this.trans_rdy = trans_rdy;
    endfunction
    
    task main();
        repeat(repeat_tests) begin
            trans = new();
            trans.randomize();    
            gen_mbx.put(trans);
        end
    -> trans_rdy; 
    endtask  
endclass

interface alu_acc_intf(input logic clk, reset, clr);
    logic [3:0]  alu_instr;  
    logic [7:0]  alu_in_a;  
    logic [7:0]  alu_in_b;
    logic        alu_c_in;
    logic        alu_b_in;   
    logic        alu_c_out;
    logic        alu_b_out;
    logic        alu_flag_valid;       
    logic [7:0]  alu_out;
    logic        acc_en;
    logic [7:0]  acc_in;
    logic [7:0]  acc_out;
    logic        acc_z_out;
    
    //driver clocking block
    clocking driver_clk_block @(posedge clk);
        default input #1 output #1;
        output  alu_instr;  
        output  alu_in_a;  
        output  alu_in_b;
        output  alu_c_in;
        output  alu_b_in;   
        input   alu_c_out;
        input   alu_b_out;
        input   alu_flag_valid;       
        input   alu_out;
        output  acc_en;
        output  acc_in;
        input   acc_out;
        input   acc_z_out;
    endclocking
    
    //monitor clocking block
    clocking monitor_clk_block @(posedge clk);
        default input #1 output #1;
        input   alu_instr;  
        input   alu_in_a;  
        input   alu_in_b;
        input   alu_c_in;
        input   alu_b_in;   
        input   alu_c_out;
        input   alu_b_out;
        input   alu_flag_valid;       
        input   alu_out;
        input   acc_en;
        input   acc_in;
        input   acc_out;
        input   acc_z_out; 
  endclocking
  
  //driver modport
  modport driver_mode  (clocking driver_clk_block, input clk, reset, clr);
  
  //monitor modport  
  modport monitor_mode (clocking monitor_clk_block, input clk, reset, clr);
  endinterface

class driver;
  int trans_cnt; //number of transactions
  virtual alu_acc_intf alu_acc_virt_intf;
  mailbox drv_mbx;
    
  //constructor
  function new(virtual alu_acc_intf alu_acc_virt_intf, mailbox drv_mbx);
    this.alu_acc_virt_intf = alu_acc_virt_intf;
    this.drv_mbx = new();
    this.drv_mbx = drv_mbx;
  endfunction
  
  
  //Reset task
  task reset;
    wait(alu_acc_virt_intf.reset);
    $display("[DRIVER] reset started");
    alu_acc_virt_intf.driver_mode.driver_clk_block.alu_instr <= 4'h0;
    alu_acc_virt_intf.driver_mode.driver_clk_block.alu_in_a <= 8'h00;
    alu_acc_virt_intf.driver_mode.driver_clk_block.alu_in_b  <= 8'h00;
    alu_acc_virt_intf.driver_mode.driver_clk_block.alu_c_in <= 1'b0;
    alu_acc_virt_intf.driver_mode.driver_clk_block.alu_b_in <= 1'b0;    
    alu_acc_virt_intf.driver_mode.driver_clk_block.acc_en <= 1'b0;
    alu_acc_virt_intf.driver_mode.driver_clk_block.acc_in <= 8'h00;
    wait(!alu_acc_virt_intf.reset);
    $display("[DRIVER] reset finished");
  endtask
  
  task main;
    forever
    begin
        transaction trans;

        drv_mbx.get(trans);
        $display("[DRIVER] transfer: %0d", trans_cnt);
        
        @(posedge alu_acc_virt_intf.driver_mode.clk);
        alu_acc_virt_intf.driver_mode.driver_clk_block.alu_instr <= trans.alu_instr;
        alu_acc_virt_intf.driver_mode.driver_clk_block.alu_in_a <= trans.alu_in_a;
        alu_acc_virt_intf.driver_mode.driver_clk_block.alu_in_b  <= trans.alu_in_b;
        alu_acc_virt_intf.driver_mode.driver_clk_block.alu_c_in <= trans.alu_c_in;
        alu_acc_virt_intf.driver_mode.driver_clk_block.alu_b_in <= trans.alu_b_in;    
        alu_acc_virt_intf.driver_mode.driver_clk_block.acc_en <= trans.acc_en;
        alu_acc_virt_intf.driver_mode.driver_clk_block.acc_in <= trans.acc_in;
                
        trans_cnt++;
    end
  endtask
         
endclass


class monitor;
    virtual alu_acc_intf alu_acc_virt_intf;
    mailbox mon_mbx;
    
    //constructor
    function new(virtual alu_acc_intf alu_acc_virt_intf, mailbox mon_mbx);
        this.alu_acc_virt_intf = alu_acc_virt_intf;
        this.mon_mbx = mon_mbx;
    endfunction
    
    task main;
    forever
    begin
        transaction trans;
        trans = new();

        @(posedge alu_acc_virt_intf.monitor_mode.clk);
        
        wait(alu_acc_virt_intf.monitor_mode.monitor_clk_block.acc_en);

        trans.alu_instr = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_instr; 
        trans.alu_in_a = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_in_a;
        trans.alu_in_b = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_in_b;
        trans.alu_c_in = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_c_in;
        trans.alu_b_in = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_b_in;  
        trans.alu_c_out = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_c_out;  
        trans.alu_b_out = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_b_out;
        trans.alu_flag_valid = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_flag_valid;
        trans.alu_out = alu_acc_virt_intf.monitor_mode.monitor_clk_block.alu_out;
        trans.acc_en = alu_acc_virt_intf.monitor_mode.monitor_clk_block.acc_en;
        trans.acc_in = alu_acc_virt_intf.monitor_mode.monitor_clk_block.acc_in;
        trans.acc_z_out = alu_acc_virt_intf.monitor_mode.monitor_clk_block.acc_z_out;

        @(posedge alu_acc_virt_intf.monitor_mode.clk); 
        trans.acc_out = alu_acc_virt_intf.monitor_mode.monitor_clk_block.acc_out;  

        mon_mbx.put(trans);
    end
    endtask
  
endclass

class scoreboard; 
    mailbox mon_mbx;
    alu_acc_ref ref_model;
    int trans_cnt;

  //constructor
  function new(mailbox mon_mbx);
    this.mon_mbx = mon_mbx;
    this.ref_model = new();
    trans_cnt = 0;
  endfunction

    task main;
        transaction trans;

        forever begin
            #50
            mon_mbx.get(trans);

            ref_model.alu(
                .instr(trans.alu_instr),
                .in_a(trans.alu_in_a),
                .in_b(trans.alu_in_b),
                .alu_c_in(trans.alu_c_in),
                .alu_b_in(trans.alu_b_in),
                .acc_en(trans.acc_en)
            );

            ref_model.acc(
                .acc_en(trans.acc_en)
            );

            if(ref_model.alu_out != trans.alu_out)
                $error("[SCOREBOARD] Transfer %0d ALU_OUT Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.alu_out,trans.alu_out);
            
            if(ref_model.acc_out != trans.acc_out) 
                $error("[SCOREBOARD] Transfer %0d ACC_OUT Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.acc_out,trans.acc_out);
            
            if(ref_model.alu_c_out != trans.alu_c_out)
                $error("[SCOREBOARD] Transfer %0d ALU_C_OUT Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.alu_c_out,trans.alu_c_out);
            
            if(ref_model.alu_b_out != trans.alu_b_out)
                $error("[SCOREBOARD] Transfer %0d ALU_B_OUT Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.alu_b_out,trans.alu_b_out);

            if(ref_model.alu_flag_valid != trans.alu_flag_valid)
                $error("[SCOREBOARD] Transfer %0d ALU_FLAG_VALID Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.alu_flag_valid,trans.alu_flag_valid);
            
            if(ref_model.z_out != trans.acc_z_out)
                $error("[SCOREBOARD] Transfer %0d Z_OUT Data Expected = %0h Data Actual = %0h",trans_cnt,ref_model.z_out,trans.acc_z_out);
            trans_cnt++;
        end
    endtask
endclass

class environment;
    generator gen;
    driver    driv;
    monitor   mon;
    scoreboard scb;
    mailbox   env_mbx_drv;
    mailbox   env_mbx_mon;
    event gen_ended;
    virtual alu_acc_intf alu_acc_virt_intf;
    
    //constructor
    function new(virtual alu_acc_intf alu_acc_virt_intf);
        this.alu_acc_virt_intf = alu_acc_virt_intf;
        env_mbx_drv = new();
        env_mbx_mon = new();
        gen = new(env_mbx_drv,gen_ended);
        driv = new(alu_acc_virt_intf,env_mbx_drv);
        mon  = new(alu_acc_virt_intf,env_mbx_mon);
        scb  = new(env_mbx_mon);
    endfunction

    task pre_test();
        driv.reset();
    endtask
    
    task test();
        fork 
        gen.main();
        driv.main();
        mon.main();
        scb.main();
        join_any
    endtask
    
    task post_test();
        wait(gen_ended.triggered);
        wait(gen.repeat_tests == driv.trans_cnt);
        wait(gen.repeat_tests == scb.trans_cnt);
    endtask  
    
    //run task
    task run;
        pre_test();
        test();
        post_test();
        $stop;
    endtask
  
endclass

program test(alu_acc_intf intf);
    environment env;
    
    initial 
    begin
        env = new(intf);
        env.gen.repeat_tests = 64;
        env.run();
    end
endprogram

module alu_acc_tb;
    bit clk;
    bit reset;
    bit clr;
    
    wire [7:0] alu_to_acc;

    //clock generation
    always #5 clk = ~clk;
    
    initial
    begin
        clr = 1;
        reset = 0;
        #5 reset = 1;
        #5 reset = 0;
    end
    
    //interface
    alu_acc_intf intf(clk, reset, clr);
    
    //testcase
    test test1(intf);
    
    //DUT
    alu alu_dut( 
        .instr(intf.alu_instr),
        .in_a(intf.alu_in_a),
        .in_b(intf.alu_in_b),
        .alu_c_in(intf.alu_c_in),
        .alu_b_in(intf.alu_b_in),
        .alu_c_out(intf.alu_c_out),
        .alu_b_out(intf.alu_b_out),
        .alu_flag_valid(intf.alu_flag_valid),
        .alu_out(alu_to_acc)
    );

    assign intf.alu_out = alu_to_acc;
    assign intf.acc_in = alu_to_acc;

    acc acc_dut(
        .clk(clk),
        .en(intf.acc_en),
        .in(alu_to_acc),
        .out(intf.acc_out),
        .z_out(intf.acc_z_out)
    );
    
    //enabling the wave dump
    initial
    begin 
        $dumpfile("alu_acc.vcd"); $dumpvars;
    end

endmodule