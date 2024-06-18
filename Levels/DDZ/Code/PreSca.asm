; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to create pre-scaled art for VRAM later - MarkeyJester (beta code)
; --- input -----------------------------------------------------------------
; d6.w = Size of nybble buffer
; a1.l = RAM address where the art currently is
; a2.l = RAM address to unpack the art
; a3.l = Sprite mappings frame list address for reference
; ---------------------------------------------------------------------------

	; --- Setting up art in RAM by splitting the pixels into odd/even versions ---

PreScale_Setup:
		clr.l	(a2)+						; create clear left pixels
		clr.l	(a2)+						; ''
		move.w	(a3)+,d7					; load number of sprites
		bmi.s	.NoSprites					; if there are no sprites, branch

	.NextSprite:
	addq.w	#$02,a3						; skip first word
		moveq	#$0F,d1						; load shape
		and.l	(a3)+,d1					; ''
		move.w	(a3)+,d0					; load art address
		lsl.w	#$05,d0						; ''
		lea	(a1,d0.w),a0					; ''
	;	addq.w	#$02,a3						; advance to end of piece
	addq.w	#$04,a3						; advance to end of piece

		moveq	#$03,d2						; load height of shape
		and.b	d1,d2						; ''
		sub.b	d2,d1						; load width of shape
		lsr.b	#$02,d1						; ''

		addq.w	#$01,d2						; convert 0 - 3 to 1 - 4
		lsl.w	#$03,d2						; align height to 8 pixels
		move.w	d2,d4						; ''
		add.w	d4,d4						; ''
		add.w	d4,d4						; ''
		subq.w	#$04,d4						; counter the first four bytes (which are written every line)
		subq.w	#$01,d2						; minus 1 for dbf counter

		pea	(a0)						; store art address

	.NextRow:
		move.l	(sp),a0						; load art source address
		move.w	d1,d3						; load width

	.NextCol:
		moveq	#$04-1,d5					; number of bytes in a tile line

	.NextByte:
		moveq	#$00,d0						; load pixels
		move.b	(a0)+,d0					; ''
		add.w	d0,d0						; split pixels
		move.w	.Split(pc,d0.w),d0				; ''
		move.w	d0,(a2,d6.w)					; save right pixels
		lsl.w	#$04,d0						; get left pixels
		move.w	d0,(a2)+					; save left pixels
		dbf	d5,.NextByte					; repeat for pixels in a tile line
		adda.w	d4,a0						; advance to next column
		dbf	d3,.NextCol					; repeat for all columns
	moveq	#$00,d0
	move.l	d0,(a2,d6.w)
	move.l	d0,(a2)+
	move.l	d0,(a2,d6.w)
	move.l	d0,(a2)+
	move.l	d0,(a2,d6.w)
	move.l	d0,(a2)+
	move.l	d0,(a2,d6.w)
	move.l	d0,(a2)+
		addq.l	#$04,(sp)					; advance to next row of pixels
		dbf	d2,.NextRow					; repeat for all rows
		addq.w	#$04,sp						; restore stack

		dbf	d7,.NextSprite					; repeat for all sprite pieces

	.NoSprites:
		rts							; return

		; Pixels on separate bytes

	.Split:	dc.w	$000,$001,$002,$003,$004,$005,$006,$007,$008,$009,$00A,$00B,$00C,$00D,$00E,$00F
		dc.w	$100,$101,$102,$103,$104,$105,$106,$107,$108,$109,$10A,$10B,$10C,$10D,$10E,$10F
		dc.w	$200,$201,$202,$203,$204,$205,$206,$207,$208,$209,$20A,$20B,$20C,$20D,$20E,$20F
		dc.w	$300,$301,$302,$303,$304,$305,$306,$307,$308,$309,$30A,$30B,$30C,$30D,$30E,$30F
		dc.w	$400,$401,$402,$403,$404,$405,$406,$407,$408,$409,$40A,$40B,$40C,$40D,$40E,$40F
		dc.w	$500,$501,$502,$503,$504,$505,$506,$507,$508,$509,$50A,$50B,$50C,$50D,$50E,$50F
		dc.w	$600,$601,$602,$603,$604,$605,$606,$607,$608,$609,$60A,$60B,$60C,$60D,$60E,$60F
		dc.w	$700,$701,$702,$703,$704,$705,$706,$707,$708,$709,$70A,$70B,$70C,$70D,$70E,$70F
		dc.w	$800,$801,$802,$803,$804,$805,$806,$807,$808,$809,$80A,$80B,$80C,$80D,$80E,$80F
		dc.w	$900,$901,$902,$903,$904,$905,$906,$907,$908,$909,$90A,$90B,$90C,$90D,$90E,$90F
		dc.w	$A00,$A01,$A02,$A03,$A04,$A05,$A06,$A07,$A08,$A09,$A0A,$A0B,$A0C,$A0D,$A0E,$A0F
		dc.w	$B00,$B01,$B02,$B03,$B04,$B05,$B06,$B07,$B08,$B09,$B0A,$B0B,$B0C,$B0D,$B0E,$B0F
		dc.w	$C00,$C01,$C02,$C03,$C04,$C05,$C06,$C07,$C08,$C09,$C0A,$C0B,$C0C,$C0D,$C0E,$C0F
		dc.w	$D00,$D01,$D02,$D03,$D04,$D05,$D06,$D07,$D08,$D09,$D0A,$D0B,$D0C,$D0D,$D0E,$D0F
		dc.w	$E00,$E01,$E02,$E03,$E04,$E05,$E06,$E07,$E08,$E09,$E0A,$E0B,$E0C,$E0D,$E0E,$E0F
		dc.w	$F00,$F01,$F02,$F03,$F04,$F05,$F06,$F07,$F08,$F09,$F0A,$F0B,$F0C,$F0D,$F0E,$F0F

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to create scale the art using unpacked art
; --- input -----------------------------------------------------------------
; d6.w = Size of nybble buffer
; d7.w = scale amount 0000 to 7F00 (QQ.FF)
; a1.l = RAM address to scale the art to
; a2.l = RAM address of unpacked art
; a3.l = Sprite mappings frame list address for reference
; ---------------------------------------------------------------------------

PreScale:
		addq.w	#$08,a2						; advance passed the clear left pixels

	; ------------------------------------------------------------
	; This is a VERY crude way of dealing with the scale size
	; unfortunately we don't have time for something more decent
	; with care, so it'll have to do...
	; ------------------------------------------------------------

	cmpi.w	#$0200,d7
	blo.s	.CapRange
	spl.b	d7
	ext.w	d7
	andi.w	#$01FF,d7

	.CapRange:

	moveq	#$00,d5
	move.w	d7,d5
	addi.w	#$0100,d5
	lsl.l	#$08,d5
	move.w	d5,d3
	swap	d5

	move.w	d7,d1
	lsr.w	#$08,d1
	swap	d1

	swap	d7

	; ------------------------------------------------------------

	moveq	#$00,d4

		move.w	(a3)+,d7					; load number of pieces
		bpl.s	.NextSprite					; if there are pieces, branch
		rts							; return

	.NextSprite:
		move.w	#$0F,d1						; load shape
	;	addq.w	#$02,a3						; ''
	addq.w	#$04,a3						; ''
		and.w	(a3)+,d1					; ''
		move.w	(a3)+,d0					; load art address

	lsl.w	#$05,d0						; multiply to x60
	move.w	d0,d2						; '' (x40 because each byte is one pixel in unpacked form, and...
	add.w	d0,d0						; '' ...x20 because of the extra tiles of blank)
	add.w	d2,d0						; ''

	; ...a bit complicated, but running out of time...
	; 6 days left til christmas...

	move.l	d7,d2
	swap	d2
	move.w	d2,d4
	andi.w	#$00FF,d2
	lsr.w	#$08,d4
	lsr.w	d4,d2
	lsr.w	#$04,d2
	sub.w	d2,d0
;	move.l	d1,d2
;	swap	d2
;	lsl.w	#$04,d2
;	add.w	d2,d0
	; ---------------------------------------------

	;	lsl.w	#$06,d0						; '' (PLEASE NOTE, IT'S 6 NOT 5, EACH BYTE IS ONE PIXEL IN UNPACKED FORM)
		lea	(a2,d0.w),a0					; ''
	;	addq.w	#$02,a3						; advance to end of piece
	addq.w	#$04,a3						; advance to end of piece
		movem.l	a2-a3,-(sp)					; store registers for next piece

		moveq	#$03,d2						; load height
		and.b	d1,d2						; ''
		sub.b	d2,d1						; load width

		addq.w	#$01,d2						; convert height from 0 - 3 to 1 - 4
		lsl.w	#$03,d2						; multiply by 8 lines per tile
		move.w	d2,d0						; copy and multiply to size of tile (d2 = dbf count | d4 = tile column size)
		add.w	d0,d0						; ''
		add.w	d0,d0						; ''
		subq.w	#$04,d0						; minus 4 (for the tile line already processed)
		subq.w	#$01,d2						; minus 1 for dbf counter
		movea.w	d0,a4						; setup for adding later

		move.w	d1,d0						; copy width for address add
		lsr.w	#$02,d1						; align for dbf counter
		addq.w	#$04,d0						; convert from 4 - C to 8 - 10
		add.w	d0,d0						; multiply to 8 bytes per tile width (for unpacked art)
	addi.w	#$0010,d0					; account for left/right blank tiles
		movea.w	d0,a3						; setup for adding later

		subq.w	#$04,sp						; reserve space for end of buffer address


	; === Setup top/bottom clearing ===

	addq.w	#$01,d2
	moveq	#$00,d0
	move.w	d2,d0
	lsl.w	#$08,d0
	swap	d7
	move.w	d7,d4
	swap	d7
	addi.w	#$0100,d4
	divu.w	d4,d0
	clr.w	d4

	sub.w	d0,d2
	exg.l	d0,d2
	subq.w	#$01,d2
	swap	d2
	lsr.w	#$01,d0
	move.w	d0,d2
	addx.w	d4,d0	; ...don't ask...
	swap	d2

	; === Clearing top ===

		subq.w	#$01,d0
		bcs.s	.NoClearTop

	.ClearTopStart:
		movem.l	d1/a0-a1,-(sp)					; store source/dest addresses

	.ClearTop:
		clr.l	(a1)+
		adda.w	a4,a1						; advance to next tile column
		dbf	d1,.ClearTop
		movem.l	(sp)+,d1/a0-a1					; reload buffers
		addq.w	#$04,a1						; advance to next row
		dbf	d0,.ClearTopStart

	.NoClearTop:

	; =======================


	.NextRow:
		movem.l	d1/a0-a1,-(sp)					; store source/dest addresses
		lea	(a0,d6.w),a2					; load right pixels



	; --- Clear left side ---

		swap	d1
		move.w	d1,d0
		subq.w	#$01,d1
		bcs.s	.NoClearLeft

	.ClearLeft:
		clr.l	(a1)+
		adda.w	a4,a1						; advance to next tile column
		dbf	d1,.ClearLeft

	.NoClearLeft:
		move.w	d0,d1
		swap	d1
		sub.w	d0,d1
		sub.w	d0,d1

	; --- Central ---

	clr.w	d4
	;moveq	#$00,d6
	swap	d6
	clr.w	d6

	.NextCol:

	rept	4
		move.b	(a0,d6.w),d0					; load left pixel
		add.w	d3,d4						; fraction
		addx.w	d5,d6						; quotient
		or.b	(a2,d6.w),d0					; load right pixel
		add.w	d3,d4						; fraction
		addx.w	d5,d6						; quotient
		move.b	d0,(a1)+					; save pixels to buffer
	endm
		move.l	a1,$0C(sp)					; store end of buffer address
		adda.w	a4,a1						; advance to next tile column
		dbf	d1,.NextCol					; repeat for all columns

	swap	d6

	; --- Clear right side ---

		move.l	d1,d0
		swap	d0
		subq.w	#$01,d0
		bcs.s	.NoClearRight

	.ClearRight:
		clr.l	(a1)+
		move.l	a1,$0C(sp)					; store end of buffer address
		adda.w	a4,a1						; advance to next tile column
		dbf	d0,.ClearRight

	.NoClearRight:

	; ------------------------

		movem.l	(sp)+,d1/a0-a1					; reload buffers
		addq.w	#$04,a1						; advance to next row
	;	adda.w	a3,a0						; advance buffers to next row

	swap	d4						; get Y fraction
	moveq	#$00,d0						; clear result
	add.w	d3,d4						; add fraction
	addx.w	d5,d0						; set quotient
	beq.s	.NoSkip						; if there are no lines to skip, branch
	subq.w	#$01,d0						; minus 1 for dbf
 .YS:	adda.w	a3,a0						; advance buffers to next row
	dbf	d0,.YS						; repeat for all rows which need skipping
	.NoSkip:
	swap	d4						; store Y fraction

		dbf	d2,.NextRow					; repeat for all rows



	; === Clearing top ===

		move.l	d2,d0
		swap	d0
		subq.w	#$01,d0
		bcs.s	.NoClearBottom

	.ClearBottomStart:
		movem.l	d1/a0-a1,-(sp)					; store source/dest addresses

	.ClearBottom:
		clr.l	(a1)+
		move.l	a1,$0C(sp)					; store end of buffer address
		adda.w	a4,a1						; advance to next tile column
		dbf	d1,.ClearBottom
		movem.l	(sp)+,d1/a0-a1					; reload buffers
		addq.w	#$04,a1						; advance to next row
		dbf	d0,.ClearBottomStart

	.NoClearBottom:

	; =======================

		movem.l	(sp)+,a1-a3					; load end of buffer (and restore sprite table address and default art address)
		dbf	d7,.NextSprite					; repeat for all pieces

	.NoSprites:
		rts							; return

; ===========================================================================
























