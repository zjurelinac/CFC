	.text
	.file	"ternary-if.c"
	.globl	f                       // -- Begin function f
	.type	f,@function
f:                                      // @f
// BB#0:
	PUSH	SR
	ASHR	R1, R0, 31
	ADD	R0, R0, R1
	XOR	R0, R0, R1
	POP	SR
	RET
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        // -- End function
	.globl	g                       // -- Begin function g
	.type	g,@function
g:                                      // @g
// BB#0:
	PUSH	SP
	PUSH	SR
	# ADJCALLSTACKDOWN 0, 0
	CALL	(f)
	# ADJCALLSTACKUP, 0
	MOVE	R0, R2
	# ADJCALLSTACKDOWN 0, 0
	MOVE	R1, R0
	CALL	(f)
	# ADJCALLSTACKUP, 0
	ADD	R0, R0, R2
	POP	SR
	POP	SP
	RET
.Lfunc_end1:
	.size	g, .Lfunc_end1-g
                                        // -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
