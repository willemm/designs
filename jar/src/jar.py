from machine import PWM, Pin, ADC
from neopixel import NeoPixel
from time import sleep_ms, ticks_ms, ticks_add, ticks_diff

leds = NeoPixel(Pin(20), 51);
btn_stop = Pin(13, Pin.IN, Pin.PULL_UP)
sw_1l = Pin(12, Pin.IN, Pin.PULL_UP)
sw_1r = Pin(2, Pin.IN, Pin.PULL_UP)
sw_2l = Pin(6, Pin.IN, Pin.PULL_UP)
sw_2r = Pin(7, Pin.IN, Pin.PULL_UP)
sw_3l = Pin(10, Pin.IN, Pin.PULL_UP)
sw_3r = Pin(3, Pin.IN, Pin.PULL_UP)

pot1 = ADC(Pin(1))
pot2 = ADC(Pin(0))

pwms = [PWM(Pin(p), 108000, duty=0) for p in [8,9,4,5]]

def floatto255(x):
    return 0 if x < 0 else 255 if x > 1 else int(x*255)

def noodstop():
    return btn_stop.value() == 1

def clampfloat(x):
    return 0.0 if x < 0.0 else 1.0 if x > 1.0 else x

def pot1val():
    # uv = microvolts, max = about 0.9v scale to 0-1
    return clampfloat(pot1.read_uv() / 900000.0)

def pot2val():
    return clampfloat(pot2.read_uv() / 900000.0)

def startup_sequence():
    # Turn on all humidifiers
    for pw in pwms:
        pw.duty(512)

    leds.fill((0,0,0))
    for s in range(100):
        ftick = s/100.0
        if noodstop():
            break
        leds[0] = (0,0,255)
        leds[1] = ( 255 if ftick > 0.1 and ftick < 0.3  else 0
                  , 255 if ftick > 0.4 and ftick < 0.6 else 0
                  , 255 if ftick > 0.7 and ftick < 0.9 else 0 )
        for p in range(12):
            if ftick > p/12.0 and ftick < ((p+1)/12.0):
                leds[p+2] = (255, 255, 255)
            elif ftick > ((p+1)/12.0):
                leds[p+2] = (floatto255(1.0-3.0*(ftick-(p+1)/12.0)), 0, 0)
            else:
                leds[p+2] = (0,0,0)
        icol = (floatto255(ftick), floatto255(ftick-0.5), floatto255(ftick-0.25))
        for p in range(37):
            leds[p+14] = icol
        leds.write()
        sleep_ms(25)

    # Turn off all humidifiers
    for pw in pwms:
        pw.duty(0)

def shutting_down_state():
    for pw in pwms:
        pw.duty(0)
    for s in range(100):
        ftick = 1.0-s/100.0
        if not noodstop():
            break
        leds.fill((floatto255(ftick*1.2), floatto255(ftick*1.2-0.5), floatto255(ftick*1.2-0.3)))
        val = floatto255(ftick)
        if ((ftick * 10) % 1.0) < 0.5:
            leds[0] = (0,0,255)
        else:
            leds[0] = (0,0,0)
        leds[1] = (val, val, val)
        leds.write()
        sleep_ms(25)

def off_state():
    for pw in pwms:
        pw.duty(0)
    leds.fill((0,0,0))
    while True:
        for s in range(200):
            ftick = s/200.0
            if not noodstop():
                return
            if ((ftick * 10) % 1.0) < 0.5:
                leds[0] = (0,0,255)
            else:
                leds[0] = (0,0,0)
            val = floatto255(0.5 - ftick if ftick < 0.5 else ftick - 0.5)
            leds[1] = (val, val, val)
            leds.write()
            sleep_ms(50)

def switchcolor(left, right, phase):
    if left.value() == 0:
        return 255
    if right.value() == 0:
        if phase % 1.0 < 0.4:
            return 255
    return 0

def lightcolor(pos, phase):
    if (pos % 4 == 0):
        return (255,0,0)
    if (pos % 4 == 1):
        return (0,255,0)
    if (pos % 4 == 2):
        return (0,0,255)
    return (0,0,0)

def insidecolor(pos, phase):
    fpos = (phase+pos)%1.0
    fpos = 1.0-2.0*fpos
    if fpos < 0.0:
        fpos = -fpos
    pv = pot1val()
    bri1 = pv * 0.3 + fpos * 0.7
    bri2 = pv - fpos * 0.3
    return ( floatto255(bri1)
           , floatto255(bri2*0.2)
           , floatto255(bri2*0.4) )

def running_sequence():
    tick = 0
    while True:
        if noodstop():
            return
        tick = 0 if tick > 999 else tick+1
        ftick = tick/1000.0
        leds[0] = (0,0,128)
        leds[1] = ( switchcolor(sw_2l, sw_2r, ftick*20.0)
                  , switchcolor(sw_1l, sw_1r, ftick*20.0+0.333)
                  , switchcolor(sw_3l, sw_3r, ftick*20.0+0.666) )

        for p in range(12):
            leds[p+2] = lightcolor(p, ftick)

        for p in range(37):
            leds[p+14] = insidecolor(p/37.0, ftick)

        leds.write()
        humstr = pot2val()
        for p in range(len(pwms)):
            ft = (ftick*10.0) % 1.0
            pstart = 0.25*p
            pend = pstart+0.50*humstr
            if pend > 1.0:
                pend = pend-1.0
            if ft > pstart and ft < pend:
                pwms[p].duty(512)
            else:
                pwms[p].duty(0)
        sleep_ms(25)

try:
    while True:
        # each state ends depending on the stop button
        off_state()
        startup_sequence()
        running_sequence()
        shutting_down_state()
finally:
    for pw in pwms:
        pw.duty(0)
    leds.fill((0,0,0))
    leds.write()
    sleep_ms(1000)
