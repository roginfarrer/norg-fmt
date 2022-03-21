.POSIX:
.SUFFIXES:
.PHONY: all help clean docs
.SILENT: help clean
.DEFAULT_GOAL := all

# Build macros
# ============
# If should build for release
release = 0

# Extra options to be passed to meson while building, e.g.
# -DUSE_BUNDLED_TREESITTER=true
EXTRA_OPTS =

# Files and Directories
# =====================
BUILD_DIR     = $(CURDIR)/build

# Output executable
ifeq ($(OS), Windows_NT)
	BUILD_BIN_PATH = $(BUILD_DIR)/norg-fmt.exe
else
	BUILD_BIN_PATH = $(BUILD_DIR)/norg-fmt
endif

# Targets
# =======
all: build

setup:
ifeq ($(release),0)
	meson --buildtype debug $(BUILD_DIR)
else
	meson --buildtype release $(BUILD_DIR)
endif
ifneq (,$(EXTRA_OPTS))
	meson configure $(EXTRA_OPTS) $(BUILD_DIR)
endif

build: setup
	cd build && meson compile
	@echo
	@echo "Produced binary is located at '$(BUILD_BIN_PATH)'"

clean:
ifeq ($(OS),Windows_NT)
	pwsh -c 'rm -r -fo "$(BUILD_DIR)"'
else
	rm -rf $(BUILD_DIR)
endif

rebuild: clean build

help:
	echo "norg-fmt - Neorg formatter Makefile"
	echo "norg-fmt source code is owned by NTBBloodbath and licensed under GPLv3 License"
	echo
	echo "Usage: make [TARGET]"
	echo
	echo "Targets:"
	echo -e "\tall\tCompile and link norg-fmt, default target"
	echo -e "\tclean\tClean objects and executable norg-fmt binary"
	echo -e "\trebuild Runs clean and all target"
	echo -e "\thelp\tShow this message"
	echo
	echo "Report bugs at https://github.com/NTBBloodbath/norg-fmt/issues/new"
