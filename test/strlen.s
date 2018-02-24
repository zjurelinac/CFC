	.text
	.file	"strlen.c"
	.globl	strlen                  ; -- Begin function strlen
	.type	strlen,@function
strlen:                                 ; @strlen
; BB#0:
	PUSH	SR
	MOVE	0, R1
	STORE	R1, (SP)
	STORE	R0, (SP+4)
.LBB0_1:                                ; =>This Inner Loop Header: Depth=1
	LOAD	R0, (SP)
	ADD	R2, R0, 1
	STORE	R2, (SP)
	LOAD	R2, (SP+4)
	ADD	R0, R2, R0
	LOADB	R0, (R0)
	SHL	R0, R0, 24
	ASHR	R0, R0, 24
	CMP	R0, R1
	JP_NE	.LBB0_1
; BB#2:
	LOAD	R0, (SP)
	POP	SR
	RET
Lfunc_end0:
	.size	strlen, Lfunc_end0-strlen
                                        ; -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
