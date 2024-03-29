#ifndef _SETTINGS_H_
#define _SETTINGS_H_
#include <Adafruit_NeoPixel.h>

// #define SERIALOUT
// #define WEBOUT
#define TELNETOUT

#ifdef TELNETOUT
#include <RemoteDebug.h>
extern RemoteDebug Debug;
#else
#ifdef SERIALOUT
#define debugV(fmt,...) serprintf('W',fmt,...)
#define debugD(fmt,...) serprintf('D',fmt,...)
#define debugI(fmt,...) serprintf('I',fmt,...)
#define debugW(fmt,...) serprintf('W',fmt,...)
#define debugE(fmt,...) serprintf('E',fmt,...)
#else
#define debugV(...)
#define debugD(...)
#define debugI(...)
#define debugW(...)
#define debugE(...)
#endif // SERIALOUT
#endif // TELNETOUT


#define LEDS_LEFT  0x01
#define LEDS_RIGHT 0x02
#define LEDS_UP    0x04
#define LEDS_DOWN  0x08

#define OTA_NAME "eos-flowcube-1"

// extern fieldcell_t field[];
extern const uint32_t colors[];
extern Adafruit_NeoPixel pixels;

void ota_setup();
void ota_check();

void leds_init();
void leds_test();
// ledset_t leds_keyidx(int keyidx);
void leds_setline(int keyidx1, int keyidx2, int colorindex);
void test_lines();
void leds_clear();

int keys_scan();
void keys_init();

void field_init();
void field_clear();
void field_test();
void field_update();
void field_debug_dump();

void webserver_log(const char *fmt, va_list args);
void webserver_init();
void webserver_update();

void debug_init();
void debug_update();

#endif // _SETTINGS_H_
