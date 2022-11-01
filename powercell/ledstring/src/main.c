#include "neopixel.h"
#include <util/delay.h>
#include <avr/io.h>

#define PIXELCOLOR(r,g,b) ((color_t){ (r), (g), (b) })

#define LENGTH 16
#define WIDTH 2

#define MAXLEN 300

int main(void)
{
    neopixel_setup();
    int c = 0;
    while (1) {
        c++;
        if (c >= MAXLEN) {
            c -= LENGTH;
        }
        for (int i = 0; i < MAXLEN; i++) {
            int v = MAXLEN+(i-c);
            if (v < 0) v = 0;
            v += 100;
            int sc = ((c-i) % LENGTH);
            int sd = LENGTH - 4*((c-i) / LENGTH);
            if (sd < WIDTH) sd = WIDTH;
#if WIDTH > 1
            v -= (sc * 16);
#endif
            if (sc >= sd) v = 0;
            if (i > c) v = 0;
            int r = v;
            if (r < 0) r = 0;
            if (r > 255) r = 255;
            int g = v-200;
            if (g < 0) g = 0;
            if (g > 255) g = 255;
            int b = v-100;
            if (b < 0) b = 0;
            if (b > 255) b = 255;
            neopixel_send(PIXELCOLOR(r, g, b));
        }
        _delay_ms(20);
    }
}
