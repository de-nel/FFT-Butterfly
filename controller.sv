module controller(
    output logic signed [7:0] dataOut,    // Control signal to load data in datapath
    output logic compute, // Control signal to perform computation in datapath
    output logic done     // Signal indicating the operation is complete
    input  logic Clock,
    input  logic nReset,
    input  logic ReadyIn,   // Ready signal to input data from switches
);

    // ----- state declaration -----
    typedef enum logic [1:0] {
        IDLE,
        LOAD,
        COMPUTE,
        DONE
    } state_t;
    state_t state;

    // ----- state + next state logic -----
    always_ff @(posedge Clock, negedge nReset) begin
        if (rst)
            state <= IDLE;
        else begin
            case (state)
                IDLE:
                    if (start)
                        state <= LOAD;
                    else
                        state <= IDLE;

                LOAD:
                    state <= COMPUTE;

                COMPUTE:
                    state <= DONE;

                DONE:
                    state <= IDLE;

                default:
                    state <= IDLE;
            endcase
        end
    end

    // ----- output logic -----
    always_comb begin
        // Default values
        load    = 0;
        compute = 0;
        done    = 0;

        case (state)
            LOAD:
                load    = 1;  // Assert load to capture input data
            COMPUTE:
                compute = 1;  // Assert compute to perform the addition
            DONE:
                done    = 1;  // Operation is complete
        endcase
    end

endmodule
