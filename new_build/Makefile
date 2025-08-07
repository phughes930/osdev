CC=i686-elf-gcc
AS=i686-elf-as

patos.iso: PatOS.elf
	cp PatOS.elf iso/boot/
	grub-mkrescue -o patos.iso iso/

PatOS.elf: linker.ld mb2_boot.o
	$(CC) -T $< -o $@ mb2_boot.o -ffreestanding -nostdlib

%.o: %.s
	$(AS) -o $@ $<

.phony: clean

clean:
	rm *.o *.elf iso/boot/*.elf