module datapath (
    output logic [7:0] result,
    input  logic [7:0] dataIn,
    input  logic       Clock, nReset,
    
    // signals from controller
    input  logic store_W, store_B, 
    input  logic calc_ReWB, calc_ImY, calc_ImZ, 
    input  logic store_A,
    input  logic calc_ReZ2, calc_ReZ, calc_ReY,
    input  logic display_ReY, display_ImY, display_ReZ, display_ImZ,
    input  logic clear
);

    // Registers
    logic [2:0] index;
    logic signed [7:0] Re_W, Im_W, Re_A, Re_B, Re_WB, Re_WB_2, Re_Y, Im_Y, Re_Z, Im_Z;

    // Memory outputs
    wire [7:0] ReW_mem, ImW_mem;
    mem mem_inst(.dout_re(ReW_mem), .dout_im(ImW_mem), .address(index), .clk(Clock));

    // Multiplier and adder
    logic signed [7:0]  input_a, input_b;
    logic signed [15:0] mult_result;
    logic signed [7:0]  adder_result;

    signed_mult mult_inst(.result(mult_result), .a(input_a), .b(input_b));
    adder add_inst(.result(adder_result), .a(input_a), .b(input_b));

    // Enables for storing results 
    logic en_ReWB, en_ImY, en_ImZ, en_ReY, en_ReZ2, en_ReZ;


    //-------------------------------------------------------------------------
    // 2) Sequential logic:
    //-------------------------------------------------------------------------
    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset) begin
            result <= 0;
            index  <= 0;
            Re_W   <= 0;
            Im_W   <= 0;
            Re_A   <= 0;
            Re_B   <= 0;
            Re_WB  <= 0;
            Re_WB_2<= 0;
            Re_Y   <= 0;
            Im_Y   <= 0;
            Re_Z   <= 0;
            Im_Z   <= 0;
        end 
        else begin
            if(clear) 
                result <= 0;

            else if(store_W) begin
                index <= dataIn[2:0];
                Re_W  <= ReW_mem;
                Im_W  <= ImW_mem;
            end
            else if(store_B)   Re_B <= dataIn;
            else if(store_A)   Re_A <= dataIn;

            if (en_ReWB)  Re_WB  <= mult_result[14:7];
            if (en_ImY)   Im_Y   <= mult_result[14:7];
            if (en_ImZ)   Im_Z   <= adder_result;
            if (en_ReY)   Re_Y   <= adder_result;
            if (en_ReZ2)  Re_WB_2<= adder_result;
            if (en_ReZ)   Re_Z   <= adder_result;

            // Display signals
            if      (display_ReY) result <= Re_Y;
            else if (display_ImY) result <= Im_Y;
            else if (display_ReZ) result <= Re_Z;
            else if (display_ImZ) result <= Im_Z;
        end
    end

    //-------------------------------------------------------------------------
    // Combinational logic:
    //-------------------------------------------------------------------------
    always_comb begin
        // Default
        input_a  = '0;
        input_b  = '0;
        en_ReWB  = 0;
        en_ImY   = 0;
        en_ImZ   = 0;
        en_ReY   = 0;
        en_ReZ2  = 0;
        en_ReZ   = 0;

        if (calc_ReWB) begin
            input_a = Re_W; 
            input_b = Re_B;
            en_ReWB = 1;
        end
        if (calc_ImY) begin
            input_a = Im_W;
            input_b = Re_B;
            en_ImY = 1;
        end
        if (calc_ImZ) begin
            input_a = ~Im_Y;
            input_b = 1;
            en_ImZ = 1;
        end
        if (calc_ReY) begin
            input_a = Re_A;
            input_b = Re_WB;
            en_ReY = 1;
        end
        if (calc_ReZ2) begin
            input_a = ~Re_WB;
            input_b = 1;
            en_ReZ2 = 1;
        end
        if (calc_ReZ) begin
            input_a = Re_A;
            input_b = Re_WB_2;
            en_ReZ = 1;
        end
    end
endmodule
