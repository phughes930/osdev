.set MAGIC,    0x1BADB002
.set FLAGS,    0x00000003
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long   MAGIC
.long   FLAGS
.long   CHECKSUM

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
