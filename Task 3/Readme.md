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

<img width="526" height="155" alt="image" src="https://github.com/user-attachments/assets/9343f45c-3888-4245-97b6-0388076e7fa3" />

Base address will be assigned or reused from Task-2.

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
