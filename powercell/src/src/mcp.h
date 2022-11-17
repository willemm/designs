#ifndef _MCP_H_
#define _MCP_H_

#include "neopixel.h"

char mcp_init(void);
char mcp_start(void);
char mcp_stop(void);
color_t mcp_read_color(uint8_t flicker);

#endif
