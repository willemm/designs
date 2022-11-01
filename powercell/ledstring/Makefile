# Uncomment lines below if you have problems with $PATH
#SHELL := /bin/bash
#PATH := /usr/local/bin:$(PATH)

all:
	pio -f -c vim run

upload:
	pio -f -c vim run --verbose --target upload

clean:
	pio -f -c vim run --target clean

program:
	pio -f -c vim run --target program

uploadfs:
	pio -f -c vim run --target uploadfs

update:
	pio -f -c vim update

disassemble:
	c:\users\wille\.platformio\packages\toolchain-atmelavr\bin\avr-objdump.exe -d .pio\build\attiny\firmware.elf > firmware.s
