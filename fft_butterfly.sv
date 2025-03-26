module fft_butterfly(
    output logic [7:0] result,
    input  logic       Clock,
    input  logic       nReset,  // active-high reset
    input  logic       ReadyIn, /
    input  logic [7:0] dataIn
);
    // Internal wires to connect the controller and datapath
    logic       twiddle;
    logic       compute;
    logic       enableW_RE;
    logic       enableW_IM;
    logic       store_Reb;
    logic       debouncedReady;
    logic       debouncedPulse;

    // Instantiate the debouncer
    debounce debouncer (    
        .logic_level(debouncedReady),
        .pulse(debouncedPulse)
        .clk(Clock),
        .nReset(nReset),
        .switch(ReadyIn),
    )
    
    // Instantiate the controller using the debounced signal.
    controller ctrl (
        .compute(compute),
        .store_Reb(store_Reb),
        .twiddle(twiddle),
        .enableW_RE(enableW_RE),
        .enableW_IM(enableW_IM),
        .Clock(Clock),
        .nReset(nReset),
        .ReadyIn(debouncedReady),
        );
    
    // Instantiate the datapath
    datapath dp (
        .result(result),
        .dataIn(dataIn),
        .Clock(Clock),
        .nReset(nReset),       // Map nReset to datapath reset
        .twiddle(twiddle),
        .compute(compute),
        .enableW_RE(enableW_RE),
        .enableW_IM(enableW_IM),
        .store_Reb(store_Reb)
    );
    
endmodule
