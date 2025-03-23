module fft_butterfly(
    input  logic       clk,
    input  logic       rst,
    input  logic       start,
    input  logic [7:0] in_a,
    input  logic [7:0] in_b,
    output logic [7:0] result,
    output logic       done
);
    // Internal wires to connect the controller and datapath
    logic load;
    logic compute;
    
    // Instantiate the controller
    controller ctrl (
        .clk(clk),
        .rst(rst),
        .start(start),
        .load(load),
        .compute(compute),
        .done(done)
    );
    
    // Instantiate the datapath
    datapath dp (
        .clk(clk),
        .rst(rst),
        .load(load),
        .compute(compute),
        .in_a(in_a),
        .in_b(in_b),
        .result(result)
    );
endmodule
