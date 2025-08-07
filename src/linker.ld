ENTRY(start)
SECTIONS {
    . = 0x100000;

    .multiboot : 
    {
        *(.multiboot)
    }

    . = ALIGN(4);

    .text : 
    {
        *(.text)
    }

    /* PVH Note */
    .note.Xen :
    {
        *(.note.Xen)
    }
    
    .rodata ALIGN(4K) :
    {
        *(.rodata)
    }

    .data ALIGN(4K) :
    {
        *(.data)
    }

    .bss ALIGN(4K) :
    {
        *(COMMON)
        *(.bss)
    }
}