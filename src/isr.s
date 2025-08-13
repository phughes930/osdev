.section .text
.global _isr0
.global _isr1
.global _isr2
.global _isr3
.global _isr4
.global _isr5
.global _isr6
.global _isr7
.global _isr8
.global _isr9
.global _isr10
.global _isr11
.global _isr12
.global _isr13
.global _isr14
.global _isr15
.global _isr16
.global _isr17
.global _isr18
.global _isr19
.global _isr20
.global _isr21
.global _isr22
.global _isr23
.global _isr24
.global _isr25
.global _isr26
.global _isr27
.global _isr28
.global _isr29
.global _isr30
.global _isr31

# 0: Divide by zero exception
_isr0:
    cli
    pushb   $0
    pushb   $0
    jmp     common_isr_stub
    


.extern _fault_handler
common_isr_stub:
    pusha
    pushw   %ds
    pushw   %es
    pushw   %fs
    pushw   %gs
    movb    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movl    %esp, %eax
    pushl   %eax
    movl    $_fault_handler, %eax
    call    %eax
    popl    %eax
    popw    %gs
    popw    %fs
    popw    %es
    popw    %ds
    popa
    addl    $8, %esp
    iret