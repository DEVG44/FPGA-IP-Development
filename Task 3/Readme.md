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

### Step 2: Implement Multi-Register RTL 

Instructions:

- Extend the GPIO IP RTL to support:
   - Multiple registers
   - Address offset decoding

- Ensure:
  - Clean synchronous logic
  - No unintended latch behavior
       - Correct write and read handling

