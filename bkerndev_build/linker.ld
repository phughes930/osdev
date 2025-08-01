/* The bootloader will look at this image and start execution at the symbol
   designated as the entry point. */
ENTRY(start)
phys = 0x00100000;

/* Tell where the various sections of the object files will be put in the final
   kernel image. */
SECTIONS
{
    /* offset */
	. = 2M;

	/* First put the multiboot header, as it is required to be put very early
	   in the image or the bootloader won't recognize the file format.
	   Next we'll put the .text section. */
	.text phys : AT(phys)
	{
        code = .;
		*(.multiboot)
		*(.text)
        *(.rodata)
        . = ALIGN(4096);
	}

	/* Read-only data.
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	} */

	/* Read-write data (initialized) */
	.data : AT(phys + (data - code))
	{
        data = .;
		*(.data)
        . = ALIGN(4096);
	}

	/* Read-write data (uninitialized) and stack */
	.bss : AT(phys + (bss - code))
	{
        bss = .;
		*(.bss)
        . = ALIGN(4096);
	}
    end = .;

	/* The compiler may produce other sections, by default it will put them in
	   a segment with the same name. Simply add stuff here as needed. */
}