// Busy polling logic analyzer
// Will probably miss stuff when sending serial

#include <stdio.h>
#include <avr/io.h>
#include <Arduino.h>

#define I2C_PORT PORTB
#define I2C_DDR  DDRB
#define I2C_SCL  1     // B1 = 15
#define I2C_SDA  3     // B3 = 14

#define ANA_BUFSIZE 256

void ana_read(void)
{
  uint8_t buf[ANA_BUFSIZE];
}
