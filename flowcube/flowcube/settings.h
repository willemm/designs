#ifndef _SETTINGS_H_
#define _SETTINGS_H_
#include <Adafruit_NeoPixel.h>
#define LEDS_LEFT  0x01
#define LEDS_RIGHT 0x02
#define LEDS_UP    0x04
#define LEDS_DOWN  0x08

struct ledset_t {
    uint8_t side;
    uint8_t left;
    uint8_t down;
};

extern uint32_t colors[];

extern Adafruit_NeoPixel pixels;
#endif // _SETTINGS_H_
