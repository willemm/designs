#include <NeoPixelBus.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <FS.h>
#include <ArduinoJson.h>
#include <math.h>

// #define SERIALOUT

ESP8266WebServer server(80);

const char *ssid = "Airy";
const char *password = "Landryssa";
const uint16_t PixelCount = 60;

NeoPixelBus<NeoGrbwFeature, Neo800KbpsMethod> strip(PixelCount, 0);

const int joyGnd = 16;
const int joyX = 14;
const int joyY = 12;
const int joyIN = A0;

void setup()
{
    pinMode(joyGnd, OUTPUT);
    pinMode(joyX, OUTPUT);
    pinMode(joyY, OUTPUT);
    digitalWrite(joyGnd, LOW);
    digitalWrite(joyX, LOW);
    digitalWrite(joyY, LOW);
      
#ifdef SERIALOUT
    Serial.begin(74880);
    while (!Serial); // wait for serial attach

    Serial.println();
    Serial.println("Initializing...");
    Serial.flush();
#endif

    // this resets all the neopixels to an off state
    strip.Begin();
    strip.Show();

    SPIFFS.begin();
#ifdef SERIALOUT
    Serial.println("SPIFFS OK...");
    Serial.flush();
#endif
    WiFi.disconnect(true);
    WiFi.begin(ssid, password);
    
#ifdef SERIALOUT
    Serial.println("WiFi connected...");
    Serial.flush();
#endif    
    ota_setup();
    
    server.on("/set", handle_set);
    server.on("/get", handle_get);
    server.serveStatic("/build/bundle.css", SPIFFS, "/bundle.css");
    server.serveStatic("/build/bundle.js", SPIFFS, "/bundle.js");
    server.serveStatic("/index.html", SPIFFS, "/index.html");
    server.serveStatic("/", SPIFFS, "/");

    server.begin();
}

const int numsets = 6;
struct hsv {
  int hue, sat, val;
} colors[numsets];
struct hsv curcolors[numsets];
unsigned long setcolor = 0;

unsigned long tick = 0;
unsigned long ctick = 0;

void loop()
{
    ota_check();
    server.handleClient();
    nub_check();
    if ((setcolor > 0) && (ctick < millis())) {
      setcolor--;
      ctick = millis() + 25;
      const int csz = PixelCount / numsets;
      for (int s = 0; s < numsets; s++) {
        int ch = colors[s].hue;
        int cch = curcolors[s].hue;
        if (ch < cch) {
          if (cch - ch > 180) ch += 360;
        } else {
          if (ch - cch > 180) cch += 360;
        }
        curcolors[s].hue = ((cch * setcolor + ch) / (setcolor+1)) % 360;
        curcolors[s].sat = (curcolors[s].sat * setcolor + colors[s].sat) / (setcolor+1);
        curcolors[s].val = (curcolors[s].val * setcolor + colors[s].val) / (setcolor+1);
#ifdef SERIALOUT
        if (setcolor == 0) {
          Serial.print("Setting color "); Serial.print(s); Serial.print(" to ("); Serial.print(colors[s].hue);
          Serial.print(","); Serial.print(colors[s].sat); Serial.print(","); Serial.print(colors[s].val); Serial.println(")");
          Serial.flush();
        }
#endif
        RgbwColor color = hsv2rgb(curcolors[s]);
        for (int p = 0; p < csz; p++) {
          strip.SetPixelColor(s*csz+p, color);
        }
      }
      strip.Show();
    }
/*
#ifdef SERIALOUT
    if (tick < millis()) {
      digitalWrite(joyY, LOW);
      digitalWrite(joyX, HIGH);
      int posX = analogRead(joyIN);
      digitalWrite(joyX, LOW);
      digitalWrite(joyY, HIGH);
      int posY = analogRead(joyIN);
      digitalWrite(joyY, LOW);
      digitalWrite(joyX, LOW);
      Serial.print("X = "); Serial.print(posX); Serial.print(", Y = "); Serial.println(posY);
      tick = millis() + 1000;
    }
#endif
*/
}

void nub_check()
{
  if (tick < millis()) {
    digitalWrite(joyY, LOW);
    digitalWrite(joyX, HIGH);
    int vert = analogRead(joyIN);
    digitalWrite(joyX, LOW);
    digitalWrite(joyY, HIGH);
    int horz = analogRead(joyIN);
    digitalWrite(joyY, LOW);
    digitalWrite(joyX, LOW);

    if (horz < 350) { // Hue rotate
      int scl = (350-horz)/35;
      for (int c = 0; c < numsets; c++) {
        int newhue = colors[c].hue - scl;
        if (newhue < 0) newhue += 360;
        colors[c].hue = newhue;
        int newsat = colors[c].sat + scl*2;
        if (newsat > 255) newsat = 255;
        colors[c].sat = newsat;
      }
      setcolor = 4;
    }
    if (horz > 600) { // Hue rotate
      int scl = (horz-600)/35;
      for (int c = 0; c < numsets; c++) {
        int newhue = colors[c].hue + scl;
        if (newhue >= 360) newhue -= 360;
        colors[c].hue = newhue;
        int newsat = colors[c].sat + scl*2;
        if (newsat > 255) newsat = 255;
        colors[c].sat = newsat;
      }
      setcolor = 4;
    }
    if (vert < 350) { // Dimming
      int scl = (350-vert)/35;
      for (int c = 0; c < numsets; c++) {
        int newval = colors[c].val - scl;
        if (newval < 0) newval = 0;
        colors[c].val = newval;
      }
      setcolor = 4;
    }
    if (vert > 600) { // Brightening
      int scl = (vert-600)/35;
      for (int c = 0; c < numsets; c++) {
        int newval = colors[c].val + scl;
        if (newval > 255) {
          newval = 255;
          int newsat = colors[c].sat - scl;
          if (newsat < 0) newsat = 0;
          colors[c].sat = newsat;
        }
        colors[c].val = newval;
      }
      setcolor = 4;
    }

    tick = millis() + 100;
  }
}

RgbwColor hsv2rgb(struct hsv color)
{
  double H = color.hue, S = ((double)color.sat)/255, V = ((double)color.val)/255;
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

  StaticJsonDocument<512> json;
  if (DeserializationError err = deserializeJson(json, server.arg("plain"))) {
    server.send(400, "text/plain", err.c_str());
    return;
  }
  for (int i = 0; i < numsets; i++) {
    colors[i].hue = json[i]["hue"];
    colors[i].sat = json[i]["sat"];
    colors[i].val = json[i]["val"];
  }
  setcolor = 10;
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
  StaticJsonDocument<512> json;
  for (int i = 0; i < numsets; i++) {
    json[i]["hue"] = colors[i].hue;
    json[i]["sat"] = colors[i].sat;
    json[i]["val"] = colors[i].val;
  }
  server.send(200, "application/json", json.as<String>());
}
