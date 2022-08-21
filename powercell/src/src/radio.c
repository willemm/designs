#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>

#include "radio.h"
#include "i2c_master.h"

#define RADIO_PIN 3
#define RADIO_BUFSIZE 256

// Time between rising and falling edges.
// A check in the isr makes sure the falling edges go in even slots
// Prescaler 1024 with a clock of 8mhz, so each count is about 128 microseconds
//
// Protocol seems to start with a 9000us high followed by 4500us low
// Which is about 70 counts high followed by 35 counts low
//
// NEC protocol: pulses of 560us.  10 = logic 0, 1000 = logic 1
// One pulse is 4 counts
//
// logic 0: ____
//         |    |____|
//
// logic 1: ____
//         |    |____________|
//
// So (always looking from even slots), logic 0 is 4+4, while logic high is 4+12
//
// Practical read:
// 
// 02-4b 08-01 03-06 08-01 03-06 07-01 03-06 07-02 07-02 07-02 07-02 07-02 07-02 02-07 07-02 02-07 07-02 02-07 07-02 07-02 02-07 07-02 02-07 02-07 02-07
//
// Which is 50 edge changes, or 25 pulses.  I'm guessing preamble + 24 bits.
//
// Doesn't look like NEC ??
//
// Let's try to decode:
// 71 counts high - let's guess preamble
//
// 101010111111010101101000
// 
// 
// TODO ....
//
// Another practical read ??
//
// 02-4b 08-01 03-06 08-01 03-06 07-01 02-06 07-02 07-02 07-02 07-02 07-02 07-02 02-07 07-02 02-07 07-02 02-07 07-02 07-02
//
// 02-4b seems like preamble
// 1010101111110101011
//
// 19 bits ???
// 
// As bits:
// 10101011-11110101-01101000 10111111-01010110-1000
// 10101011-11110101-01101000
// 

static volatile uint8_t times[RADIO_BUFSIZE];
static volatile uint8_t timeidx;

// Turn off timer on overflow
ISR(TIMER0_OVF_vect)
{
    TCCR0B = 0;  // Disable timer
    TCNT0 = 0;   // Set to 0
}

// Store timer value and start timer
ISR(PCINT0_vect)
{
    if ((timeidx & 1) != ((PINB >> RADIO_PIN) & 1)) {
        // If not in sync, skip and write 0
        times[timeidx] = 0;
        timeidx = (timeidx+1) % RADIO_BUFSIZE;
        times[timeidx] = 0;
        timeidx = (timeidx+1) % RADIO_BUFSIZE;
    } else {
        times[timeidx] = TCNT0;
        timeidx = (timeidx+1) % RADIO_BUFSIZE;
    }
    TCCR0B = 0b00000101;  // Prescaler 1/1024
    TCNT0 = 0;
    GTCCR |= (1 << PSR0); // Reset prescaler
}

static uint8_t timeptr;

void radio_setup(void)
{
    DDRB &= ~(1 << RADIO_PIN);
    PORTB |= (1 << RADIO_PIN);
    timeidx = 0;
    timeptr = 0;
    TCCR0A = 0;
    TCCR0B = 0;  // Disable timer for now
    TIMSK = (1 << TOIE0); // Timer overflow interrupt
    GIMSK |= (1 << PCIE);
    PCMSK = (1 << RADIO_PIN);
}

void radio_read(void)
{
    static const char *hex = "0123456789abcdef";
    uint8_t ti = timeidx;
    uint8_t tp = timeptr;
    // Round down to even
    if (tp % 2) tp--;
    if (ti % 2) ti--;
    unsigned char s[128];
    while (tp != ti) {
        if (times[tp+1] < 24) {
            // Eat garbage data up to large high pulse
            while ((times[tp+1] < 24) && (tp != ti)) {
                tp = (tp + 2) % RADIO_BUFSIZE;
            }
        } else {
            uint8_t data[4] = { 0, 0, 0, 0 };
            uint8_t i = 0;
            uint8_t didx = 0;
            uint16_t b = 1;
            s[i++] = '>';
            tp = (tp + 2) % RADIO_BUFSIZE;
            while (i < (32+1)) {
                uint8_t v1 = times[tp];
                uint8_t v2 = times[tp+1];
                if (v2 >= 24) break; // Short read
                if ((v1 < 5) && (v2 > 5)) {
                    b = (b << 1) | 0;
                    s[i++] = '0';
                } else if ((v1 > 5) && (v2 < 5)) {
                    b = (b << 1) | 1;
                    s[i++] = '1';
                } else {
                    s[i++] = '?';
                    break; // Garbage read
                }
                if (b >= 0x100) { data[didx++] = (b & 0xFF); }

                tp = (tp + 2) % RADIO_BUFSIZE;
                if (tp == ti) {
                    // Not enough data, retry later
                    // Purposefully skip assigning tp back to timeptr
                    return;
                }
            }
            if (i == (24 + 1)) {
                s[i++] = ' ';
                s[i++] = '=';
                s[i++] = ' ';
                s[i++] = hex[(data[0] >> 4) & 0xF];
                s[i++] = hex[(data[0] >> 0) & 0xF];
                s[i++] = hex[(data[1] >> 4) & 0xF];
                s[i++] = hex[(data[1] >> 0) & 0xF];
                s[i++] = hex[(data[2] >> 4) & 0xF];
                s[i++] = hex[(data[2] >> 0) & 0xF];
            } else {
                s[0] = '!';
            }
            if (i > 20) {
                I2C_Master_Write_Data(0x08, s, i);
            }
        }
    }
    timeptr = tp;
}
