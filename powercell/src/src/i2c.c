#include "i2c.h"
#include "i2c_master.h"
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

void i2c_setup()
{
}

void i2c_printf(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    static char s[128];

    unsigned char ln = vsnprintf(s, sizeof(s), fmt, args);
    I2C_Master_Write_Data(0x08, (unsigned char *)s, ln);
    va_end(args);
}

void i2c_print(const char *txt)
{
    I2C_Master_Write_Data(0x08, (unsigned char *)txt, strlen(txt));
}
