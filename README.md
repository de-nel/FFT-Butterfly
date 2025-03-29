# FFT_BUTTERFLY

## Notes

- Synthesised on INTEL CYCLONE V SOC FPGA and working
- `fft_butterfly` is the top module
- Coded using a controller and datapath structure
- Debounce slide switches with 50 MHz clock
- Only uses 1 adder and 1 multiplier (aside from the counter in the debouncer)
- Twiddle factors stored in memory; due to size limitations for Quartus block memory, they are implemented as combinational logic
