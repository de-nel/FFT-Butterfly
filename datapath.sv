module datapath(
    input  logic       clk,
    input  logic       rst,
    input  logic       load,    // Control signal to load inputs into registers
    input  logic       compute, // Control signal to perform the computation
    input  logic [7:0] in_a,
    input  logic [7:0] in_b,
    output logic [7:0] result
);
    // Internal registers for the inputs
    logic [7:0] reg_a;
    logic [7:0] reg_b;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_a  <= 8'd0;
            reg_b  <= 8'd0;
            result <= 8'd0;
        end else begin
            if (load) begin
                // Load the inputs into registers
                reg_a <= in_a;
                reg_b <= in_b;
            end else if (compute) begin
                // Perform the arithmetic operation (addition in this example)
                result <= reg_a + reg_b;
            end
        end
    end
endmodule