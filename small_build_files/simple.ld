ENTRY(start)
SECTIONS {
    . = 0x100000;

    .multiboot : {
        *(.multiboot)
    }
    . = ALIGN(4);
    .text : {
        *(.text)
    }
}