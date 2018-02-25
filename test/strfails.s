	.text
	.file	"strfails.c"
	.globl	strcmp                  ; -- Begin function strcmp
	.type	strcmp,@function
strcmp:                                 ; @strcmp
; BB#0:
	SUB	SP, SP, 12
	PUSH	R4
	PUSH	SR
	LOADB	R2, (R0)
	AND	R3, R2, 255
	MOVE	0, R2
	CMP	R3, R2
	JP_EQ	.LBB0_7
; BB#1:
	ADD	R0, R0, 1
.LBB0_2:                                ; =>This Inner Loop Header: Depth=1
	LOADB	R2, (R1)
	AND	R4, R2, 255
	AND	R2, R3, 255
	CMP	R2, R4
	JP_NE	.LBB0_6
; BB#3:                                 ;   in Loop: Header=BB0_2 Depth=1
	MOVE	0, R2
	CMP	R4, R2
	JP_EQ	.LBB0_6
; BB#4:                                 ;   in Loop: Header=BB0_2 Depth=1
	ADD	R4, R0, 1
	ADD	R1, R1, 1
	LOADB	R0, (R0)
	AND	R3, R0, 255
	CMP	R3, R2
	MOVE	R4, R0
	JP_NE	.LBB0_2
	JP	.LBB0_7
.LBB0_6:
	MOVE	R3, R2
.LBB0_7:
	SHL	R0, R2, 24
	ASHR	R0, R0, 24
	LOADB	R1, (R1)
	AND	R1, R1, 255
	SHL	R3, R1, 24
	ASHR	R4, R3, 24
	MOVE	-1, R3
	CMP	R0, R4
	JP_SLT	.LBB0_9
; BB#8:
	MOVE	1, R3
.LBB0_9:
	AND	R2, R2, 255
	MOVE	0, R0
	CMP	R2, R1
	JP_EQ	.LBB0_11
; BB#10:
	MOVE	R3, R0
.LBB0_11:
	POP	SR
	POP	R4
	ADD	SP, SP, 12
	RET
Lfunc_end0:
	.size	strcmp, Lfunc_end0-strcmp
                                        ; -- End function
	.globl	atoi                    ; -- Begin function atoi
	.type	atoi,@function
atoi:                                   ; @atoi
; BB#0:
	SUB	SP, SP, 8
	PUSH	SR
	MOVE	R0, R1
	MOVE	0, R0
	LOADB	R2, (R1)
	SHL	R2, R2, 24
	ASHR	R2, R2, 24
	ADD	R2, R2, -48
	MOVE	9, R3
	CMP	R2, R3
	JP_UGT	.LBB1_3
; BB#1:
	MOVE	0, R0
	LOADB	R1, (R1)
	SHL	R1, R1, 24
	ASHR	R1, R1, 24
	ADD	R1, R1, -48
	MOVE	10, R3
.LBB1_2:                                ; =>This Inner Loop Header: Depth=1
	; MUL R0, R0, R3
	ADD	R0, R2, R0
	CMP	R1, R3
	MOVE	R1, R2
	JP_ULT	.LBB1_2
.LBB1_3:
	POP	SR
	ADD	SP, SP, 8
	RET
Lfunc_end1:
	.size	atoi, Lfunc_end1-atoi
                                        ; -- End function
	.globl	memcpy                  ; -- Begin function memcpy
	.type	memcpy,@function
memcpy:                                 ; @memcpy
; BB#0:
	SUB	SP, SP, 8
	PUSH	SR
	MOVE	1, R3
	CMP	R2, R3
	JP_SLT	.LBB2_2
.LBB2_1:                                ; =>This Inner Loop Header: Depth=1
	LOADB	R3, (R1)
	STOREB	R3, (R0)
	ADD	R0, R0, 1
	ADD	R1, R1, 1
	ADD	R2, R2, -1
	MOVE	0, R3
	CMP	R2, R3
	JP_NE	.LBB2_1
.LBB2_2:
	POP	SR
	ADD	SP, SP, 8
	RET
Lfunc_end2:
	.size	memcpy, Lfunc_end2-memcpy
                                        ; -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
