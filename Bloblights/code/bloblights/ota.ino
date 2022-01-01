#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

#define OTA_NAME "gameroom-lamp"

bool ota_is_setup;

void ota_setup()
{
  ota_is_setup = false;
}

void ota_do_setup()
{
#ifdef SERIALOUT
  Serial.print("Listening on "); Serial.print(WiFi.localIP()); Serial.println(".");
  Serial.flush();
#endif
  ArduinoOTA.setHostname(OTA_NAME);
  // ArduinoOTA.setPassword("Chocola");
  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
        type = "sketch";
      else // U_SPIFFS
        type = "filesystem";
        
#ifdef SERIALOUT
      // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
      Serial.println("Start updating " + type);
#endif
      set_off();
    });
  ArduinoOTA.onEnd([]() {
#ifdef SERIALOUT
      Serial.println("\nEnd");
#endif
    });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
#ifdef SERIALOUT
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
#endif
    });
  ArduinoOTA.onError([](ota_error_t error) {
#ifdef SERIALOUT
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
#endif
      set_off();
    });

  ArduinoOTA.begin();
}

void ota_check()
{
  if (WiFi.status() == WL_CONNECTED) {
    if (!ota_is_setup) {
      ota_do_setup();
      ota_is_setup = true;
    } else {
      ArduinoOTA.handle();
    }
  }
}
