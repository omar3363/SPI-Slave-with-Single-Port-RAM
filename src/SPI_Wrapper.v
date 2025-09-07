module SPI_Wrapper(MOSI,SS_n,clk,rst_n,MISO);

input MOSI,SS_n,clk,rst_n;
output MISO;

wire rx_valid_W,tx_valid_W;
wire [7:0] dout_W;
wire [9:0] rx_data_W;

sync_RAM Ram (.clk(clk),.rst_n(rst_n),.din(rx_data_W),.rx_valid(rx_valid_W),.dout(dout_W),.tx_valid(tx_valid_W));
sync_SPI SPI (.clk(clk),.rst_n(rst_n),.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.rx_data(rx_data_W),.rx_valid(rx_valid_W),.tx_data(dout_W),.tx_valid(tx_valid_W));

endmodule
