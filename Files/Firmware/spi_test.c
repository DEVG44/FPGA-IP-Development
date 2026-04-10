#include <stdint.h>

// --- SPI Registers ---
#define SPI_BASE   0x00400040
#define SPI_CTRL   (*((volatile uint32_t*)(SPI_BASE + 0x00)))
#define SPI_TXDATA (*((volatile uint32_t*)(SPI_BASE + 0x04)))
#define SPI_RXDATA (*((volatile uint32_t*)(SPI_BASE + 0x08)))
#define SPI_STATUS (*((volatile uint32_t*)(SPI_BASE + 0x0C)))

// --- GPIO Registers (From Task-3!) ---
#define GPIO_BASE  0x00400020
#define GPIO_DATA  (*((volatile uint32_t*)(GPIO_BASE + 0x00)))
#define GPIO_DIR   (*((volatile uint32_t*)(GPIO_BASE + 0x04)))

int main() {
    // 1. Set GPIO pin 0 as an OUTPUT so we can drive the LED
    GPIO_DIR = 0x00000001; 
    GPIO_DATA = 0x00000000; // Start with LED OFF

    // 2. Enable SPI and set Clock Divider
    SPI_CTRL = (2 << 8) | 0x01; 

    // 3. Load the Transmit Register with our magic number
    uint32_t tx_val = 0xA5;
    SPI_TXDATA = tx_val;

    // 4. Trigger the START bit
    SPI_CTRL |= 0x02;

    // 5. Poll the DONE flag
    while (!(SPI_STATUS & 0x02));

    // 6. Read the Received Data
    uint32_t rx_val = SPI_RXDATA;

    // 7. Clear the DONE flag
    SPI_STATUS = 0x02;

    // 8. THE HARDWARE TEST: If Loopback works, TURN ON THE LED!
    if (rx_val == tx_val) {
        GPIO_DATA = 0x00000001; // BOOM! LED turns ON!
    }

    while(1);
    return 0;
}