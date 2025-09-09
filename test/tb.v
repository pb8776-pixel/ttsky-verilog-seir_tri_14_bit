`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump the signals
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Testbench signals
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate DUT
  tt_um_sierpinski_lfsr user_project (
`ifdef GL_TEST
      .VPWR   (VPWR),
      .VGND   (VGND),
`endif
      .clk    (clk),
      .rst_n  (rst_n),
      .ena    (ena),
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe)
  );

  // Clock generator (Cocotb will drive this as well, but having it here is safe)
  initial clk = 0;
  always #5 clk = ~clk;

endmodule
