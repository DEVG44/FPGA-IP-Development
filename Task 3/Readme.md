# Task-3: Design a Multi-Register GPIO IP with Software Control

## Objective

Extend the simple GPIO IP from Task-2 into a realistic, multi-register, software-controlled IP, similar to what exists in production SoCs.

This task focuses on:
- Designing a proper register map
- Handling multiple registers inside one IP
- Strengthening understanding of memory-mapped I/O
- Validating end-to-end control from software to hardware


## IP to be Built

### IP Name: GPIO Control IP (Direction + Data)

- This IP will allow software to:
- Configure GPIO direction (input/output)
- Write output values
Read back GPIO state

This is a very common real-world GPIO peripheral.

## IP Specification (Fixed)

### Register Map

<img width="523" height="152" alt="image" src="https://github.com/user-attachments/assets/5386bf84-2816-4633-9089-4fe88e2ef8a3" />


## Functional Requirements

### GPIO_DATA
- Writing updates output values
- Reading returns last written value

### GPIO_DIR
- Each bit controls direction of corresponding GPIO
- 1 → output enabled
- 0 → input mode

### GPIO_READ
- Returns current GPIO pin values
- For output pins, reflects driven value
- For input pins, reflects pin state

## Task Breakdown

### Step 1: Study and Plan

Instructions:

- Review their Task-2 GPIO IP
- Identify where to add:
   - Additional registers
   - Address offset decoding
- Define internal signals clearly (data, direction, readback)

#### Step 1 Completed:- Successfully identifed changes and upgrade for Task 3.


### Step 2: Implement Multi-Register RTL 

Instructions:

- Extend the GPIO IP RTL to support:
   - Multiple registers
   - Address offset decoding

- Ensure:
  - Clean synchronous logic
  - No unintended latch behavior
  - Correct write and read handling

Extended Multi Register RTL:-

```
`default_nettype none

module gpio_ip (
    input  wire        clk,
    input  wire        rst,       
    input  wire        valid,     
    input  wire        we,
    input  wire [3:0]  addr,      // Bottom 4 bits for register offsets
    input  wire [31:0] wdata,     
    output reg  [31:0] rdata,     
    inout  wire [31:0] gpio_io    // Bidirectional physical pins
);

    reg [31:0] gpio_data; // Offset 0x00
    reg [31:0] gpio_dir;  // Offset 0x04

    // Tristate buffer for bidirectional IO
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gpio_drv
            assign gpio_io[i] = gpio_dir[i] ? gpio_data[i] : 1'bz;
        end
    endgenerate

    // Synchronous Write Logic (Decoding Offsets)
    always @(posedge clk) begin
        if (rst) begin
            gpio_data <= 32'h0000_0000;
            gpio_dir  <= 32'h0000_0000; 
        end else if (valid && we) begin
            case (addr[3:2])
                2'b00: gpio_data <= wdata; // 0x00
                2'b01: gpio_dir  <= wdata; // 0x04
            endcase
        end
    end

    // Combinational Read Logic
    always @(*) begin
        rdata = 32'h0000_0000; 
        if (valid && !we) begin
            case (addr[3:2])
                2'b00: rdata = gpio_data; 
                2'b01: rdata = gpio_dir;  
                2'b10: rdata = gpio_io;   // 0x08
            endcase
        end
    end
endmodule
```

#### Step 2 Completed:- Successfully extended RTL and ensured required changes.

### Step 3: Integrate into the SoC 

Instructions:

- Update SoC integration logic if needed
- Ensure address decoding routes accesses correctly
- Expose GPIO signals to the top module as before

#### Upgrading the Wires for Input Support

In Task-2, the IP only pushed data out. In Task-3, WE added a Direction register and the ability to read physical inputs. We had to change the top-level wire from a one-way output to a two-way bidirectional wire.

**MODIFIED:** Changed the gpio_out wire to gpio_io.
```
// Task-2 (Old): wire [31:0] gpio_out;
// Task-3 (New): 
wire [31:0] gpio_io; // Now supports both driving LEDs and reading Buttons
```
#### Passing the Address Offsets

The new IP needs to know which internal register the CPU wants (0x00, 0x04, or 0x08). To do this, we routed the bottom 4 bits of the CPU's memory address bus directly into the IP.

**ADDED:** Wired mem_addr[3:0] to the new .addr port on our IP.

#### Consolidating the Write Strobe

The RISC-V CPU uses a 4-bit "Write Strobe" (mem_wstrb) to indicate which specific bytes of the 32-bit word are being written. To make your IP's internal logic simpler, we used a Verilog reduction operator (|) to tell the IP to write if any of those byte bits are high.

**MODIFIED:** Changed the .we port connection.

#### The Final Instantiation Block

Here is what the final updated block looks like in our riscv.v file, with the specific Task-3 changes highlighted:

```
wire [31:0] gpio_io;    // <-- CHANGED to bidirectional inout wire
    wire [31:0] gpio_rdata; 

    gpio_ip GPIO (
        .clk(clk),
        .rst(!resetn),
        .valid(gpio_valid),
        
        // <-- CHANGED: Reduction OR. High if any bit of mem_wstrb is 1.
        .we(|mem_wstrb),        
        
        // <-- ADDED: Passes offset (0x00, 0x04, 0x08) to the IP
        .addr(mem_addr[3:0]),   
        
        .wdata(mem_wdata),
        .rdata(gpio_rdata),
        
        // <-- CHANGED: Connected to the new bidirectional bus
        .gpio_io(gpio_io)       
    );
```

#### Step 3 Completed:- Successfully integrated extended RTL with required changes into the existing SOC.

### Step 4: Software Validation 

Instructions:

- Sets GPIO direction
- Writes values to GPIO_DATA
- Reads GPIO_READ
- Prints results via UART

Simulation proof is mandatory.

Expected validation:
- Direction control works
- Output updates are reflected
- Readback behaves as expected

C Program:-
```
#include <stdint.h>

void print_str(const char *str) {
    while (*str) {
        *((volatile uint32_t *)0x00400008) = *str++;
    }
}

#define GPIO_BASE 0x00400020
#define GPIO_DATA (*((volatile uint32_t*)(GPIO_BASE + 0x00)))
#define GPIO_DIR  (*((volatile uint32_t*)(GPIO_BASE + 0x04)))
#define GPIO_READ (*((volatile uint32_t*)(GPIO_BASE + 0x08)))

int main() {
    print_str("\n--- Starting Multi-Register GPIO Test ---\n");

    GPIO_DIR = 0xFFFFFFFF; // Set as outputs
    print_str("Direction Register (0x04) configured as outputs.\n");

    uint32_t test_val = 0x87654321;
    GPIO_DATA = test_val;
    print_str("Data Register (0x00) written with 0x87654321.\n");

    uint32_t readback = GPIO_READ;
    if (readback == test_val) {
        print_str("SUCCESS: Physical pins (0x08) match the driven data!\n");
    } else {
        print_str("ERROR: Readback mismatch.\n");
    }
    
    print_str("--- Test Complete ---\n");
    while(1); 
    return 0;
}

```

Simulation:-
<img width="1918" height="972" alt="1" src="https://github.com/user-attachments/assets/68df0991-0db1-40b3-9cde-13a1a7c96cf8" />

Waveform:-
<img width="1918" height="975" alt="2" src="https://github.com/user-attachments/assets/adfe154c-2d18-4d05-ad83-3de037dd5bdc" />

#### Step 4 Completed:- Successfully simulated the new IP and obtained waveform.
