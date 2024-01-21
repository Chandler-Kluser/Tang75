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