#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include "settings.h"
#include "secret.h"

int wifistatus = WL_IDLE_STATUS;

void ota_setup()
{
  ArduinoOTA.setHostname(OTA_NAME);
  ArduinoOTA.setPassword(OTA_PASS);
  debugI("Setting op ota");
  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
        type = "sketch";
      else // U_SPIFFS
        type = "filesystem";

      // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
      Serial.println("Start updating " + type);
    });
  ArduinoOTA.onEnd([]() {
      Serial.println("\nEnd");
    });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
    });
  ArduinoOTA.onError([](ota_error_t error) {
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
    });

  ArduinoOTA.begin();
}

void ota_check()
{
    int sts = WiFi.status();
    if (wifistatus != sts) {
        debugI("WiFi status changed from %x to %x", wifistatus, sts);
        wifistatus = sts;
        if (sts == WL_DISCONNECTED) {
            WiFi.mode(WIFI_STA);
            WiFi.begin(WIFI_SSID, WIFI_PASS);
        }
        if (sts == WL_CONNECTED) {
            ota_setup();
        }
    }
    ArduinoOTA.handle();  
}
