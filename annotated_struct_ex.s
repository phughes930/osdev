	.file	"struct_ex.c"
	.text
	.globl	init_struct
	.type	init_struct, @function
init_struct:
	pushl	%ebx                            // save ebx
	subl	$20, %esp                       // create 20 bytes of space on the
                                            // stack pointer

	// call	__x86.get_pc_thunk.bx           // load value at (%esp) to %ebx
	movl	(%esp), %ebx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx    // add global offset table value
	pushl	$16                             // push 16 onto stack
	call	malloc@PLT                      // allocate space
	movl	32(%esp), %edx                  // get pointer from stack
	movl	%eax, (%edx)                    // move malloc ptr to ptr address
	movw	$127, (%eax)                    // set short to ptr base
	movl	$32764, 4(%eax)                 // set int to ptr base + 4
	movl	$0x47322d86, 8(%eax)
	movb	$64, 12(%eax)
	addl	$24, %esp                       // add 24 to stack pointer
	popl	%ebx                            // restore %ebx
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
