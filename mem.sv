module mem (
    output logic [7:0] dout_re,   // Real-part output
    output logic [7:0] dout_im,   // Imaginary-part output
    input  logic [2:0] address,   // 3-bit address (8 entries)
    input  logic       clk        // Clock
);

    // Real-part memory array
    logic [7:0] mem_re [7:0];
    // Imaginary-part memory array
    logic [7:0] mem_im [7:0];

    // Initialize the real-part memory 
    initial begin
        mem_re[0] = 8'b01111111; // +1.0
        mem_re[1] = 8'b01011011; // +1/√2
        mem_re[2] = 8'b00000000; //  0
        mem_re[3] = 8'b10100101; // -1/√2
        mem_re[4] = 8'b10000000; // -1.0
        mem_re[5] = 8'b10100101; // -1/√2
        mem_re[6] = 8'b01111111; // +1.0
        mem_re[7] = 8'b01011011; // +1/√2
    end

    // Initialize the imaginary-part memory 
    initial begin
        mem_im[0] = 8'b00000000; //  0j
        mem_im[1] = 8'b10100101; // -1/√2 j
        mem_im[2] = 8'b10000000; // -1.0 j
        mem_im[3] = 8'b10100101; // -1/√2 j
        mem_im[4] = 8'b00000000; //  0j
        mem_im[5] = 8'b01011011; // +1/√2 j
        mem_im[6] = 8'b01111111; // +1.0 j
        mem_im[7] = 8'b01011011; // +1/√2 j
    end

    // Synchronous read  for both memories
    always_ff @(posedge clk) begin
        dout_re <= mem_re[address];
        dout_im <= mem_im[address];
    end

endmodule
