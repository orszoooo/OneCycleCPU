#!/bin/bash
rm -f ./Output/$1_sim.vcd

modules_dir="../Modules"
modules_list=""

if [ "$#" -eq 0 ]; then
    echo "Provide name of module you want to simulate i.e. ./simul.sh main or ./simul.sh pc"
    exit 1
fi


if [ "$1" = "main" ]; then
    modules_input="main pc rom id jmp lr reg_f data_mem alu acc flag_reg"
elif [ "$1" = "main_visual" ]; then
    modules_input="main_visual led_disp main pc rom id jmp lr reg_f data_mem alu acc flag_reg"
elif [ "$1" = "cpu_ctrl" ]; then
    modules_input="cpu_ctrl pc rom id jmp lr"
elif [ "$1" = "cpu_data" ]; then
    modules_input="cpu_data reg_f data_mem alu acc flag_reg"
else
    modules_input="$@"
fi

for i in $modules_input
do  
  modules_list+="$modules_dir/$i.v "
done

iverilog -Wall -s $1_tb -o ./Output/$1_sim "$modules_dir"/tb/$1_tb.v $modules_list 

if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp ./Output/$1_sim

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

rm -f ./Output/$1_sim