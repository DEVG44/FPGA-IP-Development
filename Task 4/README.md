# Task-4: Real Peripheral IP Development

## Objective

In this task, selected participants will individually own and build a real SoC peripheral IP, similar to how work is distributed in semiconductor and FPGA teams.

Each IP will be:
- Designed as a memory-mapped peripheral
- Integrated into the existing RISC-V SoC
- Validated through software and simulation
- Optionally validated on VSDSquadron FPGA hardware
- This task marks the transition from learning exercises to actual IP ownership and contribution.

# Task Structure

This is a distributed task.

- Each selected participant is assigned one IP
- Each participant is the owner of that IP
- Ownership includes design, implementation, integration, and validation

This mirrors how real engineering teams operate.

# Assigned Ips:- SPI Master (Minimal)

Each IP must include:
1. Register Map
    -Clearly defined base address and offsets
    -Read/write behavior specified

2. RTL Implementation
   - Clean, synchronous Verilog
   - Proper reset behavior
   - No hard-coded magic values

3. SoC Integration
   - Correct address decoding
   - Connection to CPU bus
   - Exposure of required signals

4. Software Validation
   - Small C program running on the RISC-V core
   - Demonstrates IP functionality
   - Output visible via UART or observable behavior

5. Simulation Proof
   - Successful simulation log or waveform
   - Confirms end-to-end functionality

6. Documentation
   - Short README explaining:
       - What the IP does
       - Register description
       - How software controls it


# Hardware Validation

Instructions:-

- Synthesize and program the design
- Validate the IP using:
    - LEDs
    - UART logs
    - External simple peripherals (if applicable)
    - 
Hardware validation is mandatory for task completion.

# Specifications

## SPI Master IP Spec (Minimal, Single-Byte, Mode 0)

### Purpose

A minimal SPI master to transmit/receive 8-bit data in Mode 0 (CPOL=0, CPHA=0). Focus on basic functionality and clean interface.

### Signals

- SCLK output
- MOSI output
- MISO input
- CS_N output (active low)

### Bus Interface

Memory-mapped, 32-bit, word-aligned.

### Register Map

Base: SPI_BASE

<img width="411" height="157" alt="image" src="https://github.com/user-attachments/assets/13fd0ca9-4918-4f13-b234-88cff5de028b" />

##### CTRL (0x00)

- Bit 0: EN (1 = enable SPI block)
- Bit 1: START (writing 1 triggers a transfer if not busy; auto-clear internally)
- Bits [15:8]: CLKDIV (SCLK divider; SCLK toggles every (CLKDIV+1) cycles)

 Other bits reserved.

##### TXDATA (0x04)

- Bits [7:0] used; writing loads transmit shift register.

##### RXDATA (0x08)

- Bits [7:0] contain received byte from last completed transfer.

##### STATUS (0x0C)

- Bit 0: BUSY (1 while transfer in progress)
- Bit 1: DONE (1 when transfer finished; stays 1 until cleared)
- Writing 1 to DONE clears it (write-1-to-clear)

 Optional: Bit 2 TX_READY (1 when not busy)

#### Transfer Behavior (Mode 0)
CS_N goes low at start of transfer and returns high at end.
Shift out on MOSI on falling edge, sample MISO on rising edge (Mode 0 standard).
Transfer length: exactly 8 bits.

#### Minimal Requirements

- One transfer at a time.
- Ignore new START while BUSY=1.
- DONE must be set at end of transfer.

#### Validation Requirements

Simulation:

- Use MISO loopback (tie MISO=MOSI in testbench)
- Write TXDATA = 0xA5, START, wait DONE, read RXDATA, verify RXDATA == 0xA5.

C test:

- Configure CLKDIV
- Write TXDATA
- Start transfer
- Poll DONE
- Read RXDATA and print via UART

Mandatory board demo:

- If no external SPI device available, do loopback with a jumper MOSI->MISO (optional).
- Show TX/RX match.


