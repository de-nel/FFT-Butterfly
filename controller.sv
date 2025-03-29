module controller(
    output logic store_W, store_B, 
    output logic calc_ReWB, store_ReWB, 
    output logic calc_ImY, store_ImY,
    output logic calc_ImZ, store_ImZ,
    output logic store_A,
    output logic calc_ReZ2, store_ReZ2,
    output logic calc_ReZ, store_ReZ,
    output logic calc_ReY, store_ReY,
    output logic display_ReY, display_ImY, display_ReZ, display_ImZ, clear,
    input  logic Clock,
    input  logic nReset,
    input  logic ReadyIn  // 10 slide switches from the FPGA board
);


    //-------------------------------------------------------------------------
    // State declaration
    //-------------------------------------------------------------------------
    typedef enum logic [4:0] {IDLE, WAITW, READW, 
                            WAITB, READB, 
                            CALC_REWB, STORE_REWB,
                            CALC_IMY, STORE_IMY,
                            CALC_IMZ, STORE_IMZ,
                            WAITA, READA,
                            CALC_REZ2, STORE_REZ2,
                            CALC_REZ, STORE_REZ,
                            CALC_REY, STORE_REY, 
                            DISPLAY_REY, DISPLAY_IMY, DISPLAY_REZ, DISPLAY_IMZ } state_t;
    state_t state;

    //-------------------------------------------------------------------------
    // State and next state logic
    //-------------------------------------------------------------------------
    always_ff @(posedge Clock,negedge nReset) begin
        if (!nReset)
            state <= IDLE;
        else begin
            case (state)
        
                IDLE:     if (ReadyIn == 0) state <= WAITW; 
                WAITW:    if (ReadyIn == 1) state <= READW;

                READW:    if (ReadyIn == 0) state <= WAITB;
                WAITB:    if (ReadyIn == 1) state <= READB;

                READB:     state <= CALC_REWB;
                CALC_REWB: state <= STORE_REWB;
                STORE_REWB: state <= CALC_IMY;

                CALC_IMY: state <= STORE_IMY;
                STORE_IMY: state <= CALC_IMZ;

                CALC_IMZ: state <= STORE_IMZ;
                STORE_IMZ: if (ReadyIn == 0) state <= WAITA;
                
                WAITA:	if (ReadyIn == 1)   state <= READA;
                READA:   state <= CALC_REZ2;

                CALC_REZ2: state <= STORE_REZ2;
                STORE_REZ2: state <= CALC_REZ;
                
                CALC_REZ: state <= STORE_REZ;
                STORE_REZ: state <= CALC_REY;
                CALC_REY: state <= STORE_REY;
                STORE_REY: state <= DISPLAY_REY;

                DISPLAY_REY:if (ReadyIn == 0) state <= DISPLAY_IMY;
                DISPLAY_IMY:if (ReadyIn == 1) state <= DISPLAY_REZ;
                DISPLAY_REZ:if (ReadyIn == 0) state <= DISPLAY_IMZ;
                DISPLAY_IMZ:if (ReadyIn == 1) state <= IDLE;

                default:   state <= IDLE;
            endcase
        end
    end

    //-------------------------------------------------------------------------
    //  Signals
    //-------------------------------------------------------------------------
    always_comb begin
        // Default values
		clear = 0;
        store_W = 0;
        store_B = 0;
        calc_ReWB = 0;
        store_ReWB = 0;
        calc_ImY = 0;
        store_ImY = 0;
        calc_ImZ = 0;
        store_ImZ = 0;
        store_A = 0;
        calc_ReZ2 =0;
        store_ReZ2 = 0;
        calc_ReZ = 0;
        store_ReZ = 0;
        calc_ReY = 0;
        store_ReY = 0;
        display_ReY = 0;
        display_ImY = 0;
        display_ReZ = 0;
        display_ImZ = 0;

        // State-dependent output logic
        case (state)
            IDLE:   clear = 1;
            READW:    store_W = 1;
            READB:    store_B = 1;
            CALC_REWB:calc_ReWB = 1;
            STORE_REWB:store_ReWB = 1;
            CALC_IMY: calc_ImY = 1;
            STORE_IMY: store_ImY = 1;
            CALC_IMZ: calc_ImZ = 1;
            STORE_IMZ: store_ImZ = 1;
            READA:    store_A = 1;
            CALC_REZ2: calc_ReZ2 =1;
            STORE_REZ2: store_ReZ2 = 1;
            CALC_REZ: calc_ReZ = 1;
            STORE_REZ: store_ReZ = 1;
            CALC_REY: calc_ReY = 1;
            STORE_REY: store_ReY = 1;
            DISPLAY_REY:display_ReY = 1;
            DISPLAY_IMY:display_ImY = 1;
            DISPLAY_REZ:display_ReZ = 1;
            DISPLAY_IMZ:display_ImZ = 1;
            default:    ; 
        endcase
    end
endmodule
