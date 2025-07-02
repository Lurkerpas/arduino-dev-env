FROM ubuntu:24.04

# Install prerequisites for Arduino CLI and QEMU
# qemu-system-misc supports avr
RUN apt-get update && apt-get install -y \
    make \
    curl \
    ca-certificates \
    xz-utils \
    qemu-system-misc \
    && rm -rf /var/lib/apt/lists/*

ENV ARDUINO_CLI_VERSION=1.2.2

# Installation instructions from https://arduino.github.io/arduino-cli/1.2/installation/
# Download and install Arduino CLI in /usr/local/bin folder
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/usr/local/bin sh

# Create configuration directory
RUN mkdir -p /root/.arduino15

# Initialize Arduino CLI and install core packages for AVR and SAM
# AVR is the base environment, which includes Uno
# SAM supports DUE board with Microchip AT91SAM3X8E Cortex-M
RUN arduino-cli config init \
    && arduino-cli core update-index \
    && arduino-cli core install arduino:avr \
    && arduino-cli core install arduino:sam

# Prepare test environment to make sure that the image works correctly
RUN mkdir /test

ADD avr-test /test/avr-test
ADD due-test /test/due-test
ADD qemu-test /test/qemu-test

# Test AVR
RUN arduino-cli compile --fqbn arduino:avr:uno /test/avr-test --output-dir /test/avr-test
# Test SAM
RUN arduino-cli compile --fqbn arduino:sam:arduino_due_x /test/due-test --output-dir /test/due-test
# Test QEMU; qemu-test is unused, as it may consume unforeseen number of cycles if the sketch crash is not induced
RUN qemu-system-avr -cpu ? | grep avr

# Set working directory
WORKDIR /workspace

CMD ["bash"]