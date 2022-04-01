#include "neopixel.h"
#include <util/delay.h>
#include <avr/io.h>

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

color_t colori(uint32_t ang, uint32_t bri)
{
  ang = ang % 360;
  if (ang <= 120) {
    return PIXELCOLOR(bri*(ang)/120, bri*(120-ang)/120, bri);
  }
  if (ang <= 240) {
    return PIXELCOLOR(bri, bri*((ang-120))/120, bri*(120-(ang-120))/120);
  }
  return PIXELCOLOR(bri*(120-(ang-240))/120, bri, bri*((ang-240))/120);
}

static inline void delay(uint32_t dly)
{
    _delay_ms(dly);
}

int main(void) {
    neopixel_setup();
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
            delay(20);
        }
    }
    return 0;
}
