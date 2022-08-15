#include "settings.h"
#ifdef TELNETOUT

RemoteDebug Debug;

#define FSZ 5
#define DSZ (FSZ*2)
#define NUMKEYS (3*FSZ*FSZ)

static void debug_process()
{
    String cmd = Debug.getLastCommand();
    Debug.printf("Executing command %s\r\n", cmd.c_str());
    if (cmd == "clear") {
        Debug.printf("Clearing field\r\n");
        field_clear();
    } else if (cmd == "dump") {
        Debug.printf("Dumping field state\r\n");
        field_debug_dump();
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
