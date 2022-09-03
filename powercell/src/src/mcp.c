#include <avr/io.h>
#include <util/delay.h>
#include "i2c.h"
#include "mcp.h"

#define MCP 0x68

#define PWR_MGMT_1 0x6B
#define PWR_MGMT_2 0x6C
#define SMPLRT_DIV 0x19
#define ACCEL_XOUT 0x3B

static int16_t instability;
static uint16_t instanim;
static int8_t lastx;
static int8_t lasty;
static int8_t lastz;

void mcp_init(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b10000000);  // Reset
}

// Setup MCP, wake from sleep etc
void mcp_start(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b00101000);  // Accelerometer only low power mode
    i2c_write_reg_u8(MCP, PWR_MGMT_2, 0b11000111);  // 40Hz, AX,AY,AZ
    instability = 0;
    instanim = 0;
}

// Put MCP to sleep
void mcp_stop(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b01101000);  // Sleep
}

#define PIXELCOLOR(r,g,b) ((color_t){ (uint8_t)(r), (uint8_t)(g), (uint8_t)(b) })

color_t mcp_read_color(uint8_t flicker)
{
    if (i2c_read_reg_start(MCP, ACCEL_XOUT) < 0) {
        i2c_print("MCP read error");
        return (color_t){ 0, 0, 0 };
    }
    // Accellerometers
    int16_t ax = i2c_read_u16(0);
    int16_t ay = i2c_read_u16(0);
    int16_t az = i2c_read_u16(1); // Last

    az = az >> 8;
    ay = ay >> 8;
    ax = ax >> 8;

    if (lastx || lasty || lastz) {
        int16_t dif = lastz - az;
        if (dif < 0) dif = -dif;
        int16_t shake = dif/2;
        dif = lasty - ay;
        if (dif < 0) dif = -dif;
        shake += dif/2;
        dif = lastx - ax;
        if (dif < 0) dif = -dif;
        shake += dif/2;
        if (shake > 127) shake = 127;
        instability = instability + (shake * shake) - 5;
        if (instability < 0) instability = 0;
        if (instability > 8191) instability = 8191;
    }

    lastx = ax;
    lasty = ay;
    lastz = az;

    int16_t r = ((az * 256) >> 7) - ax*2;
    int16_t g = ((ay *  222 + az * -128) >> 7) - ax*2;
    int16_t b = ((ay * -222 + az * -128) >> 7) - ax*2;

    if (instability >= 512) {
        instanim += (instability-256) * 1;
    } else {
        instanim += 256*1;
    }
    int16_t offs = ((int16_t)(instanim >> 8)) - 64;
    if (offs >= 64) offs = 128 - offs;
    offs = (offs * (instability >> 5)) >> 6;
    if (flicker) {
        uint8_t offs_rnd = (offs & 0xFF);
        offs_rnd = (offs_rnd << 4) | (offs_rnd >> 4);
        offs_rnd = ((offs_rnd & 0xCC) >> 2) | ((offs_rnd & 0x33) << 2);
        offs_rnd = ((offs_rnd & 0xAA) >> 1) | ((offs_rnd & 0x55) << 1);
        // i2c_printf("inst %d, anim %u, ianim %d, offs %d", instability, instanim, (int16_t)(instanim >> 8), offs);
        if ((instability >> 7) > offs_rnd) {
            r += offs;
            g += offs;
            b += offs;
        }
    } else {
        r += offs;
        g += offs;
        b += offs;
    }

    if (r < 0) r = 0;
    if (r > 255) r = 255;
    if (g < 0) g = 0;
    if (g > 255) g = 255;
    if (b < 0) b = 0;
    if (b > 255) b = 255;
    // i2c_printf("(%d,%d,%d) => (%d,%d,%d)", ax, ay, az, r, g, b);
    // delay(175);
    return PIXELCOLOR(r, g, b);
}
