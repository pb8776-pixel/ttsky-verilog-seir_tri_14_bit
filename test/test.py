# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0


import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Apply test inputs
    dut.ui_in.value = 20
    dut.uio_in.value = 30

    # Wait for a few cycles to allow DUT to process
    await ClockCycles(dut.clk, 2)

    # Log actual output
    out_val = int(dut.uo_out.value)
    dut._log.info(f"DUT output = {out_val}")

    # Adjust this check to match your DUT logic
    # Example: if DUT is supposed to add ui_in + uio_in
    expected = 20 + 30   # = 50
    # If DUT is doing something else, update accordingly

    assert out_val == expected, f"Expected {expected}, got {out_val}"
