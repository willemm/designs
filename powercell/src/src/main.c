#include "neopixel.h"
#include <util/delay.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include "i2c.h"
#include "mcp.h"
#include "radio.h"

#define PIXELCOLOR(r,g,b) ((color_t){ (r), (g), (b) })

color_t color(uint32_t ang, uint8_t bri)
{
    ang = ang % 360;
    if (ang <= 120) {
        return (color_t){ bri*(120-ang)/120, bri*(ang)/120, 0 };
    }
    if (ang <= 240) {
        return (color_t){ 0, bri*(120-(ang-120))/120, bri*(ang-120)/120 };
    }
    return (color_t){ bri*(ang-240)/120, 0, bri*(120-(ang-240))/120 };
}

color_t colori(uint32_t ang, uint32_t bri, uint32_t mbr)
{
  ang = ang % 360;
  uint32_t bf = bri-mbr;
  if (ang <= 120) {
    return PIXELCOLOR(mbr+bf*(ang)/120, mbr+bf*(120-ang)/120, bri);
  }
  if (ang <= 240) {
    return PIXELCOLOR(bri, mbr+bf*((ang-120))/120, mbr+bf*(120-(ang-120))/120);
  }
  return PIXELCOLOR(mbr+bf*(120-(ang-240))/120, bri, mbr+bf*((ang-240))/120);
}

color_t fcolori(uint16_t ang, uint16_t bri, uint16_t mbr)
{
    ang = ang % 256;
    uint16_t bf = (bri - mbr)*3;
    if (ang <= 0x55) {
        return PIXELCOLOR(mbr+bf*ang/256, mbr+bf*(0x55-ang)/256, bri);
    }
    if (ang <= 0xAA) {
        ang -= 0x55;
        return PIXELCOLOR(bri, mbr+bf*ang/256, mbr+bf*(0x55-ang)/256);
    }
    ang -= 0x55;
    return PIXELCOLOR(mbr+bf*(0x55-ang)/256, bri, mbr+bf*ang/256);
}

static inline void delay(uint32_t dly)
{
    _delay_ms(dly);
}

uint16_t check_vcc(void)
{
    ADCSRA |= (1 << ADSC);
    while (ADCSRA & (1 << ADSC)) { } // Wait
    uint8_t res = ADCH;
    uint16_t decivolt = 0x2160 / res;
    i2c_printf("vcc: %d dV", decivolt);

    return decivolt;

    /* 3.844~3.845 V = 222..223
     * 4.542~4.546 V = 185..192 ??
     *
     * 855 / 222..223 = 3.82..3.84
     * 855 / 185..192 = 4.45..4.62
     */
}

int main(void)
{
    ADCSRA = (1 << ADEN) | (5 << ADPS0); // Prescale 101 = 1/32 = 125Khz
    ADMUX = (1 << ADLAR) | (1 << MUX0);  // 
    mcp_init();
    neopixel_setup();
    radio_setup();
    i2c_setup();
    i2c_print("Setting up, start off");
    uint8_t mode = 16;
    uint32_t anim = 0;
    uint8_t tiltcount = 0;
    uint16_t ccnt = 1000;
    while (1) {
        if (mode < 16) {
            ccnt++;
            if (ccnt > 1024) {
                ccnt = 0;
                uint16_t vcc = check_vcc();
                // Decivolts
                // When lower than 3.3 volts, switch off
                i2c_printf("Vcc: %d dV", vcc);
                if (vcc < 35) {
                    mode = 16;
                    anim = 0;
                }
            }
        }
        switch (mode) {
          case 1:
            neopixel_send(colori(anim, 128, 64));
            if ((anim % 36) == 0) {
                mcp_stop();
                i2c_printf("Angle step %d", anim);
                check_vcc();
            }
            anim = (anim + 1) % 360;
            break;
          case 2:
            /*
            neopixel_send(colori(anim, 128, 64));
            if ((anim % 72) == 0) {
                uint16_t tilt = mcp_read();
                if (tilt > 5000) {
                    i2c_print("TILT");
                    tiltcount++;
                    neopixel_send((color_t) { 0, 0, 0});
                    break;
                } else {
                    if (tiltcount > 0) {
                        tiltcount--;
                    }
                }
                i2c_printf("Angle step %d", anim);
            }
            anim = (anim + 12) % 360;
            */
            neopixel_send(mcp_read_color());
            break;
          case 3:
            if ((anim % 64) == 0) {
                if ((anim / 64)) {
                    i2c_printf("Blink off");
                    neopixel_send((color_t) { 0, 0, 0 });
                } else {
                    i2c_printf("Blink on");
                    neopixel_send((color_t) { 0, 96, 0 });
                }
            }
            anim = (anim + 1) % 192;
            break;
          case 16:
            anim++;
            switch (anim % 16) {
              case 0:
                neopixel_send((color_t) {64, 0, 0} );
                break;
              case 5:
                neopixel_send((color_t) {0, 64, 0} );
                break;
              case 10:
                neopixel_send((color_t) {0, 0, 64} );
                break;
              case 1:
              case 6:
              case 11:
                neopixel_send((color_t) {0, 0, 0} );
                break;
              default:
                if (anim >= 64) {
                    i2c_print("Low power, turn off");
                    // Off.
                    neopixel_send((color_t) {0, 0, 0} );
                    mode = 17;
                }
            }
            // Extra slow
            delay(225);
            break;
          default:
            delay(1000);
            break;
        }
        delay(25);
        uint32_t rd = radio_read();
        uint8_t newmode = mode;
        switch (rd & 0x0F) {
          case 0x08:
            newmode = 1;
            break;
          case 0x04:
            newmode = 2;
            break;
          case 0x02:
            newmode = 3;
            break;
          case 0x01:
            newmode = 16;
            break;
        }
        if (tiltcount > 40) {
            newmode = 3;
            tiltcount = 0;
        }
        if (newmode != mode) {
            ccnt = 1000;
            mode = newmode;
            anim = 0;
            tiltcount = 0;
            switch(mode) {
              case 1:
                mcp_stop();
                i2c_print("Slow cycle");
                break;
              case 2:
                mcp_start();
                i2c_print("Fast cycle");
                break;
              case 3:
                mcp_stop();
                i2c_print("Flash red");
                break;
              case 16:
                mcp_stop();
                i2c_print("Turn off");
                neopixel_send((color_t) { 0, 0, 0 });
                break;
            }
        }
    }
    return 0;
}
