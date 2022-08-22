#include <avr/io.h>
#include "i2c.h"

#define MCP 0x68

#define PWR_MGMT_1 0x6B
#define SMPLRT_DIV 0x19
#define ACCEL_XOUT 0x3B

// Setup MCP, wake from sleep etc
void mcp_start(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b10000000);  // Reset, normal operation
}

// Put MCP to sleep
void mcp_stop(void)
{
    i2c_write_reg_u8(MCP, PWR_MGMT_1, 0b01000000);  // Sleep
}

// Read data from MCP
void mcp_read(void)
{
    if (i2c_read_reg_start(MCP, ACCEL_XOUT) < 0) {
        i2c_print("MCP read error");
        return;
    }
    // Accellerometers
    uint16_t ax = i2c_read_u16(0);
    uint16_t ay = i2c_read_u16(0);
    uint16_t az = i2c_read_u16(0);

    // Temperature
    uint16_t tp = i2c_read_u16(0);

    // Gyroscopes
    uint16_t gx = i2c_read_u16(0);
    uint16_t gy = i2c_read_u16(0);
    uint16_t gz = i2c_read_u16(1);  // Last

    i2c_printf("MCP Acc: (%d,%d,%d), Tem: %d, Gyr: (%d,%d,%d)", ax, ay, az, tp, gx, gy, gz);
}
