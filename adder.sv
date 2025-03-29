//adder
module adder(output logic signed [7:0] result, 
                   input logic signed [7:0] a, b
);
    assign result = a + b;
endmodule
