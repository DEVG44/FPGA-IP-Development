`default_nettype none
`timescale 1ns/1ns

module tb_force;
    reg clk;

    // Instantiate your SoC
    // When -DBENCH is active, your SoC expects the clock on the RESET pin
    SOC uut (
        .RESET(clk),
        .RXD(1'b1)
    );

    initial begin
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