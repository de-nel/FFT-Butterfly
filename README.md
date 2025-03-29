# FFT_BUTTERFLY
# for INTEL CYCLONE V SOC FPGA
# notes:
# #fft_butterfly is the top module
# controller and datapath modules 
# Debounce slide switches with 50 Mhz clock
#Only uses 1 Adder and 1 multiplier (aside from the counter in the debouncer)
# twiddle factors stored in memory, but too small for Quartus to use block memory therefore stored in hardware as comb logic
 
 
 
 
