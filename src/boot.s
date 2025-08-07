.set MAGIC,    0x1BADB002
.set FLAGS,    0x00000003
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.global multiboot_header
multiboot_header:
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .note.Xen, "a", @note
.align 4
.long 2f - 1f       # Name size
.long 4f - 3f       # Description size
.long 18            # XEN_ELFNOTE_PHYS32_ENTRY
1:  .asciz "Xen"
2:  .align 4
3:  .long start     # Entry point
4:  .align 4

.section .data
error_string:
    .ascii "There was an error with the multiboot\0"
welcome_message:
    .ascii "Welcome to PatOS\0"
debug_eax_msg:
    .asciz "%eax value is this: "
debug_ebx_msg:
    .asciz "%ebx value is this: "
header_msg:
    .asciz "Header: "
saved_eax_msg:
    .asciz "Saved EAX: "

.section .bss
.align 16
stack_bottom:
    .skip 16384 # 16 KiB
stack_top:

saved_eax: .skip 4

.section .text

// .extern term_main
.global start
.type start, @function

start:
    movl    %eax, saved_eax
    movl    $stack_top, %esp

    cli     # disable interrupts
    cld     # clear direction flag

    call    clear_screen

    pushl   %eax
    # test simple message
    movl    $welcome_message, %esi
    movl    $0, %edi
    call    print_string

    # debug header
    # print header msg
    movl    $header_msg, %esi
    addl    $160, %edi
    call    print_string

    # set new line and tab
    addl    $160, %edi
    addl    $4, %edi
    # print magic number
    movl    multiboot_header, %eax
    call    print_hex
    # print flags
    movl    multiboot_header+8, %eax
    addl    $160, %edi
    call    print_hex
    # print checksum
    movl    multiboot_header+16, %eax
    addl    $160, %edi
    call    print_hex
    # remove tab
    subl    $4, %edi
    popl    %eax

    # debug eax
    pushl   %eax
    movl    $debug_eax_msg, %esi
    addl    $160, %edi
    call    print_string
    popl    %eax
    pushl   %eax
    addl    $80, %edi
    call    print_hex
    popl    %eax

    #debug ebx
    pushl   %ebx
    pushl   %eax
    movl    $debug_ebx_msg, %esi
    addl    $80, %edi
    call    print_string
    popl    %eax
    popl    %ebx

    pushl   %ebx
    pushl   %eax
    movl    %ebx, %eax
    addl    $80, %edi
    call    print_hex
    popl    %eax
    popl    %ebx

    # print saved eax
    movl    $saved_eax_msg, %esi
    addl    $80, %edi
    call    print_string

    movl    saved_eax, %eax
    addl    $80, %edi
    call    print_hex

    cmpl    $0x36d76289, %eax
    jne     multiboot_error

    movl    $welcome_message, %esi
    movl    $0, %edi
    addl    $320, %edi
    call    print_string
    // call    term_main

halt_loop:
    hlt
    jmp     halt_loop

multiboot_error:
    movl    $error_string, %esi
    addl    $80, %edi
    call    print_string
    jmp     halt_loop

clear_screen:
    pushl   %eax
    pushl   %edi

    movl    $0xB8000, %edi
    movl    $2000, %ecx
    movw    $0x0F20, %ax

cls_loop:
    movw    %ax, (%edi)
    addl    $2, %edi
    loop    cls_loop

cls_done:
    popl    %edi
    popl    %eax
    ret

# print null terminated string to VGA buffer
# %esi -> string pointer, %edi -> screen offset
print_string:
    pushl   %eax
    pushl   %esi
    pushl   %edi
    
    addl    $0xB8000, %edi

print_loop:
    lodsb
    testb   %al, %al        # test for null char
    jz      print_done      # jump to done if null char

    movb    %al, (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi
    jmp     print_loop

print_done:
    popl    %edi
    popl    %esi
    popl    %eax
    ret

# bit to write in %al
write_com1:
    pushl   %edx

    movw    $0x3F8, %dx
    outb    %al, %dx

    popl    %edx
    ret

print_hex:
    pushl   %eax
    pushl   %ebx
    pushl   %ecx
    pushl   %edx
    pushl   %edi

    addl    $0xB8000, %edi

    # print 0x
    movb    $'0', (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi
    movb    $'x', (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi

    # set loop counter
    movl    $8, %ecx

hex_loop:
    roll    $4, %eax
    movl    %eax, %edx
    andl    $0xF, %edx

    cmpb    $9, %dl
    jle     hex_digit
    addb    $7, %dl
hex_digit:
    addb    $'0', %dl

    movb    %dl, (%edi)
    movb    $0x07, 1(%edi)
    addl    $2, %edi

    loop    hex_loop

    popl    %edi
    popl    %edx
    popl    %ecx
    popl    %ebx
    popl    %eax
    ret
