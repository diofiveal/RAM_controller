
module fsm_controller #(
    parameter ADDR_SIZE = 256
)
(
        input  logic                         wr,
        input  logic                         rd,
        input  logic                        clk,
        input  logic                      rst_n,
        output logic                       done,
        output logic[$clog2(ADDR_SIZE) - 1 : 0]addr,
        output logic                         we
);
    logic inc_addr;

    typedef enum logic[1:0] { IDLE, READ, WRITE } state_t;
    state_t state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            addr <= '0;
        else if (inc_addr)
            addr <= addr + 1'b1;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state <= IDLE;
        else 
            state <= next_state;
    end

    always_comb begin
        next_state = state;

        case (state)
            IDLE: if(wr) next_state = WRITE;
                  else if (rd) next_state = READ;
            
            READ: next_state = IDLE;
            WRITE: next_state = IDLE;
            default: next_state = IDLE;
            
        endcase
    end

    always_comb begin
        inc_addr = 1'b0;
        done = 1'b0;
        case (state)
            WRITE: begin
                inc_addr = 1'b1;
                done = 1'b1;
            end
            READ: begin
                inc_addr = 1'b1;
                done = 1'b1;
            end
        endcase
    end
    //assign we = (state == WRITE);
    assign we = (state == IDLE) && wr; 


endmodule
