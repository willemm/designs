// I2C slave bitbanging busy-waiting
//  Can only read i2c bus, will ack on one address

#include <stdio.h>
#include <avr/io.h>
#include <Arduino.h>

#define I2C_PORT PORTB
#define I2C_PIN  PINB
#define I2C_DDR  DDRB
#define I2C_SCL  1     // B1 = 15 = SCK
#define I2C_SDA  2     // B2 = 13 = MOSI

#define I2C_ADDRESS 0x08

#define I2C_BUFSIZE 132

static inline int i2c_wait_start(void)
{
  for (;;) {
    // Wait for sda to be high
    while (!(I2C_PIN & (1 << I2C_SDA))) {
      // if (Serial.available()) { return -1; }
    }
    // Wait for sda to go low
    while ((I2C_PIN & (1 << I2C_SDA))) {
      // if (Serial.available()) { return -1; }
    }
    // Return if scl is high
    if ((I2C_PIN & (1 << I2C_SCL))) {
      return 0;
    }
  }
}

static inline int i2c_read_byte(void)
{
  int byte = 0x1;
  while (byte < 0x100) {
    int stop = I2C_PIN & (1 << I2C_SDA);
    // Wait for scl to go low
    // If sda changes while scl is high, bail out
    while ((I2C_PIN & (1 << I2C_SCL))) {
      if ((I2C_PIN & (1 << I2C_SDA)) != stop) return -1;
    }
    // Wait for scl to go high
    while (!(I2C_PIN & (1 << I2C_SCL))) {
      // Nothing
    }
    // Read bit
    byte = (byte << 1) | ((I2C_PIN >> I2C_SDA) & 1);
  }
  return byte;
}

static inline int i2c_ack(int doack)
{
  int stop = I2C_PIN & (1 << I2C_SDA);
  // Wait for scl to go low
  // If sda changes while scl is high, bail out
  while ((I2C_PIN & (1 << I2C_SCL))) {
    if ((I2C_PIN & (1 << I2C_SDA)) != stop) return -1;
  }
  if (doack) {
    // Pull sda low to ack
    I2C_DDR |= (1 << I2C_SDA);
    I2C_PORT &= ~(1 << I2C_SDA);
  }
  // Wait for scl to go high
  while (!(I2C_PIN & (1 << I2C_SCL))) {
    // Nothing
  }
  stop = I2C_PIN & (1 << I2C_SDA);
  // Wait for scl to go low
  // If sda changes while scl is high, bail out
  while ((I2C_PIN & (1 << I2C_SCL))) {
    if ((I2C_PIN & (1 << I2C_SDA)) != stop) return -1;
  }
  // Release ack
  I2C_DDR &= ~(1 << I2C_SDA);
  return 0;
}

static inline int i2c_read_line(uint8_t buf[])
{
  int b = i2c_wait_start();
  if (b < 0) return -1;
  cli();
  b = i2c_read_byte();
  int addr = b;
  int bi = 0;
  while (b >= 0) {
    if (bi < I2C_BUFSIZE) {
      buf[bi++] = b;
    }
    if (i2c_ack((addr >> 1) == I2C_ADDRESS) < 0) {
      break;
    }
    b = i2c_read_byte();
  }
  sei();
  return bi;
}

// Setup i2c listener
void i2c_read(void)
{
  uint8_t buf[I2C_BUFSIZE+1];

  // Setup pins as input
  I2C_DDR &= ~((1 << I2C_SCL) | (1 << I2C_SDA));
  // Enable pullups
  // I2C_PORT |= ((1 << I2C_SCL) | (1 << I2C_SDA));
  // Disable pullups
  I2C_PORT &= ~((1 << I2C_SCL) | (1 << I2C_SDA));

  char prt[64 + 3 * I2C_BUFSIZE];

  Serial.println("Reading i2c");
  for (;;) {
    int n = i2c_read_line(buf);
    if (n < 0) break;
    if (n > 0) {
      if ((buf[0] >> 1) == I2C_ADDRESS) {
        buf[n] = 0;
        sprintf(prt, "I2C DBG: %s", buf);
      } else {
        char *bp = prt + sprintf(prt, "Addr %02x got %d bytes:", buf[0], n);
        for (int i = 1; i < n; i++) {
          bp += sprintf(bp, " %02x", buf[i]);
        }
      }
      Serial.println(prt);
    }
  }
}


