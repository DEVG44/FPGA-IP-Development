# Task-1: Environment Setup & RISC-V Reference Bring-Up

## Objective
Set up the development environment and successfully run a working RISC-V reference design, followed by running the VSDFPGA labs on the same environment.
This task focuses on:
Toolchain readiness
Understanding the RISC-V execution flow
Preparing for upcoming FPGA and IP development work


### Step 1: Set up GitHub Codespace

#### Instructions
Fork the vsd-riscv2 repository to your GitHub account.
Launch a GitHub Codespace from your fork.
Ensure the Codespace builds successfully and opens without errors.

<img width="1918" height="966" alt="1" src="https://github.com/user-attachments/assets/6f6bb8ad-c58c-4869-ab15-c698f59e0840" />

**Step 1 Complete:- Codespace built successfully.**

### Step 2: Verify RISC-V Reference Flow

Inside the vsd-riscv2 Codespace:

- Follow the README instructions in the repository.
- Build and run the provided fundamental RISC-V program.
- Observe successful execution (console output / logs).
  
Expected outcome:

- RISC-V program runs successfully
- No build or runtime errors
- Clear confirmation that the toolchain is working

Getting Started with RISC-V on GitHub Codespaces

Follow the steps below to set up and run programs in your own Codespace.

#### Step 1. Open the Repository

Go to: https://github.com/vsdip/vsd-riscv2

#### Step 2. Create a Codespace

- Log in with your GitHub account.
- Click the green Code button.
- Select Open with Codespaces → New codespace.
- Wait while the environment builds. (First time may take 10–15 minutes.)

  <img width="1918" height="966" alt="1" src="https://github.com/user-attachments/assets/d589e77e-1c4c-4df8-981a-fc77590d12b4" />

#### Step 3. Verify the Setup

In the terminal that opens, type:

```
riscv64-unknown-elf-gcc --version
spike --version
iverilog -V
```

You should see version information for each tool.
<img width="1918" height="965" alt="2 1" src="https://github.com/user-attachments/assets/59a068ef-9c5a-4514-889e-b4c2f66829fd" />
<img width="1918" height="971" alt="2 3" src="https://github.com/user-attachments/assets/d0b08b27-35bc-4e83-b7f6-818150be0e40" />


#### Step 4. Run Your First Program

- Go to the samples folder.
- Compile the program:
 
  ```
  riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
  ```
-Run it with Spike:

```
 spike pk sum1ton.o
```

Expected output:

```
Sum from 1 to 9 is 45
```

<img width="1918" height="972" alt="3" src="https://github.com/user-attachments/assets/a11c1159-36c0-4b90-83cc-c8e51edba6f9" />
