#ifndef _MCP_H_
#define _MCP_H_

#include "neopixel.h"

void mcp_init(void);
void mcp_start(void);
void mcp_stop(void);
color_t mcp_read_color(uint8_t flicker);

#endif
