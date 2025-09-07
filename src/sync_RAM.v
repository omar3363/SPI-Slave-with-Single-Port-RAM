module sync_RAM(din, clk, rst_n, rx_valid, dout, tx_valid);

parameter   MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [9:0] din;
input clk, rst_n, rx_valid;

output reg [7:0] dout;
output reg tx_valid;

reg [7:0] hold_w_addr, hold_r_addr ; // to hold w/r address

// create memory
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];

always @(posedge clk) begin 
    if (~rst_n) begin
        dout <= 8'b0;
        tx_valid <= 1'b0;
    end else begin 
        tx_valid <= 1'b0;  // Default to 0 every cycle 
        case (din[9:8])
            2'b00: begin 
                if (rx_valid)
                    hold_w_addr <= din[7:0];
            end
            2'b01: begin
                if (rx_valid)
                    mem[hold_w_addr] <= din[7:0];
            end
            2'b10: begin 
                if (rx_valid)
                    hold_r_addr <= din[7:0];
            end
            2'b11: begin 
                if (rx_valid) begin
                    dout <= mem[hold_r_addr];
                    tx_valid <= 1'b1;
                end
            end
            default: dout <= 8'b0;
        endcase
    end
end

endmodule
