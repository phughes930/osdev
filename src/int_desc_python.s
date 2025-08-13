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

_isr0:
    cli
	pushb	$0
	pushb	$0
	jmp	isr_common_stub

_isr1:
    cli
	pushb	$0
	pushb	$1
	jmp	isr_common_stub

_isr2:
    cli
	pushb	$0
	pushb	$2
	jmp	isr_common_stub

_isr3:
    cli
	pushb	$0
	pushb	$3
	jmp	isr_common_stub

_isr4:
    cli
	pushb	$0
	pushb	$4
	jmp	isr_common_stub

_isr5:
    cli
	pushb	$0
	pushb	$5
	jmp	isr_common_stub

_isr6:
    cli
	pushb	$0
	pushb	$6
	jmp	isr_common_stub

_isr7:
    cli
	pushb	$0
	pushb	$7
	jmp	isr_common_stub

#   8: Double fault exception
_isr8:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$8
	jmp	isr_common_stub

_isr9:
    cli
	pushb	$0
	pushb	$9
	jmp	isr_common_stub

#   10: Bad TSS exception
_isr10:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$10
	jmp	isr_common_stub

#   11: Segment not present exception
_isr11:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$11
	jmp	isr_common_stub

_isr12:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$12
	jmp	isr_common_stub

_isr13:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$13
	jmp	isr_common_stub

_isr14:
    cli
    # not pushing error code as this interrupt already does so
	pushb	$14
	jmp	isr_common_stub

_isr15:
    cli
	pushb	$0
	pushb	$15
	jmp	isr_common_stub

_isr16:
    cli
	pushb	$0
	pushb	$16
	jmp	isr_common_stub

_isr17:
    cli
	pushb	$0
	pushb	$17
	jmp	isr_common_stub

_isr18:
    cli
	pushb	$0
	pushb	$18
	jmp	isr_common_stub

_isr19:
    cli
	pushb	$0
	pushb	$19
	jmp	isr_common_stub

_isr20:
    cli
	pushb	$0
	pushb	$20
	jmp	isr_common_stub

_isr21:
    cli
	pushb	$0
	pushb	$21
	jmp	isr_common_stub

_isr22:
    cli
	pushb	$0
	pushb	$22
	jmp	isr_common_stub

_isr23:
    cli
	pushb	$0
	pushb	$23
	jmp	isr_common_stub

_isr24:
    cli
	pushb	$0
	pushb	$24
	jmp	isr_common_stub

_isr25:
    cli
	pushb	$0
	pushb	$25
	jmp	isr_common_stub

_isr26:
    cli
	pushb	$0
	pushb	$26
	jmp	isr_common_stub

_isr27:
    cli
	pushb	$0
	pushb	$27
	jmp	isr_common_stub

_isr28:
    cli
	pushb	$0
	pushb	$28
	jmp	isr_common_stub

_isr29:
    cli
	pushb	$0
	pushb	$29
	jmp	isr_common_stub

_isr30:
    cli
	pushb	$0
	pushb	$30
	jmp	isr_common_stub

_isr31:
    cli
	pushb	$0
	pushb	$31
	jmp	isr_common_stub


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

    movl    $_fault_handler, %eax
    call    %eax

    popl    %eax
    popw    %gs
    popw    %fs
    popw    %es
    popw    %ds
    popa

    add     $8, %esp
    iret