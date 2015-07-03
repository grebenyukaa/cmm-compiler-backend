	.file	"main.ll"
	.text
	.globl	print
	.align	16, 0x90
	.type	print,@function
print:                                  # @print
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp1:
	.cfi_def_cfa_offset 16
	movl	4(%rsp), %edi
	callq	putChar
	popq	%rax
	ret
.Ltmp2:
	.size	print, .Ltmp2-print
	.cfi_endproc

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp4:
	.cfi_def_cfa_offset 16
	movl	$61, %edi
	callq	print
	movl	$65, %edi
	callq	print
	xorl	%eax, %eax
	popq	%rdx
	ret
.Ltmp5:
	.size	main, .Ltmp5-main
	.cfi_endproc

	.type	gvar,@object            # @gvar
	.comm	gvar,4,4

	.section	".note.GNU-stack","",@progbits
