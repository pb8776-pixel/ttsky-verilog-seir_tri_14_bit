`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb();

  reg clk, rst_n;
  wire [13:0] lfsr_out;
  integer i, row;
  integer width = 14;    // visible width
  integer full_width = 16; // internal width (power of 2)

  reg [15:0] curr_row, next_row;

  // Instantiate DUT (not used for triangle printing)
  tt_um_sierpinski_lfsr user_project (
    .clk(clk),
    .rst_n(rst_n),
    .lfsr_out(lfsr_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("=== Exact 14-bit Sierpinski Triangle (centered from 16-bit) ===");
    clk = 0;
    rst_n = 0;
    #10 rst_n = 1;

    // Start with a single 1 in the middle of 16 bits
    curr_row = 16'b0000000010000000;

    // Generate 20 rows
    for (row = 0; row < 20; row = row + 1) begin
      @(posedge clk);

      // Print leading spaces
      for (i = 0; i < (width - row); i = i + 1)
        $write(" ");

      // Print only the middle 14 bits
      for (i = width-1; i >= 0; i = i - 1) begin
        if (curr_row[i+1])  // shift by 1 to drop edges
          $write("* ");
        else
          $write("  ");
      end
      $write("\n");

      // Pascal's rule: next row = XOR of neighbors
      next_row = {curr_row[14:0], 1'b0} ^ {1'b0, curr_row[15:1]};
      curr_row = next_row;
    end

    $finish;
  end

endmodule
