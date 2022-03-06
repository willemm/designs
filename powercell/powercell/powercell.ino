// BOARD: Digispark - Default

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
 #include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

// Which pin on the Arduino is connected to the NeoPixels?
#define PIN        0 // On Trinket or Gemma, suggest changing this to 1

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS 1 // Popular NeoPixel ring size

// When setting up the NeoPixel library, we tell it how many pixels,
// and which pin to use to send signals. Note that for older NeoPixel
// strips you might need to change the third parameter -- see the
// strandtest example for more information on possible values.
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

#define DELAYVAL 20 // Time (in milliseconds) to pause between pixels

void setup() {
  // These lines are specifically to support the Adafruit Trinket 5V 16 MHz.
  // Any other board, you can remove this part (but no harm leaving it):
#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
  clock_prescale_set(clock_div_1);
#endif
  // END of Trinket-specific code.

  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  pixels.clear(); // Set all pixel colors to 'off'
}

uint32_t color(uint32_t ang)
{
  uint32_t bri = 255;
  ang = ang % 360;
  if (ang <= 120) {
    return pixels.Color(bri*(120-ang)/120, bri*(ang)/120, 0);
  }
  if (ang <= 240) {
    return pixels.Color(0, bri*(120-(ang-120))/120, bri*(ang-120)/120);
  }
  return pixels.Color(bri*(ang-240)/120, 0, bri*(120-(ang-240))/120);
}

uint32_t colori(uint32_t ang)
{
  uint32_t bri = 255;
  ang = ang % 360;
  if (ang <= 120) {
    return pixels.Color(bri*(ang)/120, bri*(120-ang)/120, bri);
  }
  if (ang <= 240) {
    return pixels.Color(bri, bri*((ang-120))/120, bri*(120-(ang-120))/120);
  }
  return pixels.Color(bri*(120-(ang-240))/120, bri, bri*((ang-240))/120);
}

void loop() {

  for(uint32_t bri = 0; bri < 256; bri += 1) {
    pixels.setPixelColor(0, pixels.Color(bri, bri, bri));
    pixels.show();
    delay(DELAYVAL);  
  }
  delay(10000);

  for(uint32_t ang=0; ang<28800; ang += 2+(ang/1600)) {
    for(uint32_t i=0; i<NUMPIXELS; i++) { // For each pixel...
      pixels.setPixelColor(i, colori(ang+i*0));
    }
    pixels.show();   // Send the updated pixel colors to the hardware.
    delay(DELAYVAL); // Pause before next pass through loop
  }
}
