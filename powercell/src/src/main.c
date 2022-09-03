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

color_t turnoff(color_t col, uint8_t pl)
{
    if (pl > 5) pl = 10 - pl;
    // Blue goes off first
    if (pl > 1) { col.b = 0; }
    else if (pl > 0) { col.b >>= 1; }
    if (pl > 3) { col.g = 0; }
    else if (pl > 2) { col.g >>= 1; }
    if (pl > 5) { col.r = 0; }
    else if (pl > 4) { col.r >>= 1; }
    return col;
}

uint8_t pulseone(uint8_t c, uint16_t anim)
{
    int16_t cl = c << 1;
    anim = anim % 360;
    if (anim < 240) {
        if (anim >= 120) anim = 240 - anim;
        cl -= anim*2;
        if (cl < 0) cl = 0;
    }
    if (cl > 255) cl = 255;
    return (uint8_t)cl;
}

color_t pulse(color_t col, uint16_t anim)
{
    col.r = pulseone(col.r, anim);
    col.g = pulseone(col.g, anim+120);
    col.b = pulseone(col.b, anim+240);
    return col;
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
    int16_t anim = 0;
    uint8_t tiltcount = 0;
    uint16_t ccnt = 1000;
    uint8_t bounce = 0;
    uint8_t pl = 0;
    while (1) {
        if (mode < 16) {
            ccnt++;
            if (ccnt > 1024) {
                ccnt = 0;
                uint16_t vcc = check_vcc();
                // Decivolts
                // When lower than 3.3 volts, switch off
                if (vcc < 34) {
                    i2c_printf("Low power %d, turn off", vcc);
                    mode = 16;
                    anim = 0;
                } else {
                    i2c_printf("Vcc: %d dV", vcc);
                }
            }
        }
        switch (mode) {
          case 1:
            neopixel_send(turnoff(colori(anim, 128, 64), pl));
            if ((anim % 36) == 0) {
                mcp_stop();
                i2c_printf("Angle step %d", anim);
                check_vcc();
            }
            anim = (anim + 1) % 360;
            break;
          case 2:
            anim = (anim + 11) % 360;
            neopixel_send(turnoff(pulse(mcp_read_color(1), anim), pl));
            break;
          case 3:
            neopixel_send(turnoff(mcp_read_color(1), pl));
            break;
            /*
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
            */
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
        uint8_t newmode = mode;
        uint32_t rd = radio_read();
        if (!bounce) {
            switch (rd & 0x0F) {
              case 0x08:
                pl++;
                newmode = 1;
                bounce = 20;
                break;
              case 0x04:
                pl++;
                newmode = 2;
                bounce = 20;
                break;
              case 0x02:
                pl++;
                newmode = 3;
                bounce = 20;
                break;
              case 0x01:
                newmode = 16;
                bounce = 20;
                break;
            }
            if (pl >= 10) pl = 0;
        } else {
            bounce--;
        }
        if (tiltcount > 40) {
            newmode = 16;
            tiltcount = 0;
        }
        if (newmode != mode) {
            pl = 0;
            ccnt = 1000;
            mode = newmode;
            anim = 0;
            tiltcount = 0;
            switch(mode) {
              case 1:
                mcp_stop();
                i2c_print("Slow cycle");
                break;
                /*
              case 2:
                mcp_start();
                i2c_print("Sensitive");
                break;
                */
              case 2:
                mcp_start();
                i2c_print("Sensitive pulse");
                break;
              case 3:
                mcp_start();
                i2c_print("Sensitive flicker");
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
