	.text
	.file	"1.c"
	.globl	f                       // -- Begin function f
	.type	f,@function
f:                                      // @f
// BB#0:
	PUSH	SR
	ADD	R0, R0, 1
	POP	SR
	RET
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        // -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
