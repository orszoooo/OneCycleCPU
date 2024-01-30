`define NOT 8'h00
`define XOR 8'h01
`define OR  8'h02
`define AND 8'h03
`define SUB 8'h04
`define ADD 8'h05 //DATA_MEM
`define RR  8'h06
`define RL  8'h07
`define DEC 8'h08
`define INC 8'h09
`define LD  8'h0A
`define ST  8'h0B
`define LDR 8'h0C
`define STR 8'h0D

`define BAR 8'h0E //Base address register - provide base address
`define JMP 8'h0F //JMP to address
`define JMPO 8'h10 //JMP for specified offset

`define XORR 8'h11 //R0-R7
`define ORR  8'h12
`define ANDR 8'h13
`define SUBR 8'h14
`define ADDR 8'h15 

`define CALL 8'h16
`define RET 8'h17
`define JZ 8'h18 //jump condtionally
`define JZO 8'h19 //jump condtionally for offset

`define LDI 8'h1A //Load immediate, differentiates from LD only in fifth bit
`define LDAR 8'h1D //DATA_MEM address read from R0-R7
`define NOP 8'h1E
`define RST 8'h1F