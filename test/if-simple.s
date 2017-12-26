	.text
	.file	"if-simple.c"
	.globl	f                       // -- Begin function f
	.type	f,@function
f:                                      // @f
// BB#0:
	PUSH	SR
	STORE	R0, (SP+20)
	MOVE	-1, R1
	CMP	R0, R1
	JP_SLE	BB0_1
// BB#2:
	LOAD	R0, (SP+20)
	JP	BB0_3
BB0_1:
	MOVE	0, R0
BB0_3:
	STORE	R0, (SP+16)
	LOAD	R0, (SP+16)
	POP	SR
	RET
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        // -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
