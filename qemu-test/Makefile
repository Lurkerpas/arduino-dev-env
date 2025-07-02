.PHONY: all build test clean

all: build test

build: build/avr-sketch.ino.with_bootloader.bin

build/avr-sketch.ino.with_bootloader.bin: avr-sketch/avr-sketch.ino
	mkdir -p build
	arduino-cli compile --fqbn arduino:avr:uno avr-sketch --output-dir build

# The sketch finishes execution by crashing, so the QEMU error is ignored, and only the serial output is checked
test: build
	qemu-system-avr -machine uno -nographic -bios build/avr-sketch.ino.with_bootloader.bin > test.log || true
	grep -q "I am alive" test.log

clean:
	rm -r -f build
	rm -f test.log