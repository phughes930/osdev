CC=i686-elf-gcc
AS=i686-elf-as
IDIR=../include
CFLAGS=-I$(IDIR) -ffreestanding -std=gnu99 -O2 -Wall -Wextra

patos.iso: PatOS.elf
	cp PatOS.elf iso/boot/
	grub-mkrescue -o patos.iso iso/

PatOS.elf: linker.ld mb2_boot.o kernel.o
	$(CC) -T $< -o $@ mb2_boot.o kernel.o -ffreestanding -nostdlib

%.o: %.s
	$(AS) -o $@ $<

%.o: %.c
	$(CC) -c -o $@ $^ $(CFLAGS)

.phony: clean

clean:
	rm *.o *.elf iso/boot/*.elf	*.iso