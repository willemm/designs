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
    static void _receive(int howmany);
    static void _analyze();
    static void _printf(const char *fmt, ...);
    static WiFiServer _server;
    static WiFiClient _client;
    static int _busy;
};

#endif