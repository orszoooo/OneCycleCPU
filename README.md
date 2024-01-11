# OneCycleCPU
Aim of this project is to design simple microprocessor in which every instruction always takes 1 clock cycle to complete. 

## Schematic - modules overview
![OneCycleCPU](https://github.com/orszoooo/OneCycleCPU/assets/117857476/1b6cbc9a-08ae-4fcf-9cc1-31085698004d)

**Register** File holds 9 registers noted as R0, R1, ... R8. R8 is special register and will be used for I/O by PORT. At the moment only reading from R8 is possible by setting instruction operand to 4'h9. 

## Instruction format
**8-bit Op Code + 8-bit Operand** 

i.e. ADD 32 -> 0532

## Exemplary program 
```
1A11 //LDI 11 => 11h -> ACC
0D01 //STR R1 => ACC -> Register 1
1AFF //LDI FF => FFh -> ACC
1501 //ADDR ACC + R1 => ACC = ACC + R1
1F00 //RST 
```
Simple addition using register 1(R1) and immediate variable. 

*ACC - Accumulator*

## Instruction set
Instruction|Op Code(8-bit Hex)|Operand(8-bit)|Description
---|---|---|---
NOT|00h|Not used|Negation of ACC content
XOR|01h|Address in data memory|Performs bit-wise XOR on ACC and variable in pointed memory address 
OR|02h|Address in data memory|Performs bit-wise OR on ACC and variable in pointed memory address 
AND|03h|Adress in data memory|Performs bit-wise AND on ACC and variable in pointed memory address
SUB|04h|Adress in data memory|Subtracts variable(pointed by memory address) from current value in ACC
ADD|05h|Adress in data memory|Adds variable(pointed by memory address) to current value in ACC
RR|06h|Not used|Rotates right the ACC content. In other words divides ACC by 2
RL|07h|Not used|Rotates left the ACC content. In other words multiplies ACC by 2
DEC|08h|Not used|Decrements value in ACC by 1
INC|09h|Not used|Increments value in ACC by 1
LD|0Ah|Address in data memory|Loads variable from data memory to ACC
ST|0Bh|Address in data memory|Writes value from ACC to data memory(under address given as an operand)
LDR|0Ch|Register in Register File(R0-R8)|Loads value from selected register to ACC
STR|0Dh|Register in Register File(R0-R8)|Writes value from ACC to selected register
BAR|0Eh|Base address|Sets the Base Address. This address is used by relative jumps(JMPO and JZO)
JMP|0Fh|Address|Performs absolute jump to selected address
JMPO|10h|Offset|Performs relative jump to place in ROM pointed by *Base Address + Offset*
XORR|11h|Register in Register File(R0-R8)|Performs bit-wise XOR on ACC and variable from selected register  
ORR|12h|Register in Register File(R0-R8)|Performs bit-wise OR on ACC and variable from selected register 
ANDR|13h|Register in Register File(R0-R8)|Performs bit-wise AND on ACC and variable from selected register 
SUBR|14h|Register in Register File(R0-R8)|Subtracts variable(held by selected register) from current value in ACC
ADDR|15h|Register in Register File(R0-R8)|Adds variable(held by selected register) to current value in ACC
CALL|16h|Address|Jumps to pointed address in program memory(ROM) but load to Link Register(LR) current address(before the jump). When RET instruction will be encountered then the program execution will return to address from LR incremented by 1
RET|17h|Not used|Ends the CALL and goes back to address stored in LR incremented by 1
JZ|18h|Address|Performs absolute jump if Zero flag(Z) is set to 1
JZO|19h|Offset|Performs relative(to base address) jump if Zero flag(Z) is set to 1
LDI|1Ah|Immediate variable|Loads immediate variable to ACC
LDAR|1Dh|Register in Register File(R0-R8)|Loads variable to ACC from data memory. Address pointing memory cell is stored and taken from selected register.
NOP|1Eh|Not used|For one clock cycle does nothing. Usefull when there is need to wait for some process to finish
RST|1Fh|Not used|Resets the Program Counter and clears Flag Register. Starts the program execution from the begining.

## Plan for the future
- [ ] Add stack
- [ ] Add simple I/O support(by means of PORT)
- [ ] Add MUL and DIV instrucions
- [ ] Add data source selection bits to the program word i.e. Op Code + Source Selector + Operand
- [ ] Develop compiler and assembler 
