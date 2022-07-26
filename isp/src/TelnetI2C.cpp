#include "TelnetI2C.h"
#include <c_types.h>
#include <SoftwareSerial.h>

const uint8_t I2C_ADDRESS = (0x08 << 1);
#define SDA_PIN 13
#define SCL_PIN 14

#define RX_PIN 12

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
                        //_stop_rx();
                        _busy = 2;
                        _client.print("Start logic analyzer");
                        _start_analyze();
                    } else {
                        _print_analyze();
                        _busy = 1;
                        //_start_rx();
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
                /*
                _printf("Starting serial receiver\r\n");
                _start_rx();
                */
            }
            _busy = 1;
            // Reject other connections
            while (_server.hasClient()) _server.available().stop();
        }
    }
}

SoftwareSerial rxSerial(RX_PIN, 4);

void TelnetI2C::_start_rx()
{
    rxSerial.begin(100000);
}

void TelnetI2C::_stop_rx()
{
    rxSerial.end();
}

void TelnetI2C::_print_rx()
{
    char buf[256];
    int pt;
    while (rxSerial.available() > 0) {
        buf[pt] = rxSerial.read();
        pt++;
        if ((buf[pt-1] == '\n') || (pt > 253)) {
            buf[pt] = 0;
            _client.print(buf);
            pt = 0;
        }
    }
    if (pt > 0) {
        buf[pt] = 0;
        _client.print(buf);
    }
}

#define N_SAMPLES 4096

#define bitshift(val) (val)
#define isr_bitshift(val) ((((val) >> SDA_PIN) & 1) | (((val) >> (SCL_PIN)) & 1) << 1 | (((val) >> (RX_PIN)) & 1) << 2)

volatile unsigned long times[N_SAMPLES];
volatile uint8_t values[N_SAMPLES];
volatile uint8_t blockit = 0;
volatile int pointer = 0;
volatile unsigned long timestart = 0;

#define I2C_BUF_SIZE 31
#define I2C_BUF_COUNT 8

#if 1
volatile struct {
    struct {
        uint8_t len;
        uint8_t bytes[I2C_BUF_SIZE];
    } buffer[I2C_BUF_COUNT];
    uint8_t bufindex; // Index of current buffer
} I2C;
#else
volatile struct {
    uint8_t buffer[I2C_BUF_COUNT][I2C_BUF_SIZE];
    uint8_t byte;     // Byte being received
    uint8_t bitpos;   // Position of bit being received
    uint8_t addr;     // Address being received
    uint8_t bufpos;   // Position in buffer
    uint8_t bufindex; // Index of current buffer
    uint8_t status;   // If we're ack-ing
} I2C;
#endif

#define I2C_INTR_PINS ((1 << SDA_PIN) | (1 << SCL_PIN))

#if 0
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
        case 0x6: // Start condition: Setup new buffer
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
                    // show we're ack-ing
                    I2C.status = 1;
                }
                // Use bitpos 9 to check for rising clock
                I2C.bitpos = 9;
            }
            if (I2C.bitpos == 10) {
                if (I2C.status) {
                    // Unassert SDA
                    pinMode(SDA_PIN, INPUT);
                    I2C.status = 0;
                }
                // Ready for next byte
                I2C.bitpos = 0;
            }
            break;
    }
}
#endif

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

static void IRAM_ATTR handle_i2c_interrupt_block(void *arg, void *frame) {
    (void) arg;
    (void) frame;
    uint32_t levels = GPI;
    uint32_t status = GPIE;
    GPIEC = status;
    // Was it a change on SDA
    if ((status & (1 << SDA_PIN)) == 0) { return; }
    // Was it a falling edge on SDA while SCL is high
    if ((levels & ((1 << SDA_PIN) | (1 << SCL_PIN))) != (1 << SCL_PIN)) { return ; }
    int bytepos = 0;
    // 4 milliseconds, assuming one wait cycle is 3 instructions (check bit, dec timeout, branch)
    int32_t timeout = 4 * F_CPU / 1000 / 4;
    uint8_t addr = 0;
    I2C.bufindex %= I2C_BUF_COUNT;
    while (true) {
        // Marker bit
        uint16_t byte = 1;
        // Read 8 bits on SCl rising
        while (byte < 0x100) {
            // Wait for SCL to fall
            while (GPI & (1 << SCL_PIN)) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            // Wait for SCL to rise, also check if SDA changes
            // Rise means stop condition.
            // If it falls, it's a repeated start which we don't want to support
            uint16_t stop = (GPI & (1 << SDA_PIN));
            while (!(GPI & (1 << SCL_PIN))) {
                if ((GPI & (1 << SDA_PIN)) != stop) { break; /* Stop condition */ }
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            // Read SDA
            byte = byte << 1 | ((GPI >> SDA_PIN) & 1);
        }
        byte &= 0xFF;
        if (bytepos == 0) {
            addr = byte;
        }
        I2C.buffer[I2C.bufindex].bytes[bytepos] = byte;
        bytepos++;
        if (addr == I2C_ADDRESS) {
            // Ack
            // Wait for SCL to fall
            while (GPI & (1 << SCL_PIN)) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            // Ack on SDA
            pinMode(SDA_PIN, OUTPUT);
            digitalWrite(SDA_PIN, LOW);
            // Wait for SCL to rise
            while (!(GPI & (1 << SCL_PIN))) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            // Wait for SCL to fall
            while (GPI & (1 << SCL_PIN)) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            pinMode(SDA_PIN, INPUT_PULLUP);
        } else {
            // Wait for SCL to fall
            while (GPI & (1 << SCL_PIN)) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
            // Wait for SCL to rise
            while (!(GPI & (1 << SCL_PIN))) {
                if (--timeout <= 0) { return; /* Timed out */ }
            }
        }
    }
    I2C.buffer[I2C.bufindex].len = bytepos;
    I2C.bufindex = (I2C.bufindex + 1) % I2C_BUF_COUNT;
}

#if 1
void TelnetI2C::_start_i2c()
{
    pinMode(SDA_PIN, INPUT_PULLUP);
    pinMode(SCL_PIN, INPUT_PULLUP);
    ETS_GPIO_INTR_DISABLE();
    I2C.bufindex = 0;
    GPC(SDA_PIN) &= ~(0xF << GPCI);
    GPIEC = (1 << SDA_PIN);
    GPC(SDA_PIN) |= ((CHANGE & 0xF) << GPCI);
    ETS_GPIO_INTR_ATTACH(handle_i2c_interrupt_block, (1 << SDA_PIN));
    ETS_GPIO_INTR_ENABLE();
}
#else
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
#endif

void TelnetI2C::_start_analyze()
{
    timestart = micros();
    pinMode(SDA_PIN, INPUT_PULLUP);
    pinMode(SCL_PIN, INPUT_PULLUP);
    pinMode(RX_PIN, INPUT_PULLUP);
    ETS_GPIO_INTR_DISABLE();
    GPC(SDA_PIN) &= ~(0xF << GPCI);
    GPC(SCL_PIN) &= ~(0xF << GPCI);
    GPC(RX_PIN) &= ~(0xF << GPCI);
    GPIEC = I2C_INTR_PINS | (1 << RX_PIN);
    GPC(SDA_PIN) |= ((CHANGE & 0xF) << GPCI);
    GPC(SCL_PIN) |= ((CHANGE & 0xF) << GPCI);
    GPC(RX_PIN) |= ((CHANGE & 0xF) << GPCI);
    ETS_GPIO_INTR_ATTACH(handle_interrupt, (I2C_INTR_PINS | (1 << RX_PIN)));
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
        uint8_t len = I2C.buffer[lastindex].len;
        if (0 /*I2C.buffer[lastindex][1] == I2C_ADDRESS*/) {
            sprintf(str, "%x I2C addr %02x received %d chars: '%.*s'\r\n",
                lastindex, I2C.buffer[lastindex].bytes[0] >> 1, len-1, len-1, &I2C.buffer[lastindex].bytes[1]);
            _client.print(str);
        } else {
            char *ptr = str + sprintf(str, "%x I2C addr %02x received %d bytes:", 
                lastindex, I2C.buffer[lastindex].bytes[0] >> 1, len-1);
            for (uint8_t i = 1; i < len; i++) {
                ptr = ptr + sprintf(ptr, " %02x", I2C.buffer[lastindex].bytes[i]);
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
    while (times[pos % N_SAMPLES] < timestart) {
        pos++;
        if (pos >= lastpos) {
            _printf("No samples found");
            return;
        }
    }
    unsigned long times0 = times[pos % N_SAMPLES];
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
        for (int p = 0; p < 3; p++) {
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
                for (unsigned long w = times[i % N_SAMPLES]+1; w < times[(i+1) % N_SAMPLES]; w += 5) {
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
                for (unsigned long w = times[i % N_SAMPLES]+1; w < times[(i+1) % N_SAMPLES]; w += 5) {
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
