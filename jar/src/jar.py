from machine import PWM, Pin, ADC
from neopixel import NeoPixel
from time import sleep_ms

np = NeoPixel(Pin(20), 51);
btn_stop = Pin(13, Pin.IN, Pin.PULL_UP)
btn_1l = Pin(12, Pin.IN, Pin.PULL_UP)
btn_1r = Pin(2, Pin.IN, Pin.PULL_UP)
btn_2l = Pin(6, Pin.IN, Pin.PULL_UP)
btn_2r = Pin(7, Pin.IN, Pin.PULL_UP)
btn_3l = Pin(10, Pin.IN, Pin.PULL_UP)
btn_3r = Pin(3, Pin.IN, Pin.PULL_UP)

pot1 = ADC(Pin(1))
pot2 = ADC(Pin(0))

pwms = [PWM(Pin(p), 108000, duty=0) for p in [8,9,4,5]]

def clamp255(x):
    return 0 if x < 0 else 64 if x > 64 else x

for i in range(256*10):
    bri1 = clamp255(int(pot1.read_uv() / 3900)+1)
    bri2 = clamp255(int(pot2.read_uv() / 3900)+1)
    for p in range(51):
        np[p] = (0,0,0)
    if btn_1l.value() == 1 and btn_2l.value() == 1 and btn_3l.value() == 1:
        for p in range(15,51):
            np[p] = ((i*11+p*4)%bri1, (i*11+p*4+0x55)%bri1, (i*11+p*4+0xaa)%bri1)
    if btn_1r.value() == 1 and btn_2r.value() == 1 and btn_3r.value() == 1:
        for p in range(1,15):
            np[p] = ((i*11+p*4)%bri2, (i*11+p*4+0x55)%bri2, (i*11+p*4+0xaa)%bri2)
    np.write()
    sleep_ms(25)
    if btn_stop.value() == 1:
        break
    ps = i % 160
    for p in range(len(pwms)):
        if ps > (40*p) and ps < (40*p+35):
            pwms[p].duty(512)
        else:
            pwms[p].duty(0)

for pw in pwms:
    pw.duty(0)
for p in range(51):
    np[p] = (0,0,0)
np[0] = (0,0,255)
np.write()
