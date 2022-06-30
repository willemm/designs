#include "TelnetI2C.h"
#include <c_types.h>

const uint8_t I2C_ADDRESS = (0x08 << 1);
#define SDA_PIN 13
#define SCL_PIN 14

WiFiServer TelnetI2C::_server = WiFiServer(23);
WiFiClient TelnetI2C::_client;
int TelnetI2C::_busy = -1;

void TelnetI2C::begin()
{
    _server.begin();
}

void TelnetI2C::update()
{
    if ((_busy == 1) || (_busy == 2)) {
        if (!_client.connected()) {
            _client.stop();
            _busy = 0;
        } else {
            // Reject other connections
            while (_server.hasClient()) _server.available().stop();
            while (_client.available()) {
                uint8_t b = (uint8_t)_client.read();
                if (b == 13) {
                    if (_busy == 1) {
                        _busy = 2;
                        _client.print("Start logic analyzer");
                        _start_analyze();
                    } else {
                        _print_analyze();
                        _busy = 1;
                        _start_i2c();
                    }
                }
            }
        }
        _print_i2c();
    } else if (_busy <= 0) {
        if (_server.hasClient()) {
            _client = _server.available();
            _client.setNoDelay(true);
            _client.print("Connected to attiny\r\n");
            if (_busy < 0) {
                /*
                _printf("Starting pin analyzer\r\n");
                _start_analyze();
                */
                _printf("Starting i2c receiver\r\n");
                _start_i2c();
            }
            _busy = 1;
            // Reject other connections
            while (_server.hasClient()) _server.available().stop();
        }
    }
}

#define N_SAMPLES 4096

#define bitshift(val) (val)
#define isr_bitshift(val) ((((val) >> SDA_PIN) & 1) | (((val) >> (SCL_PIN)) & 1) << 1)

volatile unsigned long times[N_SAMPLES];
volatile uint8_t values[N_SAMPLES];
volatile uint8_t blockit = 0;
volatile int pointer = 0;

#define I2C_BUF_SIZE 32
#define I2C_BUF_COUNT 8

volatile struct {
  uint8_t buffer[I2C_BUF_COUNT][I2C_BUF_SIZE];
  uint8_t byte;     // Byte being received
  uint8_t bitpos;   // Position of bit being received
  uint8_t addr;     // Address being received
  uint8_t bufpos;   // Position in buffer
  uint8_t bufindex; // Index of current buffer
} I2C;

#define I2C_INTR_PINS ((1 << SDA_PIN) | (1 << SCL_PIN))

static void IRAM_ATTR handle_i2c_interrupt(void *, void *)
{
    uint32_t levels = GPI;
    uint32_t status = GPIE;
    GPIEC = status;
    // if ((status & I2C_INTR_PINS) == 0) return;
    /* Extract scl/sda
     * 0?0? = nothing changed, ignore (0,1,4,5)
     * 001? = data changing while clock low, ignore (2,3)
     * 101? = data changing while clock falling, ignore (A,B) ??
     * 0110 = data falling while clock high: start condition (6)
     * 0111 = data rising while clock high:  stop condition  (7)
     * 111? = data changing while clock rising, ignore (E, F) ??????
     * 1100 = data low with clock rising:  data bit 0 (C)
     * 1101 = data high with clock rising: data bit 1 (D)
     * 1001 = clock falling with data high: if we got 8 bits, pull SDA low to acknowledge (9)
     * 1000 = clock falling with data low: if we're pulling SDA low to acknowledge, release SDA (8)
     * Maybe 1000 and 1001 should be joined ??
     *
     * NB: If we're pulling SDA low, timeout ???
     * Maybe also wait for clock rise (1100) when asserting SDA to avoid double falling edge ???
     */
    uint8_t what = ((levels >> SDA_PIN) & 1)
                 | ((status >> SDA_PIN) & 1) << 1
                 | ((levels >> SCL_PIN) & 1) << 2
                 | ((status >> SCL_PIN) & 1) << 3;

    switch (what) {
        case 0x6: // Start condition
            if (I2C.bufpos > 1) {
                I2C.buffer[I2C.bufindex][0] = I2C.bufpos-1;
                I2C.bufindex = (I2C.bufindex + 1) % I2C_BUF_COUNT;
            }
            I2C.byte = 0;
            I2C.bitpos = 0;
            I2C.bufpos = 1;
            break;
        case 0x7: // Stop condition
            // Close current receive buffer
            if (I2C.bufpos > 1) {
                I2C.buffer[I2C.bufindex][0] = I2C.bufpos-1;
                I2C.bufindex = (I2C.bufindex + 1) % I2C_BUF_COUNT;
                I2C.bitpos = 11; // Set idle
            }
            break;
        case 0xC: // 0 bit
            if (I2C.bitpos < 8) {
                I2C.bitpos += 1;
                break;
            }
            // Fallthrough to clock rise
        case 0xD: // 1 bit
            if (I2C.bitpos < 8) {
                I2C.byte |= (1 << (7 - I2C.bitpos));
                I2C.bitpos += 1;
                break;
            }
            // Fallthrough to clock rise
        case 0xE: // clock rise: check if we're ack-ing
        case 0xF:
            if (I2C.bitpos == 9) {
                // prepare to unassert SDA
                I2C.bitpos = 10;
            }
            break;
        case 0x8: // clock fall: check if we're ack-ing or should ack
        case 0x9:
        case 0xA:
        case 0xB:
            if (I2C.bitpos == 8) {
                if (I2C.bufpos == 1) { // bufpos 0 is the buffer length
                    I2C.addr = I2C.byte;
                }
                if (I2C.bufpos < I2C_BUF_SIZE) {
                    I2C.buffer[I2C.bufindex][I2C.bufpos] = I2C.byte;
                    I2C.bufpos++;
                }
                if (I2C.addr == I2C_ADDRESS) {
                    // Assert SDA to send ACK
                    pinMode(SDA_PIN, OUTPUT);
                    digitalWrite(SDA_PIN, 0);
                    // Use bitpos 9 to show we're ack-ing
                    I2C.bitpos = 9;
                } else {
                    I2C.bitpos = 11;
                }
            }
            if (I2C.bitpos == 10) {
                // Unassert SDA
                pinMode(SDA_PIN, INPUT);
                I2C.bitpos = 11;
            }
            break;
    }
}

static void IRAM_ATTR handle_interrupt(void *arg, void *frame)
{
    (void) arg;
    (void) frame;
    uint32_t levels = GPI;
    uint32_t status = GPIE;
    GPIEC = status;
    if (blockit) return;
    pointer = (pointer + 1) % N_SAMPLES;
    times[pointer] = micros();
    values[pointer] = isr_bitshift(levels);
}

void TelnetI2C::_start_i2c()
{
    pinMode(SDA_PIN, INPUT_PULLUP);
    pinMode(SCL_PIN, INPUT_PULLUP);
    ETS_GPIO_INTR_DISABLE();
    I2C.bufpos = 0;
    I2C.bufindex = 0;
    I2C.bitpos = 11;
    GPC(SDA_PIN) &= ~(0xF << GPCI);
    GPC(SCL_PIN) &= ~(0xF << GPCI);
    GPIEC = I2C_INTR_PINS;
    GPC(SDA_PIN) |= ((CHANGE & 0xF) << GPCI);
    GPC(SCL_PIN) |= ((CHANGE & 0xF) << GPCI);
    ETS_GPIO_INTR_ATTACH(handle_i2c_interrupt, I2C_INTR_PINS);
    ETS_GPIO_INTR_ENABLE();
}

void TelnetI2C::_start_analyze()
{
    pinMode(SDA_PIN, INPUT_PULLUP);
    pinMode(SCL_PIN, INPUT_PULLUP);
    ETS_GPIO_INTR_DISABLE();
    GPC(SDA_PIN) &= ~(0xF << GPCI);
    GPC(SCL_PIN) &= ~(0xF << GPCI);
    GPIEC = I2C_INTR_PINS;
    GPC(SDA_PIN) |= ((CHANGE & 0xF) << GPCI);
    GPC(SCL_PIN) |= ((CHANGE & 0xF) << GPCI);
    ETS_GPIO_INTR_ATTACH(handle_interrupt, I2C_INTR_PINS);
    ETS_GPIO_INTR_ENABLE();
}

void TelnetI2C::_printf(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    char s[256];

    vsnprintf(s, sizeof(s), fmt, args);
    _client.print(s);
    va_end(args);
}

static uint8_t lastindex = 0;

void TelnetI2C::_print_i2c()
{
    uint8_t curindex = I2C.bufindex % I2C_BUF_COUNT;
    while (lastindex != curindex) {
        char str[64 + 3 * I2C_BUF_SIZE];
        uint8_t len = I2C.buffer[lastindex][0];
        if (I2C.buffer[lastindex][1] == I2C_ADDRESS) {
            sprintf(str, "%x I2C addr %02x received %d chars: '%.*s'\r\n",
                lastindex, I2C.buffer[lastindex][1], len-1, len-1, &I2C.buffer[lastindex][2]);
            _client.print(str);
        } else {
            char *ptr = str + sprintf(str, "%x I2C addr %02x received %d bytes:", 
                lastindex, I2C.buffer[lastindex][1], len);
            for (uint8_t i = 2; i <= len; i++) {
                ptr = ptr + sprintf(ptr, " %02x", I2C.buffer[lastindex][i]);
            }
            sprintf(ptr, "\r\n");
            _client.print(str);
        }
        lastindex = (lastindex + 1) % I2C_BUF_COUNT;
    }
}

void TelnetI2C::_print_analyze()
{
    blockit = 1;
    int pos = pointer+1;
    int lastpos = (pos + N_SAMPLES - 1);
    char buf[256];
    unsigned long times0 = times[pos];
    _printf("Pointer at %d (time %d)\r\n", pos, times0);
    /*
    for (int i = pos; i < lastpos; i++) {
        _printf("%8d:%x (%x) ", times[i % N_SAMPLES]-times0, values[i % N_SAMPLES], statuses[i % N_SAMPLES]);
    }
    _printf("\r\n");
    */
    while (pos < lastpos) {
        int epos = pos;
        while (epos != lastpos) {
            if (times[epos % N_SAMPLES] >  (times[pos % N_SAMPLES] + 1000L)) break;
            epos++;
        }
        _printf("Time %ld-%ld\r\n", times[pos % N_SAMPLES]-times0, times[(epos - 1) % N_SAMPLES]-times0);
        for (int p = 0; p < 2; p++) {
            // _printf("Pin %d\r\n", p);
            int bi = 0;
            for (int i = pos; i < epos; i++) {
                char c = ' ';
                char cb = ' ';
                if (bitshift(values[i % N_SAMPLES]) & (1 << p)) {
                    c = '_';
                    if (bitshift(values[(i-1) % N_SAMPLES]) & (1 << p)) {
                        cb = '_';
                    }
                }
                buf[bi++] = cb;
                for (unsigned long w = times[i % N_SAMPLES]+1; w < times[(i+1) % N_SAMPLES]; w += 10) {
                    buf[bi++] = c;
                    if (bi >= 120) break;
                }
                if (bi >= 120) {
                    break;
                }
            }
            buf[bi] = 0;
            _printf("%s\r\n", buf);
            bi = 0;
            for (int i = pos; i < epos; i++) {
                char c = '_';
                if (bitshift(values[i % N_SAMPLES]) & (1 << p)) {
                    c = ' ';
                }
                char cb = c;
                if ((bitshift(values[i % N_SAMPLES]) & (1 << p)) != (bitshift(values[(i-1) % N_SAMPLES]) & (1 << p))) {
                    cb = '|';
                }
                buf[bi++] = cb;
                for (unsigned long w = times[i % N_SAMPLES]+1; w < times[(i+1) % N_SAMPLES]; w += 10) {
                    buf[bi++] = c;
                    if (bi >= 120) break;
                }
                if (bi >= 120) {
                    buf[bi++] = '*';
                    break;
                }
            }
            buf[bi]  = 0;
            _printf("%s\r\n", buf);
        }
        pos = epos;
    }
    blockit = 0;
}

void TelnetI2C::pause()
{
    if (_busy == 1) {
        _client.stop();
    }
    _busy = 2;
}

void TelnetI2C::unpause()
{
    if (_busy == 2) {
        _busy = 0;
    }
}
