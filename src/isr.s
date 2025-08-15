.section .text
.global idt_load
.type idt_load, @function
idt_load:
    lidt    idtp
    ret

.global isr0
.global isr1
.global isr2
.global isr3
.global isr4
.global isr5
.global isr6
.global isr7
.global isr8
.global isr9
.global isr10
.global isr11
.global isr12
.global isr13
.global isr14
.global isr15
.global isr16
.global isr17
.global isr18
.global isr19
.global isr20
.global isr21
.global isr22
.global isr23
.global isr24
.global isr25
.global isr26
.global isr27
.global isr28
.global isr29
.global isr30
.global isr31

isr0:
    cli
	pushw	$0
	pushw	$0
	jmp	    isr_common_stub

isr1:
    cli
	pushw	$0
	pushw	$1
	jmp	    isr_common_stub

isr2:
    cli
	pushw	$0
	pushw	$2
	jmp	    isr_common_stub

isr3:
    cli
	pushw	$0
	pushw	$3
	jmp	    isr_common_stub

isr4:
    cli
	pushw	$0
	pushw	$4
	jmp	    isr_common_stub

isr5:
    cli
	pushw	$0
	pushw	$5
	jmp	    isr_common_stub

isr6:
    cli
	pushw	$0
	pushw	$6
	jmp	    isr_common_stub

isr7:
    cli
	pushw	$0
	pushw	$7
	jmp	    isr_common_stub

#   8: Double fault exception
isr8:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$8
	jmp	    isr_common_stub

isr9:
    cli
	pushw	$0
	pushw	$9
	jmp	    isr_common_stub

#   10: Bad TSS exception
isr10:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$10
	jmp	    isr_common_stub

#   11: Segment not present exception
isr11:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$11
	jmp	    isr_common_stub

isr12:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$12
	jmp	    isr_common_stub

isr13:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$13
	jmp	    isr_common_stub

isr14:
    cli
    # not pushing error code as this interrupt already does so
	pushw	$14
	jmp	    isr_common_stub

isr15:
    cli
	pushw	$0
	pushw	$15
	jmp	    isr_common_stub

isr16:
    cli
	pushw	$0
	pushw	$16
	jmp	    isr_common_stub

isr17:
    cli
	pushw	$0
	pushw	$17
	jmp	    isr_common_stub

isr18:
    cli
	pushw	$0
	pushw	$18
	jmp	    isr_common_stub

isr19:
    cli
	pushw	$0
	pushw	$19
	jmp	    isr_common_stub

isr20:
    cli
	pushw	$0
	pushw	$20
	jmp	    isr_common_stub

isr21:
    cli
	pushw	$0
	pushw	$21
	jmp	    isr_common_stub

isr22:
    cli
	pushw	$0
	pushw	$22
	jmp	    isr_common_stub

isr23:
    cli
	pushw	$0
	pushw	$23
	jmp	    isr_common_stub

isr24:
    cli
	pushw	$0
	pushw	$24
	jmp	    isr_common_stub

isr25:
    cli
	pushw	$0
	pushw	$25
	jmp	    isr_common_stub

isr26:
    cli
	pushw	$0
	pushw	$26
	jmp	    isr_common_stub

isr27:
    cli
	pushw	$0
	pushw	$27
	jmp	    isr_common_stub

isr28:
    cli
	pushw	$0
	pushw	$28
	jmp	    isr_common_stub

isr29:
    cli
	pushw	$0
	pushw	$29
	jmp	    isr_common_stub

isr30:
    cli
	pushw	$0
	pushw	$30
	jmp	    isr_common_stub

isr31:
    cli
	pushw	$0
	pushw	$31
	jmp	    isr_common_stub


.extern fault_handler
isr_common_stub:
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

    movl    %esp, %eax
    pushl   %eax

    movl    $fault_handler, %eax
    call    *%eax

    popl    %eax
    popw    %gs
    popw    %fs
    popw    %es
    popw    %ds
    popa

    add     $8, %esp
    iret
