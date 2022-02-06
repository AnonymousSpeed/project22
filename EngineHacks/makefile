# This makefile handles making all the asm binaries (mostly dmp and lyn.event files)
# Building those files can be done manually too, this is just convenience for high-end users

.SUFFIXES:

CACHE_DIR := .Cache
$(shell mkdir -p $(CACHE_DIR) > /dev/null)

include $(DEVKITARM)/base_tools

EA_DIR   := ../EventAssembler
EA_DEP   := $(EA_DIR)/ea-dep.exe
LYN      := $(EA_DIR)/Tools/lyn.exe
PNG2DMP  := $(EA_DIR)/Tools/Png2Dmp.exe
COMPRESS := $(EA_DIR)/Tools/compress.exe

MAIN_EVENT := _MasterHackInstaller.event
ALL_FILES  := $(shell $(EA_DEP) $(MAIN_EVENT) -I "$(EA_DIR)" --add-missings)

all: $(ALL_FILES)
.PHONY: all

# =================
# = PATTERN RULES =
# =================

# TODO: add skill system's very own CLib

LYN_REFERENCE := CLib/reference/fe8-us.o

# Setting C/ASM include directories up
INCLUDE_DIRS := CLib/include
INCFLAGS     := $(foreach dir, $(INCLUDE_DIRS), -I "$(dir)")

# setting up compilation flags
ARCH := -mcpu=arm7tdmi -mthumb -mthumb-interwork
CC_FLAGS := $(ARCH) $(INCFLAGS) -Wall -O2 -mtune=arm7tdmi -ffreestanding -fomit-frame-pointer -mlong-calls
AS_FLAGS := $(ARCH) $(INCFLAGS)

# defining dependency flags
CC_DEPFLAGS = -MMD -MT "$*.o" -MT "$*.asm" -MF "$(CACHE_DIR)/$(notdir $*).d" -MP
AS_DEPFLAGS = --MD "$(CACHE_DIR)/$(notdir $*).d"

# ASM to OBJ rule
%.o: %.s
	$(AS) $(AS_FLAGS) $(AS_DEPFLAGS) -I $(dir $<) $< -o $@ $(ERROR_FILTER)

# C to OBJ rule
%.o: %.c
	$(CC) $(CC_FLAGS) $(CC_DEPFLAGS) -g -c $< -o $@ $(ERROR_FILTER)

# C to ASM rule
# Generating "asm" files instead of s files so that we can gitignore them no prob
%.asm: %.c
	$(CC) $(CC_FLAGS) $(CC_DEPFLAGS) -S $< -o $@ -fverbose-asm $(ERROR_FILTER)

# OBJ to event
%.lyn.event: %.o $(LYN_REFERENCE)
	$(LYN) $< $(LYN_REFERENCE) > $@

# OBJ to DMP rule
%.dmp: %.o
	$(OBJCOPY) -S $< -O binary $@

# PNG to 4bpp rule
%.4bpp: %.png
	$(PNG2DMP) $< -o $@

# PNG to gbapal rule
%.gbapal: %.png
	$(PNG2DMP) $< -po $@ --palette-only

# Anything to lz rule
%.lz: %
	$(COMPRESS) $< --to-stdout > $@
