#include <stdint.h>

typedef struct { uint8_t r, g, b; } color_t;

void neopixel_setup();
void neopixel_send(color_t color);
