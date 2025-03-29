module debounce(
    input  logic clk,
    input  logic nReset,
    input  logic raw,
    output logic debounced
);
    // Parameter: number of cycles for debounce (1e6 cycles = ~20 ms at 50 MHz)
    parameter integer DEBOUNCE_TIME = 1000000;

    logic [19:0] counter;  // 20-bit counter for up to 1,000,000 cycles
    logic        last_raw;

    always_ff @(posedge clk or negedge nReset) begin
        if (!nReset) begin
            counter    <= 20'd0;
            last_raw   <= 1'b0;
            debounced  <= 1'b0;
        end else begin
            // If the raw input has changed, reset the counter
            if (raw != last_raw) begin
                counter  <= 20'd0;
                last_raw <= raw;
            end else if (counter < DEBOUNCE_TIME) begin
                counter <= counter + 20'd1;
            end else begin
                // Once the counter reaches the threshold, update the debounced output
                debounced <= raw;
            end
        end
    end
endmodule
