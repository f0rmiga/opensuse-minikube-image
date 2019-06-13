MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))

DESCRIPTION := $(MAKEFILE_DIR)/description
OUTPUT := $(MAKEFILE_DIR)/output

.PHONY: build clean

build:
	make/build $(DESCRIPTION) $(OUTPUT)

clean:
	rm -rf $(OUTPUT)
