`define NOT 5'b00000
`define XOR 5'b00001
`define OR  5'b00010
`define AND 5'b00011
`define SUB 5'b00100
`define ADD 5'b00101 //DATA_MEM
`define RR  5'b00110
`define RL  5'b00111
`define DEC 5'b01000
`define INC 5'b01001
`define LD  5'b01010
`define ST  5'b01011
`define LDR 5'b01100
`define STR 5'b01101

`define BAR 5'b01110 //Base address register - provide base address
`define JMP 5'b01111 //JMP to address
`define JMPO 5'b10000 //JMP for specified offset

`define XORR 5'b10001 //R0-R7
`define ORR  5'b10010
`define ANDR 5'b10011
`define SUBR 5'b10100
`define ADDR 5'b10101 

`define LDI 5'b11010 //Load immediate, differentiates from LD only in fifth bit
`define LDAR 5'b11101 //DATA_MEM address read from R0-R7
`define NOP 5'b11110
`define RST 5'b11111