CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra -pedantic
LDFLAGS ?=
LIBS ?= -lcurl

BIN = gpio_curl

all: $(BIN)

$(BIN): src/gpio_curl.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LIBS)

clean:
	rm -f $(BIN) gpio_curl.arm
