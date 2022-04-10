#include <stdio.h>
#include <stdarg.h>
#include "settings.h"

void serprintf(const char lvl, const char *fmt, ...)
{
#ifdef SERIALOUT
    va_list args;
    va_start(args, fmt);
    char s[256];
    s[0] = '(';
    s[1] = lvl;
    s[2] = ')';
    s[3] = ' ';

    vsnprintf(s+4, sizeof(s)-4, fmt, args);
    Serial.println(s);
    va_end(args);
#endif // SERIALOUT
}

void setup() {
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial);
    Serial.println();
    Serial.println("Initializing...");
#endif // SERIALOUT
    ota_check();
    debug_init();
    leds_init();
    leds_test();
    keys_init();
    field_init();
    //field_test();
    field_clear();
#ifdef WEBOUT
    webserver_init();
#endif // WEBOUT
}

void loop()
{
#ifdef WEBOUT
    webserver_update();
#endif // WEBOUT
    field_update();
    ota_check();
    debug_update();
}
