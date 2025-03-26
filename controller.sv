module controller(
    output logic compute,       // Control signal to perform computation in datapath
    output logic store_Reb,
    output logic twiddle,       // Control signal to perform computation in datapath
    output logic enableW_RE,    // Signal for real-part enable
    output logic enableW_IM,    // Signal for imaginary-part enable
    input  logic Clock,
    input  logic nReset
    input  logic ReadyIn  // 10 slide switches from the FPGA board
);

    //-------------------------------------------------------------------------
    // Use one of the slide switches as the ReadyIn signal.
    // For example, we use slide_switch[0]. The switches are level-sensitive,
    // with UP (high) and DOWN (low). You could use a different mapping if needed.
    //-------------------------------------------------------------------------
    logic ReadyIn;

    // always_ff @(posedge Clock or negedge nReset) begin
    //     if (!nReset)
    //         ReadyIn <= 1'b0;
    //     else
    //         ReadyIn <= slide_switch;
    // end

    //-------------------------------------------------------------------------
    // State declaration
    //-------------------------------------------------------------------------
    typedef enum logic [3:0] {
        IDLE,
        WAIT0_W,
        WAIT1_W,
        WAIT0_D,
        WAIT1_D,
        WAIT0_I,
        WAIT1_I,
        READ_W,
        READ_B,
        DISP_W_RE,
        DISP_W_IM
    } state_t;
    state_t state;

    //-------------------------------------------------------------------------
    // State and next state logic
    //-------------------------------------------------------------------------
    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset)
            state <= IDLE;
        else begin
            case (state)
                // a.Wait for SW8 =0
                IDLE:      state <= WAIT0_W;
                WAIT0_W:   if (ReadyIn == 0) state <= WAIT1_W;

                // b.Wait for SW8 =1
                WAIT1_W:   if (ReadyIn == 1) state <= READ_W;

                // c.Read twiddle factor
                READ_W:    state <= WAIT0_D;
                
                // d.Wait for SW8 =0
                WAIT0_D:   if (ReadyIn == 0) state <= WAIT1_D;

                // e.Wait for SW8 =1
                WAIT1_D:   if (ReadyIn == 1) state <= READ_B;

                // f.Read Re b
                READ_B:    state <= WAIT0_I; 

                // g.Wait for SW8 =0
                WAIT0_I:   if (ReadyIn == 1) state <= WAIT1_I;

                // h.Wait for SW8 =1
                WAIT1_I:   if (ReadyIn == 1) state <= DISP_W_IM;
                DISP_W_IM: if (ReadyIn == 0) state <= IDLE;
                default:   state <= IDLE;
            endcase
        end
    end

    //-------------------------------------------------------------------------
    // Output logic
    //-------------------------------------------------------------------------
    always_comb begin
        // Default values
        enableW_RE = 0;
        enableW_IM = 0;
        compute    = 0;
        twiddle    = 0;
        store_Reb  = 0;
        case (state)
            WAIT0_W:    twiddle   = 1;
            READ_W:     compute   = 1;
            READ_B:     store_Reb  = 1;
            DISP_W_RE:  enableW_RE = 1;
            DISP_W_IM:  enableW_IM = 1;
            default:    ; // defaults already applied
        endcase
    end

endmodule
