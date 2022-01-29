#include <Wire.h>

#define MCP23017 0x20

#define MCP_IODIR   0x00
#define MCP_IPOL    0x02
#define MCP_GPINTEN 0x04
#define MCP_DEFVAL  0x06
#define MCP_INTCON  0x08
#define MCP_IOCON   0x0A
#define MCP_GPPU    0x0C
#define MCP_INTF    0x0E
#define MCP_INTCAP  0x10
#define MCP_GPIO    0x12
#define MCP_OLAT    0x14
static inline int mcpwrite(byte reg, uint16_t val)
{
    Wire.beginTransmission(MCP23017);
    Wire.write(reg);
    Wire.write(val & 0xff);
    Wire.write((val >> 8) & 0xff);
    if (Wire.endTransmission()) {
        serprintf("mcp write error");
        return -1;
    }
    return 0;
}

static inline int32_t mcpread(byte reg)
{
    Wire.beginTransmission(MCP23017);
    Wire.write(reg);
    if (Wire.endTransmission()) {
        serprintf("mcp read error");
        return -1;
    }
    Wire.requestFrom(MCP23017, 2);
    byte lo, hi;
    lo = Wire.read();
    hi = Wire.read();
    return (hi << 8) | lo;
}

#define KEYROW1 0b0000000011111000
#define KEYROW2 0b0001111100000000
#define KEYROW3 0b0110000000000111

uint16_t scanrows[][2] = {
    { KEYROW1, KEYROW2|KEYROW3 },
    { KEYROW2, KEYROW3 }
};

byte keyoff[] = {
    0, 25
};

byte keyrows[] = {
    7,6,5,
    4,3,2,1,0,
    0,1,2,3,4,
    8,9,0
};

int keys_scan()
{
    int key = 0;
    if (mcpwrite(MCP_GPPU, KEYROW1|KEYROW2|KEYROW3) < 0) return -1;
    if (mcpwrite(MCP_IODIR, 0xFFFF) < 0) return -1;
    for (int r = 0; r < 2; r++) {
        // Loop over first set
        for (int ob = 0; ob < 16; ob++) {
            if (scanrows[r][0] & (1 << ob)) {
                // Set one pin to output, output a zero
                // serprintf("Bit %d, write 0x%04x", ob, ~(1<<ob));
                if (mcpwrite(MCP_IODIR, ~(1<<ob)) < 0) return -1;
                if (mcpwrite(MCP_GPIO, ~(1<<ob)) < 0) return -1;

                int32_t res = mcpread(MCP_GPIO);
                if (res < 0) {
                    mcpwrite(MCP_IODIR, 0xFFFF);
                    return -1;
                }
                // serprintf("Got result 0x%04x, scanning 0x%04x", res, scanrows[r][1]);
                for (int ib = 0; ib < 16; ib++) {
                    if (scanrows[r][1] & (1 << ib)) {
                        if ((res & (1 << ib)) == 0) {
                            if (key > 0) {
                                // Double press
                                mcpwrite(MCP_IODIR, 0xFFFF);
                                return 0;
                            }
                            key = keyoff[r]+keyrows[ib]*5+keyrows[ob]+1;
                            // serprintf("Pressed: %d,%d = %d", ob, ib, key);
                        }
                    }
                }
            }
        }
    }
    mcpwrite(MCP_IODIR, 0xFFFF);
    return key;
}

void keys_init()
{
    Wire.begin();
    /*
    serprintf("Scanning I2C bus...");
    Wire.begin();
    for (byte i = 8; i < 120; i++) {
        Wire.beginTransmission(i);
        if (Wire.endTransmission() == 0) {
            serprintf("Found I2C device at 0x%02x", i);
            delay(1);
        }
    }
    serprintf("Scanning I2C bus finished");
    */
}
