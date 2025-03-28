//signed multiplier
module signed_mult(output logic signed [15:0] output, 
                   input logic signed [7:0] a, b
);
    assign output = a * b;
endmodule
