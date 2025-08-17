SOURCES := $(wildcard *.s)
OBJECTS := $(patsubst %.s, build/%.o, $(SOURCES))

build:
	mkdir -p build

build/%.o: %.s | build
	as $< -o $@

all: build $(OBJECTS)
	gcc $(OBJECTS) -o build/jasm -no-pie
	rm -f build/*.o
