#include <util/delay.h>
#include <avr/io.h>
#include <Arduino.h>
#include "TrinketHidCombo.h"

void send_key(uint16_t keycode);
void ms_delay(uint16_t x);

#define REPEAT_DELAY 220

//#define DEBUG
//#define EXTRADEBUG

#define LEDPIN DDB1

/*
OK:    10005C
LEFT:  11005A
RIGHT: 10005B
UP:    110058
DOWN:  100059
PLAY:  11002C
PAUSE: 100030
STOP:  110031
PREV:  10002B
NEXT:  110028
BACK:  10000A
POWER: 10000C

*/

#define REMOTE_UP     0x0058
#define REMOTE_DOWN   0x0059
#define REMOTE_LEFT   0x005A
#define REMOTE_RIGHT  0x005B
#define REMOTE_OK     0x005C
#define REMOTE_POWER  0x000C
#define REMOTE_RETURN 0x000A
#define REMOTE_PREV   0x002B
#define REMOTE_NEXT   0x0028
#define REMOTE_PLAY   0x002C
#define REMOTE_PAUSE  0x0030

#ifdef EXTRADEBUG
volatile uint8_t times[180];
volatile uint8_t timeptr = 0, time_got = 0;
#endif // EXTRADEBUG

volatile uint32_t irread, ircode;
uint8_t irbit;
volatile uint8_t irstate = 0, irdone = 0;

int main(void) {
    DDRB |= (1 << LEDPIN);
    PORTB |= (1 << LEDPIN);
    PORTB |= 1 << PB2;
    GIMSK |= 1 << INT0;
    MCUCR |= 1 << ISC00;
    GTCCR |= 1 << PSR0;
    TCCR0A = 0;
    TCCR0B = 0;
    TIMSK = 1 << TOIE0; //interrupt Timer/Counter1 Overflow  enable
    TrinketHidCombo.begin();

    uint8_t press_timeout = 0;

    uint32_t lastcode = 0;
    for (;;) {
#ifdef EXTRADEBUG
        if (time_got) {
            for (uint8_t i = 0; i < timeptr; i += 4) {
                TrinketHidCombo.print(times[i], DEC);
                TrinketHidCombo.print(',');
                TrinketHidCombo.print(times[i+1], DEC);
                TrinketHidCombo.print(',');
                TrinketHidCombo.print(times[i+2], BIN);
                TrinketHidCombo.print(',');
                TrinketHidCombo.println(times[i+3], DEC);
            }
            TrinketHidCombo.println(timeptr, DEC);
            time_got = 0;
            timeptr = 0;
        }
#endif // EXTRADEBUG
        if (irdone) {
            uint32_t newcode = ircode;
            irdone = 0;
            if (lastcode != newcode) {
                if (press_timeout > 0) TrinketHidCombo.pressKey(0, 0);

                lastcode = newcode;
                uint16_t keycode = newcode & 0xFFFF;
                send_key(keycode);
            }
            press_timeout = 200; // Release after 200ms
        } else {
            if (press_timeout > 0) {
                press_timeout--;
            } else {
                // Unpress key
                TrinketHidCombo.pressKey(0, 0);
                PORTB &= ~(1 << LEDPIN);
            }
            _delay_ms(1);
            TrinketHidCombo.poll();
        }
    }
}

/* RC6 times:
// Transmission clock: 895 uS
//  Start bit 1:  2685 uS + 895 uS  (
//  Start bit 2:   448 uS + 448 uS
//  Field bits(3): 448 uS + 448 uS
//  Toggle bit:    895 uS + 895 uS
//  Address(8):    448 uS + 448 uS
//  Command(8):    448 uS + 448 uS
//
//  1/256 prescaler on 16MHz = 1/16
//   So transmission clock in timer ticks = 56
//   Manchester coding, so a single pulse is 28 ticks
//  Overflow (256 ticks) would be 4096 uS
//
//  1/1024 prescaler on 16MHz = 1/64
//   So transmission clock in timer ticks = 14
//   Manchester coding, so a single pulse is 7 ticks
//  Overflow (256 ticks) would be 16384 uS
*/
#define PULSE_MIN(w) (w*(28-6))
#define PULSE_MAX(w) (w*(28+6))
#define PULSE_IS(p,w) (((p) >= PULSE_MIN(w)) && ((p) <= PULSE_MAX(w)))

ISR(INT0_vect) {
    uint16_t timer_value;
    uint8_t pulse = 0;
    if (irstate) {
        timer_value = TCNT0;
        TCNT0 = 0;
        if (PULSE_IS(timer_value,1)) {
            pulse = 1;
        } else if (PULSE_IS(timer_value,2)) {
            pulse = 2;
        } else if (PULSE_IS(timer_value,3)) {
            pulse = 3;
        } else if (PULSE_IS(timer_value,6)) {
            pulse = 6;
        }
#ifdef EXTRADEBUG
        if (!time_got && timeptr < sizeof(times)-3) {
            times[timeptr++] = irstate;
            times[timeptr++] = pulse;
            times[timeptr++] = irread;
            times[timeptr++] = irbit;
        }
#endif // EXTRADEBUG
    }
    switch (irstate) {
      case 0: // Start
        irstate = 1;
        TCCR0B = (1 << CS02); // start clock, prescale 1/256
        break;
      case 1: // First (6x = 168) pulse of start bit, high to low
        if (pulse == 6 && (PINB & (1 << 2))) {
            irread = 0;
            irbit = 21;  // start(4)-toggle(1)-address(8)-command(8), counting from 0
            irstate = 2;
        }
        break;
      case 2: // Second (2x = 56) pulse of start bit (nb: second start bit is 1)
        if (pulse == 2 && !(PINB & (1 << 2))) {
            irstate = 3;
        } else {
            irstate = 1;
        }
        break;
      case 3: // First half of bit, started with edge
        // Always expect an edge, but position 17 (toggle bit) length is doubled
        if (pulse == 1 || (pulse == 2 && irbit == 17)) {
            irbit--;
            if ((PINB & (1 << 2))) {
                // High means pulse is low, which means this is a 1 bit
                irread |= (1UL << irbit);
            }
            irstate = 4;
            if (irbit == 0) {
                ircode = irread;
                irdone = 1;
                irstate = 1; // Maybe go again
            } 
        } else {
            irstate = 1; // Fail
        }
        break;
      case 4: // Second half of bit, maybe first half of next bit
        if (irbit == 16) pulse--; // Second half of toggle bit is longer
        if (pulse == 1) {
            // Single period means next bit starts with edge
            irstate = 3;
        } else if (pulse == 2 || (pulse == 3 && irbit == 17)) {
            irbit--;
            // Double period means next bit had no edge and we're in it
            if ((PINB & (1 << 2))) {
                irread |= (1UL << irbit); // Low means this is a 1 bit
            }
            if (irbit == 0) {
                ircode = irread;
                irdone = 1;
                irstate = 1; // Maybe go again
            } 
        } else {
            irstate = 1; // Fail
        }
        break;
    }
}

ISR(TIMER0_OVF_vect) {
    // GIMSK &= ~(1 << INT0);
    irstate = 0;
#ifdef EXTRADEBUG
    time_got = 1;
#endif // EXTRADEBUG
    TCCR0B = 0;
}

void ms_delay(uint16_t x) // USB polling delay function
{
  for (uint16_t m = 0; m < (x / 10); m++) {
    _delay_ms(10);
    TrinketHidCombo.poll();
  }
}

void send_key(uint16_t keycode)
{
  switch (keycode)
  {
    case REMOTE_OK:
      TrinketHidCombo.pressKey(0, KEYCODE_ENTER);
      break;
    case REMOTE_LEFT:
      TrinketHidCombo.pressKey(0, KEYCODE_ARROW_LEFT);
      break;
    case REMOTE_RIGHT:
      TrinketHidCombo.pressKey(0, KEYCODE_ARROW_RIGHT);
      break;
    case REMOTE_DOWN:
      TrinketHidCombo.pressKey(0, KEYCODE_ARROW_DOWN);
      break;
    case REMOTE_UP:
      TrinketHidCombo.pressKey(0, KEYCODE_ARROW_UP);
      break;
//    case REMOTE_POWER:
//      TrinketHidCombo.pressSystemCtrlKey(SYSCTRLKEY_POWER);
//      break;
    case REMOTE_RETURN:
      TrinketHidCombo.pressKey(0, KEYCODE_BACKSPACE);
      break;
    case REMOTE_PREV:
      TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_PREV_TRACK);
      break;
    case REMOTE_NEXT:
      TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_NEXT_TRACK);
      break;
    case REMOTE_PLAY:
      TrinketHidCombo.pressMultimediaKey(MMKEY_PLAYPAUSE);
      break;
    case REMOTE_PAUSE:
      TrinketHidCombo.pressMultimediaKey(MMKEY_PLAYPAUSE);
      break;

    default:
#ifdef DEBUG
      TrinketHidCombo.println(keycode, HEX);
#else
      return;
#endif // DEBUG
      
  }
  PORTB |= (1 << LEDPIN);
}
