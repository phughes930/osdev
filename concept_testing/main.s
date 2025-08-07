.section .data

.extern new_func
.section .text
.global _start
_start:
    nop
    xor     %eax, %eax
    movl    $9, %eax
    xor     %edx, %edx
    movl    $9, %edx
    imull   %edx, %eax
    call    new_func
    addl    $10, %eax
    
    movl    %eax, %ebx
    movl    $1, %eax
    int     $0x80
