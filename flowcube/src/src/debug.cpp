#include "settings.h"
#ifdef TELNETOUT

RemoteDebug Debug;

struct res_t {
    uint8_t dv,md;
};

static inline res_t calc_divmod5_base(uint8_t idx)
{
    res_t res;
    res.dv = ((idx % 32) / 5);
    res.md = ((idx % 32) % 5);
    return res;
}

static inline res_t calc_divmod5_dm(uint8_t idx)
{
    res_t res;
    res.dv = ((idx % 32) / 5);
    res.md = ((idx % 32) - (res.dv * 5));
    return res;
}

/*
	movi.n	a3, 0x18
	addi	sp, sp, -16
	bne	a2, a3, .L2
	movi.n	a2, 4
	s8i	a2, sp, 0
	j	.L7
.L2:
	extui	a4, a2, 0, 2
	srli	a2, a2, 2
	movi.n	a3, 1
	blt	a4, a2, .L4
	movi.n	a3, 0
.L4:
	sub	a3, a2, a3
	s8i	a3, sp, 0
	movi.n	a5, 0
	sub	a3, a4, a2
	bge	a4, a2, .L6
	movi.n	a5, 5
.L6:
	add.n	a2, a3, a5
.L7:
	s8i	a2, sp, 1
	l8ui	a2, sp, 1
	l8ui	a3, sp, 0
	slli	a2, a2, 8
	or	a2, a3, a2
	addi	sp, sp, 16
	ret.n
*/

static inline res_t calc_divmod5_flex(uint8_t idx)
{
    res_t res;
    uint8_t r = (idx & 3);
    uint8_t d = (idx >> 2);
    uint8_t o = (d > r) + (d > 5);
    res.dv = d - o;
    res.md = r + o*5 - d;
    return res;
}

static inline uint32_t asm_ccount(void) {
    uint32_t r;

    asm volatile ("rsr %0, ccount" : "=r"(r));
    return r;
}

static void do_timing_base()
{
    uint32_t st = asm_ccount();
    uint8_t tot = 0;
    for (int n = 0; n < 400; n++) {
        for (uint8_t idx = 0; idx < 25; idx++) {
            res_t r = calc_divmod5_base(idx);
            tot = tot + r.dv + r.md;
        }
    }
    uint32_t el = asm_ccount();
    el = el - st;
    debugI("calc_divmod5_base took %d ticks, result %d, %d ticks/div\r\n", el, tot, (el/(400*25)));
}

static void do_timing_dm()
{
    uint32_t st = asm_ccount();
    uint8_t tot = 0;
    for (int n = 0; n < 400; n++) {
        for (uint8_t idx = 0; idx < 25; idx++) {
            res_t r = calc_divmod5_dm(idx);
            tot = tot + r.dv + r.md;
        }
    }
    uint32_t el = asm_ccount();
    el = el - st;
    debugI("calc_divmod5_dm took %d ticks, result %d, %d ticks/div\r\n", el, tot, (el/(400*25)));
}

static void do_timing_flex()
{
    uint32_t st = asm_ccount();
    uint8_t tot = 0;
    for (int n = 0; n < 400; n++) {
        for (uint8_t idx = 0; idx < 25; idx++) {
            res_t r = calc_divmod5_flex(idx);
            tot = tot + r.dv + r.md;
        }
    }
    uint32_t el = asm_ccount();
    el = el - st;
    debugI("calc_divmod5_flex took %d ticks, result %d, %d ticks/div\r\n", el, tot, (el/(400*25)));
}

static void do_test_divs()
{
    /*
    for (uint8_t idx = 0; idx < 25; idx++) {
        res_t r1 = calc_divmod5_base(idx);
        res_t r2 = calc_divmod5_dm(idx);
        res_t r3 = calc_divmod5_flex(idx);
        if (r1.dv != r2.dv) { debugE("Divmod error: %d / 5 != %d\r\n", idx, r2.dv); }
        if (r1.md != r2.md) { debugE("Divmod error: %d %% 5 != %d\r\n", idx, r2.md); }
        if (r1.dv != r3.dv) { debugE("Flex error: %d / 5 != %d\r\n", idx, r3.dv); }
        if (r1.md != r3.md) { debugE("Flex error: %d %% 5 != %d\r\n", idx, r3.md); }
    }
    */
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
        field_debug_dump();
    } else if (cmd == "reset") {
        Debug.printf("Resetting\r\n");
        ESP.restart();
    } else if (cmd == "perftest") {
        Debug.printf("Timing performance\r\n");
        do_test_divs();
        do_timing_base();
        do_timing_dm();
        do_timing_flex();
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
