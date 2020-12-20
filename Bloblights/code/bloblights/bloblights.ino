#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <FS.h>
#include <ArduinoJson.h>
#include <math.h>

#define SERIALOUT

ESP8266WebServer server(80);

const char *ssid = "Airy";
const char *password = "Landryssa";

const int pins[] = {
  5,4,0,2,
  14,12,13,15
};

const int numsets = 2;

struct hsv {
  int hue, sat, val;
} colors[numsets];

struct hsv curcolors[numsets];

struct rgbw {
  double red, green, blue, white;
};

void setup() {
  for (int i = 0; i < 8; i++) {
    pinMode(pins[i], OUTPUT);
    digitalWrite(pins[i], LOW);
  }
  // put your setup code here, to run once:
#ifdef SERIALOUT
  Serial.begin(74880);
  while (!Serial);

  Serial.println();
  Serial.println("Initializing...");
#endif

  SPIFFS.begin();
  
  WiFi.disconnect(true);
  WiFi.begin(ssid, password);

  ota_setup();

  server.on("/set", handle_set);
  server.on("/get", handle_get);
  server.serveStatic("/build/bundle.css", SPIFFS, "/bundle.css");
  server.serveStatic("/build/bundle.js", SPIFFS, "/bundle.js");
  server.serveStatic("/index.html", SPIFFS, "/index.html");
  server.serveStatic("/", SPIFFS, "/");

  server.begin();
}

struct rgbw hsv2rgbw(struct hsv color)
{
  double H = color.hue, S = ((double)color.sat)/255, V = ((double)color.val)/255;
  /*
  Serial.print("H="); Serial.print(H);
  Serial.print(" S="); Serial.print(S);
  Serial.print(" V="); Serial.println(V);
  */
  double rgbw[4];
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
  rgbw[io] = (((X2+m)));
  rgbw[(io+1)%3] = (((X1+m)));
  rgbw[(io+2)%3] = (m);
  rgbw[3] = ((1-S)*(1-S)*V);
  return {.red=rgbw[0], .green=rgbw[1], .blue=rgbw[2], .white=rgbw[3]};
}

void writecolor(int pin, struct rgbw color)
{
  const int scale = 1023;
  analogWrite(pins[pin*4  ], (uint16_t)(color.red   * scale));
  analogWrite(pins[pin*4+1], (uint16_t)(color.green * scale));
  analogWrite(pins[pin*4+2], (uint16_t)(color.blue  * scale));
  analogWrite(pins[pin*4+3], (uint16_t)(color.white * scale));
}

unsigned long setcolor = 0;
unsigned long tick = 0;
unsigned long ctick = 0;

void loop() {
    ota_check();
    server.handleClient();
    if ((setcolor > 0) && (ctick < millis())) {
      setcolor--;
      ctick = millis() + 25;
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
        writecolor(s, hsv2rgbw(curcolors[s]));
      }
    }
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
