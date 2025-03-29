//signed multiplier
module signed_mult(output logic signed [15:0] result, 
                   input logic signed [7:0] a, b
);
    assign result = a * b;
endmodule
