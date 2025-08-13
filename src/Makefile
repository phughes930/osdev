CC=i686-elf-gcc
AS=i686-elf-as
IDIR=../include
CFLAGS=-I$(IDIR) -ffreestanding -std=gnu99 -O2 -Wall -Wextra

patos.iso: PatOS.elf
	cp PatOS.elf iso/boot/
	grub-mkrescue -o patos.iso iso/

PatOS.elf: linker.ld booter.o kernel.o
	$(CC) -T $< -o $@ booter.o kernel.o -ffreestanding -nostdlib

booter.o: mb2_boot.s gdt.s
	$(AS) -o $@ $^

%.o: %.c
	$(CC) -c -o $@ $^ $(CFLAGS)

.phony: clean

clean:
	rm *.o *.elf iso/boot/*.elf	*.iso