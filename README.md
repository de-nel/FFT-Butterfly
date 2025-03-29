# FFT_BUTTERFLY

## Notes

- Synthesised on INTEL CYCLONE V SOC FPGA and working
- `fft_butterfly.sv` is the top module
- Coded a `controller.sv` and `datapath.sv` structure
- `debounce` slide switches with 50 MHz clock
- Only uses 1 `adder.sv` and 1 `signed_mult.sv`  (aside from the counter in the debouncer)
- Twiddle factors stored in memory `mem.sv`; due to size limitations for Quartus block memory, they are implemented as combinational logic
- - `fft_butterfly.qsf` contain pin assignments

