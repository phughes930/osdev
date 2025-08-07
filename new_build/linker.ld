ENTRY(start)
SECTIONS {
    . = 0x100000;

    /* Multiboot section at top and aligned */
    .multiboot ALIGN(8) : {
        *(.multiboot)
    }

    /* Text section */
    . = ALIGN(4);
    .text ALIGN(4) : {
        *(.text)
    }

    /* Read-only data */
    .rodata ALIGN(4) : {
        *(.rodata*)
    }
    
    /* PVH Xen note section */
    .note.Xen : {
        *(.note.Xen)
    }
    /* BSS section: uninitialized data
     * i.e. stack
     */
    .bss : {
        *(.bss)
    }
}