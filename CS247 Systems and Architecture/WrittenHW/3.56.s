	.file	"3.56.c"
	.text
	.globl	loop
	.type	loop, @function
loop:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$1, -8(%ebp)
	movl	$-1, -4(%ebp)
	jmp	.L2
.L3:
	movl	8(%ebp), %eax
	movl	-4(%ebp), %edx
	andl	%edx, %eax
	xorl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, %ecx
	sall	%cl, -4(%ebp)
.L2:
	cmpl	$0, -4(%ebp)
	jne	.L3
	movl	-8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	loop, .-loop
	.ident	"GCC: (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
