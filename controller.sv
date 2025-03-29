module controller(
    output logic store_W, store_B, 
    output logic calc_ReWB, calc_ImY, calc_ImZ,
    output logic store_A,
    output logic calc_ReZ2, calc_ReZ, calc_ReY,
    output logic display_ReY, display_ImY, display_ReZ, display_ImZ,
    output logic clear,
    input  logic Clock,
    input  logic nReset,
    input  logic ReadyIn
);

    // Reduced state encoding – no separate store states
    typedef enum logic [4:0] {
        IDLE, 
        WAITW, 
        READW, 
        WAITB, 
        READB, 
        CALC_REWB, 
        CALC_IMY, 
        CALC_IMZ, 
        WAITA, 
        READA, 
        CALC_REZ2, 
        CALC_REZ, 
        CALC_REY, 
        DISPLAY_REY, 
        DISPLAY_IMY, 
        DISPLAY_REZ, 
        DISPLAY_IMZ
    } state_t;
    
    state_t state, next_state;

    // State transition (synchronous update)
    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = state; // default
        case(state)
            IDLE:      if (!ReadyIn) next_state = WAITW;
            WAITW:     if (ReadyIn)  next_state = READW;
            READW:     if (!ReadyIn) next_state = WAITB;
            WAITB:     if (ReadyIn)  next_state = READB;
            READB:     next_state = CALC_REWB;
            CALC_REWB: next_state = CALC_IMY;
            CALC_IMY:  next_state = CALC_IMZ;
            CALC_IMZ:  if (!ReadyIn) next_state = WAITA;
            WAITA:     if (ReadyIn)  next_state = READA;
            READA:     next_state = CALC_REZ2;
            CALC_REZ2: next_state = CALC_REZ;
            CALC_REZ:  next_state = CALC_REY;
            CALC_REY:  next_state = DISPLAY_REY;
            DISPLAY_REY: if (!ReadyIn) next_state = DISPLAY_IMY;
            DISPLAY_IMY: if (ReadyIn)  next_state = DISPLAY_REZ;
            DISPLAY_REZ: if (!ReadyIn) next_state = DISPLAY_IMZ;
            DISPLAY_IMZ: if (ReadyIn)  next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

    // Output logic (combinational decoding of the state)
    always_comb begin
        // Default assignments
        store_W     = 0;
        store_B     = 0;
        calc_ReWB   = 0;
        calc_ImY    = 0;
        calc_ImZ    = 0;
        store_A     = 0;
        calc_ReZ2   = 0;
        calc_ReZ    = 0;
        calc_ReY    = 0;
        display_ReY = 0;
        display_ImY = 0;
        display_ReZ = 0;
        display_ImZ = 0;
        clear       = 0;
        
        case(state)
            IDLE:       clear = 1;
            READW:      store_W = 1;
            READB:      store_B = 1;
            CALC_REWB:  calc_ReWB = 1;
            CALC_IMY:   calc_ImY  = 1;
            CALC_IMZ:   calc_ImZ  = 1;
            READA:      store_A   = 1;
            CALC_REZ2:  calc_ReZ2 = 1;
            CALC_REZ:   calc_ReZ  = 1;
            CALC_REY:   calc_ReY  = 1;
            DISPLAY_REY: display_ReY = 1;
            DISPLAY_IMY: display_ImY = 1;
            DISPLAY_REZ: display_ReZ = 1;
            DISPLAY_IMZ: display_ImZ = 1;
            default:    ;
        endcase
    end

endmodule
