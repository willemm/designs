#include <stdio.h>
#include <stdarg.h>
#include "settings.h"

// #define SERIALOUT
// #define WEBOUT
#define TELNETOUT

#ifdef TELNETOUT
#include <RemoteDebug.h>
RemoteDebug Debug;
#else
#ifdef SERIALOUT
#define debugD(fmt,...) serprintf('D',fmt,...)
#define debugV(fmt,...) serprintf('W',fmt,...)
#define debugI(fmt,...) serprintf('I',fmt,...)
#define debugW(fmt,...) serprintf('W',fmt,...)
#define debugE(fmt,...) serprintf('E',fmt,...)
#else
#endif
#endif // TELNETOUT

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
    leds_init();
    leds_test();
    keys_init();
    field_init();
    //field_test();
    field_clear();
#ifdef WEBOUT
    webserver_init();
#endif // WEBOUT
#ifdef TELNETOUT
    Debug.begin("eos-flowcube-1");
    Debug.showColors(true);
#endif // TELNETOUT
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
#ifdef TELNETOUT
    Debug.handle();
#endif // TELNETOUT
}
