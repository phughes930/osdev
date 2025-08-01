
.set FLAGS,         0x00000003      /* align and mem info flags */
.set MAGIC,         0x1BADB002      /* 'magic number' */
.set CHECKSUM, -(MAGIC + FLAGS)      /* checksum of above, to prove we are 
                                      * multiboot */

.section .multiboot
.align 4
multiboot_header:
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .bss
.align 16
stack_bottom:
    .skip 16384 # 16 KiB
stack_top:

.section .text
.global start
.type start, @function
start:
    movl    stack_top, %esp

    cli     # disable interrupts
    cld     # clear direction flag


    cmpl    $0x2BADB002, %eax
    jne     multiboot_error

    call    clear_screen
    movb    $'G', %al
    call    write_com1


    movl    $welcome_message, %esi
    xor     %edi, %edi
    movl    $320, %edi
    call    print_string

    movb    $'G', %al
    call    write_com1

halt_loop:
    hlt
    jmp     halt_loop

multiboot_error:
    movl    $error_string, %esi
    call    print_string
    jmp     halt_loop


clear_screen:
    movl    $0xB8000, %edi
    movl    $2000, %eax

cls_loop:
    dec     %eax
    movb    $' ', (%edi)
    movb    $0x0F, 1(%edi)
    addl    $2, %edi
    testl   $0, %eax
    jz      cls_done

cls_done:
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

    

.section .rodata
error_string:
    .ascii "There was an error with the multiboot\0"

welcome_message:
    .ascii "Welcome to PatOS\0"
