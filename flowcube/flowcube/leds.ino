#include <Adafruit_NeoPixel.h>
#include "settings.h"

// Which pin on the Arduino is connected to the NeoPixels?
#define PIN 2

#define NUMKEYS 5
#define SIDEKEYS (NUMKEYS*NUMKEYS)

#define NUMROWS (2*NUMKEYS)
#define PERROW (2*NUMKEYS)
#define NUMPIXELS (3*NUMROWS*PERROW)

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

void leds_init()
{
    pixels.begin();

    pixels.clear();
    pixels.show();
}

uint32_t colors[] = {
    pixels.Color(151,0,0),
    pixels.Color(0,101,0),
    pixels.Color(0,0,121),
    pixels.Color(94,86,0),
    pixels.Color(0,75,85),
    pixels.Color(99,0,87)
};

#define DELAYVAL 50

void testleds()
{
    for(int rgb=0; rgb < sizeof(colors)/sizeof(colors[0]); rgb++) {
        delay(DELAYVAL);

        for(int i=0; i<PERROW; i++) {
            for (int j = 0; j < NUMROWS*2; j++) {
                int o = ((rgb+j)%2) ? (PERROW-1) : 0;
                int s = ((rgb+j)%2) ? -1 : 1;
                pixels.setPixelColor(j*PERROW+o+i*s, colors[rgb]);
            }

            pixels.show();
            delay(DELAYVAL);
        }
    }
}

ledset_t leds_keyidx(int keyidx)
{
    int side = keyidx/SIDEKEYS;
    int y = (keyidx%SIDEKEYS) / NUMKEYS;
    int x = keyidx%NUMKEYS;
    ledset_t cell;
    int s1 = (y%2) ? -1 : 1;
    cell.left = y*(NUMKEYS*2) + (NUMKEYS-1) + s1*((x*2)-(NUMKEYS-1));
    int s2 = (x%2) ? -1 : 1;
    cell.down = (SIDEKEYS*4-2) - (x*(NUMKEYS*2) + (NUMKEYS-1) + s2*((y*2)-(NUMKEYS-1)));
    return cell;
}

void leds_setkey(int keyidx, int colorindex, int direction=0xF)
{
    uint32_t color = colors[colorindex];
    int side = keyidx/SIDEKEYS;
    int y = (keyidx%SIDEKEYS) / NUMKEYS;
    int x = keyidx%NUMKEYS;
    int s1 = (y%2) ? -1 : 1;
    int c1 = y*(NUMKEYS*2) + (NUMKEYS-1) + s1*((x*2)-(NUMKEYS-1));
    int s2 = (x%2) ? -1 : 1;
    int c2 = (SIDEKEYS*4-2) - (x*(NUMKEYS*2) + (NUMKEYS-1) + s2*((y*2)-(NUMKEYS-1)));

    /*
    serprintf("Set key(%d,%d,%d)", side, x, y);
    serprintf("  c1 = %d*%d + %d + %d*(%d-%d) = %d", y, NUMKEYS*2, NUMKEYS-1, s1, x, NUMKEYS-1, c1);
    serprintf("    s1=%d, c1=%d, s2=%d, c2=%d", s1, c1, s2, c2);
    */

    if (direction | LEDS_LEFT)  pixels.setPixelColor(c1, color);
    if (direction | LEDS_RIGHT) pixels.setPixelColor(c1+1, color);
    if (direction | LEDS_UP)    pixels.setPixelColor(c2, color);
    if (direction | LEDS_DOWN)  pixels.setPixelColor(c2+1, color);
}

void leds_setline(int keyidx1, int keyidx2, int colorindex)
{
    uint32_t color = colors[colorindex];
    int side1 = keyidx1/SIDEKEYS;
    int side2 = keyidx2/SIDEKEYS;
    int y1 = (keyidx1%SIDEKEYS) / NUMKEYS;
    int x1 = keyidx1%NUMKEYS;
    int y2 = (keyidx2%SIDEKEYS) / NUMKEYS;
    int x2 = keyidx2%NUMKEYS;
    if (side1 == side2) {
        int c1;
        if (y1 == y2) {
            int s = (y1%2) ? -1 : 1;
            c1 = y1*(NUMKEYS*2) + (NUMKEYS-1) + (x1+x2-(NUMKEYS-1))*s;
        } else {
            int s = (x1%2) ? -1 : 1;
            c1 = (SIDEKEYS*4-2)-(x1*(NUMKEYS*2) + (NUMKEYS-1) + (y1+y2-(NUMKEYS-1))*s);
        }
        pixels.setPixelColor(c1, color);
        pixels.setPixelColor(c1+1, color);
    }
}

int lines[4][6] = {
    { 1,2,3,4,9,14 },
    { 0,5,6,7,12,13 },
    { 10,15,20,21,22,23 },
    { 11,16,17,18,19,24 }
};

void test_lines()
{
    pixels.clear();
    pixels.show();
    /*
    for (int l=0; l < 4; l++) {
        delay(2000);
        leds_setkey(lines[l][0], l);
        leds_setkey(lines[l][5], l);
        for (int p = 0; p < 5; p++) {
            leds_setline(lines[l][p], lines[l][p+1], l);
        }
        pixels.show();
    }
    */
    for (int st = 0; st < 4*6; st++) {
        for (int d = 0; d < 1; d++) {
            delay(500);
            keys_scan();
        }
        pixels.clear();
        int nl = st/6;
        for (int l = 0; l <= nl; l++) {
            int np = 5;
            if (l == nl) { np = (st % 6); }
            leds_setkey(lines[l][0], l);
            leds_setkey(lines[l][5], l);
            for (int p = 0; p < np; p++) {
                leds_setline(lines[l][p], lines[l][p+1], l);
            }
        }
        pixels.show();
    }
    for (int d = 0; d < 10; d++) {
        delay(500);
        keys_scan();
    }
}

void leds_clear()
{
    pixels.clear();
}

void leds_show()
{
    pixels.show();
}
