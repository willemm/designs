#include "i2c.h"
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>

#define I2C_SDA  0
#define I2C_SCL  2
#define I2C_PORT PORTB
#define I2C_DDR  DDRB
#define I2C_PIN  PINB

#define cbi(p,b) asm volatile ( "cbi %[port], %[bit] \n\t" :: [port] "I" (_SFR_IO_ADDR(p)),[bit] "I" (b) )
#define sbi(p,b) asm volatile ( "sbi %[port], %[bit] \n\t" :: [port] "I" (_SFR_IO_ADDR(p)),[bit] "I" (b) )
#define SDA_HI() cbi(I2C_DDR,I2C_SDA)
#define SCL_HI() cbi(I2C_DDR,I2C_SCL)
#define SDA_LO() sbi(I2C_DDR,I2C_SDA)
#define SCL_LO() sbi(I2C_DDR,I2C_SCL)

#define I2C_ERROR(rv) i2c_stop_condition(); return (rv);
// #define I2C_ERROR(rv)

void i2c_setup(void)
{
    // SDA_HI and SCL_HI set pins to input
    // so the pullups can pull them high.
    SDA_HI();
    SCL_HI();
    // Set the pin values to low.
    // This means no internal pullups, but driving low is done by setting the pin DDR to output
    cbi(I2C_PORT,I2C_SCL);
    cbi(I2C_PORT,I2C_SDA);
}

// Start condition: SDA transition high to low while SCL is high
static void i2c_start_condition()
{
    SDA_HI();
    SCL_HI();
    _delay_us(5);
    SDA_LO();
    _delay_us(5);
    SCL_LO();
}

// Stop condition: SDA transition low to high while SCL is high
static void i2c_stop_condition()
{
    SDA_LO();
    _delay_us(5);
    SCL_HI();
    _delay_us(5);
    SDA_HI();
    _delay_us(5);
}

// Write a byte and wait for ack
static inline unsigned char i2c_write_byte(unsigned char b)
{
    unsigned char i;
    // When entering, clock line will already be low (end of ack, or start condition)
    // Write high to low bits
    for (i = 0x80; i; i >>= 1) {
        if (b & i) {
            SDA_HI();
        } else {
            SDA_LO();
        }
        // Wait for line to stabilize
        _delay_us(3);
        // Rising edge to signal data bit
        SCL_HI();
        // Wait for receiver to sample bit
        _delay_us(3);
        // Also wait for clock line to actually go high (clock stretching)
        while (!(I2C_PIN & (1 << I2C_SCL))) { /* Wait */ }
        // End cycle, drive clock low again
        SCL_LO();
        // Another 3 microseconds makes about 10 per loop, so 100khz-ish.
        _delay_us(3);
    }
    // Release data line to wait for ack
    SDA_HI();
    _delay_us(3);
    // Release clock line
    SCL_HI();
    _delay_us(3);
    // Wait for clock stretching
    while (!(I2C_PIN & (1 << I2C_SCL))) { /* Wait */ }
    unsigned int a = (I2C_PIN & (1 << I2C_SDA));
    // Another 3 microseconds
    _delay_us(3);
    SCL_LO();
    return (a ? 1 : 0);
}

// Read a byte and send ack or nack
static unsigned char i2c_read_byte(unsigned char ack)
{
    unsigned char i, b;
    // Release data line
    SDA_HI();
    _delay_us(3);
    b = 0;
    // Read bit by bit
    for (i = 0x80; i; i >>= 1) {
        // Rising edge starts clock pulse
        SCL_HI();
        _delay_us(3);
        // Check for clock stretch
        while (!(I2C_PIN & (1 << I2C_SCL))) { /* Wait */ }
        // Read bit
        if (I2C_PIN & (1 << I2C_SDA)) {
            b |= i;
        }
        _delay_us(3);
        // End clock pulse
        SCL_LO();
        _delay_us(3);
    }
    // Pull data low to send ack.  Or not.
    if (ack) SDA_LO();
    else SDA_HI();
    _delay_us(3);
    // Send clock pulse
    SCL_HI();
    _delay_us(3);
    // Wait for clock stretch
    while (!(I2C_PIN & (1 << I2C_SCL))) { /* Wait */ }
    _delay_us(3);
    // End clock pulse
    SCL_LO();
    _delay_us(3);
    return b;
}

// Send a number of bytes over the bus
char i2c_write_bytes(unsigned char addr, const unsigned char *msg, unsigned char msg_size)
{
    i2c_start_condition();
    if (i2c_write_byte(addr << 1)) {
        I2C_ERROR(-0x01);
    }
    while (msg_size--) {
        if (i2c_write_byte(*msg++)) {
            I2C_ERROR(-0x04);
        }
    }
    i2c_stop_condition();
    return 0;
}

// Send register address and one byte
char i2c_write_reg_u8(unsigned char addr, unsigned char reg, unsigned char data)
{
    i2c_start_condition();
    if (i2c_write_byte(addr << 1)) {
        I2C_ERROR(-0x01);
    }
    if (i2c_write_byte(reg)) {
        I2C_ERROR(-0x02);
    }
    if (i2c_write_byte(data)) {
        I2C_ERROR(-0x04);
    }
    i2c_stop_condition();
    return 0;
}

// Read one byte from register address
int i2c_read_reg_u8(unsigned char addr, unsigned char reg)
{
    i2c_start_condition();
    if (i2c_write_byte(addr << 1)) {
        I2C_ERROR(-0x10);
    }
    if (i2c_write_byte(reg)) {
        I2C_ERROR(-0x20);
    }
    i2c_start_condition();
    if (i2c_write_byte((addr << 1) | 1)) {
        I2C_ERROR(-0x40);
    }
    unsigned char data = i2c_read_byte(0);
    i2c_stop_condition();
    return data;
}

/*
// Start batch read from register address
char i2c_write_reg_start(unsigned char addr, unsigned char reg)
{
    i2c_start_condition();
    if (i2c_write_byte(addr << 1)) {
        I2C_ERROR(-0x10);
    }
    if (i2c_write_byte(reg)) {
        I2C_ERROR(-0x20);
    }
    return 0;
}

// Read one byte in batch
uint8_t i2c_write_u8(unsigned char data, char last)
{
    i2c_write_byte(data);
    if (last) i2c_stop_condition();
    return data;
}
*/

// Start batch read from register address
char i2c_read_reg_start(unsigned char addr, unsigned char reg)
{
    i2c_start_condition();
    if (i2c_write_byte(addr << 1)) {
        I2C_ERROR(-0x10);
    }
    if (i2c_write_byte(reg)) {
        I2C_ERROR(-0x20);
    }
    i2c_start_condition();
    if (i2c_write_byte((addr << 1) | 1)) {
        I2C_ERROR(-0x40);
    }
    return 0;
}

// Read one byte in batch
uint8_t i2c_read_u8(char last)
{
    unsigned char data = i2c_read_byte(!last);
    if (last) i2c_stop_condition();
    return data;
}

// Read two bytes in batch (big-endian)
uint16_t i2c_read_u16(char last)
{
    unsigned char hi = i2c_read_byte(1);
    unsigned char lo = i2c_read_byte(!last);
    if (last) i2c_stop_condition();
    return (hi << 8) | lo;
}

// Functions to output debug data
// Use snprintf to generate string to send as data
void i2c_printf(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    static char s[128];

    unsigned char ln = vsnprintf(s, sizeof(s), fmt, args);
    i2c_write_bytes(0x08, (unsigned char *)s, ln);
    va_end(args);
}

// Send a string
void i2c_print(const char *txt)
{
    i2c_write_bytes(0x08, (unsigned char *)txt, strlen(txt));
}


/*
S 00010000 1 N = 10 = 08<<1 = dbg
T

S 11010000 0 A = d0 = 68<<1 = mcp  (dus hij ackt wel?)
  01101011 0 A = 6b = PWR_MGMT_1   (weer ack)
  10000000 0 A = 80 = reset
T

S 00010000 1 N = dbg
T

S 11010000 0 A = mcp
  00111011 0 A = 3b = ACCEL_XOUT
S 11010001 0 A = mcp read
  00000000 1 N = 0 (bad, should be ack)
  11111111 0 A = ff (mcp is probably not responding any more)



*/
