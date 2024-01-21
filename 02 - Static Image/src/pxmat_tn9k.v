// +-------------------------------------------+
// |                                           |
// |     HUB75 DOT MATRIX DISPLAY DRIVER       |
// |                                           |
// |  Author: Chandler Klüser Chantre (2023)   |
// |  Device: Sipeed Tang Nano 9k              |
// |  Display: 64x32 1/16 dot matrix HUB75     |
// |  Lesson 02: Single Static Image           |
// |                                           |
// |  This code does not work with nextpnr     |
// |  due to lack of BRAM support              |
// |                                           |
// +-------------------------------------------+

// parameters
localparam PIXEL_COLUMNS = 64; // screen width in pixels
localparam PIXEL_LINES   = 16; // screen height in pixels/2
localparam OE_INTENSITY  =  6; // screen display intensity (min=1; max=128; off=0)

`include "src/clock_divisor.v"
`include "src/oe_controller.v"
`include "src/framebuffer.v"

// top module
module pxmat_tn9k(
    input           clk,     // Board 27MHz clock
    input           rst,     // Reset button for display driver
    output[3:0]     ADDR,    // A B C and D pins (address pins) counts from 0 up to PIXEL_LINES-1 (2 groups of PIXEL_LINES lines)
    output reg      OE,      // OUTPUT ENABLE pin, drives the display intensity
    output reg      LATCH,   // LATCH pin (HIGH every time the line is filled, LOW elsewhere)
    output[2:0]     RGB0,    // R0, G0 and B0 pins - lines  0 to PIXEL_LINES-1
    output[2:0]     RGB1,    // R1, G1 and B1 pins - lines PIXEL_LINES to 2*PIXEL_LINES-1
    output          clk_out  // output clock pin (needs to cycle PIXEL_COLUMNS times until reset column count)
);

    // basic counter for state machine handling
    reg[6:0] counter;

    // ADDR Signal logic
    reg[3:0] ADDR_CTRL;
    assign ADDR = ADDR_CTRL-1;

    // clock divisor (outputs ~50Hz)
    wire clk_master;
    clock_divisor clkdiv(.clk(clk),.clk_out(clk_master));

    // output enable controller
    oe_controller oe_ctrl(.clk(clk_master),.rst(rst),.cnt(counter),.OE(OE));

    // shift registers clock driver
    assign clk_out = (counter<PIXEL_COLUMNS) ? clk_master : 1;

    // framebuffer
    framebuffer buffer(.column(counter[5:0]),.ADDR(ADDR_CTRL),.RGB0(RGB0),.RGB1(RGB1));
    
    always @(negedge clk_master) begin
        // async reset logic
        if (!rst) begin
            ADDR_CTRL     <= 0;
            LATCH         <= 0;
            counter       <= 7'd0;
        end else begin
            // increment clock counter
            counter <= counter + 7'd1;
            if (counter==PIXEL_COLUMNS-1) begin
                LATCH <= 1;
            end else
            // LATCH signal handling
            // PIXEL_COLUMNS+1 clock cycle LATCHES
            if (counter==PIXEL_COLUMNS) begin
                LATCH        <= 0;
                ADDR_CTRL    <= ADDR_CTRL + 1;
                counter      <= 7'd0;
            end
        end
    end
endmodule