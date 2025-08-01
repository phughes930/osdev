CC=i686-elf-gcc
AS=i686-elf-as
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra
LFLAGS=-ffreestanding -O2 -nostdlib -lgcc

# myos.iso: myos.bin
# 	mkdir -p isodir/boot/grub
# 	cp myos.bin isodir/boot/
# 	cp grub.cfg isodir/boot/grub/
# 	grub-mkrescue -o $@ isodir

myos.iso: myos.bin
	mkdir -p isodir/boot/grub
	cp $^ isodir/boot/myos.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir

myos.bin: linker.ld boot.o # kernel.o
	$(CC) -T $< -o $@ $(LFLAGS) boot.o

boot.o: boot.s
	$(AS) $^ -o $@

kernel.o: kernel.c
	$(CC) -c $^ -o $@ $(CFLAGS)

.phony: clean

clean:
	rm -r isodir
	rm *.o
	rm *.bin
	rm *.iso