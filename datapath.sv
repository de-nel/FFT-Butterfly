module datapath (
    output logic [7:0] result,  // For example, output the real lookup value
    input  logic [7:0] dataIn,   // 8-bit input (address in lower 3 bits)
    input  logic       Clock,      // Clock signal
    input  logic       nReset,   // Active-low reset
    input  logic       store_W, store_B,
    input  logic       calc_ReWB , store_ReWB , 
    input  logic       calc_ImY, store_ImY, 
    input  logic       calc_ImZ, store_ImZ,
    input  logic       store_A,
    input  logic       calc_ReZ2, store_ReZ2,
    input  logic       calc_ReZ, store_ReZ,
    input  logic       calc_ReY, store_ReY,
    input  logic       display_ReY, display_ImY, display_ReZ, display_ImZ,clear
);

    // Internal address register store 3 bit twiddle factor address
    logic [2:0] index;

    // Wires to capture the memory outputs
    wire [7:0] ReW_mem, ImW_mem;

    //Wires to capture the multiplier outputs
    logic signed [15:0] mult_result;
    logic signed [7:0] input_a, input_b;

    logic signed [7:0] adder_result;    
    
    //datapath registers
    logic signed [7:0] Re_W, Im_W;
    logic signed [7:0] Re_A, Re_B;

    logic signed [7:0] Re_WB, Re_WB_2;

    logic signed [7:0] Re_Y, Im_Y;
    logic signed [7:0] Re_Z, Im_Z;

    //Instantiate the multiplier
    signed_mult mult_inst (
        .result(mult_result),
        .a(input_a),
        .b(input_b)
        );
    
        //Instantiate the multiplier
    adder add (
        .result(adder_result),
        .a(input_a),
        .b(input_b)
        );
    
    
    // Instantiate the memory module
    mem mem_inst (
        .dout_re(ReW_mem),
        .dout_im(ImW_mem),
        .address(index),
        .clk(Clock)
    );

    always_ff @(posedge Clock,negedge nReset) begin
        if (!nReset) begin
            result <= 8'b0;
            Re_W   <= 8'b0;
            Im_W   <= 8'b0;
            index  <= 3'b0;
            input_a <= 0;
            input_b <= 0;
            Re_A     <= 8'b0;
            Re_B     <= 8'b0;
            Re_WB    <= 8'b0;
            Re_WB_2  <= 8'b0;
            Re_Y     <= 8'b0;
            Im_Y     <= 8'b0;
            Re_Z     <= 8'b0;
            Im_Z     <= 8'b0;
        end 
        else begin
            if(clear) result <=0;

            else if(store_W) begin 
                        index <= dataIn[2:0];
                        Re_W <= ReW_mem;
                        Im_W <= ImW_mem;
            end

            else if(store_B) Re_B <= dataIn;

            else if(calc_ReWB) begin
                    input_a <= Re_W;
                    input_b <= Re_B;
            end

            else if(store_ReWB) Re_WB <= mult_result[14:7];
            

            else if(calc_ImY) begin
                input_a <= Im_W;
                input_b <= Re_B;
            end

            else if(store_ImY) Im_Y <= mult_result[14:7];

            else if(calc_ImZ)begin
                input_a <= ~(Im_Y);
                input_b <= 1;
            end

            else if(store_ImZ) Im_Z <= adder_result;

            else if(store_A) Re_A <= dataIn;

            else if(calc_ReY) begin
                input_a <= Re_A;
                input_b <= Re_WB;
            end

            else if(store_ReY) Re_Y <= adder_result;

            else if(calc_ReZ2) begin
                input_a <= ~(Re_WB);
                input_b <= 1;

            end

            else if(store_ReZ2) Re_WB_2 <= adder_result;

            else if(calc_ReZ) begin
                input_a <= Re_A;
                input_b <= Re_WB_2;

            end 
            else if(store_ReZ) Re_Z <= adder_result;

            else if(display_ReY) result <= Re_Y;
            else if(display_ImY) result <= Im_Y;
            else if(display_ReZ) result <= Re_Z;
            else if(display_ImZ) result <= Im_Z;
            

        end
    end
endmodule
