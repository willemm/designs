#include <NeoPixelBus.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <FS.h>
#include <ArduinoJson.h>
#include <math.h>

ESP8266WebServer server(80);

const char *ssid = "Airy";
const char *password = "Landryssa";
const uint16_t PixelCount = 60;

NeoPixelBus<NeoGrbwFeature, Neo800KbpsMethod> strip(PixelCount, 0);

void setup()
{
    /*
    Serial.begin(74880);
    while (!Serial); // wait for serial attach

    Serial.println();
    Serial.println("Initializing...");
    Serial.flush();
    */

    // this resets all the neopixels to an off state
    strip.Begin();
    strip.Show();

    SPIFFS.begin();
    /*
    Serial.println("SPIFFS OK...");
    Serial.flush();
    */
    WiFi.disconnect(true);
    WiFi.begin(ssid, password);
    
    /*
    Serial.println("WiFi connected...");
    Serial.flush();
    */
    ota_setup();
    
    server.on("/set", handle_set);
    server.on("/get", handle_get);
    server.serveStatic("/build/bundle.css", SPIFFS, "/bundle.css");
    server.serveStatic("/build/bundle.js", SPIFFS, "/bundle.js");
    server.serveStatic("/index.html", SPIFFS, "/index.html");
    server.serveStatic("/", SPIFFS, "/");

    server.begin();
    /*
    Serial.print("Listening on"); Serial.print(WiFi.localIP()); Serial.println(".");
    */
}

int hue, sat, val;
bool setcolor = false;

void loop()
{
    ota_check();
    server.handleClient();
    if (setcolor) {
      RgbwColor color = hsv2rgb(hue, sat, val);
      for (int i = 0; i < PixelCount; i++) {
        strip.SetPixelColor(i, color);
      }
      strip.Show();
    }
}

RgbwColor hsv2rgb(int h, int s, int v)
{
  double H = h, S = ((double)s)/255, V = ((double)v)/255;
  /*
  Serial.print("H="); Serial.print(H);
  Serial.print(" S="); Serial.print(S);
  Serial.print(" V="); Serial.println(V);
  */
  uint8_t rgbw[4];
  double C = V * S;
  double X1 = fmod(H/60, 2);
  double X2 = 2 - X1;
  if (X1 > 1) { X1 = 1; } else { X2 = 1; }
  X1 = X1 * C;
  X2 = X2 * C;
  double m = V - C;
  int io = (int)(H/120) % 3;
  /*
  Serial.print("C="); Serial.print(C);
  Serial.print(" X1="); Serial.print(X1);
  Serial.print(" X2="); Serial.print(X2);
  Serial.print(" m="); Serial.print(m);
  Serial.print(" io="); Serial.println(io);
  */
  rgbw[io] = (uint8_t)(((X2+m)*255));
  rgbw[(io+1)%3] = (uint8_t)(((X1+m)*255));
  rgbw[(io+2)%3] = (uint8_t)(m*255);
  rgbw[3] = (uint8_t)((1-S)*(1-S)*V*255);
  return RgbwColor(rgbw[0], rgbw[1], rgbw[2], rgbw[3]);
}

void handle_set()
{
  if (!server.hasArg("plain")) {
    server.send(400, "text/plain", "No data");
    return;
  }
  /*
  Serial.print("Got: ");
  Serial.println(server.arg("plain"));
  */
  /*
  int h, s, v;
  if (sscanf(server.arg("plain").c_str(), "%d:%d:%d", &h, &s, &v) < 3) {
    server.send(400, "text/plain", "Argument error");
    return;
  }
  */
  StaticJsonDocument<256> json;
  if (DeserializationError err = deserializeJson(json, server.arg("plain"))) {
    server.send(400, "text/plain", err.c_str());
    return;
  }
  hue = json["hue"];
  sat = json["sat"];
  val = json["val"];

  /*
  char buf[32];
  sprintf(buf, "Color: %d,%d,%d,%d", color.R, color.G, color.B, color.W);
  Serial.println(buf);
  server.send(200, "text/plain", buf);
  */
  server.send(200, "application/json", json.as<String>());
}

void handle_get()
{
  StaticJsonDocument<256> json;
  json["hue"] = hue;
  json["sat"] = sat;
  json["val"] = val;
  server.send(200, "application/json", json.as<String>());
}
