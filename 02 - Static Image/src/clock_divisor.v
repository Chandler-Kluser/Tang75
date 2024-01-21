module clock_divisor (
    input      clk,
    output clk_out
);
    reg[6:0] counter;
    assign                clk_out = counter[6];
    always @(negedge clk) counter = counter + 1;
endmodule