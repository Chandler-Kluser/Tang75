`include "src/top_half_rom.v"
`include "src/bottom_half_rom.v"

module framebuffer(
    input  wire[5:0] column, // column index (6 bits for 64 pixels)
    input  wire[3:0]   ADDR, // ADDR input
    output wire[2:0]   RGB0, // RGB0 output
    output wire[2:0]   RGB1  // RGB1 output
);

wire[2:0] data0,data1;
wire[9:0]    addr_rom;

assign addr_rom = {ADDR,column};

ROMTop      rom_low (.addr(addr_rom),.data(data0));
ROMBottom   rom_high(.addr(addr_rom),.data(data1));

assign RGB0 = data0;
assign RGB1 = data1;

endmodule
