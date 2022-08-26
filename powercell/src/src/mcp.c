#include <avr/io.h>
#include <util/delay.h>
#include "i2c.h"
#include "mcp.h"
#include <math.h>

#define MCP 0x68

#define PWR_MGMT_1 0x6B
#define PWR_MGMT_2 0x6C
#define SMPLRT_DIV 0x19
#define ACCEL_XOUT 0x3B

void mcp_init(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b10000000);  // Reset
}

// Setup MCP, wake from sleep etc
void mcp_start(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b00101000);  // Accelerometer only low power mode
    i2c_write_reg_u8(MCP, PWR_MGMT_2, 0b11000111);  // 40Hz, AX,AY,AZ
}

// Put MCP to sleep
void mcp_stop(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b01101000);  // Sleep
}

// Imprecise but fast atan2 function
float fatan2(float y, float x)
{
    static const float b = 0.596227f;
    float bxy = fabs(b*x*y);
    float at = (bxy + y*y)/(x*x + bxy + bxy + y*y);
    if (x < 0.0) { at = 2.0 - at; }
    if (y < 0.0) { at = -at; }
    return at;
}

// Estimate euclidean distance with octogonal approximation
uint16_t fdist(int16_t x, int16_t y)
{
    uint32_t mx = (x > 0) ? x : -x;
    uint32_t mn = (y > 0) ? y : -y;
    if (mn > mx) {
        uint32_t tmp = mn;
        mn = mx;
        mx = tmp;
    }
    return (((mx << 8) + (mx << 3) - (mx << 4) - (mx << 1) +
             (mn << 7) - (mn << 5) + (mn << 3) - (mn << 1)) >> 8);
}

// Read data from MCP
uint16_t mcp_read(void)
{
#if 0
    if (i2c_read_reg_start(MCP, ACCEL_XOUT) < 0) {
        i2c_print("MCP read error");
        return 0;
    }
    // Accellerometers
    int16_t ax = i2c_read_u16(0);
    int16_t ay = i2c_read_u16(0);
    int16_t az = i2c_read_u16(1); // Last

    /*
    // Temperature
    int16_t tp = i2c_read_u16(0);

    // Gyroscopes
    int16_t gx = i2c_read_u16(0);
    int16_t gy = i2c_read_u16(0);
    int16_t gz = i2c_read_u16(1);  // Last

    i2c_printf("MCP Acc: (%d,%d,%d), Tem: %d, Gyr: (%d,%d,%d)", ax, ay, az, tp, gx, gy, gz);
    */

    float axf = ax;
    float ayf = ay;
    float azf = az;
    float ayzs = ayf*ayf + azf*azf;
    float ayz = sqrtf(ayzs);
    // float angh2 = atan2f(ay,az)*(180.0/M_PI);
    // float angt2 = atan2f(ax,ayz)*(180.0/M_PI);
    float angh = fatan2(ay,az)*180.0;
    float angt = fatan2(ax,ayz)*180.0;
    float at = sqrtf(ayzs + axf*axf);
    i2c_printf("Rot: (%d,%d), Acc: %d", (int)angh, (int)angt, (int)at);
#endif
    return 0;
}

color_t colori(uint32_t ang, uint32_t bri, uint32_t mbr);

color_t mcp_read_color(void)
{
    if (i2c_read_reg_start(MCP, ACCEL_XOUT) < 0) {
        i2c_print("MCP read error");
        return (color_t){ 0, 0, 0 };
    }
    // Accellerometers
    int16_t ax = i2c_read_u16(0);
    int16_t ay = i2c_read_u16(0);
    int16_t az = i2c_read_u16(1); // Last

#if 0
    float c_axf = ax;
    float c_ayf = ay;
    float c_azf = az;
    float c_ayzs = c_ayf*c_ayf + c_azf*c_azf;
    float c_ayz = sqrtf(c_ayzs);
    float c_angh = atan2f(c_ayf,c_azf)*(180.0/M_PI)+180.0;
    float c_angt = atan2f(c_axf,c_ayz)*(180.0/M_PI);
    // float c_at = sqrtf(ayzs + axf*axf);
#endif

    int16_t ayz = fdist(ay,az);
    float angh = fatan2(ay,az)*90.0+180.0;
    float angt = fatan2(ax,ayz)*90.0;
    uint32_t mbr, bri;
    if (angt >= 15.0) {
        mbr = 0;
        bri = (uint32_t)(180.0-angt*2.0);
    } else if (angt >= -15.0) {
        mbr = 0;
        bri = 180;
    } else {
        bri = 180;
        mbr = (uint32_t)(-angt*2.0);
    }
    color_t col = colori((uint32_t)angh, mbr, bri);
    // i2c_printf("(%d,%d)=%d (%d,%d)~(%d,%d) = (%d,%u,%u) -> (%u,%u,%u)", ay, az, ayz, (int)c_angt, (int)c_angh, (int)angt, (int)angh, (uint32_t)angh, mbr, bri, col.r, col.g, col.b);
    return col;
}
