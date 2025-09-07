module SPI_tb();
//stimuls and rsponse 
reg MOSI,SS_n,clk,rst_n;
wire MISO;
//DUT
SPI_Wrapper spi (.MOSI(MOSI),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.MISO(MISO));
//clk generation 
initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end
//start from known states >>(directed wait and checking using waveform)
initial begin
    rst_n = 0;
    MOSI = 0;
    SS_n = 0;
    @(negedge clk);
    rst_n = 1;
    SS_n = 0;
    //writing in the ram from spi:
    wait (spi.SPI.cs == 3'b011);
    @(negedge clk);    
    //1-getting writing address
    MOSI = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =1; //  saving 0000000111[7] writing address  >>[00]
    repeat(2)@(negedge clk);


    //2-start writing in the saved writing address
    SS_n =1; // telling the slave that the comm is done / returning to IDLE
    @(negedge clk);
    SS_n = 0; //telling the slave that the comm is starting
    MOSI = 0; // going to write command


    wait (spi.SPI.cs == 3'b011);
    // writing in the saved writing address
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0; // writing 0100000100[4] in the saved writing address  >>[01]
    repeat(4)@(negedge clk);

    SS_n =1; // telling the slave that the comm is done / returning to IDLE
    @(negedge clk);
    SS_n = 0; //telling the slave that the comm is starting
    MOSI = 1; // going to read command
    spi.SPI.check = 1'b0;

    //reading the ram from spi:
    wait (spi.SPI.cs == 3'b010);
    @(negedge clk);    
    //1-getting reading address
    MOSI = 1;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =1;
    @(negedge clk);
    MOSI =1; //  saving 0000000111[7] reading address  >>[10]
    repeat(2)@(negedge clk);

    SS_n =1; // telling the slave that the comm is done / returning to IDLE
    @(negedge clk);
    SS_n = 0; //telling the slave that the comm is starting
    MOSI = 1; // going to read command
    spi.SPI.check = 1'b1;
    //2-reading the data that has been written using spi after reachinh the reading address using spi
    wait (spi.SPI.cs == 3'b100);
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0;
    @(negedge clk);
    MOSI =0; //  reading 0000000111[7] reading address  >>[11]
    repeat(4)@(negedge clk);
    $stop;
end
endmodule
