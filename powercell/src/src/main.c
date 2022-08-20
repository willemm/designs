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
    i2c_printf("Setting up");
    /*
    for(uint16_t bri = 0; bri < 256; bri += 1) {
        i2c_printf("Brightness increasing");
        neopixel_send(PIXELCOLOR(bri, bri, bri));
        delay(25);  
    }
    */
    //DDRB |= 2;
    while (1) {
        // rcv: 0c 66 1e e7 ce e3 e7 cf ce f1 31 03 e1 cf 1c 87 39 8c 8c 0c fe
        // bit: 00001100 01100110 00011110 11100111 11001110 11100011 11100111 11101111
        //      11001110 11110001 00110001 00000011 11100001 11001111 10001100 10001110
        //      00111001 10001100 10001100 00001100 254(timeout)
        // snd: 10 43 6f 6c 6f 75 72 20 63 79 63 6c 65
        // bit: 00010000 01000011 01101111 01101100 01101111 01110101 01110010 00100000
        //      01100011 01111001 01100011 01101100 01100101 (stop)
        i2c_printf("Colour cycle");
        for (uint32_t ang=0; ang<360; ang += 1) {
            neopixel_send(colori(ang, 255, 64));
            delay(25);
            if ((ang % 36) == 0) {
                i2c_printf("Angle step %d", ang);
            }
            //PORTB ^= 2;
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
