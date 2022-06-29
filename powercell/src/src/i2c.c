#include "i2c.h"
#include "i2c_master.h"
#include <string.h>

void i2c_setup()
{
}

void i2c_send(char *txt)
{
    unsigned char ln = strlen(txt);
    I2C_Master_Write_Data(0x08, (unsigned char *)txt, ln);
}
