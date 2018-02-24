	.text
	.file	"string.c"
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
	.globl	strcpy                  ; -- Begin function strcpy
	.type	strcpy,@function
strcpy:                                 ; @strcpy
; BB#0:
	PUSH	SR
	STORE	R1, (SP)
	STORE	R0, (SP+4)
	JP	.LBB1_1
.LBB1_2:                                ;   in Loop: Header=BB1_1 Depth=1
	LOAD	R0, (SP)
	ADD	R1, R0, 1
	STORE	R1, (SP)
	LOADB	R0, (R0)
	LOAD	R1, (SP+4)
	ADD	R2, R1, 1
	STORE	R2, (SP+4)
	STOREB	R0, (R1)
.LBB1_1:                                ; =>This Inner Loop Header: Depth=1
	LOAD	R0, (SP)
	LOADB	R0, (R0)
	SHL	R0, R0, 24
	ASHR	R1, R0, 24
	MOVE	0, R0
	CMP	R1, R0
	JP_NE	.LBB1_2
; BB#3:
	LOAD	R1, (SP+4)
	STOREB	R0, (R1)
	POP	SR
	RET
Lfunc_end1:
	.size	strcpy, Lfunc_end1-strcpy
                                        ; -- End function
	.globl	strncpy                 ; -- Begin function strncpy
	.type	strncpy,@function
strncpy:                                ; @strncpy
; BB#0:
	PUSH	SR
	STORE	R1, (SP+8)
	STORE	R0, (SP+12)
	STORE	R2, (SP+4)
	MOVE	0, R0
	STORE	R0, (SP)
	JP	.LBB2_1
.LBB2_5:                                ;   in Loop: Header=BB2_1 Depth=1
	LOAD	R1, (SP+8)
	LOADB	R1, (R1)
	LOAD	R2, (SP+12)
	STOREB	R1, (R2)
	LOAD	R1, (SP)
	ADD	R1, R1, 1
	STORE	R1, (SP)
	LOAD	R1, (SP+8)
	ADD	R1, R1, 1
	STORE	R1, (SP+8)
	LOAD	R1, (SP+12)
	ADD	R1, R1, 1
	STORE	R1, (SP+12)
.LBB2_1:                                ; =>This Inner Loop Header: Depth=1
	LOAD	R1, (SP+4)
	LOAD	R2, (SP)
	CMP	R2, R1
	MOVE	R0, R1
	JP_SGE	.LBB2_4
; BB#2:                                 ;   in Loop: Header=BB2_1 Depth=1
	LOAD	R1, (SP+8)
	LOADB	R1, (R1)
	SHL	R1, R1, 24
	ASHR	R3, R1, 24
	MOVE	0, R2
	MOVE	1, R1
	CMP	R3, R2
	JP_NE	.LBB2_4
; BB#3:                                 ;   in Loop: Header=BB2_1 Depth=1
	MOVE	R2, R1
.LBB2_4:                                ;   in Loop: Header=BB2_1 Depth=1
	AND	R1, R1, 1
	MOVE	0, R2
	CMP	R1, R2
	JP_NE	.LBB2_5
; BB#6:
	POP	SR
	RET
Lfunc_end2:
	.size	strncpy, Lfunc_end2-strncpy
                                        ; -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
