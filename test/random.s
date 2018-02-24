	.text
	.file	"random.c"
	.globl	_Z5srandj               ; -- Begin function _Z5srandj
	.type	_Z5srandj,@function
_Z5srandj:                              ; @_Z5srandj
; BB#0:
	MOVE	_ZL8holdrand, R1
	STORE	R0, (R1)
	STORE	R0, (SP)
	RET
Lfunc_end0:
	.size	_Z5srandj, Lfunc_end0-_Z5srandj
                                        ; -- End function
	.globl	_Z4randv                ; -- Begin function _Z4randv
	.type	_Z4randv,@function
_Z4randv:                               ; @_Z4randv
; BB#0:
	PUSH	SR
	MOVE	_ZL8holdrand, R0
	LOAD	R1, (R0)
	MOVE	214013, R2
	; MUL R1, R1, R2
	ADD	R1, R1, 2531011
	STORE	R1, (R0)
	SHR	R0, R1, 16
	AND	R0, R0, 32767
	POP	SR
	RET
Lfunc_end1:
	.size	_Z4randv, Lfunc_end1-_Z4randv
                                        ; -- End function
	.type	_ZL8holdrand,@object    ; @_ZL8holdrand
	.local	_ZL8holdrand
	.comm	_ZL8holdrand,4,4

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
