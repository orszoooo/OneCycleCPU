#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo Provide module name as an argument i.e. ./simul.sh pc 
    exit 1
fi

cd Output

rm -f $1_sim.vcd

modules_dir="../../Modules"
modules_list=""

for i in "$@"
do  
  modules_list+="$modules_dir/$i.v "
done

iverilog -Wall -s $1_tb -o $1_sim "$modules_dir"/tb/$1_tb.v "$modules_list" 

if [ $? -eq 1 ]; then
    echo Source compilation failure
    exit 1
fi

vvp $1_sim

if [ $? -ne 0 ]; then
    echo Running simulation failure
    exit 1
fi

rm -f $1_sim