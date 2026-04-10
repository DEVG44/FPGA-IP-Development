`timescale 1ns/1ps

module riscv_tb;

reg clk = 0;
reg RESET = 1;
wire TXD;
reg RXD = 1;
wire [4:0] LEDS;

// Instantiate SOC
SOC uut (
    .RESET(RESET),
    .LEDS(LEDS),
    .RXD(RXD),
    .TXD(TXD)
);

// Clock generation (10ns period → 100 MHz for simulation)
always #5 clk = ~clk;

// Force clock into SOC (since FPGA clock is disabled in BENCH)

    initial begin
    force uut.clk_int = clk;   // override internal oscillator
end


// Reset sequence
initial begin
    RESET = 1;
    #200;
    RESET = 0;
end

// Dump waveform (optional)
initial begin
    $dumpfile("soc.vcd");
    $dumpvars(0, riscv_tb);
end

// ---------------- UART DECODER ----------------
// Assumes ~9600 baud, simulation clock ~100 MHz

integer i;
reg [7:0] rx_byte;

initial begin
    forever begin
        // Wait for start bit (TXD goes LOW)
        @(negedge TXD);

        // Wait half bit time
        #52000;

        // Sample 8 bits
        for (i = 0; i < 8; i = i + 1) begin
            #104000;
            rx_byte[i] = TXD;
        end

        // Wait stop bit
        #104000;

        // Print character
        $write("%c", rx_byte);
    end
end
// ------------------------------------------------

// Run simulation long enough for UART output
initial begin
    #50000000;   // VERY IMPORTANT (UART is slow)
    $finish;
end

endmodule