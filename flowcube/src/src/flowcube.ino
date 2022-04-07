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
#endif
}

void setup() {
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial);
    Serial.println();
    Serial.println("Initializing...");
#endif
    ota_check();
    leds_init();
    leds_test();
    keys_init();
    field_init();
    //field_test();
    field_clear();
}

void loop()
{
    field_update();
    ota_check();
    delay(20);
}
