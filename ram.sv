
module ram_sync #(
    parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 256
) (
    input  logic                         clk,
    input  logic                       rst_n,
    input  logic                          we,
    input  logic [$clog2(ADDR_SIZE) - 1 : 0]    addr,
    input  logic [DATA_SIZE - 1 : 0] data_in,
    output logic [DATA_SIZE - 1: 0]  data_out
);

    logic [DATA_SIZE - 1:0] mem [ADDR_SIZE - 1: 0];  // Исправил было logic [DATA_SIZE - 1:0] mem [0:255]

    always_ff @(posedge clk) begin
        if(we) mem[addr] <= data_in;
        else   data_out <= mem[addr];
    end
    
endmodule
