IDIR=../include
CC=i686-elf-gcc
AS=i686-elf-as
CFLAGS=-I$(IDIR) -std=gnu99 -Wall -Wextra -ffreestanding -O2
KFLAGS=-ffreestanding -O2 -nostdlib -lgcc

ODIR=obj

_OBJ=kernel.o gdt.o
OBJ=$(patsubst %,$(ODIR)/%,$(_OBJ))

_DEPS=types.h
DEPS=$(patsubst %,$(IDIR)/%,$(_DEPS))

_AOBJ=boot.o kernel.o gdt.o
AOBJ=$(patsubst %,$(ODIR)/%,$(_AOBJ))

myos.bin: $(AOBJ)
	$(CC) -T linker.ld -o $@ $^ $(KFLAGS)

$(ODIR)/boot.o: boot.s
	$(AS) -o $@ $^

$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c $< -o $@ $(CFLAGS)