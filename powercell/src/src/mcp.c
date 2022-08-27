#include <avr/io.h>
#include <util/delay.h>
#include "i2c.h"
#include "mcp.h"
// #include <math.h>

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

#if 0
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
#endif

// Imprecise but fast atan2 function with integer math
// Returns degrees in range 0-360
int16_t iatan2(int16_t y, int16_t x)
{
    static const uint32_t b = 19537; // (0.596227 << 15)
    uint32_t ux = (x > 0) ? x : -x;
    uint32_t uy = (y > 0) ? y : -y;
    uint32_t bxy = ((uy*ux)>>16)*b;  // Shift right one to make room plus 15 for the constant
    uint32_t numer = bxy + ((uy*uy)>>1);
    // Shift denominator 10 bits to scale range 0-1 to 0-1024
    uint32_t at = numer / ((numer + bxy + ((ux*ux)>>1)) >> 10);
    // at is now scaled from 0 to 1024 which should be 0 to 90
    at = (at * 90) >> 10;

    if (x < 0) { at = 180 - at; }
    if (y < 0) { at = -at; }
    return at;
}

// Estimate euclidean distance with octogonal approximation
uint16_t idist(int16_t x, int16_t y)
{
    uint32_t mx = (x > 0) ? x : -x;
    uint32_t mn = (y > 0) ? y : -y;
    if (mn > mx) {
        uint32_t tmp = mn;
        mn = mx;
        mx = tmp;
    }
    // mx * (256 + 8 - 16 - 2) = mx * 246
    // mn * (128 - 32 + 8 - 2) = mn * 102
    return (((mx << 8) - (mx << 3) - (mx << 1) +
             (mn << 7) - (mn << 4) - (mn << 3) - (mn << 1)) >> 8);
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

color_t fcolori(uint16_t ang, uint16_t bri, uint16_t mbr);

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

    int16_t ayz = idist(ay,az);
    int16_t angh = iatan2(ay,az)+180;
    int16_t angt = iatan2(ax,ayz);
    /*
    float angh = fatan2(ay,az)*90.0+180.0;
    float angt = fatan2(ax,ayz)*90.0;
    */
    uint16_t mbr, bri;
    if (angt >= 15) {
        mbr = 0;
        bri = (uint16_t)(180-angt*2);
    } else if (angt >= -15) {
        mbr = 0;
        bri = 180;
    } else {
        bri = 180;
        mbr = (uint16_t)(-angt*2);
    }
    color_t col = fcolori((uint16_t)angh, mbr, bri);
    // i2c_printf("(%d,%d)=%d (%d,%d)~(%d,%d) = (%d,%u,%u) -> (%u,%u,%u)", ay, az, ayz, (int)c_angt, (int)c_angh, (int)angt, (int)angh, (uint32_t)angh, mbr, bri, col.r, col.g, col.b);
    return col;
}
