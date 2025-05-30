	.file	"decode2.c"
	.text
	.globl	decode2
	.type	decode2, @function
decode2:
.LFB0:
	.cfi_startproc
	movl	8(%esp), %eax
	subl	12(%esp), %eax
	movl	%eax, %edx
	sall	$31, %edx
	sarl	$31, %edx
	imull	4(%esp), %edx
	xorl	%edx, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	decode2, .-decode2
	.ident	"GCC: (Ubuntu/Linaro 4.7.2-2ubuntu1) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
