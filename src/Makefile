CC=i686-elf-gcc
AS=i686-elf-as
CFLAGS=-ffreestanding -O2 -Wall -Wextra
LFLAGS=-ffreestanding -nostdlib 

myos.elf: linker.ld boot.o # kernel.o
	$(CC) $(LFLAGS) -T $< boot.o -o $@

boot.o: boot.s
	$(AS) boot.s -o boot.o

# kernel.o: kernel.c
#	$(CC) -c -o kernel.o kernel.c $(CFLAGS)

.phony: clean

clean:
	rm *.o *.elf