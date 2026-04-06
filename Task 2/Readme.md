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
- 
### Interface

- Memory-mapped, connected to the existing CPU bus
- Uses the same bus signals already present in the SoC

### Address Map (example)
- Base address assigned by mentor (e.g. 0x2000_0000)
- Offset 0x00 → GPIO output register
