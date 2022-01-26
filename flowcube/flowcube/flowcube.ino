#include <stdio.h>
#include <stdarg.h>
#include "settings.h"

#define SERIALOUT

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

void setup() {
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial);
    Serial.println();
    Serial.println("Initializing...");
#endif
    leds_init();
    keys_init();
    field_init();
}

void loop()
{
    testleds();
    test_lines();
}
