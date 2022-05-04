#include "neopixel.h"
#include <util/delay.h>
#include <avr/io.h>
#include "i2c.h"

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

static inline void delay(uint32_t dly)
{
    _delay_ms(dly);
}

int main(void) {
    neopixel_setup();
    i2c_setup();
    i2c_send("Setting up\n");
    for(uint16_t bri = 0; bri < 256; bri += 1) {
        i2c_send("Brightness increasing");
        neopixel_send(PIXELCOLOR(bri, bri, bri));
        delay(100);  
    }
    while (1) {
        i2c_send("Colour cycle");
        for (uint32_t ang=0; ang<360; ang += 12) {
            i2c_send("Angle step");
            neopixel_send(colori(ang, 255, 64));
            delay(100);
        }
    }
    /*
    DDRB |= 2;
    while (1) {
        for(uint16_t bri = 0; bri < 256; bri += 1) {
            neopixel_send(PIXELCOLOR(bri, bri, bri));
            delay(20);  
            if ((bri & 15) == 0) {
                PORTB ^= 2;
            }
        }
        for (int i = 0; i < 10; i++) {
            PORTB ^= 2;
            delay(1000);
        }

        for (uint32_t ang=0; ang<28800; ang += 2+(ang/1600)) {
            neopixel_send(colori(ang, 255));
            PORTB ^= 2;
            delay(20);
        }
    }
    */
    return 0;
}
