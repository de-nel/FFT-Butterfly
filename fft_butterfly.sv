module fft_butterfly(
    output logic [7:0] result,
    input  logic       Clock,
    input  logic       nReset,  
    input  logic       ReadyIn, 
    input  logic [7:0] dataIn
);

    // Debouncer signals
    logic debouncedReady, debouncedPulse;

    // Controller/Datapath control signals (store signals removed for calc-only operations)
    logic       store_W, store_B;
    logic       calc_ReWB, calc_ImY, calc_ImZ;
    logic       store_A;
    logic       calc_ReZ2, calc_ReZ, calc_ReY;
    logic       display_ReY, display_ImY, display_ReZ, display_ImZ;
    logic       clear;

    // // Instantiate debouncer
    // debounce debouncer (    
    //     .logic_level(debouncedReady),
    //     .pulse(debouncedPulse),
    //     .clk(Clock),
    //     .nReset(nReset),
    //     .switch(ReadyIn)
    // );
    
    debounce debouncer (
        .clk(Clock),
        .nReset(nReset),
        .raw(ReadyIn),
        .debounced(debouncedReady)
    )
    
    // Instantiate updated controller (store states removed)
    controller ctrl (
        .store_W(store_W),
        .store_B(store_B),
        .calc_ReWB(calc_ReWB),
        .calc_ImY(calc_ImY),
        .calc_ImZ(calc_ImZ),
        .store_A(store_A),
        .calc_ReZ2(calc_ReZ2),
        .calc_ReZ(calc_ReZ),
        .calc_ReY(calc_ReY),
        .display_ReY(display_ReY),
        .display_ImY(display_ImY),
        .display_ReZ(display_ReZ),
        .display_ImZ(display_ImZ),
        .clear(clear),
        .Clock(Clock),
        .nReset(nReset),
        .ReadyIn(debouncedReady)
    );
    
    // Instantiate datapath
    datapath datapath_inst ( 
        .result(result),
        .dataIn(dataIn),
        .Clock(Clock),
        .nReset(nReset),
        .store_W(store_W),
        .store_B(store_B),
        .calc_ReWB(calc_ReWB),
        .calc_ImY(calc_ImY),
        .calc_ImZ(calc_ImZ),
        .store_A(store_A),
        .calc_ReZ2(calc_ReZ2),
        .calc_ReZ(calc_ReZ),
        .calc_ReY(calc_ReY),
        .display_ReY(display_ReY),
        .display_ImY(display_ImY),
        .display_ReZ(display_ReZ),
        .display_ImZ(display_ImZ),
        .clear(clear)
    );

endmodule
