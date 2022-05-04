#include <SPI.h>
#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <ESP8266AVRISP.h>
#include "TelnetI2C.h"
#include "secret.h"

#ifndef STASSID
#define STASSID ""
#define STAPSK ""
#endif

const char* host = "esp8266-avrisp";
const char* ssid = STASSID;
const char* pass = STAPSK;
const uint16_t port = 328;
const uint8_t reset_pin = 5;

ESP8266AVRISP avrprog(port, reset_pin);
TelnetI2C ti2c;

void setup() {
  Serial.begin(74880);
  Serial.println("");
  Serial.println("Arduino AVR-ISP over TCP");
  avrprog.setReset(false);  // let the AVR run

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, pass);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    WiFi.begin(ssid, pass);
    Serial.println("WiFi failed, retrying.");
  }

  MDNS.begin(host);
  MDNS.addService("avrisp", "tcp", port);

  IPAddress local_ip = WiFi.localIP();
  Serial.print("IP address: ");
  Serial.println(local_ip);
  Serial.println("Use your avrdude:");
  Serial.print("avrdude -c arduino -p <device> -P net:");
  Serial.print(local_ip);
  Serial.print(":");
  Serial.print(port);
  Serial.println(" -t # or -U ...");

  // listen for avrdudes
  avrprog.begin();
  ti2c.begin();
}

void loop() {
  static AVRISPState_t last_state = AVRISP_STATE_IDLE;
  AVRISPState_t new_state = avrprog.update();
  if (last_state != new_state) {
    switch (new_state) {
      case AVRISP_STATE_IDLE:
        {
          pinMode(12, INPUT);
          pinMode(13, INPUT);
          pinMode(14, INPUT);
          ti2c.unpause();
          Serial.printf("[AVRISP] now idle\r\n");
          // Use the SPI bus for other purposes
          break;
        }
      case AVRISP_STATE_PENDING:
        {
          ti2c.pause();
          Serial.printf("[AVRISP] connection pending\r\n");
          // Clean up your other purposes and prepare for programming mode
          break;
        }
      case AVRISP_STATE_ACTIVE:
        {
          Serial.printf("[AVRISP] programming mode\r\n");
          // Stand by for completion
          break;
        }
    }
    last_state = new_state;
  }
  // Serve the client
  if (last_state != AVRISP_STATE_IDLE) { avrprog.serve(); }
  else { ti2c.update(); }

  if (WiFi.status() == WL_CONNECTED) { MDNS.update(); }
}

