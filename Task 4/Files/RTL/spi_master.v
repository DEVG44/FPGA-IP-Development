`default_nettype none

module spi_master (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid,
    input  wire        we,
    input  wire [3:0]  addr,
    input  wire [31:0] wdata,
    output reg  [31:0] rdata,
    
    // SPI Physical Pins
    output reg         sclk,
    output reg         mosi,
    input  wire        miso,
    output reg         cs_n
);

    // Register State
    reg        ctrl_en;
    reg [7:0]  ctrl_clkdiv;
    reg [7:0]  tx_data;
    reg [7:0]  rx_data;
    reg        status_busy;
    reg        status_done;

    // Internal SPI State Machine
    reg [7:0]  clk_cnt;       // Divides the system clock
    reg [4:0]  edge_cnt;      // Counts the 16 edges (8 rising, 8 falling) of an 8-bit transfer
    reg [7:0]  tx_shift_reg;  // Holds data being shifted out
    reg [7:0]  rx_shift_reg;  // Holds data being shifted in

    // Read Logic (Combinational)
    always @(*) begin
        rdata = 32'h0000_0000;
        if (valid && !we) begin
            case (addr[3:2])
                2'b00: rdata = {16'b0, ctrl_clkdiv, 6'b0, 1'b0, ctrl_en}; // 0x00 CTRL
                2'b01: rdata = {24'b0, tx_data};                          // 0x04 TXDATA
                2'b10: rdata = {24'b0, rx_data};                          // 0x08 RXDATA
                2'b11: rdata = {30'b0, status_done, status_busy};         // 0x0C STATUS
            endcase
        end
    end

    // Write Logic & SPI State Machine (Synchronous)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctrl_en     <= 0;
            ctrl_clkdiv <= 0;
            tx_data     <= 0;
            status_busy <= 0;
            status_done <= 0;
            sclk        <= 0; // Mode 0 idles low
            cs_n        <= 1; // Active low
            mosi        <= 0;
            clk_cnt     <= 0;
            edge_cnt    <= 0;
        end else begin
            // 1. Handle CPU Writes
            if (valid && we) begin
                case (addr[3:2])
                    2'b00: begin
                        ctrl_en     <= wdata[0];
                        ctrl_clkdiv <= wdata[15:8];
                        // If START is written (bit 1) and we aren't busy, trigger transfer
                        if (wdata[1] && ctrl_en && !status_busy) begin
                            status_busy  <= 1;
                            status_done  <= 0;
                            clk_cnt      <= 0;
                            edge_cnt     <= 0;
                            tx_shift_reg <= tx_data;
                            cs_n         <= 0; // Pull CS low to start
                            mosi         <= tx_data[7]; // Setup first bit
                        end
                    end
                    2'b01: tx_data <= wdata[7:0];
                    2'b11: if (wdata[1]) status_done <= 0; // Write-1-to-clear DONE
                endcase
            end

            // 2. SPI Transfer State Machine
            if (status_busy) begin
                if (clk_cnt == ctrl_clkdiv) begin
                    clk_cnt <= 0;
                    sclk    <= ~sclk; // Toggle clock
                    edge_cnt <= edge_cnt + 1;

                    if (~sclk) begin 
                        // It was LOW, now HIGH -> Rising Edge (Sample MISO)
                        rx_shift_reg <= {rx_shift_reg[6:0], miso};
                    end else begin
                        // It was HIGH, now LOW -> Falling Edge (Shift MOSI)
                        if (edge_cnt < 15) begin
                            tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
                            mosi         <= tx_shift_reg[6]; // Setup next bit
                        end else begin
                            // Transfer complete!
                            status_busy <= 0;
                            status_done <= 1;
                            cs_n        <= 1; // Release chip select
                            rx_data     <= rx_shift_reg; // Commit received data
                        end
                    end
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
        end
    end
endmodule