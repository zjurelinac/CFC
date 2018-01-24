	.text
	.file	"string.c"
	.globl	_Z6strlenPKc            // -- Begin function _Z6strlenPKc
	.type	_Z6strlenPKc,@function
_Z6strlenPKc:                           // @_Z6strlenPKc
// BB#0:
	PUSH	SR
	MOVE	0, R2
	MOVE	R2, R1
BB0_1:                                  // =>This Inner Loop Header: Depth=1
	ADD	R3, R0, R1
	ADD	R1, R1, 1
	LOADB	R3, (R3)
	CMP	R3, R2
	JP_NE	BB0_1
// BB#2:
	MOVE	R1, R0
	POP	SR
	RET
.Lfunc_end0:
	.size	_Z6strlenPKc, .Lfunc_end0-_Z6strlenPKc
                                        // -- End function
	.globl	_Z6strcpyPcPKc          // -- Begin function _Z6strcpyPcPKc
	.type	_Z6strcpyPcPKc,@function
_Z6strcpyPcPKc:                         // @_Z6strcpyPcPKc
// BB#0:
	PUSH	R4
	PUSH	SR
	LOADB	R3, (R1)
	MOVE	0, R2
	CMP	R3, R2
	JP_EQ	BB1_3
// BB#1:
	ADD	R1, R1, 1
BB1_2:                                  // =>This Inner Loop Header: Depth=1
	STOREB	R3, (R0)
	ADD	R4, R1, 1
	ADD	R0, R0, 1
	LOADB	R3, (R1)
	MOVE	0, R1
	CMP	R3, R1
	MOVE	R4, R1
	JP_NE	BB1_2
BB1_3:
	STOREB	R2, (R0)
	POP	SR
	POP	R4
	RET
.Lfunc_end1:
	.size	_Z6strcpyPcPKc, .Lfunc_end1-_Z6strcpyPcPKc
                                        // -- End function
	.globl	_Z7strncpyPcPKci        // -- Begin function _Z7strncpyPcPKci
	.type	_Z7strncpyPcPKci,@function
_Z7strncpyPcPKci:                       // @_Z7strncpyPcPKci
// BB#0:
	PUSH	R6
	PUSH	R5
	PUSH	R4
	PUSH	SR
	MOVE	1, R3
	CMP	R2, R3
	JP_SLT	BB2_4
// BB#1:
	MOVE	0, R3
	MOVE	R3, R4
BB2_2:                                  // =>This Inner Loop Header: Depth=1
	ADD	R5, R1, R4
	LOADB	R5, (R5)
	CMP	R5, R3
	JP_EQ	BB2_4
// BB#3:                                //   in Loop: Header=BB2_2 Depth=1
	ADD	R6, R0, R4
	STOREB	R5, (R6)
	ADD	R4, R4, 1
	CMP	R4, R2
	JP_SLT	BB2_2
BB2_4:
	POP	SR
	POP	R4
	POP	R5
	POP	R6
	RET
.Lfunc_end2:
	.size	_Z7strncpyPcPKci, .Lfunc_end2-_Z7strncpyPcPKci
                                        // -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
