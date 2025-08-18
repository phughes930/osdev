CC=i686-elf-gcc
AS=i686-elf-as
IDIR=../include
CFLAGS=-I$(IDIR) -ffreestanding -std=gnu99 -O2 -Wall -Wextra

_DEPS=system.h
DEPS=$(patsubst %,$(IDIR)/%,$(_DEPS))

patos.iso: PatOS.elf
	cp PatOS.elf iso/boot/
	grub-mkrescue -o patos.iso iso/

PatOS.elf: linker.ld booter.o kernel.o system.o gdt.o idt.o isrs.o irqs.o clock.o
	$(CC) -o $@ -T $^ -ffreestanding -nostdlib

booter.o: mb2_boot.s isr.s irq.s
	$(AS) -o $@ $^

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

.phony: clean

clean:
	rm *.o *.elf iso/boot/*.elf	*.iso