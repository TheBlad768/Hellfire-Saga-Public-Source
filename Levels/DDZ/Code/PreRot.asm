; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to create pre-rotated art from VRAM - MarkeyJester
; --- input -----------------------------------------------------------------
; d0.w = VRAM to rip from
; d1.w = width of sprite size
; d2.w = height of sprite size
; d4.w = VRAM address to save to (in pattern index format)
; d7.w = Angle rate
; a1.l = $1800 bytes - RAM to unpack to (should be $30 x $30, but we'll make it $40 x $30 for easy calculation)
; a3.l =  $200 bytes - RAM art to pack and transfer
; a4.l = Large enough for the frames - RAM address to dump the sprite mappings
; ---------------------------------------------------------------------------
;		move.w	#$0020,d0					; VRAM address where art is
;		moveq	#$03,d1						; width of sprite
;		moveq	#$04,d2						; height of sprite
;		move.w	#$1000,d4					; VRAM address to save rotated art to
;		moveq	#$08,d7		; Must be power of 2!		; angle rate (speed of advancing the angle around)
;		lea	($FFFF0000).l,a1				; ram address to unpack to
;		lea	($FFFF1800).l,a3				; ram address to rotate and pack to
;		lea	($FFFF1A00).l,a4				; ram address to dump the sprite mappings
;		jsr	PreRotate					; unpack and prerotate art from VRAM
; ---------------------------------------------------------------------------

PreRotate:
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		bsr.w	PreRot_Unpack					; unpack art for prerotation
		moveq	#$80-1,d6					; get number of frames based on angle rate
		addq.b	#$01,d6						; '' (div needs entire long-word)
		divu.w	d7,d6						; ''
		move.w	d6,d0						; multiply by 2 for the other 180 degrees
		add.w	d0,d0						; ''
		move.l	#$00000100,d3					; load maximum angles amount
		divu.w	d0,d3						; divide by number of frames to get angle rate
		move.w	d7,d0						; store half the segment size
		lsr.w	#$01,d0						; '' (needed for shifting rotation around correctly and fairly)
		move.w	d0,(a4)+					; ''
		move.w	d3,(a4)+					; save as first entry in mapping list
		move.w	#$00C0,d3					; starting angle
		subq.w	#$01,d6						; minus 1 from frames count for dbf counter
		move.w	d6,-(sp)					; store for later (need to do other 180 later on)
		pea	(a4)						; store start of mappings address
		move.w	d4,d5						; make the second piece use the same art as the first piece
		eori.w	#$1800,d5					; rotate the second piece 180
		; second piece art will be reversed below (see the cmpi with d6 for details)

	.NextAngle:
		bsr.w	PreRot_Rotate					; rotate art
		bsr.w	PreRot_Pack					; pack art into VRAM
		bsr.w	PreRot_MakeMap					; make the mappings for sprites
		move.w	$04(sp),d0					; reload frames count
		cmp.w	d0,d6						; have we just rendered the first frame?
		bne.s	.Okay						; if not, continue normally
		; The first frame needed the same VRAM on right piece as left, but
		; the frames after don't, hence this below:
		move.w	d6,d5						; load number of angles
		addq.w	#$01,d5						; remove dbf count
		lsl.w	#$03,d5						; multiply by 10 tiles per piece
		add.w	d5,d5						; '' ($200)
		add.w	d4,d5						; advance to end position

	.Okay:
		subi.w	#$0010,d5					; advance to previous art
		addi.w	#$0010,d4					; advance to next art
		add.b	d7,d3						; rotate
		dbf	d6,.NextAngle					; repeat for number of angles

	; --- Mapping other half of 180 with same art ---

		move.l	(sp)+,a2					; reload start of mappings address
		move.w	(sp)+,d6					; number of angles to render
		move.w	#$1800,d2					; prepare 

	.Next:
		move.l	(a2)+,(a4)+					; copy Y, and shape across
		move.w	(a2),d0						; load first VRAM
		eor.w	d2,d0						; rotate 180
		move.l	(a2)+,(a4)+					; copy X across
		move.l	(a2)+,(a4)+					; copy Y, and shape across
		move.w	(a2)+,d1					; load second VRAM
		eor.w	d2,d1						; rotate 180
		move.w	d0,(a4)+					; save first VRAM to second
		move.w	(a2)+,(a4)+					; copy X across
		move.w	d1,-$0C(a4)					; save second VRAM to first
		dbf	d6,.Next					; repeat for number of sprites required
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to create sprite mappings to be used with the art
; --- input -----------------------------------------------------------------
; d1.w = width of sprite size
; d2.w = height of sprite size
; d3.w = angle of rotation 00QQ
; a4.l = RAM address to dump the sprite mappings
; ---------------------------------------------------------------------------

PreRot_MakeMap:
		movem.l	d0-a3,-(sp)					; store registers

		add.w	d3,d3						; multiply angle by word element size
		lea	(SineTable+1).w,a0				; load sinewave table

	; The pieces are separated from centre along the width, and
	; so the height will be set to the same as the width 

	move.w	d1,d2						; set height to be the same as width

		muls.w	-$01(a0,d3.w),d2				; multiply sprite size by sine distance
		muls.w	+$7F(a0,d3.w),d1				; ''
	;	asr.l	#$06,d2						; divide by $100 then mutliply by 4 (half a tile per tile (half a sprite))
	;	asr.l	#$06,d1						; ''
	divs.w	#$40+1,d2			; divide by $100 then mutliply by 4 (half a tile per tile (half a sprite))
	divs.w	#$40+1,d1			; '' (the extra 1 is to shrink it closer together by a pixel to hide the gap)
		neg.w	d1						; reverse X for left side first

		move.w	d2,(a4)						; set Y position
		subi.w	#$10,(a4)+					; account for radius of 4 x 4 sprite
		move.w	#$000F,(a4)+					; set shape (4 x 4 sprite)
		move.w	d4,(a4)+					; set VRAM for left side
		move.w	d1,(a4)						; set X position
		subi.w	#$10,(a4)+					; account for radius of 4 x 4 sprite

		neg.w	d2						; reverse to opposide side 180 degrees
		neg.w	d1						; ''
		eori.w	#$0800,d5					; mirror the opposide side's pattern index

		move.w	d2,(a4)						; set Y position
		subi.w	#$10,(a4)+					; account for radius of 4 x 4 sprite
		move.w	#$000F,(a4)+					; set shape (4 x 4 sprite)
		move.w	d5,(a4)+					; set VRAM for right side
		move.w	d1,(a4)						; set X position
		subi.w	#$10,(a4)+					; account for radius of 4 x 4 sprite

		movem.l	(sp)+,d0-a3					; restore registers
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to pack rotated art ready for VRAM
; --- input -----------------------------------------------------------------
; d4.w = VRAM address to save to
; a3.l = art to pack and transfer
; ---------------------------------------------------------------------------

PreRot_Pack:
		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts
		movem.l	d0-a4,-(sp)					; store registers

	; --- VDP write setup ---

		lsl.l	#$07,d4						; align address for VRAM write
		lsr.w	#$02,d4						; ''
		ori.w	#$4000,d4					; ''
		swap	d4						; ''
		andi.w	#$0003,d4					; get only address bits
		move.l	d4,(a6)						; set VDP to VRAM write mode

		moveq	#4-1,d6						; number of columns to do

PRP_NextX:

Count := 0
	rept	4*8
AddrTemp := ((4*8)/2)*Count	; because AS doesn't like doing it on the instruction itself >=(
		move.l	AddrTemp(a3),(a5)			; write tile line
Count := Count+1
	endm
		addq.w	#$04,a3						; advance to next tile column
		dbf	d6,PRP_NextX					; repeat for all colums

		movem.l	(sp)+,d0-a4					; restore registers
		move.w	(sp)+,sr					; restore status register
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to rotate unpacked art
; --- input -----------------------------------------------------------------
; d3.w = angle of rotation 00QQ
; a1.l = unpacked art
; a3.l = dump address
; ---------------------------------------------------------------------------

PreRot_Rotate:
		movem.l	d0-a5,-(sp)					; store registers

		lea	(SineTable+1).w,a0				; load sinewave table

	; --- start position setup ---

		move.w	d3,d0						; load angle
		subi.b	#$60,d0						; get angle of top/left start point
		add.w	d0,d0						; multiply by size of word
		move.w	-$01(a0,d0.w),d1				; load Y trajectory
		move.w	+$7F(a0,d0.w),d0				; load X trajectory
		ext.l	d0						; sign extend
		ext.l	d1						; ''
		lsl.w	#$04,d0						; multiply by radius to corner (half of $20 max sprite size)
		lsl.w	#$04,d1						; ''
		move.w	+$3F(a0),d2					; divide by corner distance to get pixel distance instead of sine distance
	asl.l	#$04,d0						; create fraction space (cannot go higher)
	asl.l	#$04,d1						; ''
		divs.w	d2,d0						; ''
		divs.w	d2,d1						; ''
		swap	d0						; convert to QQQQ.FFFF
		swap	d1						; ''
		clr.w	d0						; clear fractions
		clr.w	d1						; ''
	asr.l	#$04,d0						; remove fraction for X
	lsl.l	#$06-4,d1					; remove fraction then multiply Y by $40 (width of buffer)

	; --- X advancement ---

		move.w	d3,d2						; load angle
		add.w	d2,d2						; multiply by size of word element
		move.w	-$01(a0,d2.w),d4				; load Y trajectory
		move.w	+$7F(a0,d2.w),d2				; load X trajectory
		ext.l	d2						; convert to 0001.FFFF (QQQQ.FFFF)
		asl.l	#$08,d2						; ''
		swap	d4						; convert to 004F.FFFF (QQQF.FFFF)
		clr.w	d4						; ''
		asr.l	#$02,d4						; ''
		move.l	d2,a5						; store X advancement
		move.l	d4,a4						; ''

	; --- Y advancement ---

		move.w	d3,d2						; load angle
		addi.b	#$40,d2						; rotate 90 degrees for vertical movement
		add.w	d2,d2						; multiply by size of word element
		move.w	-$01(a0,d2.w),d4				; load Y trajectory
		move.w	+$7F(a0,d2.w),d2				; load X trajectory
		ext.l	d2						; convert to 0001.FFFF (QQQQ.FFFF)
		asl.l	#$08,d2						; ''
		swap	d4						; convert to 004F.FFFF (QQQF.FFFF)
		clr.w	d4						; ''
		asr.l	#$02,d4						; ''
		move.l	d2,-(sp)					; store Y advancement for later (not enough registers)
		move.l	d4,a0						; ''

	; --- The transform loop ---

		lea	$18+($18*$40)(a1),a1				; get centre position
		lea	$C00(a1),a2					; get right nybble version
		move.l	#$FFC00000,d3					; prepare Y quotient mask
		moveq	#(4*8)-1,d7					; height

	.NextY:
		moveq	#((4*8)/2)-1,d6					; width
		movem.l	d0-d1,-(sp)					; store positions

	.NextX:
		move.l	d1,d2						; load Y
		and.l	d3,d2						; clear fraction
		add.l	d0,d2						; add X
		swap	d2						; get only quotient
		move.b	(a1,d2.w),d3					; write pixel
		add.l	a5,d0						; advance along X (sine X)
		add.l	a4,d1						; '' (sine Y)
		move.l	d1,d2						; load Y
		and.l	d3,d2						; clear fraction
		add.l	d0,d2						; add X
		swap	d2						; get only quotient
		or.b	(a2,d2.w),d3					; fuse with left pixel
		move.b	d3,(a3)+					; write pixels to out buffer
		add.l	a5,d0						; advance along X (sine X)
		add.l	a4,d1						; '' (sine Y)
		dbf	d6,.NextX					; repeat for all pixels in width
		movem.l	(sp)+,d0-d1					; restore positions
		add.l	(sp),d0						; advance along Y (sine X)
		add.l	a0,d1						; '' (sine Y)
		dbf	d7,.NextY					; repeat for all lines in height
		addq.w	#$04,sp						; remove Y advance sine adds from stack
		movem.l	(sp)+,d0-a5					; restore registers
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to rip out tile sprite art from VRAM and unpack into RAM as bitmap
; --- input -----------------------------------------------------------------
; d0.w = VRAM to rip from
; d1.w = width of sprite size
; d2.w = height of sprite size
; a1.l = RAM to unpack to (should be $30 x $30, but we'll make it $40 x $30 for easy calculation)
;			  (x2 for two nybble sides ($1000 x 2 = $2000))
;         _________________
;	,/($10^2) + ($10^2) = $17 ($18 rounded) x 2 = $30 ($40 rounded)
; ---------------------------------------------------------------------------

PreRot_Unpack:
		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts
		movem.l	d0-a4,-(sp)					; store registers

	; --- VDP read setup ---

		lsl.l	#$02,d0						; align address for VRAM read
		lsr.w	#$02,d0						; ''
		swap	d0						; ''
		andi.w	#$0003,d0					; get only address bits
		move.l	d0,(a6)						; set VDP to VRAM read mode

	; --- Getting RAM start address ---

		moveq	#$04,d3						; get starting X position
		sub.w	d1,d3						; ''
		add.w	d3,d3						; multiply by 8 / 2
		add.w	d3,d3						; ''
		lea	$08(a1,d3.w),a2					; load starting X position (add pad area)
		moveq	#$04,d3						; get starting Y position
		sub.w	d2,d3						; ''
		lsl.w	#$07,d3						; multiply by (8 / 2) x 40
		add.w	d3,d3						; ''
		addi.w	#8*$40,d3					; add pad area
		lea	(a2,d3.w),a2					; load starting Y position

	; --- Loading art out ---

		pea	(a2)						; store starting position
		move.w	d1,d3						; load width
		subq.w	#$01,d3						; ''

	.NextX:
		pea	(a2)						; store starting Y position
		move.w	d2,d0						; load height
		subq.w	#$01,d0						; ''

	.NextY:
	rept	8
		move.l	(a5),(a2)					; load pixel row
		lea	$40(a2),a2					; advance to next row
	endm
		dbf	d0,.NextY					; repeat for number of tiles vertically
		move.l	(sp)+,a2					; restore starting Y address
		addq.w	#$08,a2						; move right
		dbf	d3,.NextX					; repeat for number of tiles horizontally

	; --- Unpacking pixel width ---

		move.l	(sp),a2						; restore starting address
		clr.w	-(sp)						; clear multiplication space
		move.l	#$0F0F0F0F,d7					; prepare and masking
		lsl.w	#$03,d2						; multiply height by 8 (size of a tile)
		subq.w	#$01,d2						; minus 1 for dbf

	.LineY:
		move.w	d1,d0						; load width
		subq.w	#$01,d0						; ''

	.LineX:
		move.l	(a2),d3						; load pixels
		swap	d3						; reverse order
		moveq	#$02-1,d6					; number of long-words per long

	.NextLong:
		moveq	#$02-1,d5					; number of words

	.NextWord:
		swap	d4						; send to upper word
		rol.w	#$04,d3						; get first nybble
		move.b	d3,(sp)						; send to upper byte
		move.w	(sp),d4						; ''
		rol.w	#$04,d3						; get second nybble
		move.b	d3,d4						; ''
		dbf	d5,.NextWord					; repeat for long-word
		and.l	d7,d4						; get only right nybbles
		move.l	d4,$C00(a2)					; save to right nybble buffer
		lsl.l	#$04,d4						; get left nybbles
		move.l	d4,(a2)+					; save to left nybble buffer
		swap	d3						; get next word for next long-word
		dbf	d6,.NextLong					; repeat for second word/long-word
		dbf	d0,.LineX					; repeat for number of pixels horizontally
		addi.w	#$40,$04(sp)					; advance to next line
		move.l	$02(sp),a2					; load next address
		dbf	d2,.LineY					; repeat for number of pixels vertically
		addq.w	#$06,sp						; restore stack

		movem.l	(sp)+,d0-a4					; restore registers
		move.w	(sp)+,sr					; restore sr
		rts							; return

; ===========================================================================