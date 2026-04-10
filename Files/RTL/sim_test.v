`default_nettype none
`timescale 1ns/1ns

// Mock Lattice FPGA Oscillator
module SB_HFOSC #(parameter CLKHF_DIV = "0b10") (
    input CLKHFEN, input CLKHFPU, output reg CLKHF
);
    initial CLKHF = 0;
    always #5 CLKHF = ~CLKHF;
endmodule

// Mock Lattice FPGA PLL
module SB_PLL40_CORE #(
    parameter FEEDBACK_PATH = "SIMPLE", parameter PLLOUT_SELECT = "GENCLK",
    parameter DIVR = 4'b0000, parameter DIVF = 7'b0000000,
    parameter DIVQ = 3'b000, parameter FILTER_RANGE = 3'b000
) (
    input REFERENCECLK, input RESETB, input BYPASS,
    output reg PLLOUTCORE, output reg LOCK
);
    initial begin PLLOUTCORE = 0; LOCK = 1; end
    always #5 PLLOUTCORE = ~PLLOUTCORE;
endmodule

// Master Testbench
module sim_test;
    reg reset;
    wire [4:0] leds;
    wire txd;

    // Instantiate your SoC
    SOC uut (
        .RESET(reset), .LEDS(leds), .RXD(1'b1), .TXD(txd)
    );

    // Run Simulation
    initial begin
        reset = 1;        // Start in reset
        #100;
        reset = 0;        // Release reset to boot CPU
        #2000000;         // Let it run for 2 million nanoseconds
        $display("\n--- Testbench Timeout Reached ---");
        $finish;
    end

    // Snoop on the UART signals to print text without needing -DBENCH
    always @(posedge uut.clk) begin
        if (uut.uart_valid) begin
            $write("%c", uut.mem_wdata[7:0]);
            $fflush();
        end
    end
endmodule