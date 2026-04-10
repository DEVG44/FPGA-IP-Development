`default_nettype none
`timescale 1ns/1ns

module tb_waveform;
    reg clk;
    wire TXD;
    
// --- NEW SPI WIRES ---
    wire spi_sclk;
    wire spi_mosi;
    wire spi_cs_n;
    wire spi_miso;

    // SIMULATED HARDWARE LOOPBACK: Wire MOSI directly into MISO
    assign spi_miso = spi_mosi;
    // ---------------------


    // Instantiate your SoC
    SOC uut (
        .RESET(clk), // When -DBENCH is active, your SoC uses RESET for the clock
        .RXD(1'b1),
        .TXD(TXD),       // <-- Make sure there is a comma here!

        // NEW SPI CONNECTIONS
        .SPI_SCLK(spi_sclk),
        .SPI_MOSI(spi_mosi),
        .SPI_MISO(spi_miso),
        .SPI_CS_N(spi_cs_n)
    );


    initial begin
        // Waveform Generation Commands
        $dumpfile("sim.vcd"); // Creates the simulation results file
        $dumpvars(0, tb_waveform); // Dumps all signals in the testbench and below
        
        clk = 0;
        
        // 1. Force the CPU into reset overriding internal logic
        force uut.resetn = 0;
        #50;
        
        // 2. Release the reset so the CPU starts executing your C code
        force uut.resetn = 1;

        // 3. Give it plenty of time to run, then stop
        #500000;
        $display("\n--- Simulation Complete ---");
        $finish;
    end

    // Generate a clock signal
    always #5 clk = ~clk;

endmodule