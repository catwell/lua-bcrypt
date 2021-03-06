SOURCES = $(wildcard src/**/*.c src/*.c)
OBJECTS = $(patsubst %.c,%.o,$(SOURCES))

TARGET = bcrypt.so

LIBS = -lcrypto
CFLAGS = -O2 -shared -fPIC -std=c11 -D_GNU_SOURCE -Wall -Wextra -Wno-nonnull -Wwrite-strings -Wformat=2 -DNDEBUG -Ilib/bcrypt

BCRYPT_OBJECTS = lib/bcrypt/crypt_blowfish.o lib/bcrypt/x86.o lib/bcrypt/crypt_gensalt.o lib/bcrypt/wrapper.o

.PHONY: debug test clean

all: $(TARGET)

debug: CFLAGS += -ggdb -UNDEBUG
debug: all

lib/bcrypt/%.o:
	make -C lib/bcrypt

$(TARGET): $(OBJECTS) $(BCRYPT_OBJECTS)
	$(CC) -o $(TARGET) $^ $(CFLAGS) $(LIBS)

test:
	make -C lib/bcrypt check
	@lua tests.lua

clean:
	make -C lib/bcrypt clean
	rm -f $(OBJECTS) $(TARGET)
