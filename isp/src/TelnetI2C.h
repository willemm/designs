#ifndef _TELNETI2C_H
#define _TELNETI2C_h
#include <ESP8266WiFi.h>

class TelnetI2C {
public:
    static void begin();
    static void update();
    static void pause();
    static void unpause();
protected:
    static void _start_i2c();
    static void _print_i2c();
    static void _start_rx();
    static void _stop_rx();
    static void _print_rx();
    static void _start_analyze();
    static void _print_analyze();
    static void _printf(const char *fmt, ...);
    static WiFiServer _server;
    static WiFiClient _client;
    static int _busy;
};

#endif
