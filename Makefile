SOURCES := $(wildcard *.s)
OBJECTS := $(patsubst %.s, build/%.o, $(SOURCES))

build:
	mkdir -p build

build/%.o: %.s | build
	as $< -o $@

all: build $(OBJECTS)
	clang $(OBJECTS) -o build/jasm -no-pie
	rm -f build/*.o
