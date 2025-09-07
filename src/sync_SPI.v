module sync_SPI(MOSI,SS_n,clk,rst_n,tx_valid,tx_data,MISO,rx_valid,rx_data);
//states in parameters and encoding them
parameter IDLE = 3'b000;
parameter CHK_CMD = 3'b001;
parameter READ_ADD = 3'b010;
parameter WRITE = 3'b011;
parameter READ_DATA = 3'b100;
//input and output declaration
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg [9:0] rx_data;
//internal signal to determine Read_Add or Read_Date
reg check;
reg [3:0] bit_counter;
reg [7:0] miso_shift_reg;
//cs and ns registers 
(* fsm_encoding = "gray" *)
reg [2:0] cs,ns;
//state memory 
always @(posedge clk) begin
    if(~rst_n)
        cs <= IDLE;
    else
        cs <= ns;
end
//next state
always @(cs,MOSI,SS_n,check) begin
    case(cs)

        IDLE : 
        begin
            if(~SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end

        CHK_CMD : 
        begin
            if(SS_n)
                ns = IDLE;
            else if(SS_n == 0 && MOSI == 0) 
                ns = WRITE;
            else begin
                if(SS_n == 0 && MOSI == 1) begin
                    if(check) begin
                        ns = READ_DATA;
                    end
                    else begin
                        ns = READ_ADD;
                    end
                end
            end
        end

        WRITE :
        begin
            if(SS_n)
                ns = IDLE;
            else 
                ns = WRITE;
        end

        READ_ADD : 
        begin
            if(SS_n)
                ns = IDLE;
            else 
                ns = READ_ADD;
        end

        READ_DATA : 
        begin
            if(SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end

        default :
            ns = IDLE;
    endcase
end
//outputs
always @(posedge clk) begin
    if(~rst_n) begin
        rx_data <= 10'b0;
        rx_valid <= 1'b0;
        MISO <= 1'b0;
        bit_counter <= 4'b0;
        check <= 1'b0;
        miso_shift_reg <= 8'b0;
    end
    else begin
        if(SS_n) begin
            bit_counter <= 4'b0;
            check <= 1'b0;
        end
    end

        case(cs)

            CHK_CMD: 
            begin
                bit_counter <= 4'b0;
                rx_valid <= 1'b0;
                rx_data <= 10'b0;
            end

            WRITE :
            begin
                if(~SS_n && bit_counter < 10) begin
                    rx_data <= {rx_data[8:0], MOSI};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 10) begin
                    rx_valid <= 1'b1;
                end
            end
            READ_ADD :
            begin
                if(~SS_n) 
                if(~SS_n && bit_counter < 10) begin
                    rx_data <= {rx_data[8:0], MOSI};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 10) begin
                    rx_valid <= 1'b1;
                    check <= 1'b1;
                end
            end
            READ_DATA : 
            begin
                if(~SS_n) 
                if(~SS_n && bit_counter < 10) begin
                    rx_data <= {rx_data[8:0], MOSI};
                    bit_counter <= bit_counter + 1;
                end
                if (bit_counter == 10) begin
                    rx_valid <= 1'b1;
                    check <= 1'b1;
                end

                
                if (tx_valid) begin
                    miso_shift_reg <= tx_data;
                end

                if(~SS_n && bit_counter < 8) begin
                    MISO <= miso_shift_reg[7];
                    miso_shift_reg <= miso_shift_reg << 1;
                    bit_counter <= bit_counter + 1;
                end
            end
        endcase
end

endmodule
