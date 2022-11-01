#include <stdint.h>
#include <avr/io.h>
#include "neopixel.h"

#define PIXEL_PORT  PORTB  // Port of the pin the pixels are connected to
#define PIXEL_DDR   DDRB   // Port of the pin the pixels are connected to
#define PIXEL_BIT   2      // Bit of the pin the pixels are connected to

// These are the timing constraints taken mostly from the WS2812 datasheets 
// These are chosen to be conservative and avoid problems rather than for maximum throughput 

#define T1H  900    // Width of a 1 bit in ns
#define T1L  600    // Width of a 1 bit in ns

#define T0H  400    // Width of a 0 bit in ns
#define T0L  900    // Width of a 0 bit in ns

// Older pixels would reliabily reset with a 6us delay, but some newer (>2019) ones
// need 250us. This is set to the longer delay here to make sure things work, but if
// you want to get maximum refresh speed, you can try decreasing this until your pixels
// start to flicker. 

#define RES 250000    // Width of the low gap between bits to cause a frame to latch

// Here are some convience defines for using nanoseconds specs to generate actual CPU delays

#define NS_PER_SEC (1000000000L)          // Note that this has to be SIGNED since we want to be able to check for negative values of derivatives

#define CYCLES_PER_SEC (F_CPU)

#define NS_PER_CYCLE ( NS_PER_SEC / CYCLES_PER_SEC )

#define NS_TO_CYCLES(n) ( (n) / NS_PER_CYCLE )

static inline void sendBits(uint8_t bits)
{
    for (uint8_t b = 1<<7; b > 0; b >>= 1) {
        if (bits & b) {
            asm volatile (
                    "sbi %[port], %[bit] \n\t"
                    ".rept %[onCycles] \n\t"
                    "nop \n\t"
                    ".endr \n\t"
                    "cbi %[port], %[bit] \n\t"
                    ".rept %[offCycles] \n\t"
                    "nop \n\t"
                    ".endr \n\t"
                    ::
                    [port]		"I" (_SFR_IO_ADDR(PIXEL_PORT)),
                    [bit]		"I" (PIXEL_BIT),
                    [onCycles]	"I" (NS_TO_CYCLES(T1H) - 2),
                    [offCycles] 	"I" (NS_TO_CYCLES(T1L) - 2)

            );
        } else {
            asm volatile (
                    "cli \n\t"
                    "sbi %[port], %[bit] \n\t"
                    ".rept %[onCycles] \n\t"
                    "nop \n\t"
                    ".endr \n\t"
                    "cbi %[port], %[bit] \n\t"
                    "sei \n\t"
                    ".rept %[offCycles] \n\t"
                    "nop \n\t"
                    ".endr \n\t"
                    ::
                    [port]		"I" (_SFR_IO_ADDR(PIXEL_PORT)),
                    [bit]		"I" (PIXEL_BIT),
                    [onCycles]	"I" (NS_TO_CYCLES(T0H) - 2),
                    [offCycles]	"I" (NS_TO_CYCLES(T0L) - 2)

            );
        }
    }
}
  
void neopixel_setup()
{
    PIXEL_DDR |= (1 << PIXEL_BIT);
}

void neopixel_send(color_t color)
{
    sendBits(color.g);
    sendBits(color.r);
    sendBits(color.b);
}
