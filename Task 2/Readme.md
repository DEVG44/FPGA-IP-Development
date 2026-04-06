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

#### Step 1 Completed:- Analysed the riscv.v SOC file and understood the existing peripherals and registers.

### Step 2: Write the IP RTL

Instructions:

-Create a new RTL module for the GPIO IP
-Implement:
   -Register storage
   -Write logic
  -Readback logic
-Follow synchronous design principles

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
