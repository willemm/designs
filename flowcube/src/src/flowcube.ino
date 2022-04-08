#include <stdio.h>
#include <stdarg.h>
#include "settings.h"

// #define SERIALOUT
#define WEBOUT
// #define TELNETOUT

void serprintf(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
#ifdef SERIALOUT
    char s[256];
    vsnprintf(s, sizeof(s), fmt, args);
    Serial.println(s);
#endif // SERIALOUT
#ifdef WEBOUT
    webserver_log(fmt, args);
#endif // WEBOUT
#ifdef TELNETOUT
#endif // TELNETOUT
    va_end(args);
}

void setup() {
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial);
    Serial.println();
    Serial.println("Initializing...");
#endif // SERIALOUT
    ota_check();
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
#ifdef TELNETOUT
#endif // TELNETOUT
#ifdef WEBOUT
    webserver_check();
#endif // WEBOUT
    field_update();
    ota_check();
    delay(20);
}
