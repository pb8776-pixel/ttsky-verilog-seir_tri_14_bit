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
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    # Expected LFSR sequence (first few values from seed = 0x01)
    expected_sequence = [0x01, 0x02, 0x04, 0x08, 0x11, 0x23, 0x47, 0x8E]

    # Check first 8 cycles
    for i, expected in enumerate(expected_sequence):
        await ClockCycles(dut.clk, 1)
        out_val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: DUT output = {out_val:02X}, Expected = {expected:02X}")
        assert out_val == expected, f"Mismatch at cycle {i}: expected {expected:02X}, got {out_val:02X}"
