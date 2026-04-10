#include <stdint.h>
#include <stdbool.h>

// Helper function to print strings over UART
void print_str(const char *str) {
    while (*str) {
        *((volatile uint32_t *)0x00400008) = *str++;
    }
}

// Define pointers to our 3 registers using the base address
#define GPIO_BASE 0x00400020
#define GPIO_DATA (*((volatile uint32_t*)(GPIO_BASE + 0x00)))
#define GPIO_DIR  (*((volatile uint32_t*)(GPIO_BASE + 0x04)))
#define GPIO_READ (*((volatile uint32_t*)(GPIO_BASE + 0x08)))

int main() {
    print_str("\n--- Starting Multi-Register GPIO Test ---\n");

    // 1. Set Direction: Make all 32 pins OUTPUTS (1 = Output)
    GPIO_DIR = 0xFFFFFFFF;
    print_str("Direction Register (0x04) configured as outputs.\n");

    // 2. Write Data: Send a new magic number to the pins
    uint32_t test_val = 0x87654321;
    GPIO_DATA = test_val;
    print_str("Data Register (0x00) written with 0x87654321.\n");

    // 3. Read back the actual physical pins!
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