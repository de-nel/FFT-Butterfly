module debounce (
    output logic       logic_level,  // debounced signal
    output logic       pulse,    // 1-clock pulse on 0->1 transition
    input  logic       clk,
    input  logic       nReset,
    input  logic       switch
);
    // Number of bits for the counter
    localparam int N = 21;

    // State encoding
    typedef enum {
        ZERO , WAIT1 , ONE , WAIT0 } state;

    state  state_reg, state_next;
    logic [N-1:0] q_reg,    q_next;

    // Synchronous state and data registers
    always_ff @(posedge clk,negedge nReset) 
        if (!nReset) 
            begin
                state_reg <= ZERO;
                q_reg     <= 0;
            end
        else 
            begin
                state_reg <= state_next;
                q_reg     <= q_next;
            end


    // Next-state logic and outputs
    always_comb 
    begin
        // Default assignments
        state_next = state_reg; //default state: the same
        q_next     = q_reg;   // default q unchanged
        logic_level   = 1'b0; //default output: 0
        pulse    = 1'b0; // defautl output:0 

        case (state_reg)
            ZERO: begin
                // If sw goes high, start waiting
                if (switch) begin
                    state_next = WAIT1;
                    q_next     = {N{1'b1}};  // load all 1’s
                end
            end
            WAIT1: begin 
                if (switch) begin
                    q_next = q_reg -1;
                    if (q_next == 0) begin
                        state_next = ONE;
                        pulse    = 1'b1;
                    end
                end
                else //sw==0
                    state_next = ZERO;
            end
            ONE: begin
                logic_level = 1'b1;
                // If sw goes low, start waiting
                if (!switch) begin
                    state_next = WAIT0;
                    q_next     = {N{1'b1}}; //load 1...1
                end
            end
            WAIT0: begin
                logic_level = 1'b1; // still considered 1 until stable
                if (!switch) begin
                    q_next   = q_reg - 1;
                    if(q_next == 0) 
                        state_next = ZERO;
                end
                else //sw ==1
                    state_next = ONE;
            end
        endcase
    end
endmodule