vlib work

vlog SPI_tb.v

vsim -voptargs=+acc SPI_tb

add wave /SPI_tb/clk
add wave /SPI_tb/rst_n
add wave /SPI_tb/MOSI
add wave /SPI_tb/SS_n
add wave /SPI_tb/MISO

add wave /SPI_tb/spi/SPI/tx_data
add wave /SPI_tb/spi/SPI/rx_data
add wave /SPI_tb/spi/SPI/rx_valid
add wave /SPI_tb/spi/SPI/tx_valid

run -all

# quit -sim
