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

