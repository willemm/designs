#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    DDRB |= _BV(5);
    PORTB &= ~(_BV(5));
    TCCR1A = _BV(COM1A1) | _BV(WGM11);
    TCCR1B = _BV(WGM13) | _BV(WGM12) | _BV(CS10);
    ICR1 = 147;
    OCR1A = 74;
    while (1) {
        _delay_ms(1000);
        TCCR1A = _BV(WGM11);
        PORTB &= ~(_BV(5));
        _delay_ms(2000);
        TCCR1A = _BV(COM1A1) | _BV(WGM11);
    }
    return 0;
}
