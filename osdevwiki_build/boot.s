/* Declare constants for the multiboot header. */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .data
gdt:
.fill 24

gdtr:   
    .word 23            // size
    .long 0             // linear address of the gdt

seg_low:
    .word   0xFFFF
    .word   0

seg_high:
    .byte   0xFF            // base mid
    .byte   0               // access byte
    .byte   0xCF            // limit (low 4) and flags (high 4)
    .byte   0xFF            // base high

.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.section .text

.global _start
.type _start, @function
_start:
	movl    $stack_top, %esp

    /* disable interrupts */
    cli

    /* define null value and set to first GDT value */
    xor     %eax, %eax
    pushl   %eax
    pushl   %eax

    /* load gdtr pointer into the gdt register */
    leal    (gdt), %eax
    leal    gdtr, %ebx
    addl    $2, %ebx
    movl    %eax, (%ebx)
    lgdt    gdtr

    /* define code segment descriptor */
    movl    $1, %ecx
    call    _push_gdt_low
    xor     %edx, %edx
    movb    $0x9A, %dl
    call    _set_gdt_high

    /* define data segment descriptor */
    movl    $2, %ecx
    call    _push_gdt_low
    xor     %edx, %edx
    movb    $0x92, %dl
    call    _set_gdt_high

    /* set segment registers */
    push    $0x08
    leal    (reload_cs), %eax
    pushl   %eax
    retfl

reload_cs:
    xor     %eax, %eax
    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs

    /* preserve alignment to 16-byte alignment */
    xor     %eax, %eax
    pushl   %eax
    pushl   %eax

	call    kernel_main

	cli
1:	hlt
	jmp     1b

/*
Set the size of the _start symbol to the current location '.' minus its start.
This is useful when debugging or when you implement call tracing.
*/
.size _start, . - _start

.global _set_gdt_high
.type _set_gdt_high, @function
// entry num in %ecx, access byte in %eax
_set_gdt_high:
    movl    (seg_high), %ebx
    addl    $4, %ebx
    movb    %dl, (%ebx)
    movl    (seg_high), %eax
    leal    gdt, %ebx
    addl    $8, %ebx
    movl    %eax, (%ebx, %ecx, 8)
    ret

.global _push_gdt_low
.type _push_gdt_low, @function
// entry num in %ecx
_push_gdt_low:
    movl seg_low, %eax
    imull $8, %ecx
    movl %eax, gdt(, %ecx, 8)
    ret
