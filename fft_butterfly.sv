module fft_butterfly(
    output logic [7:0] result,
    input  logic       Clock,
    input  logic       nReset,  
    input  logic       ReadyIn, 
    input  logic [7:0] dataIn
);
    // Internal wires to connect the controller and datapath

    logic       debouncedReady;
    logic       debouncedPulse;
    logic       store_W, store_B;
    logic       calc_ReWB, store_ReWB;
    logic       calc_ImY, store_ImY;
    logic       calc_ImZ, store_ImZ;
    logic       store_A;
    logic       calc_ReZ2, store_ReZ2;
    logic       calc_ReZ, store_ReZ;
    logic       calc_ReY, store_ReY;
    logic       display_ReY, display_ImY, display_ReZ, display_ImZ, clear;

    // Instantiate the debouncer
    debounce debouncer (    
        .logic_level(debouncedReady),
        .pulse(debouncedPulse),
        .clk(Clock),
        .nReset(nReset),
        .switch(ReadyIn)
    );
    
    // Instantiate the controller using the debounced signal.
    controller ctrl (
        .store_W(store_W),
        .store_B(store_B),
        .calc_ReWB(calc_ReWB),
        .store_ReWB(store_ReWB),
        .calc_ImY(calc_ImY),
        .store_ImY(store_ImY),
        .calc_ImZ(calc_ImZ),
        .store_ImZ(store_ImZ),
        .store_A(store_A),
        .calc_ReZ2(calc_ReZ2),
        .store_ReZ2(store_ReZ2),
        .calc_ReZ(calc_ReZ),
        .store_ReZ(store_ReZ),
        .calc_ReY(calc_ReY),
        .store_ReY(store_ReY),
        .display_ReY(display_ReY),
        .display_ImY(display_ImY),
        .display_ReZ(display_ReZ),
        .display_ImZ(display_ImZ),
        .clear(clear),
        .Clock(Clock),
        .nReset(nReset),
        .ReadyIn(debouncedReady)
        );
    
    // Instantiate the datapath
    datapath datapath_inst ( 
        .result(result),
        .dataIn(dataIn),
        .Clock(Clock),
        .nReset(nReset),
        .store_W(store_W),
        .store_B(store_B),
        .calc_ReWB(calc_ReWB),
        .store_ReWB(store_ReWB),
        .calc_ImY(calc_ImY),
        .store_ImY(store_ImY),
        .calc_ImZ(calc_ImZ),
        .store_ImZ(store_ImZ),
        .store_A(store_A),
        .calc_ReZ2(calc_ReZ2),
        .store_ReZ2(store_ReZ2),
        .calc_ReZ(calc_ReZ),
        .store_ReZ(store_ReZ),
        .calc_ReY(calc_ReY),
        .store_ReY(store_ReY),
        .display_ReY(display_ReY),
        .display_ImY(display_ImY),
        .display_ReZ(display_ReZ),
        .display_ImZ(display_ImZ),
        .clear(clear)
        );

    
endmodule
