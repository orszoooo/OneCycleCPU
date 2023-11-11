`define NOT 5'h00
`define XOR 5'h01
`define OR  5'h02
`define AND 5'h03
`define SUB 5'h04
`define ADD 5'h05 //DATA_MEM
`define RR  5'h06
`define RL  5'h07
`define DEC 5'h08
`define INC 5'h09
`define LD  5'h0A
`define ST  5'h0B
`define LDR 5'h0C
`define STR 5'h0D

`define BAR 5'h0E //Base address register - provide base address
`define JMP 5'h0F //JMP to address
`define JMPO 5'h10 //JMP for specified offset

`define XORR 5'h11 //R0-R7
`define ORR  5'h12
`define ANDR 5'h13
`define SUBR 5'h14
`define ADDR 5'h15 

`define LDI 5'h1A //Load immediate, differentiates from LD only in fifth bit
`define LDAR 5'h1D //DATA_MEM address read from R0-R7
`define NOP 5'h1E
`define RST 5'h1F