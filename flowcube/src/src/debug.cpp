#include "settings.h"
#ifdef TELNETOUT

RemoteDebug Debug;

#define FSZ 5
#define DSZ (FSZ*2)
#define NUMKEYS (3*FSZ*FSZ)

static inline int field_idx(int y, int x)
{
    if (y < FSZ) {
        // top
        return (FSZ-1-x)*FSZ + y;
        //return (FSZ-1)*FSZ - x*FSZ + y;
    } else if (x < FSZ) {
        // front
        return FSZ*FSZ + (y-FSZ)*FSZ + x;
        //return y*FSZ + x;
    } else {
        // right
        return FSZ*FSZ*2 + (x-FSZ)*FSZ + (FSZ-1-(y-FSZ));
        //return FSZ*FSZ + 2*FSZ - 1 + x*FSZ - y;
    }
}

static void debug_dump()
{
    for (int y = 0; y < DSZ; y++) {
        int xsz = ((y >= FSZ) ? DSZ : FSZ);
        for (int x = 0; x < xsz; x++) {
            Debug.printf("%2d  ", field_idx(y, x));
        }
        Debug.printf("\r\n");
    }
    for (int idx = 0; idx < NUMKEYS; idx++) {
        Debug.printf("%2d : neighbour = (%2d, %2d, %2d, %2d) pixel = (%2d, %2d, %2d, %2d) side = %d\r\n",
            idx,
            field[idx].neighbour[0], field[idx].neighbour[1],
            field[idx].neighbour[2], field[idx].neighbour[3],
            field[idx].pixel[0], field[idx].pixel[1],
            field[idx].pixel[2], field[idx].pixel[3],
            field[idx].side);
        Debug.printf("    : chain = (%d, %d) dist = %2d color = %2d endpoint = %d\r\n",
            field[idx].prev, field[idx].next, field[idx].dist,
            field[idx].color, field[idx].is_endpoint);
    }
}

static void debug_process()
{
    String cmd = Debug.getLastCommand();
    Debug.printf("Executing command %s\r\n", cmd.c_str());
    if (cmd == "clear") {
        Debug.printf("Clearing field\r\n");
        field_clear();
    } else if (cmd == "dump") {
        Debug.printf("Dumping field state\r\n");
        debug_dump();
    } else if (cmd == "reset") {
        Debug.printf("Resetting\r\n");
        ESP.restart();
    }
}

void debug_init()
{
    Debug.begin(OTA_NAME);
    Debug.showColors(true);
    Debug.setCallBackProjectCmds(&debug_process);
    Debug.setHelpProjectsCmds("clear - clear field\r\ndump - show field state\r\nreset - reboot esp");
}

void debug_update()
{
    Debug.handle();
}

#else // TELNETOUT
void debug_init()
{
}
void debug_update()
{
}
#endif // TELNETOUT
