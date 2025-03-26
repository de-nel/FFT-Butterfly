module datapath (
    output logic [7:0] result,  // For example, output the real lookup value
    input  logic [7:0] dataIn,   // 8-bit input (address in lower 3 bits)
    input  logic       Clock,      // Clock signal
    input  logic       nReset,   // Active-low reset
    input  logic       twiddle,  // When high, load address from dataIn
    input  logic       compute,   // When high, latch lookup outputs
    input  logic       enableW_RE,// Enable signal to update 're'
    input  logic       enableW_IM,// Enable signal to update 'im'
    input  logic       store_Reb
);

    // Internal address register (3-bit for 8 entries)
    logic [2:0] index;
    // Wires to capture the memory outputs
    logic [7:0] Re_W;
    logic [7:0] Im_w;
    logic [7:0] Re_b;
    
    //     // STEP 1: Use wires for memory outputs
    // wire [7:0] mem_re_out;
    // wire [7:0] mem_im_out;

    // Instantiate the memory module
    mem mem_inst (
        .dout_re(Re_W),
        .dout_im(Im_w),
        .address(index),
        .clk(Clock)
    );

    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset) begin
            result <= 8'b0;
            Re_W   <= 8'b0;
            Im_w   <= 8'b0;
            index  <= 3'b0;
        end 
        else begin
            // Latch the address when twiddle is asserted
            if (twiddle)  index <= dataIn[2:0];
            if (enableW_RE) result <= Re_W;
            else if (enableW_IM) result <= Im_w;
        end
    end


endmodule
