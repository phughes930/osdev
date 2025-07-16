	.file	"struct_ex.c"
	.text
	.p2align 4
	.globl	init_struct
	.type	init_struct, @function
init_struct:
	pushl	%ebx
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$20, %esp
	pushl	$16
	call	malloc@PLT
	movl	32(%esp), %edx
	movl	$32764, 4(%eax)
	movl	%eax, (%edx)
	movl	$127, %edx
	movw	%dx, (%eax)
	movl	$0x47322d86, 8(%eax)
	movb	$64, 12(%eax)
	addl	$24, %esp
	popl	%ebx
	ret
	.size	init_struct, .-init_struct
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
	movl	(%esp), %ebx
	ret
	.ident	"GCC: (Debian 12.2.0-14+deb12u1) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
