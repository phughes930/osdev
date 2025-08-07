make clean
make
./checkmultiboot.sh
qemu-system-i386 -cdrom patos.iso -d int,cpu_reset