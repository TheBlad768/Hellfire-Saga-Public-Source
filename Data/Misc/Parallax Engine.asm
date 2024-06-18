; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to process horizontal deformation of the background
;
; input:
;   a4 - Deformation table data
;   a5 - Address for values for defining the BG positions to use.
; ---------------------------------------------------------------------------

ApplyDeformation:
		move.w	#$E0-1,d1			; load number of scanlines to process

ApplyDeformation2:
		lea	v_hscrolltablebuffer.w,a1	; load horizontal scroll table to a1
		move.w	Camera_Y_pos_BG_copy.w,d0	; load BG y-position to d0
		move.w	v_screenposx.w,d3		; load camera x-position to d3

ApplyDeformation3:
		move.w	(a4)+,d2			; load number of scanlines to process to d2
		smi	d4				; if negative, set complex flag
		andi.w	#$7FFF,d2			; clear most significant bit
		sub.w	d2,d0				; substract the line count from current y-position
		bmi.s	.linevisible			; if negative, this section is visible now.

		addq.w	#2,a5				; skip this section's offset value
		tst.b	d4				; check if complex flag was set
		beq.s	ApplyDeformation3		; if not, check next segment

		subq.w	#2,a5				; undo section skipping
		add.w	d2,d2				; double line count
		adda.w	d2,a5				; add that into BG position array (each line is 2 bytes)
		bra.s	ApplyDeformation3		; check next section
; ---------------------------------------------------------------------------

.linevisible
		neg.w	d3				; negate FG x-position
		swap	d3				; swap it to high word

		tst.b	d4				; check if complex flag was set
		beq.s	.nocomplex			; if not, branch
		add.w	d0,d2				; substract leftover y-position from total line count
		add.w	d2,d2				; double the value
		adda.w	d2,a5				; add the lines not visible into BG position array

.nocomplex
		neg.w	d0				; negate y-position offset (this gets how many lines this block is on-screen)
		move.w	d1,d2				; copy screen height - 1 to d2
		sub.w	d0,d2				; substract the block height on-screen from number of lines left to fill
		bcc.s	.blockloop			; if less lines are in the block, branch
		move.w	d1,d0				; copy amount of lines left to d0
		addq.w	#1,d0				; account of the -1

.blockloop
		subq.w	#1,d0				; decrement 1 for dbf

.blockloop2
		tst.b	d4				; check for complex flag
		beq.s	.donormal			; if not set, branch
		lsr.w	#1,d0				; halve value (for quicker loop)
		bcc.s	.complexeven			; branch if the number was even

.complexloop
		move.w	(a5)+,d3			; get the background x-position from RAM
		neg.w	d3				; negate it
		move.l	d3,(a1)+			; save FG & BG position to h-scroll table

.complexeven
		move.w	(a5)+,d3			; get the background x-position from RAM
		neg.w	d3				; negate it
		move.l	d3,(a1)+			; save FG & BG position to h-scroll table
		dbf	d0,.complexloop			; loop for all the remaining lines in the block
		bra.s	.nextblock
; ---------------------------------------------------------------------------

.donormal
		move.w	(a5)+,d3			; get the background x-position from RAM
		neg.w	d3				; negate it
		lsr.w	#1,d0				; halve value (for quicker loop)
		bcc.s	.normaleven			; branch if the number was even

.normalloop
		move.l	d3,(a1)+			; save FG & BG position to h-scroll table

.normaleven
		move.l	d3,(a1)+			; save FG & BG position to h-scroll table
		dbf	d0,.normalloop			; loop for all the remaining lines in the block

.nextblock
		tst.w	d2				; check if there are any lines remaining onscreen
		bmi.s	.rts				; if not, exit
		move.w	(a4)+,d0			; load number of scanlines to process to d0
		smi	d4				; if negative, set complex flag
		andi.w	#$7FFF,d0			; clear most significant bit

		move.w	d2,d3				; copy remaining number of lines to fill to d3
		sub.w	d0,d2				; substract the block height on-screen from number of lines left to fill
		bpl.s	.blockloop			; if less lines are in the block, branch

		move.w	d3,d0				; copy amount of lines left to d0
		bra.s	.blockloop2
; ---------------------------------------------------------------------------

.rts
		rts
