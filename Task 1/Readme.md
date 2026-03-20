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

Succesfully displayed version infomration for each tool.


#### Step 4. Run Your First Program

- Go to the samples folder.
- Compile the program:
 
  ```
  riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
  ```
- Run it with Spike:

```
 spike pk sum1ton.o
```

Expected output:

```
Sum from 1 to 9 is 45
```

<img width="1918" height="972" alt="3" src="https://github.com/user-attachments/assets/a11c1159-36c0-4b90-83cc-c8e51edba6f9" />

Succesfully ran the code and also changed value.

#### Step 5. Next Steps

- You can edit and run your own C programs.
- You can also try Verilog programs using iverilog.

<img width="1918" height="972" alt="5" src="https://github.com/user-attachments/assets/8c6126c6-9754-4e6e-88c1-df478515b1e4" />

Successfully ran Verilog program using IVerilog.

Working with GUI Desktop (noVNC) – Advanced

The following steps show how to use a full Linux desktop inside your Codespace and run the same RISC-V programs there.

#### Step 6. Launch the noVNC Desktop

- In your Codespace, click the PORTS tab.
- Look for the forwarded port named noVNC Desktop (6080).
- Click the Forwarded Address link.
- A new browser tab opens with a directory listing. Click vnc_lite.html.

<img width="1918" height="967" alt="6 1" src="https://github.com/user-attachments/assets/616f5f77-603d-4f41-bd22-6bcc1b35fcae" />

- The Linux desktop appears in your browser.

<img width="1918" height="967" alt="6 2" src="https://github.com/user-attachments/assets/7d5ccce3-1913-4f3d-b52d-a9447c5861de" />

#### Step 7. Open a Terminal Inside the Desktop

- Right-click anywhere on the desktop background.
- Select Open Terminal Here.

A terminal window will open on the desktop.

#### Step 8. Navigate to the Sample Programs

In the terminal, go to the workspace and then to the samples folder:
```
cd /workspaces/vsd-riscv2
cd samples
ls -ltr
```
You should see files like sum1ton.c, 1ton_custom.c, load.S, and Makefile.

<img width="1918" height="970" alt="7" src="https://github.com/user-attachments/assets/05df6030-9b91-4bd1-8c31-d7569114332b" />

#### Step 9. Compile and Run Using Native GCC (x86)

First, compile and run the C program with the standard gcc compiler:
```
gcc sum1ton.c
./a.out
```
Expected output:
```
Sum from 1 to 9 is 45
```
<img width="1918" height="972" alt="9" src="https://github.com/user-attachments/assets/fd2fff9e-fe8e-40dd-a947-2dcaedf8c778" />

#### Step 10. Compile and Run Using RISC-V GCC and Spike

Now compile the same program for RISC-V and run it on the Spike ISA simulator:
```
riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
spike pk sum1ton.o
```
You will see the proxy kernel (pk) messages and then the program output.

<img width="1918" height="971" alt="10" src="https://github.com/user-attachments/assets/7d741bef-16e5-486d-aa41-62d90bed37b4" />

#### Step 11. Edit the C Program Using gedit (GUI Editor)

To edit the program using a graphical editor:

```
gedit sum1ton.c &
```

<img width="1918" height="970" alt="11 1" src="https://github.com/user-attachments/assets/5102d844-e957-4ed5-a69c-df2c903eff71" />

Make changes (for example, change n = 9; to another value), save the file, and re-run:

```
riscv64-unknown-elf-gcc -o sum1ton.o sum1ton.c
spike pk sum1ton.o
```

<img width="1918" height="975" alt="11 2" src="https://github.com/user-attachments/assets/309d9071-53bf-4798-89c9-6c8b896ee716" />

You have now:

- Launched a full Linux desktop inside GitHub Codespaces
- Compiled and executed a C program with native GCC
- Compiled and executed the same program on a RISC-V target using Spike
- Edited and rebuilt the code using a GUI editor over noVNC
- You’re ready to explore more RISC-V and Verilog labs in this Codespace.


**Step 2 Complete:- Succesfully verified RISC-V Reference Flow.**


### Step 3: Clone and Run VSDFPGA Labs

Once the RISC-V reference flow works, clone the FPGA labs repository inside the same Codespace:

```
git clone https://github.com/vsdip/vsdfpga_labs.git
cd vsdfpga_labs
```

Follow the README instructions in vsdfpga_labs to:

Build and run the basic lab(s) that do not require FPGA hardware
- Verify successful execution through simulation or logs
- This step validates:
  - Multi-repository workflow
  - Readiness for IP and SoC-level tasks

<img width="1918" height="917" alt="12 1" src="https://github.com/user-attachments/assets/4df0c082-31d9-4c96-b913-62da3b3c9e10" />

#### VSDSquadron FPGA mini Lab: Basic Message Display on RISC-V core

###### Prerequisites
Install the following tools before proceeding:

###### General dependencies

```
sudo apt-get install git vim autoconf automake autotools-dev curl libmpc-dev \
libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
patchutils bc zlib1g-dev libexpat1-dev gtkwave picocom -y
```


###### FPGA toolchain (Yosys/NextPNR/IceStorm)
```
sudo apt-get install yosys nextpnr-ice40 icestorm iverilog -y
```
###### RISC-V Toolchain (GCC 8.3.0)

```
cd ~
mkdir -p riscv_toolchain && cd riscv_toolchain
wget "https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14.tar.gz"
tar -xvzf riscv64-unknown-elf-gcc-*.tar.gz
echo 'export PATH=$HOME/riscv_toolchain/riscv64-unknown-elf-gcc-8.3.0-2019.08.0-x86_64-linux-ubuntu14/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

<img width="1918" height="921" alt="14" src="https://github.com/user-attachments/assets/3e39089a-22f1-4ba3-8801-c853505b656a" />

##### Building & Running

Building the file

```
git clone https://github.com/vsdip/vsdfpga_labs.git
cd vsdfpga_labs/basicRISCV/Firmware
make riscv_logo.bram.hex
```
<img width="1918" height="972" alt="15 1" src="https://github.com/user-attachments/assets/7b01d2df-adc2-4e8c-83c1-1c4740c6b4bc" />


Compiling and Running the file

```
riscv64-unknown-elf-gcc -o riscv_logo riscv_logo.c
spike pk riscv_logo
```

<img width="1918" height="975" alt="15 2" src="https://github.com/user-attachments/assets/5a40b63e-67bd-4e0d-88ad-83717d6a8abb" />


**Step 3 Complete:- Succesfully Cloned and Tested VSDFPGA Labs.**

### Step 4: Local Machine Preparation 


#### Instruction 1:- 

Setup the enivornment for RISC-V Devoplemnt on local machine as per the docker file.

<img width="1920" height="1053" alt="image" src="https://github.com/user-attachments/assets/99107644-712d-4d70-809b-def4f8a5398e" />

#### Instruction 2:- 

Cloneed both repositories locally:
- vsd-riscv2
- vsdfpga_labs

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2948e98b-be6a-4319-affc-4ae21a29643b" />



**Step 4 Complete:- Succesfully Completed Local Machine Preparation.**



## Understanding Check

#### Q1. Where is the RISC-V program located in the vsd-riscv2 repository?

The program is in the **samples** directory of the vsd-riscv2 repository, where we have files that are used to test the proper working of the RISC-V environment.

#### Q2. How is the program compiled and loaded into memory?

The program is compiled using our toolchain command 

```
riscv64-unknown-elf-gcc main.c -o program
```

This makes a RISC-V executable (ELF format) file.

Then it is loaded into memory using spike with this command

```
spike pk program
```

This makes a pk (proxy kernel) load our ELF file and set it up into our memory.

Then it executes it so we can simulate it in our terminal.


#### Q3. How does the RISC-V core access memory and memory-mapped IO?

#### Q4. Where would a new FPGA IP block logically integrate in this system?

