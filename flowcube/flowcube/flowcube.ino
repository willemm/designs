#include <Adafruit_NeoPixel.h>
#include <stdio.h>
#include <stdarg.h>

// Which pin on the Arduino is connected to the NeoPixels?
#define PIN 2

#define NUMBUTTONS 5
#define SIDEBUTTONS (NUMBUTTONS*NUMBUTTONS)

#define NUMROWS (2*NUMBUTTONS)
#define PERROW (2*NUMBUTTONS)
#define NUMPIXELS (NUMROWS*PERROW) // Popular NeoPixel ring size

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#define DELAYVAL 50

// #define SERIALOUT

void setup() {
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial);
    Serial.println();
    Serial.println("Initializing...");
#endif
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

int lines[4][6] = {
    { 1,2,3,4,9,14 },
    { 0,5,6,7,12,13 },
    { 10,15,20,21,22,23 },
    { 11,16,17,18,19,24 }
};

void serprintf(const char *fmt, ...)
{
#ifdef SERIALOUT
    char s[256];
    va_list args;

    va_start(args, fmt);
    vsnprintf(s, sizeof(s), fmt, args);
    Serial.println(s);
    va_end(args);
#endif SERIALOUT
}

void loop() {
    /*
    for(int rgb=0; rgb < sizeof(colors)/sizeof(colors[0]); rgb++) {
        delay(DELAYVAL);

        for(int i=0; i<PERROW; i++) {
            for (int j = 0; j < NUMROWS; j++) {
                int o = ((rgb+j)%2) ? (PERROW-1) : 0;
                int s = ((rgb+j)%2) ? -1 : 1;
                pixels.setPixelColor(j*PERROW+o+i*s, colors[rgb]);
            }

            pixels.show();
            delay(DELAYVAL);
        }
    }
    */
    pixels.clear();
    pixels.show();
    /*
    for (int l=0; l < 4; l++) {
        delay(2000);
        setbutton(lines[l][0], colors[l]);
        setbutton(lines[l][5], colors[l]);
        for (int p = 0; p < 5; p++) {
            setline(lines[l][p], lines[l][p+1], colors[l]);
        }
        pixels.show();
    }
    */
    for (int st = 0; st < 4*6; st++) {
        delay(500);
        pixels.clear();
        int nl = st/6;
        for (int l = 0; l <= nl; l++) {
            int np = 5;
            if (l == nl) { np = (st % 6); }
            setbutton(lines[l][0], colors[l]);
            setbutton(lines[l][5], colors[l]);
            for (int p = 0; p < np; p++) {
                setline(lines[l][p], lines[l][p+1], colors[l]);
            }
        }
        pixels.show();
    }
    delay(5000);
}

void setbutton(int btn, uint32_t color)
{
    int side = btn/SIDEBUTTONS;
    int y = (btn%SIDEBUTTONS) / NUMBUTTONS;
    int x = btn%NUMBUTTONS;
    int s1 = (y%2) ? -1 : 1;
    int c1 = y*(NUMBUTTONS*2) + (NUMBUTTONS-1) + s1*((x*2)-(NUMBUTTONS-1));
    int s2 = (x%2) ? -1 : 1;
    int c2 = (SIDEBUTTONS*4-2) - (x*(NUMBUTTONS*2) + (NUMBUTTONS-1) + s2*((y*2)-(NUMBUTTONS-1)));

    /*
    serprintf("Set button(%d,%d,%d)", side, x, y);
    serprintf("  c1 = %d*%d + %d + %d*(%d-%d) = %d", y, NUMBUTTONS*2, NUMBUTTONS-1, s1, x, NUMBUTTONS-1, c1);
    serprintf("    s1=%d, c1=%d, s2=%d, c2=%d", s1, c1, s2, c2);
    */

    pixels.setPixelColor(c1, color);
    pixels.setPixelColor(c1+1, color);
    pixels.setPixelColor(c2, color);
    pixels.setPixelColor(c2+1, color);
}

void setline(int btn1, int btn2, uint32_t color)
{
    int side1 = btn1/SIDEBUTTONS;
    int side2 = btn2/SIDEBUTTONS;
    int y1 = (btn1%SIDEBUTTONS) / NUMBUTTONS;
    int x1 = btn1%NUMBUTTONS;
    int y2 = (btn2%SIDEBUTTONS) / NUMBUTTONS;
    int x2 = btn2%NUMBUTTONS;
    if (side1 == side2) {
        int c1;
        if (y1 == y2) {
            int s = (y1%2) ? -1 : 1;
            c1 = y1*(NUMBUTTONS*2) + (NUMBUTTONS-1) + (x1+x2-(NUMBUTTONS-1))*s;
        } else {
            int s = (x1%2) ? -1 : 1;
            c1 = (SIDEBUTTONS*4-2)-(x1*(NUMBUTTONS*2) + (NUMBUTTONS-1) + (y1+y2-(NUMBUTTONS-1))*s);
        }
        pixels.setPixelColor(c1, color);
        pixels.setPixelColor(c1+1, color);
    }
}
