`timescale 1ns/100ps

module rom # (
    parameter WIDTH = 8
)(
    addr,
    data
);
input [WIDTH-1:0] addr;
output [(WIDTH*2)-1:0] data;

reg [(WIDTH*2)-1:0] mem [0:WIDTH-1];

initial begin
  $readmemh("rom_init.hex", mem);
end

assign data = mem[addr];

endmodule