// Busy polling logic analyzer
// Will probably miss stuff when sending serial

#include <stdio.h>
#include <avr/io.h>
#include <Arduino.h>

#define I2C_PORT PORTB
#define I2C_PIN  PINB
#define I2C_DDR  DDRB
#define I2C_SCL  1     // B1 = 15
#define I2C_SDA  3     // B3 = 14

#define ANA_NUMPINS 2

#if (ANA_NUMPINS == 3)

static const char *lbls[] = { "SCK","MISO","MOSI" };

#define ANA_PIN1 1
#define ANA_PIN2 3
#define ANA_PIN3 2

#define ANA_PINS ((1 << ANA_PIN1) | (1 << ANA_PIN2) | (1 << ANA_PIN3))

#define ANA_PINSHIFT(val) (((((val) >> ANA_PIN3) & 1) << 2) | ((((val) >> ANA_PIN2) & 1) << 1) | (((val) >> ANA_PIN1) & 1))

#else // ANA_NUMPINS == 3

static const char *lbls[] = { "SCL","SDA" };

#define ANA_PIN1 1
#define ANA_PIN2 2

#define ANA_PINS ((1 << ANA_PIN1) | (1 << ANA_PIN2))

#define ANA_PINSHIFT(val) (((((val) >> ANA_PIN2) & 1) << 1) | (((val) >> ANA_PIN1) & 1))

#endif // ANA_NUMPINS == 3

#define ANA_BUFLINE 36
#define ANA_BUFSIZE (ANA_BUFLINE * 8)

void ana_read(void)
{
  I2C_DDR &= ~ANA_PINS;
  I2C_PORT &= ~ANA_PINS;

  uint8_t buf[ANA_BUFSIZE+1];
  unsigned int st = -1;
  cli();
  for (int i = 0; i < ANA_BUFSIZE; i++) {
    unsigned int val = I2C_PIN & ANA_PINS;
    while (val == st) {
      val = I2C_PIN & ANA_PINS;
    }
    st = val;
    buf[i] = ANA_PINSHIFT(val);
  }
  sei();

  buf[ANA_BUFSIZE] = buf[ANA_BUFSIZE-1];
  char str[ANA_BUFLINE*2+4];
  // static const char *hexh = " 123456789ABCDEF";
  // static const char *hexl = "0123456789ABCDEF";
  // sda scl sda scl
  // 0000 0001 0010 0011
  // none, scl-rise while sda low, sda-rise while scl low, both-rise
  // 0100 0101 0110 0111
  // scl-fall while sda low, none, both-flip, sda rise while scl high
  // 1000 1001 1010 1011
  // sda-fall while scl low, both-flip, none, scl rise while sda high
  // 1100 1101 1110 1111
  // both-fall, sda-fall while scl high, scl-fall while sda high, none
  static const char *i2cchr = "?0.!.?!T.!?1!S.?";
  for (int r = 0; r < (ANA_BUFSIZE/ANA_BUFLINE); r++) {
    for (int i = 0; i < ANA_BUFLINE; i++) {
        str[i] = i2cchr[((buf[r*ANA_BUFLINE+i] << 2) | (buf[r*ANA_BUFLINE+i+1]))];
    }
    str[ANA_BUFLINE-1] = 0;
    Serial.println(str);
    /*
    for (int i = 0; i < ANA_BUFLINE; i++) {
      str[i*2] = hexh[(buf[r*ANA_BUFLINE+i] >> 4) & 0xF];
      str[i*2+1] = hexl[buf[r*ANA_BUFLINE+i] & 0xF];
    }
    str[ANA_BUFLINE*2] = 0;
    Serial.println(str);
    */
    for (int b = 0; b < ANA_NUMPINS; b++) {
      int prv = buf[r*ANA_BUFLINE] & (1<<b);
      for (int i = 0; i < ANA_BUFLINE; i++) {
        if (prv && (buf[r*ANA_BUFLINE+i] & (1<<b))) {
          str[i*2] = '_';
        } else {
          str[i*2] = ' ';
        }
        prv = buf[r*ANA_BUFLINE+i] & (1<<b);
        if (prv) {
          str[i*2+1] = '_';
        } else {
          str[i*2+1] = ' ';
        }
      }
      str[ANA_BUFLINE*2] = 0;
      Serial.println(str);
      prv = buf[r*ANA_BUFLINE] & (1<<b);
      for (int i = 0; i < ANA_BUFLINE; i++) {
        if (prv != (buf[r*ANA_BUFLINE+i] & (1<<b))) {
          str[i*2] = '|';
        } else if (prv) {
          str[i*2] = ' ';
        } else {
          str[i*2] = '_';
        }
        prv = buf[r*ANA_BUFLINE+i] & (1<<b);
        if (prv) {
          str[i*2+1] = ' ';
        } else {
          str[i*2+1] = '_';
        }
      }
      str[ANA_BUFLINE*2] = 0;
      Serial.println(str);
      Serial.println(lbls[b]);
    }
  }
}
