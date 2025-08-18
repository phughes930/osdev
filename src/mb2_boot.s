.set MB2_MAGIC,     0xe85250d6
.set MB2_ARCH,      0x00000000      #i386
.set MB2_LENGTH,    (mb2_header_end - mb2_header_start)
.set MB2_CHECKSUM, -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

.section .multiboot
.align 8
mb2_header_start:
.long   MB2_MAGIC
.long   MB2_ARCH
.long   MB2_LENGTH
.long   MB2_CHECKSUM

# End tag
.align 8
.word   0   # type
.word   0   # flags
.word   8   # size
mb2_header_end:

.section .note.Xen, "a", @note
.align 4
.long 2f - 1f       # Name size
.long 4f - 3f       # Description size
.long 18            # XEN_ELFNOTE_PHYS32_ENTRY
1:  .asciz "Xen"
2:  .align 4
3:  .long start     # Entry point
4:  .align 4

.section .bss
.align 16
stack_bottom:
.skip 16384         # 16Kb
stack_top:

// .align 2
// gdtr:
//     .word   # should be 0x20
//     .long   # should be an address

// gdt_bottom:
// .skip 48    # 8 bytes x 2 levels x 2 types + 8 for null + 8 for TSS
//             # + 16 for extra TSS
// gdt_top:

tss:
.skip 104
tss_limit:


saved_eax: .skip 4
saved_ebx: .skip 4

.section .text

.extern term_main
.extern set_gdtr
.extern set_gdt_descr
.extern set_tss_descriptor
.extern idt_install

.global start
.type start, @function
start:
    movl    %eax, saved_eax
    movl    %ebx, saved_ebx

    movl    $stack_top, %esp

    cli
    cld

    call    gdt_install

//     call    set_gdtr
//     lgdt    gdtr

//     #   reset the segment registers
//     ljmp    $0x08, $reload_segments    # Far jump to reload CS
// reload_segments:
//     movw    $0x10, %ax              # Load kernel data segment
//     movw    %ax, %ds
//     movw    %ax, %es
//     movw    %ax, %fs
//     movw    %ax, %gs
//     movw    %ax, %ss

//     hlt
//     #   reset stack pointer just in case
//     movl    $stack_top, %esp

//     #   flags & limit high 4 bits in %al
//     #   access byte in %dl
//     #   setting up the gdt
//     movl    $0, %ecx
//     call    set_gdt_descr

//     #   set up a kernel code segment
//     incl    %ecx
//     movb    $0xCF, %al
//     movb    $0x9A, %dl
//     pushl   %ecx
//     call    set_gdt_descr
//     popl    %ecx

//     #   set up a kernel data segment
//     incl    %ecx
//     movb    $0xCF, %al
//     movb    $0x92, %dl
//     pushl   %ecx
//     call    set_gdt_descr
//     popl    %ecx

//     #   set up a user code segment
//     incl    %ecx
//     movb    $0xCF, %al
//     movb    $0xFA, %dl
//     pushl   %ecx
//     call    set_gdt_descr
//     popl    %ecx

//     #   set up a user data segment
//     incl    %ecx
//     movb    $0xCF, %al
//     movb    $0xF2, %dl
//     pushl   %ecx
//     call    set_gdt_descr
//     popl    %ecx

//     #   set up a task state segment
//     incl    %ecx
//     pushl   %ecx
//     call    set_tss_descriptor
//     popl    %ecx

    call    cls

    # Welcome to PatOS!
    movl    $welcome_message, %esi
    movl    $0, %edi
    call    print_string

    # Multiboot Debug
    #   EAX debug
    movl    $eax_message, %esi
    movl    $160, %edi
    call    print_string

    movl    saved_eax, %eax
    addl    $12, %edi
    call    print_hex
    subl    $12, %edi

    #   EBX debug
    movl    $ebx_message, %esi
    addl    $160, %edi
    call    print_string

    movl    saved_ebx, %eax
    addl    $12, %edi
    call    print_hex
    subl    $12, %edi


    #   GDT debug
    movl    $gdt_message, %esi
    addl    $160, %edi
    call    print_string
    #       GDT size
    xorl    %eax, %eax
    // movw    gdtr, %ax
    movw    gdtp, %ax
    addl    $12, %edi
    call    print_hex
    subl    $12, %edi
    #       GDT loc
    // movl    gdtr+2, %eax
    movl    gdtp+2, %eax
    addl    $34, %edi
    call    print_hex
    subl    $34, %edi


    #   debug the null descriptor
    movl    $gdt_desc_message, %esi
    addl    $160, %edi
    call    print_string

    // movl    gdt_bottom, %eax
    movl    gdt, %eax
    addl    $18, %edi
    call    print_hex
    addl    $22, %edi
    // movl    gdt_bottom+4, %eax
    movl    gdt+4, %eax
    call    print_hex
    subl    $40, %edi
    
    #   debug the kernel code segment
    movl    $gdt_desc_message, %esi
    addl    $160, %edi
    call    print_string

    // movl    gdt_bottom+8, %eax
    movl    gdt+8, %eax
    addl    $18, %edi
    call    print_hex
    addl    $22, %edi
    // movl    gdt_bottom+12, %eax
    movl    gdt+12, %eax
    call    print_hex
    subl    $40, %edi
    
    #   debug the kernel data segment
    movl    $gdt_desc_message, %esi
    addl    $160, %edi
    call    print_string

    // movl    gdt_bottom+16, %eax
    movl    gdt+16, %eax
    addl    $18, %edi
    call    print_hex
    addl    $22, %edi
    // movl    gdt_bottom+20, %eax
    movl    gdt+20, %eax
    call    print_hex
    
    call    kernel_main

halt_loop:
    hlt
    jmp     halt_loop


# cls: clear screen
cls:
    pushl   %edi

    xorl    %edi, %edi
    addl    $0xB8000, %edi
    movl    $2000, %ecx
    movw    $0x0720, %ax
    
cls_loop:
    movw    %ax, (%edi)
    addl    $2, %edi
    loop    cls_loop
    
    popl    %edi
    ret

# print_string: 
#   %esi: string pointer
#   %edi: screen offset
print_string:
    pushl   %edi
    pushl   %esi
    
    addl    $0xB8000, %edi
print_loop:
    lodsb
    testb   %al, %al
    jz      print_done

    movb    $0x07, %ah
    movw    %ax, (%edi)
    addl    $2, %edi
    jmp     print_loop
print_done:
    popl    %esi
    popl    %edi
    ret

# print_hex:
#   %eax: hex value
#   %edi: screen offset
print_hex:
    pusha

    addl    $0xB8000, %edi
    # print "0x"
    movb    $'0', (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi
    movb    $'x', (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi
    
    movl    $8, %ecx        # 8 reps
hex_loop:
    roll    $4, %eax
    movl    %eax, %edx
    andl    $0xF, %edx      # mask off low 4 bits

    cmpb    $9, %dl
    jle     hex_digit
    addb    $7, %dl         # A-F offset
hex_digit:
    addb    $'0', %dl

    movb    $0x07, %dh
    movw    %dx, (%edi)
    addl    $2, %edi
    loop    hex_loop

    popa
    ret

.global load_gdt
.type load_gdt, @function
.extern gdtp
load_gdt:
    lgdt    gdtp
    ljmp    $0x08, $reload_segments
reload_segments:
    movw    $0x10, %ax              # Load kernel data segment
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movw    %ax, %ss
    ret

.section .rodata
welcome_message:
    .asciz "Welcome to PatOS"
eax_message:
    .asciz "EAX: "
ebx_message:
    .asciz "EBX: "
gdt_message:
    .asciz "GDT: "
gdt_desc_message:
    .asciz "GDT Seg: "
