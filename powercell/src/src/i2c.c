#include "i2c.h"
#include <avr/interrupt.h>
#include <avr/io.h>
#include <util/delay.h>
#include <USI_TWI_Master.h>

/*
#define I2C_SCL 2
#define I2C_SDA 0

#define SETBIT(b) ((PORTB |= (1 << (b))))
#define CLRBIT(b) ((PORTB &= ~(1 << (b))))

void i2c_setup()
{
    SETBIT(I2C_SDA);
    SETBIT(I2C_SCL);

    DDRB |= (1 << I2C_SCL);
    DDRB |= (1 << I2C_SDA);

    USIDR = 0xFF;
    USICR = (0 << USISIE) | (0 << USIOIE)
          | (1 << USIWM1) | (0 << USIWM0)
          | (1 << USICS1) | (0 << USICS0)
          | (1 << USICLK) | (0 << USITC );
    USISR = (1 << USISIF) | (1 << USIOIF)
          | (1 << USIPF ) | (1 << USIDC )
          | (0x0 << USICNT0) ;
}

static void i2c_start()
{
    SETBIT(I2C_SCL);
    while (!(PORTB & (1 << I2C_SCL)))
        ;
    _delay_us(5);

    CLRBIT(I2C_SDA);
    _delay_us(5);
    CLRBIT(I2C_SCL);
    SETBIT(I2C_SDA);
}

static void i2c_send_data(char *msg)
{
    unsigned char const do8bits = (1 << USISIF) | (1 << USIOIF)
                                | (1 << USIPF ) | (1 << USIDC)
                                | (0x0 << USICNT0) ;

    unsigned char const do1bits = (1 << USISIF) | (1 << USIOIF)
                                | (1 << USIPF ) | (1 << USIDC)
                                | (0xE << USICNT0) ;

    unsigned char const doedge = (0 << USISIE) | (0 << USIOIE)
                               | (1 << USIWM1) | (0 << USIWM0)
                               | (1 << USICS1) | (0 << USICS0)
                               | (1 << USICLK) | (1 << USITC ) ;

    while (*msg) {
        USIDR = (unsigned char)*msg++;
        USISR = do8bits;
        do {
            _delay_us(5);
            USICR = doedge;
            while (!(PINB & (1 << I2C_SCL)))
                ;
            _delay_us(5);
            USICR = doedge;
        } while (!(USISR & (1 << USIOIF)));
        _delay_us(5);
        USIDR = 0xFF;

        DDRB &= ~(1 << I2C_SDA);
        USISR = do1bits;
        do {
            _delay_us(5);
            USICR = doedge;
            while (!(PINB & (1 << I2C_SCL)))
                ;
            _delay_us(5);
            USICR = doedge;
        } while (!(USISR & (1 << USIOIF)));
        _delay_us(5);
        unsigned char ack = USIDR;
        USIDR = 0xFF;
        DDRB |= (1 << I2C_SDA);

        if (ack & 1) {
            return;
        }
    }
}

static void i2c_stop()
{
    CLRBIT(I2C_SDA);
    SETBIT(I2C_SCL);
    while (!(PINB & (1 << I2C_SCL)))
        ;
    _delay_us(5);
    SETBIT(I2C_SDA);
}

void i2c_send(char *txt)
{
    i2c_start();
    i2c_send_data(txt);
    i2c_stop();
}
*/

#if 0
void i2c_setup()
{
    USI_TWI_Master_Initialise();
}

void i2c_send(char *txt)
{
    uint8_t buf[256];
    char xferOK = 0;
    buf[0] = 0x08;
    uint8_t len;
    while (*txt && (len < 255)) {
        buf[len++] = *txt++;
    }
    buf[len++] = 0;
    xferOK = USI_TWI_Start_Read_Write(buf, len);
    if (xferOK) {
        USI_TWI_Master_Stop();
    }
}
#else
void i2c_setup()
{
}

void i2c_send(char *txt)
{
}

#endif
