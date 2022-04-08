#include <stdio.h>
#include <stdarg.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>

ESP8266WebServer server(80);

static int pptr = 0;
static char printbuffer[4096];

void webserver_log(const char *fmt, va_list args)
{
    int sz = sizeof(printbuffer)-pptr-2;
    int n = vsnprintf(printbuffer+pptr, sz, fmt, args);
    if (n > sz) {
        pptr = vsnprintf(printbuffer, sizeof(printbuffer), fmt, args);
    } else {
        pptr = pptr + n;
    }
    if (pptr < sizeof(printbuffer)-2) {
        printbuffer[pptr++] = '\r';
        printbuffer[pptr++] = '\n';
    }
}

void webserver_init()
{
    server.on("/log", handle_log);
    server.begin();
}

void webserver_check()
{
    server.handleClient();
}

void handle_log()
{
    server.send(200, "text/plain", printbuffer);
}
