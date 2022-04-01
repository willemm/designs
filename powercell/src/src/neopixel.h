#ifndef __INCLUDE_NEOPIXEL_H
#define __INCLUDE_NEOPIXEL_H
#include <stdint.h>

typedef struct { uint8_t r, g, b; } color_t;

void neopixel_setup();
void neopixel_send(color_t color);
#endif // __INCLUDE_NEOPIXEL_H
