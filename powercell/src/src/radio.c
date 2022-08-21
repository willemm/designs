#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <stdio.h>

#include "radio.h"
#include "i2c.h"

#define RADIO_PIN 3

// Protocol uses time between rising and falling edges.
// long high + short low = 1, short high + long low = 0
//
// Prescaler 1024 with a clock of 8mhz, so each count is about 128 microseconds
//
// Long and short cutoff seems to be around 6 counts
//
// Our controller sends 24 bits

// Turn off timer on overflow
ISR(TIMER0_OVF_vect)
{
    TCCR0B = 0;  // Disable timer
    TCNT0 = 0;   // Set to 0
}

static uint32_t rbuf;
static uint8_t rbit;
static uint8_t rptm;
static volatile uint32_t rdata;

// Store timer value and start timer
ISR(PCINT0_vect)
{
    uint8_t pin = PINB;
    uint8_t tm = TCNT0;
    TCCR0B = 0b00000101;  // Turn on timer, prescaler 1/1024
    GTCCR |= (1 << PSR0); // Reset prescaler
    TCNT0 = 0;            // Start count from 0

    if (!(pin & (1 << RADIO_PIN))) {
        // Start of high pulse, store time of last low pulse;
        rptm = tm;
    } else {
        // End of high pulse
        if (tm > 24) {
            if ((rbit >= 24) && (rbit <= 32)) {
                rdata = rbuf;
            }
            // Long pulse, setup count
            rbit = 0;
            rbuf = 0;
        } else {
            if (rbit < 32) {
                uint8_t highlong = (rptm > 5);
                uint8_t lowlong  = (tm > 5);
                if (highlong == lowlong) {
                    // long-long or short-short is garbage
                    rbit = 255; // Garbage
                    return;
                }
                rbuf = (rbuf << 1) | (highlong & 1);
                rbit++;
            }
        }
    }
}

void radio_setup(void)
{
    DDRB &= ~(1 << RADIO_PIN);
    PORTB |= (1 << RADIO_PIN);
    rbit = 255;
    rdata = 0;
    TCCR0A = 0;
    TCCR0B = 0;  // Disable timer for now
    TIMSK = (1 << TOIE0); // Timer overflow interrupt
    GIMSK |= (1 << PCIE);
    PCMSK = (1 << RADIO_PIN);
}

static inline unsigned char hex(uint8_t v)
{
    return (v < 10) ? (v + '0') : (v + ('a' - 10));
}

uint32_t radio_read(void)
{
    uint32_t r = rdata;
    rdata = 0;
    if (r) {
        i2c_printf("Got radio: %06lx", r);
    }
    return r;
}
