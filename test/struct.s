	.text
	.file	"struct.c"
	.globl	same                    // -- Begin function same
	.type	same,@function
same:                                   // @same
// BB#0:
	PUSH	SR
	LOAD	R1, (R0)
	ADD	R0, R0, 4
	LOAD	R2, (R0+4)
	MOVE	1, R0
	CMP	R1, R2
	JP_EQ	BB0_2
// BB#1:
	MOVE	0, R0
BB0_2:
	POP	SR
	RET
.Lfunc_end0:
	.size	same, .Lfunc_end0-same
                                        // -- End function
	.globl	inc_fst                 // -- Begin function inc_fst
	.type	inc_fst,@function
inc_fst:                                // @inc_fst
// BB#0:
	PUSH	SR
	LOAD	R1, (R0)
	ADD	R1, R1, 1
	STORE	R1, (R0)
	POP	SR
	RET
.Lfunc_end1:
	.size	inc_fst, .Lfunc_end1-inc_fst
                                        // -- End function
	.globl	inc_snd                 // -- Begin function inc_snd
	.type	inc_snd,@function
inc_snd:                                // @inc_snd
// BB#0:
	PUSH	SR
	ADD	R0, R0, 4
	LOAD	R1, (R0+4)
	ADD	R1, R1, 1
	STORE	R1, (R0+4)
	POP	SR
	RET
.Lfunc_end2:
	.size	inc_snd, .Lfunc_end2-inc_snd
                                        // -- End function
	.globl	do_stuff                // -- Begin function do_stuff
	.type	do_stuff,@function
do_stuff:                               // @do_stuff
// BB#0:
	PUSH	R4
	PUSH	SP
	PUSH	SR
	MOVE	R0, R3
	ADD	R0, SP, 40
	OR	R4, R0, 4
	STORE	R2, (R4+4)
	STORE	R1, (SP+40)
	# ADJCALLSTACKDOWN 0, 0
	CALL	same
	MOVE	0, R1
	# ADJCALLSTACKDOWN 0, 0
	CMP	R0, R1
	JP_EQ	BB3_2
// BB#1:
	CALL	inc_fst
	JP	BB3_3
BB3_2:
	CALL	inc_snd
BB3_3:
	LOAD	R0, (R4+4)
	ADD	R1, R3, 4
	LOAD	R2, (SP+40)
	STORE	R0, (R1+4)
	STORE	R2, (R3)
	POP	SR
	POP	SP
	POP	R4
	RET
.Lfunc_end3:
	.size	do_stuff, .Lfunc_end3-do_stuff
                                        // -- End function

	.ident	"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"
	.section	".note.GNU-stack","",@progbits
