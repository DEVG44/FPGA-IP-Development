# Task-2: Design & Integrate Your First Memory-Mapped IP

## Objective

Design a simple memory-mapped IP, integrate it into the existing RISC-V SoC, and validate it through simulation.
Participants who already have the FPGA board may additionally validate the same IP on hardware, but hardware validation is optional in this task.

## IP to be built

### IP Name: Simple GPIO Output IP (Write-Only)

This is intentionally chosen because:
- It is conceptually simple
- It introduces all core IP concepts
- It mirrors the first IP most engineers build in industry

## IP Specification 

Participants must implement the following IP exactly as specified.

### Functionality

- One 32-bit register
- Writing to the register updates an output signal
- Reading the register returns the last written value

### Interface

- Memory-mapped, connected to the existing CPU bus
- Uses the same bus signals already present in the SoC

### Address Map (example)
- Base address assigned by mentor (e.g. 0x2000_0000)
- Offset 0x00 → GPIO output register


## Task Breakdown

### Step 1: Understand the existing SoC

Instructions:

- Identify where memory-mapped peripherals are decoded
- Understand how the CPU reads/writes registers
- Locate existing simple peripherals (LED / UART)

This is reading and understanding, not coding yet.

#### Step 1 Completed:- Successfully Analysed the riscv.v SOC file and understood the existing peripherals and registers.

### Step 2: Write the IP RTL

Instructions:

- Create a new RTL module for the GPIO IP
- Implement:
   - Register storage
   - Write logic
   - Readback logic
- Follow synchronous design principles

GPIO RTL IP FILE:- 

```
`default_nettype none

module gpio_ip (
    input  wire        clk,
    input  wire        rst,       
    input  wire        valid,     
    input  wire        we,        
    input  wire [31:0] wdata,     
    output wire [31:0] rdata,     
    output wire [31:0] gpio_out   
);
    // Internal 32-bit register
    reg [31:0] gpio_reg;

    // Continuously drive the output pins and readback bus
    assign gpio_out = gpio_reg;
    assign rdata    = gpio_reg; 

    // Synchronous write logic
    always @(posedge clk) begin
        if (rst) begin
            gpio_reg <= 32'h0000_0000;
        end else if (valid && we) begin
            gpio_reg <= wdata;
        end
    end
endmodule
```

#### Step 2 Completed:- Successfully wrote the GPIO IP RTL File.

### Step 3: Integrate the IP into the SoC 

Instructions:

- Instantiate the IP in the SoC top-level
- Add address decoding
- Connect bus signals
- Expose the output signal (internally or externally)

#### Adding the IP to the Build

**Created the IP File:** Wrote the actual hardware logic in a new file named gpio_ip.v.

**Included the File in Top-Level:** Added an include directive at the very top of riscv.v.
```
// ADDED to the top of riscv.v
`include "gpio_ip.v"
```

#### Memory Mapping & Address Decoding

**Assigned the Address Bit:** Created a new parameter to define the GPIO's location on the bus.

```
// ADDED inside the SOC module
localparam IO_GPIO_bit = 3;
```

**Created the Chip-Select (Valid) Signal:** Added logic to tell the IP exactly when the CPU is trying to talk to it.

```
// ADDED inside the SOC module
assign gpio_valid = isIO & mem_wordaddr[IO_GPIO_bit];
```
#### Multiplexing the Read Data

**Injected the GPIO into the Read Mux:** We updated the existing IO_rdata assignment to route your IP's data back to the CPU.

```
// MODIFIED inside the SOC module
wire [31:0] IO_rdata = 
      mem_wordaddr[IO_GPIO_bit]      ? gpio_rdata :  // <--- WE ADDED THIS LINE
      mem_wordaddr[IO_UART_CNTL_bit] ? { 22'b0, !uart_ready, 9'b0} :
                                       32'b0;
```

#### Instantiating the Hardware
**Wired the Module:** We connected the CPU's clock, reset, write data, and write strobe directly to the IP.

```
// ADDED inside the SOC module
wire [31:0] gpio_out; // Added wire to expose pins
wire [31:0] gpio_rdata; // Added wire for readback

gpio_ip GPIO (
    .clk(clk),
    .rst(!resetn),
    .valid(gpio_valid),
    .we(mem_wstrb),
    .wdata(mem_wdata),
    .rdata(gpio_rdata),
    .gpio_out(gpio_out)
);
```

At this point, the IP is part of the system.

#### Step 3 Completed:- Successfully integrated the GPIO IP into the existing SOC.

### Step 4: Validate using Simulation 

Instructions:

- Write or reuse a small C program that:
     - Writes values to the GPIO register
     - Reads back and prints values via UART

C Program: 
```
#include <stdint.h>

// Memory map based on your 1-hot encoding
#define UART_DAT (*(volatile uint32_t*)0x00400008) // Bit 1 of word addr
#define GPIO_REG (*(volatile uint32_t*)0x00400020) // Bit 3 of word addr

void print_str(const char *str) {
    while (*str) {
        UART_DAT = *str++;
    }
}

int main() {
    uint32_t test_val = 0x12345678;
    
    print_str("\n--- Starting GPIO IP Test ---\n");

    // Write to the GPIO register
    GPIO_REG = test_val;
    print_str("Data written to GPIO.\n");
    
    // Read back from the GPIO register
    uint32_t readback = GPIO_REG;

    // Validate and print result
    if (readback == test_val) {
        print_str("SUCCESS: Readback matches 0x12345678!\n");
    } else {
        print_str("ERROR: Readback failed.\n");
    }

    print_str("--- Test Complete ---\n");

    // Infinite loop to stop execution
    while(1); 
    return 0;
}
```

- Run simulation
- Verify:
    - Correct register updates
    - Correct readback behavior


<img width="1918" height="972" alt="1" src="https://github.com/user-attachments/assets/5a2e8265-e15f-43c6-8a14-ff2b76b9b853" />
<img width="1262" height="772" alt="2" src="https://github.com/user-attachments/assets/72d994bc-7248-4fd7-9cda-24561a01d0fb" />
<img width="1918" height="975" alt="3" src="https://github.com/user-attachments/assets/15b7e50a-c415-4b48-96cb-1eac4bf85f06" />
<img width="1918" height="972" alt="4" src="https://github.com/user-attachments/assets/cc8c8449-39a0-4e7c-a8f8-1d706958ba5d" />


