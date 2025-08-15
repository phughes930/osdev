.section .text
.global irq0
.global irq1
.global irq2
.global irq3
.global irq4
.global irq5
.global irq6
.global irq7
.global irq8
.global irq9
.global irq10
.global irq11
.global irq12
.global irq13
.global irq14
.global irq15


irq0:
    cli
    pushw   $0
    pushw   $32
    jmp     irq_common_stub

irq1:
    cli
    pushw   $0
    pushw   $33
    jmp     irq_common_stub

irq2:
    cli
    pushw   $0
    pushw   $34
    jmp     irq_common_stub

irq3:
    cli
    pushw   $0
    pushw   $35
    jmp     irq_common_stub

irq4:
    cli
    pushw   $0
    pushw   $36
    jmp     irq_common_stub

irq5:
    cli
    pushw   $0
    pushw   $37
    jmp     irq_common_stub

irq6:
    cli
    pushw   $0
    pushw   $38
    jmp     irq_common_stub

irq7:
    cli
    pushw   $0
    pushw   $39
    jmp     irq_common_stub

irq8:
    cli
    pushw   $0
    pushw   $40
    jmp     irq_common_stub

irq9:
    cli
    pushw   $0
    pushw   $41
    jmp     irq_common_stub

irq10:
    cli
    pushw   $0
    pushw   $42
    jmp     irq_common_stub

irq11:
    cli
    pushw   $0
    pushw   $43
    jmp     irq_common_stub

irq12:
    cli
    pushw   $0
    pushw   $44
    jmp     irq_common_stub

irq13:
    cli
    pushw   $0
    pushw   $45
    jmp     irq_common_stub

irq14:
    cli
    pushw   $0
    pushw   $46
    jmp     irq_common_stub

irq15:
    cli
    pushw   $0
    pushw   $47
    jmp     irq_common_stub


irq_common_stub:
    pusha
    pushw   %ds
    pushw   %es
    pushw   %fs
    pushw   %gs
    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movl    %eax, %esp
    pushl   %eax
    movl    $irq_handler, %eax
    call    *%eax
    popl    %eax
    popw    %gs
    popw    %fs
    popw    %es
    popw    %ds
    popa
    addl    $8, %esp
    iret
