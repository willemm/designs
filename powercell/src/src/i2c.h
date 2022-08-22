#ifndef _I2C_H_
#define _I2C_H_

#include <stdint.h>

void i2c_setup(void);
char i2c_write_bytes(unsigned char addr, const unsigned char *msg, unsigned char msg_size);
char i2c_write_reg_u8(unsigned char addr, unsigned char reg, unsigned char data);
int i2c_read_reg_u8(unsigned char addr, unsigned char reg);
char i2c_read_reg_start(unsigned char addr, unsigned char reg);
uint8_t i2c_read_u8(char last);
uint16_t i2c_read_u16(char last);
void i2c_printf(const char *fmt, ...);
void i2c_print(const char *txt);

#endif
