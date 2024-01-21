// +-------------------------------------------+
// |                                           |
// |     HUB75 DOT MATRIX DISPLAY DRIVER       |
// |                                           |
// |  Author: Chandler Klüser Chantre (2023)   |
// |  Device: Sipeed Tang Nano 9k              |
// |  Display: 64x32 1/16 dot matrix HUB75     |
// |  Lesson 01: Single Static Red Pixel       |
// |                                           |
// +-------------------------------------------+

// parameters
localparam PIXEL_COLUMNS = 64; // screen width in pixels
localparam PIXEL_LINES   = 16; // screen height in pixels/2
localparam OE_INTENSITY  =  1; // screen display intensity (min=1; max=128; off=0)

// top module
module pxmat_tn9k(
    input           clk,     // Board 27MHz clock
    input           rst,     // Reset button for display driver
    output reg[3:0] ADDR,    // A B C and D pins (address pins) counts from 0 up to PIXEL_LINES-1 (2 groups of PIXEL_LINES lines)
    output reg      OE,      // OUTPUT ENABLE pin, drives the display intensity
    output reg      LATCH,   // LATCH pin (HIGH every time the line is filled, LOW elsewhere)
    output[2:0]     RGB0,    // R0, G0 and B0 pins - lines  0 to PIXEL_LINES-1
    output[2:0]     RGB1,    // R1, G1 and B1 pins - lines PIXEL_LINES to 2*PIXEL_LINES-1
    output          clk_out  // output clock pin (needs to cycle PIXEL_COLUMNS times until reset column count)
);

    // basic counter for state machine handling
    reg[6:0] counter;

    // clock divisor (outputs 60Hz)
    wire clk_master;
    clock_divisor clkdiv(.clk(clk),.clk_out(clk_master));

    // register to control LATCH output
    reg        LAT_EN;

    // output enable controller
    oe_controller oe_ctrl(.clk(clk_master),.rst(rst),.cnt(counter),.OE(OE));

    // prints only first line
    assign ADDR = 4'b0000;

    // shift registers clock driver
    assign clk_out = (counter<PIXEL_COLUMNS) ? clk_master : 1;

    // design pattern
    assign RGB0 = (counter==63) ? 3'b001 : 3'b000;
    assign RGB1 = 3'b000;
    
    always @(negedge clk_master) begin
        // async reset logic
        if (!rst) begin
            LATCH         <= 0;
            LAT_EN        <= 1;
            counter       <= 7'd0;
        end else begin
            // increment clock counter
            counter <= counter + 7'd1;

            // LATCH signal handling
            // PIXEL_COLUMNS+1 clock cycle LATCHES
            if (counter==PIXEL_COLUMNS & LAT_EN) begin
                LATCH <= 1;
            // PIXEL_COLUMNS+2 clock cycle UNLATCH
            end else if (counter==PIXEL_COLUMNS+1 & LAT_EN) begin
                LATCH        <= 0;
                counter      <= 7'd0;
                LAT_EN       <=    0;
            end
        end
    end
endmodule

module clock_divisor (
    input       clk,
    output  clk_out
);

    reg[11:0] counter;
    assign clk_out = counter[11];
    always @(negedge clk) counter = counter + 1;
endmodule

module oe_controller(
    input      clk,
    input      rst,
    input[6:0] cnt,
    output reg  OE
);

    always @(negedge clk) begin
        if (!rst) begin
            OE      = 1;
        end else begin
            if (cnt<OE_INTENSITY) OE = 0; else OE = 1;
        end
    end
endmodule