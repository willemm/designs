#include "TelnetI2C.h"
#include <Wire.h>
#include <c_types.h>

const uint16_t I2C_ADDRESS = 0x08;
#define SDA_PIN 13
#define SCL_PIN 14

WiFiServer TelnetI2C::_server = WiFiServer(23);
WiFiClient TelnetI2C::_client;
int TelnetI2C::_busy = -1;

void TelnetI2C::begin()
{
    _server.begin();
}

void TelnetI2C::update()
{
    if (_busy == 1) {
        if (!_client.connected()) {
            _client.stop();
            _busy = 0;
        } else {
            // Reject other connections
            while (_server.hasClient()) _server.available().stop();
            while (_client.available()) {
                uint8_t b = (uint8_t)_client.read();
                if (b == 13) {
                    _analyze();
                }
            }
        }
    } else if (_busy <= 0) {
        if (_server.hasClient()) {
            _client = _server.available();
            _client.setNoDelay(true);
            _client.print("Connected to attiny\r\n");
            if (_busy < 0) {
                /*
                Wire.begin(SDA_PIN, SCL_PIN, I2C_ADDRESS);
                Wire.onReceive(_receive);
                */
            }
            _busy = 1;
            // Reject other connections
            while (_server.hasClient()) _server.available().stop();
        }
    }
}

#define N_SAMPLES 300

#define PIN0 SDA_PIN
#define PIN1 SCL_PIN
#define PIN2 4
#define PIN3 12

#define MASK ((1 << PIN0) | (1 << PIN1) | (1 << PIN2) | (1 << PIN3))

#define bitshift(val) ((((val) >> PIN0) & 1) | (((val) >> (PIN1)) & 1) << 1 | (((val) >> (PIN2)) & 1) << 2 | (((val) >> (PIN3)) & 1) << 3)

unsigned long times[N_SAMPLES]; // when did change happen
uint32_t values[N_SAMPLES];     // GPI value at time

extern int IRAM_ATTR logic_collect() {
  pinMode(PIN0, INPUT);
  pinMode(PIN1, INPUT);
  pinMode(PIN2, INPUT);
  unsigned long etime = micros();
  times[0] = etime;
  values[0] = GPI & MASK;
  etime = etime + 1000000;
  int i = 1;
  for (; i < N_SAMPLES; ++i) {
    uint32_t value;
    do {
      value = GPI & MASK;
    } while ((micros() < etime) && (value == values[i - 1]));
    if (micros() >= etime) break;
    times[i] = micros();
    values[i] = value;
  }
  return i;
}

void TelnetI2C::_printf(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    char s[256];

    vsnprintf(s, sizeof(s), fmt, args);
    _client.print(s);
    va_end(args);
}

void TelnetI2C::_analyze()
{
    int n = logic_collect();
    _printf("Got %d samples: ", n);
    for (int i = 0; i < n; i++) {
        _printf("%d:%x ", times[i]-times[0], bitshift(values[i]));
    }
    _printf("\r\n");
}

void TelnetI2C::_receive(int howmany)
{
    if (!_client.connected()) {
        return;
    }
    unsigned long rtimeout = millis() + 200;
    while (millis() < rtimeout) {
        while (Wire.available() > 0) {
            char c = Wire.read();
            _client.print(c);
        }
    }
}

void TelnetI2C::pause()
{
    if (_busy == 1) {
        _client.stop();
    }
    _busy = 2;
}

void TelnetI2C::unpause()
{
    if (_busy == 2) {
        _busy = 0;
    }
}
