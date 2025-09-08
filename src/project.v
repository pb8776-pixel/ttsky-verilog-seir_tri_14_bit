/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

module tt_um_sierpinski_lfsr (
    input  wire clk,        // system clock
    input  wire rst_n,      // active-low reset
    output reg  [13:0] lfsr_out // 14-bit LFSR state (row of triangle)
);

    reg [13:0] lfsr;

    // Feedback taps for maximal-length 14-bit LFSR (x^14 + x^13 + x^12 + x^2 + 1)
    wire feedback = lfsr[13] ^ lfsr[12] ^ lfsr[11] ^ lfsr[1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 14'b0000_0000_0000_01;  // seed value (single '1')
        else
            lfsr <= {lfsr[12:0], feedback};
    end

    // Assign LFSR state to output
    always @(*) begin
        lfsr_out = lfsr;
    end

endmodule
