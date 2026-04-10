`default_nettype none

module gpio_ip (
    input  wire        clk,
    input  wire        rst,       
    input  wire        valid,     
    input  wire        we,
    input  wire [3:0]  addr,      // NEW: Bottom 4 bits of CPU address for offsets
    input  wire [31:0] wdata,     
    output reg  [31:0] rdata,     // CHANGED: Now a reg so we can use it in an always block
    inout  wire [31:0] gpio_io    // CHANGED: Bidirectional inout for physical pins
);

    // Internal Registers
    reg [31:0] gpio_data; // Offset 0x00
    reg [31:0] gpio_dir;  // Offset 0x04

    // 1. Tristate buffer for bidirectional IO (Per-bit direction control)
    // If dir=1 (Output), drive the pin with data. If dir=0, set to High-Z (Input).
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gpio_drv
            assign gpio_io[i] = gpio_dir[i] ? gpio_data[i] : 1'bz;
        end
    endgenerate

    // 2. Synchronous Write Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_data <= 32'h0000_0000;
            gpio_dir  <= 32'h0000_0000; // Default to inputs (0) for electrical safety
        end else if (valid && we) begin
            // Look at bits [3:2] to decode 0x00, 0x04, and 0x08
            case (addr[3:2])
                2'b00: gpio_data <= wdata; // Write to 0x00
                2'b01: gpio_dir  <= wdata; // Write to 0x04
                // Note: 0x08 is read-only, so we ignore writes to it
            endcase
        end
    end

    // 3. Combinational Read Logic (Multiplexer)
    always @(*) begin
        rdata = 32'h0000_0000; // Default to 0 to prevent latches
        
        if (valid && !we) begin
            case (addr[3:2])
                2'b00: rdata = gpio_data; // Read what we set as output
                2'b01: rdata = gpio_dir;  // Read direction config
                2'b10: rdata = gpio_io;   // Read actual physical pin states (Offset 0x08)
            endcase
        end
    end

endmodule