
module ram_controller_top #(
    parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 256
) (
    input logic clk, rst_n, wr, rd,
    input logic [DATA_SIZE - 1 : 0] data_in,
    output logic [DATA_SIZE - 1 : 0] data_out,
    output logic done
);
    logic we;
    logic [$clog2(ADDR_SIZE) - 1 : 0] addr_wire;

    /*logic [DATA_SIZE - 1 : 0]data_in_reg;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) data_in_reg <= 0;
        else if (wr) data_in_reg <= data_in;
    end*/

    fsm_controller #(.ADDR_SIZE(ADDR_SIZE)) controller (      // Исправлено: не передал значения параметров
        .clk,
        .rst_n,
        .wr,
        .rd,
        .we,
        .done,
        .addr(addr_wire)
    );
    ram_sync #(.DATA_SIZE(DATA_SIZE), .ADDR_SIZE(ADDR_SIZE)) ram(
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .addr(addr_wire),
        .data_in(data_in),
        .data_out(data_out)
    );
endmodule