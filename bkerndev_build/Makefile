CC=i686-elf-gcc
AS=i686-elf-as
IDIR=../include
CFLAGS=-Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions \
		-nostdinc -fno-builtin -I./include -c -g
LFLAGS=-ffreestanding -O2 -nostdlib -lgcc

kernel.bin: linker.ld start.o main.o kernel.o
	$(CC) -T $< -o $@ $(wildcard *.o) $(LFLAGS)

start.o: new_boot.s
	$(AS) -o $@ $^ --gstabs

%.o: %.c
	$(CC) -o $@ -c $^ $(CFLAGS)

.PHONY: clean

clean:
	rm *.o *.bin