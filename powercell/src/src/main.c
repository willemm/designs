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
    uint8_t mode = 1;
    int16_t anim = 0;
    uint8_t tiltcount = 0;
    uint16_t ccnt = 1000;
    uint8_t bounce = 0;
    uint8_t pl = 0;
    uint8_t mcp = 0;
    while (1) {
        if (pl < 6) {
            if (!mcp) {
                mcp_start();
                i2c_print("Starting up");
                mcp = 1;
            }
            ccnt++;
            if (ccnt > 1024) {
                i2c_printf("Mode %d, pl %d");
                ccnt = 0;
                uint16_t vcc = check_vcc();
                // Decivolts
                // When lower than 3.3 volts, switch off
                if (vcc < 34) {
                    i2c_printf("Low power %d, turn off", vcc);
                    if (pl < 6) { pl++; }
                } else {
                    i2c_printf("Vcc: %d dV", vcc);
                }
            }
            switch (mode) {
                case 1: // Normal mode
                    neopixel_send(turnoff(mcp_read_color(1), pl));
                    break;
                case 2: // Pulsing mode
                    anim = (anim + 11) % 360;
                    neopixel_send(turnoff(pulse(mcp_read_color(1), anim), pl));
                    break;
            }
        } else {
            if (mcp) {
                mcp_stop();
                mcp = 0;
                i2c_print("Shutting down");
            }
            // Power off
            neopixel_send((color_t) {0, 0, 0} );
            // Extra slow
            delay(225);
        }
        delay(25);
        uint8_t newmode = mode;
        uint32_t rd = radio_read();
        if (!bounce) {
            if (rd != 0) {
                i2c_printf("Radio code %lx, command %x", rd & 0xFFFFF0, rd & 0x0F);
            }
            if ((rd & 0xFFFFF0) == RADIO_CODE) switch (rd & 0x0F) {
              case 0x08: // A
                // Power level up
                if (pl > 0) {
                    ccnt = 1000;
                    pl--;
                }
                bounce = 10;
                break;
              case 0x04: // B
                // Power level down
                if (pl < 6) {
                    ccnt = 1000;
                    pl++;
                }
                bounce = 10;
                break;
              case 0x02: // C
                // Normal mode
                newmode = 1;
                break;
              case 0x01: // D
                newmode = 2;
                break;
            }
        } else {
            bounce--;
        }
        if (tiltcount > 40) {
            if (pl < 6) {
                i2c_printf("Tilt!  Lowering pl to %d", pl);
                pl++;
            }
            tiltcount = 0;
        }
        if (newmode != mode) {
            ccnt = 1000;
            mode = newmode;
            anim = 0;
            tiltcount = 0;
            switch(mode) {
              case 1:
                i2c_print("Sensitive flicker");
                break;
              case 2:
                i2c_print("Sensitive pulse");
                break;
            }
        }
    }
    return 0;
}
