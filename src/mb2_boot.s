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

saved_eax: .skip 4
saved_ebx: .skip 4

.section .text
.extern term_main
.global start
.type start, @function
start:
    movl    %eax, saved_eax
    movl    %ebx, saved_ebx

    movl    $stack_top, %esp

    cli
    cld

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

    call    term_main

halt_loop:
    hlt
    jmp     halt_loop


# cls: clear screen
cls:
    pushl   %eax
    pushl   %ecx
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
    popl    %ecx
    popl    %eax
    ret

# print_string: 
#   %esi: string pointer
#   %edi: screen offset
print_string:
    pushl   %eax
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
    popl    %eax
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

.section .rodata
welcome_message:
    .asciz "Welcome to PatOS"
eax_message:
    .asciz "EAX: "
ebx_message:
    .asciz "EBX: "
