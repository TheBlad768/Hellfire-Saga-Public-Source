; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite control subroutine for DDZ boss - Call from sprite rendering routine
; ---------------------------------------------------------------------------

DDZ_SpriteControl:
		movem.l	d0-d6/a0-a5,-(sp)				; store register data

	; --- Intro ---

		bsr.w	DDZ_PentSprites					; render pentagram sprites
		bsr.w	DDZ_EggmanIntro					; rendering the eggman intro sprites

	; --- Phase 1 ---

		cmpi.b	#$01,(RDD_Phase).l				; are we at phase 1?
		bne.s	.NoPhase1					; if not, skip
		bsr.w	DDZ_LaserParticles				; render particles of laser beam
		bsr.w	DDZ_Missiles					; render the missles and explosions
		bsr.w	DDS_MaskVScroll_Bottom				; render V-scroll mask sprites for the bottom only
		bsr.w	DDS_WormBody					; render body sprites of worm
		bsr.w	DDS_MaskVScroll					; render V-scroll mask sprites

	.NoPhase1:
		bsr.w	DDZ_Vortex					; render the vortex when the boss is defeated

		movem.l	(sp)+,d0-d6/a0-a5				; restore register data
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Rendering vortex sprites at end of phase 1
; ---------------------------------------------------------------------------

DDZ_Vortex:
		tst.w	(RDD_ExplodeTimer).l				; is the vortex meant to show yet?
		bne.s	.NoVortex					; if not, skip
		tst.b	(Ctrl_1_locked).w				; have the controls been locked yet?
		beq.s	.NoVortex					; if not, skip

		moveq	#$00,d0						; clear d0
		addq.b	#$01,(RDD_VortexFrame).l			; increase vortex frame
		move.b	(RDD_VortexFrame).l,d0				; load vortex frame ID
		bmi.s	.NoVortex					; if frame is negative (still counting and waiting for kosm)
		cmpi.b	#(7+4)*4,d0					; have we reached the loop frame?
		blo.s	.NoReset					; if not, branch
		moveq	#7*4,d0						; loop

	.NoReset:
		move.b	d0,(RDD_VortexFrame).l				; update frame ID
		lsr.b	#$01,d0						; get only quotient
		andi.w	#-2,d0						; ''
		lea	.MapVr(pc),a1					; load mapping sprite list
		adda.w	(a1,d0.w),a1					; ''
		move.w	(a1)+,d6					; load number of pieces
		bmi.s	.NoVortex					; if there are no pieces, branch
		moveq	#$01,d0						; subtract from pieces left counter
		add.w	d6,d0						; ''
		sub.w	d0,d7						; ''
		bpl.s	.OkayVortex					; if there's no sprite space left, branch
		add.w	d0,d7						; restore sprite count
		rts							; return

	.OkayVortex:
		move.w	#DDZ_BOSS_CENTRE_X,d2				; X position at centre of arena
		sub.w	(Camera_X_pos).w,d2				; ''
		add.w	(Screen_shaking_flag+2).w,d1			; add screenshake to Y position
		move.w	#(224/2)-$20,d1					; Y position at centre of arena
		move.w	#$6000|(VDD_VortexArt/$20),d3			; pattern index address

	.NextPiece:
		move.w	(a1)+,d0					; Y pos
		add.w	d1,d0						; central Y
		move.w	d0,(a6)+					; save to sprite table
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a6)+					; save to sprite table
		addq.w	#$01,a6						; skip link ID
		move.w	(a1)+,d0					; load pattern index
		add.w	d3,d0						; add base
		move.w	d0,(a6)+					; save to sprite table
		move.w	(a1)+,d0					; X pos
		add.w	d2,d0						; central X
		move.w	d0,(a6)+					; save to sprite table
		dbf	d6,.NextPiece					; repeat for remaining pieces

	.NoVortex:
		rts							; return

	.MapVr:	binclude "Levels\DDZ\Code\Data\Phase 1\Vortex\Map.bin"
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Rendering pentagram sprites correctly
; ---------------------------------------------------------------------------

DDZ_PentSprites:
		tst.b	(RDD_PentShow).l				; is the pentagram meant to show?
		bne.s	.YesPentagram					; if so, continue showing
		tst.b	(RDD_CandlesShow).l				; are the candles meant to show either?
		beq.s	.NoCandles					; if not, show nothing
		pea	(a6)			; for candles later	; store sprite table position for now
		lea	$08*5(a6),a6		; for candles later	; skip 5 slots for the candles (they need to be on top of the lines)
		subq.w	#$05,d7			; for candles later	; decrease sprite count by 5
		bra.w	.NoPentagram					; show only the candles now

	.NoCandles:
		rts							; return (show nothing)

	.YesPentagram:
		move.w	(RDD_PentSpeed).l,d0				; load rotation speed
		add.w	d0,(RDD_PentAngle).l				; add to rotation angle

	; --- Palette Cycling ---

		tst.b	(RDD_PentCycDisable).l				; has the palette cycling been disabled? (i.e. are we fading?)
		bne.s	.Delay						; if so, skip cycling
		subq.b	#$01,(RDD_PentCycDelay).l			; decrease delay time
		bcc.s	.Delay						; if not finished, skip
		move.b	#$04,(RDD_PentCycDelay).l			; reset timer
		move.b	(Normal_palette+$7F).w,d0			; load colour
		tst.b	(RDD_PentCycle).l				; check cycle direction
		bgt.s	.YellowUp					; if yellow is to increase, branch
		bmi.s	.BothDown					; if yellow is to decrease, branch
		addq.b	#$02,d0						; increase red
		cmpi.b	#$2E,d0						; have we reached maximum red?
		blo.s	.SaveColour					; if not, branch
		addq.b	#$01,(RDD_PentCycle).l				; set to increase yellow next
		bra.s	.SaveColour					; finish

	.YellowUp:
		addi.b	#$20,d0						; increase green (make it more yellow)
		cmpi.b	#$C0,d0						; has it reached maximum yellow?
		blo.s	.SaveColour					; if not, branch
		st.b	(RDD_PentCycle).l				; set to decrease yellow
		bra.s	.SaveColour					; finish

	.BothDown:
		subi.b	#$22,d0						; decrease green and red (reduce yellow)
		cmpi.b	#$24,d0						; have we reached bottom?
		bhs.s	.SaveColour					; if not, branch
		moveq	#$22,d0						; force to bottom
		sf.b	(RDD_PentCycle).l				; set to increase red again

	.SaveColour:
		move.b	d0,(Normal_palette+$7F).w			; update palette

	.Delay:

	; --- The sprite rendering itself ---

		move.w	#$6000|(VDD_PentArt/$20),d3			; prepare starting pattern index
		move.w	(RDD_PentAngle).l,d5				; load angle
		sf.b	d5						; clear fraction
		moveq	#$05-1,d6					; number of angles for pentagram lines

		pea	(a6)			; for candles later	; store sprite table position for now
		lea	$08*5(a6),a6		; for candles later	; skip 5 slots for the candles (they need to be on top of the lines)
		subq.w	#$05,d7			; fork handles later	; decrease sprite count by 5

	.NextAngle:
		move.w	d5,d0						; load angle
		sf.b	d0						; clear fraction
		addi.w	#DDZ_PENTAGRAM_ROTATE,d5			; rotate to next angle
		move.w	d5,d1						; reload angle
		sf.b	d1						; clear fraction
		sub.w	d0,d1						; get angle in the middle
		asr.w	#$01,d1						; ''
		add.w	d0,d1						; ''
		subi.w	#$4000,d1					; rotate 90 degrees
		sf.b	d1						; clear fraction
		lsr.w	#$08-3,d0					; align quotient to size of sprite element
		lea	Map_Pentagram(pc),a0				; load pentagram mappings
		adda.w	d0,a0						; advance to correct map piece

		lsr.w	#$02,d0						; divide to size of word element
		lsr.w	#$08-1,d1					; ''
		exg.l	d1,d0						; swap angles (need d1 for calculation)
		lea	(SineTable+1).w,a4				; load sinewave table

		; --- Sine Add ---

		move.w	+$7F(a4,d1.w),d2				; load Y
		move.w	-$01(a4,d1.w),d1				; load X
		neg.w	d2						; up is positive
	moveq	#$1E,d4						; distance between pieces (slightly smaller to account for overlap)
		muls.w	d4,d1						; multiply by distance between sprite pieces
		muls.w	d4,d2						; ''
		asl.l	#$08,d1						; send quotient to upper word
		asl.l	#$08,d2						; ''
		move.l	d1,a1						; store as add values
		move.l	d2,a2						; ''

		; --- Sine Pos ---

		move.w	+$7F(a4,d0.w),d2				; load Y
		move.w	-$01(a4,d0.w),d1				; load X
		neg.w	d2						; up is positive
		move.w	(RDD_PentScale).l,d0				; load scale amount radius
		muls.w	d0,d1						; multiply by scale
		muls.w	d0,d2						; ''
		asl.l	#$08,d1						; send quotient to upper word
		asl.l	#$08,d2						; ''

		; Central position

		;addi.l	#((320/2)+$80)<<$10,d1				; add screen's central position
		;addi.l	#((224/2)+$80)<<$10,d2				; ''

		move.l	#DDZ_BOSS_CENTRE_X+$80,d4			; get X position where the pentagram is supposed to show
		sub.w	(Camera_X_pos).w,d4				; minus camera's X position
		swap	d4						; send to quotient area
		add.l	d4,d1						; add screen's central position
		addi.l	#(((224/2)-$20)+$80)<<$10,d2			; ''

		; --- Size of line ---

		move.l	d1,-(sp)		; for candles later	; store first X and Y positions
		move.l	d2,-(sp)		; for candles later	; ''


		moveq	#$00,d4						; clear "last piece" flag (in MSB)
		move.w	d0,d4						; load scale amount radius
		lsr.w	#$04,d4						; divide by 20 (then multiply by 2 (diameter size))
		sub.w	d4,d7						; decrease sprite count
		bpl.s	.ValidCount					; if there's space, branch
		addq.b	#$01,d7						; increase by 1 (due to DBF)
		add.w	d7,d4						; set count to remaining space
		moveq	#-1,d7						; force sprite count to negative (no more space)

	.ValidCount:
		subq.w	#$01,d4						; minus 1 for dbf counter
		bmi.s	.SkipPieces					; if there's no lines left, branch to skip rendering

	; --- The line rendering loop ---
	; Renders a group of sprite lines
	; at the correct angle
	; -------------------------------

	.NextPiece:
		lea	(a0),a4						; load mappings
		move.l	d2,d0						; load Y
		swap	d0						; get only quotient
		add.w	(a4)+,d0					; add Y map
		move.w	d0,(a6)+					; save Y to sprite table
		move.w	(a4)+,d0					; load shape
		move.b	d0,(a6)+					; save shape to sprite table
		addq.w	#$01,a6						; skip link ID
		move.l	d1,d0						; load X position
		move.w	d3,d0						; load base index
		add.w	(a4)+,d0					; add map index
		swap	d0						; get X quotient
		add.w	(a4)+,d0					; add X map
		cmpi.w	#320+$80+$20,d0					; is it on-screen?
		bcs.s	.OnScreen					; if so, branch
		subq.w	#$04,a6						; cancel sprite
		addq.w	#$01,d7						; ''
		bra.s	.OffScreen					; skip over pattern and X

	.OnScreen:
		move.l	d0,(a6)+					; save pattern index and X to sprite table

	.OffScreen:
		add.l	a1,d1						; advance X and Y to next sprite line piece
		add.l	a2,d2						; ''
		dbf	d4,.NextPiece					; repeat for size of line

	; ------------------------------------------------------
	; The last piece makes up the last smaller part of
	; the line, this below will setup the map routine above
	; to run one last time, but positioning the last piece
	; such that it overlaps the previous pieces, thus making
	; the line smaller within the $20 pixel boundary.
	; ------------------------------------------------------

		tst.l	d4						; has the last piece rendered yet?
		bmi.s	.SkipPieces					; if  not, branch
		swap	d3						; store pattern index
		clr.w	d3						; get remaining pixels to render
		sub.w	(RDD_PentScale).l,d3				; ''
		add.w	d3,d3						; multiply by 2 (because scale is radius not diameter)
		andi.w	#$001F,d3					; get within the $20 pixel boundary
		beq.s	.NoEnd						; if the line is exactly a multiple of $20, don't bother with the last piece (not needed)
		subq.w	#$01,d7						; minus 1 extra sprite peice
		bmi.s	.NoEnd						; if there's no sprite space left, branch
		move.l	a1,d0						; load X and Y advancement of $20
		move.l	a2,d4						; ''
		asr.l	#$05,d0						; divide by $20
		asr.l	#$05,d4						; ''

	.MoveBack:
		sub.l	d0,d1						; move piece back up into the line (overlapping previous sprite)
		sub.l	d4,d2						; ''
		dbf	d3,.MoveBack					; repeat until moved up correctly (this loop should be quicker than DIV or MUL)

		move.l	#$80000000,d4					; set dbf count to 0 (one more piece) and set last piece as being rendered
		swap	d3						; get pattern index back
		bra.w	.NextPiece					; render one last piece to finish the line...

	.NoEnd:
		swap	d3						; get pattern index back

	; ------------------------------------------------------

	.SkipPieces:
		move.w	$02(a0),d0					; load shape
		move.b	.ShapePat(pc,d0.w),d0				; load correct number of tiles to advance
		add.w	d0,d3						; advance to next piece's VRAM
		dbf	d6,.NextAngle					; repeat for all lines

	; --- Rendering the candles ---

		lea	(RDD_CandlePos).l,a1
	rept	5
		move.l	(sp)+,(a1)+
		move.l	(sp)+,(a1)+
	endm

	; --- Animating candles ---

	.NoPentagram:
		subq.b	#$01,(RDD_CandleAniDelay).l			; decrease delay timer
		bcc.s	.NoAni						; if not finished, branch
		move.b	#$04,(RDD_CandleAniDelay).l			; reset delay timer
		move.w	(RDD_CandleAni).l,d0				; load animation slot
		addq.w	#$08,d0						; increase slot position
		cmp.w	#9*$08,d0					; has the animation finished?
		bls.s	.Ani						; if not, continue
		moveq	#$00,d0						; reset animation

	.Ani:
		move.w	d0,(RDD_CandleAni).l				; update animation slot

	.NoAni:

		move.w	#$6000|(VDD_CandleArt/$20),d2			; use 4th line as 3rd line is too dark at the moment
		tst.b	(RDD_CandlesShow).l				; is it time to use the 3rd line?  (has the palette brightened up?
		bmi.s	.DarkPal					; if not, branch
		subi.w	#$2000+$8000,d2		; set highplane too	; set to use 3rd line instead (now that it's brighter)

	.DarkPal:
		pea	(a6)						; store end of sprite table
		move.l	$04(sp),a6					; load start of sprite table where high plane candles are
		lea	Map_Candles(pc),a0				; load candle mappings
		adda.w	(RDD_CandleAni).l,a0				; advance to correct frame
		lea	(RDD_CandlePos).l,a1				; load X and Y positions
		bsr.s	.RenderCandles		; INFRONT of pentagram	; render the candles themselves

		move.l	(sp)+,a6					; restore end of sprite table
	;	lea	10*8(a0),a0					; advance to shadow version of candle mappignsrame
	;	lea	(RDD_CandlePos).l,a1				; load X and Y positions
	;	bsr.s	.RenderCandles		; BEHIND pentagram	; render the shadows/glow of the candles

		addq.w	#$04,sp						; restore stack
		rts							; return

	; --- Shape to Pattern add ---
	; Used for advancing the pattern index by the right
	; number of tiles for each line in VRAM
	; ----------------------------

	.ShapePat:
		dc.b	$01,$02,$03,$04
		dc.b	$02,$04,$06,$08
		dc.b	$03,$06,$09,$0C
		dc.b	$04,$08,$0C,$10

	; --- Rendering for the candles ---

	.RenderCandles:
		moveq	#$05-1,d1					; number of candles

	.NextCandle:
		lea	(a0),a4						; reload mappings list
		move.l	(a1)+,d0					; load Y
		swap	d0						; get only quotient
		add.w	(a4)+,d0					; add Y map
		move.w	d0,(a6)+					; save Y to sprite table
		move.w	(a4)+,d0					; load shape
		move.b	d0,(a6)+					; save shape to sprite table
		addq.w	#$01,a6						; skip link ID
		move.l	(a1)+,d0					; load X position
		move.w	d2,d0						; load base index
		add.w	(a4)+,d0					; add map index
		swap	d0						; get X quotient
		add.w	(a4)+,d0					; add X map
		cmpi.w	#320+$80+$20,d0					; is it on-screen?
		bcs.s	.Valid						; if so, branch
		clr.w	-$04(a6)					; force sprite above screen (out the way)

	.Valid:
		move.l	d0,(a6)+					; save pattern index and X to sprite table
		dbf	d1,.NextCandle					; repeat for all candles
		rts							; return

	; --- Map pieces ---
	; Format: YYYY 000S VVVV XXXX
	; ------------------

Map_Pentagram:	incbin	"Data\Intro\Line Maker\Line Map.bin"
Map_Candles:	incbin	"Data\Intro\Candles\Map.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Eggman from the intro
; ---------------------------------------------------------------------------

DDZ_EggmanIntro:
		tst.b	(RDD_EggIntroShow).l				; is intro eggman meant to be showing?
		bne.s	.Show						; if so, branch
		rts							; return (don't show)

	.Show:
		moveq	#$00,d0						; clear d0
		move.b	(RDD_EggIntro_Ani).l,d0				; load animation position
		moveq	#$00,d1						; clear d1

	.RegetFrame:
		move.b	.EggIntAni(pc,d0.w),d1				; load correct frame ID
		bpl.s	.GotFrame					; if it's a frame number, branch
		add.b	d1,d0						; move script back
		bra.s	.RegetFrame					; go back and try again

	.EggIntAni:
		dc.b	0, 0, 1, 1, 1, 2, 3, 3, 4, 4, 4, 5, -12
		even

	.GotFrame:
		subq.b	#$01,(RDD_EggIntro_AniDelay).l			; decrease delay timer
		bcc.s	.NoAni						; if not finished, branch
		move.b	#$05,(RDD_EggIntro_AniDelay).l			; reset delay timer
		addq.b	#$01,d0						; increase animation position

	.NoAni:
		move.b	d0,(RDD_EggIntro_Ani).l				; update animation position
		move.b	d1,(RDD_EggIntro_Frame).l			; update frame ID
		lea	Map_EggIntro(pc),a1				; load map list

	; --- Cover first ---

		movem.l	d1/a1,-(sp)					; store mapping and frame ID
		adda.w	6*2(a1),a1					; load cover mappings directly
		move.w	(RDD_EggIntro_YDest).l,d0			; get distance to move the cover
		sub.w	(RDD_EggIntro_YPos).l,d0			; ''
		beq.s	.NoMove						; if the cover in at destination, branch
		move.w	d0,d1						; store distance
		asr.w	#$04,d0						; divide by 4
		bne.s	.StillMoving					; if movement is still posible at 1/4, branch
		moveq	#$01,d0						; force to move at minimum speed down

	.StillMoving:
		add.w	d0,(RDD_EggIntro_YPos).l			; move cover towards destination

	.NoMove:
		move.l	#DDZ_BOSS_CENTRE_X+$80,d1			; get X position where the pentagram is supposed to show
		sub.w	(Camera_X_pos).w,d1				; minus camera's X position
		move.w	#((224/2)-$10)+$80,d2				; Y central position
		add.w	(RDD_EggIntro_YPos).l,d2			; add Y offset/position for cover
		move.w	#$2000|(VDD_EggCoverIntroArt/$20),d3		; VRAM address
		bsr.w	RenderSpriteMap					; render the sprite frame

	; --- Now the pod/machine ---

		movem.l	(sp)+,d1/a1					; restore mapping and frame ID
		add.w	d1,d1						; multiply frame ID by size of word element
		adda.w	(a1,d1.w),a1					; advance to correct slot
		move.l	#DDZ_BOSS_CENTRE_X+$80,d1			; get X position where the pentagram is supposed to show
		sub.w	(Camera_X_pos).w,d1				; minus camera's X position
		move.w	#((224/2)-$13)+$80,d2				; Y central position
		move.w	#$2000|(VDD_EggIntroArt/$20),d3			; VRAM address
		bra.w	RenderSpriteMap					; render the sprite frame

	; --- Map pieces ---

Map_EggIntro:	incbin	"Data\Intro\Eggman\Map.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render an optimised set of mappings
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a1.l = Mapping list address
; d1.w = X position
; d2.w = Y position
; d3.w = base index
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

RenderSpriteMap:
		move.w	(a1)+,d4					; load sprite count

RenderSpriteMap_Indirect:
		sub.w	d4,d7						; subtract from remaining amount
		bpl.s	.Valid						; if there's space, branch
		addq.b	#$01,d7						; increase by 1 (due to DBF)
		add.w	d7,d4						; set count to remaining space
		moveq	#-1,d7						; force sprite count to negative (no more space)

	.Valid:
		subq.w	#$01,d4						; minus 1 for dbf counter
		bmi.s	.Finish						; if there are no sprites, branch

	.NextPiece:
		move.w	(a1)+,d0					; load Y position
		add.w	d2,d0						; add Y central position
		move.w	d0,(a6)+					; save to sprite table
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a6)+					; save to sprite table
		addq.w	#$01,a6						; skip link ID
		move.w	(a1)+,d0					; load pattern index
		add.w	d3,d0						; add base index
		move.w	d0,(a6)+					; save to sprite tbale
		move.w	(a1)+,d0					; load X position
		add.w	d1,d0						; add X central position
		cmpi.w	#320+$80+$20,d0					; is it off-screen?
		bcs.s	.OnScreen					; if not, branch
		subq.w	#$06,a6						; cancel sprite
		addq.w	#$01,d7						; ''
		dbf	d4,.NextPiece					; repeat for all pieces
		rts							; return

	.OnScreen:
		move.w	d0,(a6)+					; save to sprite table
		dbf	d4,.NextPiece					; repeat for all pieces

	.Finish:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render laser particles
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

DDZ_LaserParticles:
		cmpi.b	#60*2,(RDD_Worm+WmBeamCharge).l			; has timer even started yet?
		bhs.w	.NoParticles					; if not, branch

		moveq	#$01,d0						; load width of worm
		lea	Map_WormHead(pc),a1				; load worm head mappings
		add.b	(a1)+,d0					; ''
		add.w	d0,d0						; multiply by size of word mappings
		move.w	d0,-(sp)					; store width for later
		addq.w	#$01,a1						; skip height (it's height of full set, not just the head)
		mulu.w	#(DDZ_WORM_HEIGHT/8)+(1),d0	;(Y)		; multiply by height (size of entire head mappings)
		addi.w	#($0C*2),d0			;(X)		; advance to beam particle balls
		adda.w	d0,a1						; ''

		move.w	#$E000|(VDD_WormHeadArt/$20),d2			; pattern index base for worm head art
		lea	(SineTable+1).w,a2				; load sinewave table


		move.w	(RDD_Worm+WmDispY).l,d5				; load worm Y position
		sub.w	(Camera_Y_pos).w,d5				; get relative to camera
		addi.w	#$0080+$1E,d5					; get releative to socket
		move.w	(RDD_Worm+WmDispX).l,d4				; load worm X position
		sub.w	(Camera_X_pos).w,d4				; get relative to camera
		addi.w	#$0080-4,d4					; add void space (centre position exact)


	; --- The load loop ---

		moveq	#DDZ_WORMBEAMS_MAXSIZE-1,d6			; number of beams to read through
		lea	(RDD_WormBeams).l,a0				; load beam objects

	.NextBeam:
		tst.b	WbD(a0)						; load distance from centre
		beq.w	.NoBeam						; if distance is 0, skip
		tst.b	WbT(a0)						; is this a charge particle?
		bne.w	.NoBeam						; if not, skip

		; --- Changing distance ---
		; If the charge is finished, the beams balls will
		; fly away, otherwise they'll attract towards
		; -------------------------

		tst.b	(RDD_Worm+WmBeamCharge).l			; has charge reached 0?
		bne.s	.Attract					; if not, continue attracting
		addi.w	#$0100,WbD(a0)					; move beam away
		cmpi.w	#$1000,WbD(a0)					; has beam moved too far away?
		blo.s	.DistNoFinish					; if not,  branch
		clr.w	WbD(a0)						; no distance
		bra.s	.NoBeam						; finish (no beam)

	.Attract:
		move.w	#$1000,d0					; get reverse distance
		sub.w	WbD(a0),d0					; ''
		lsr.w	#$03,d0						; slow it down
		addq.w	#$08,d0						; give some speed
		sub.w	d0,WbD(a0)					; subtract from distance
		bcc.s	.DistNoFinish					; if surpassed 0, branch
		clr.w	WbD(a0)						; force to 0

	.DistNoFinish:

		; --------------------------

		subq.w	#$01,d7						; decrease sprite count
		bpl.s	.Valid						; if there's still space, continue
		addq.w	#$01,d7						; restore count
		bra.s	.NoCharge					; no more space for particles

	.Valid:

		; --- Socket side ---
		; The side of the socket the beam is meant to
		; be on is interlaced, first slot left, second slot
		; right, etc...
		; -------------------

		moveq	#-$1B,d3					; set to go to left socket
		moveq	#-$80,d0					; speed of rotation
		btst.l	#$00,d6						; are we on the left socket?
		beq.s	.Odd						; if so, continue
		neg.w	d0						; reverse direction
		neg.w	d3						; reverse side

	.Odd:
		add.w	d0,WbA(a0)					; rotate beam

		; -------------------

		moveq	#$00,d0						; load angle
		move.b	WbA(a0),d0					; ''
		add.w	d0,d0						; multiply by size of word element
		moveq	#$00,d1						; load distance
		move.b	WbD(a0),d1					; ''
		muls.w	-$01(a2,d0.w),d1				; multiply by sine Y position
		asr.l	#$08,d1						; divide off the sine range
		add.w	d5,d1						; add central Y
		move.w	d1,(a6)+					; save Y position

		sf.b	(a6)+						; set shape (always one tile)
		addq.w	#$01,a6						; skip link ID

		move.b	WbD(a0),d1					; load distance
		subq.b	#$08,d1						; convert from 0 - $10 to -8 - -8
		bmi.s	.Neg						; ''
		neg.b	d1						; ''

	.Neg:
		addq.b	#$08,d1						; convert to 0 - 0 (9 to $10 become 8 to 0)
		cmp.b	#$08,d1						; is it at 8? (only frames 0, 2, 4, and 6 are valid)
		bne.s	.Okay						; if not, valid
		subq.b	#$02,d1						; force to 6

	.Okay:
		andi.w	#$0006,d1					; keep in range (and clear upper byte)
		move.w	(a1,d1.w),d1					; load pattern index address
		add.w	d2,d1						; add base address
		move.w	d1,(a6)+					; save pattern index

		moveq	#$00,d1						; load distance
		move.b	WbD(a0),d1					; ''
		muls.w	+$7F(a2,d0.w),d1				; multiply by sine X position
		asr.l	#$08,d1						; divide off the sine range
		add.w	d1,d3						; add sine X position to side position
		add.w	d4,d3						; get correct socket X position
		move.w	d3,(a6)+					; save X position

	.NoBeam:
		lea	WormBeam_Size(a0),a0				; advance to next beam
		dbf	d6,.NextBeam					; repeat for all slots

	.NoCharge:

; ---------------------------------------------------------------------------
; Spark particles now...
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

		move.w	#(224-$30),d5					; Y position (where the floor is)
		lea	(RDD_HScrollBG).l,a0				; load BG H-scroll table starting from floor
		move.w	d5,d4						; multiply Y position by size of word
		add.w	d4,d4						; ''
		move.w	(a0,d4.w),d4					; load X position
		moveq	#$80-4,d0					; prepare void size (minus half a tile)
		add.w	d0,d5						; add void space
		add.w	d0,d4						; ''
		add.w	(RDD_Worm+WmWidth).l,d4				; advance to centre of boss
		add.w	(Screen_shaking_flag+2).w,d5			; add screen wobble position to Y (seeing as the shaking lifts the FG up/down
	subq.w	#$01,d5						; move up a bit so a pixel of the sparks is ON the surface not IN it
		move.w	(sp)+,d1					; reload width
		cmpi.b	#DDZ_WORM_BEAMMAX,(RDD_Worm+WmBeam).l		; is beam at maximum?
		blt.w	.NoParticles					; if not, skip sparks

	; --- Master sparks ---

		add.w	d1,a1						; advance to spark line
		pea	(a1)						; store for after
		btst.b	#$01,(Level_frame_counter+1).w			; are we on a semi-odd frame?
		beq.s	.MasterFlicker					; if not, use first flicker frame
		addq.w	#$04,d1						; advance to next flicker frame

	.MasterFlicker:
		add.w	d1,a1						; advance to master spark on the floor
		moveq	#$02-1,d0					; number of master particles (two sides)
		moveq	#($1F-8),d3					; move to right side
		add.w	d4,d3						; load X position

	.NextMaster:
		subq.w	#$01,d7						; decrease sprite count
		bpl.s	.ValidMaster					; if there's still space, continue
		addq.w	#$01,d7						; restore count
		addq.w	#$04,sp						; restore stack
		bra.w	.NoParticles					; no more space for particles

	.ValidMaster:
		moveq	#$04,d1						; load Y position and move back to floor directly
		add.w	d5,d1						; ''
		move.w	d1,(a6)+					; set Y position
		move.b	#$04,(a6)+					; set shape
		addq.w	#$01,a6						; skip link
		move.w	(a1),d1						; load correct map frame
		btst.b	#$02,(Level_frame_counter+1).w			; are we on a semi-odd frame?
		beq.s	.MasterMirror					; if not, normal frame
		eori.w	#$0800,d1					; mirror the frame

	.MasterMirror:
		add.w	d2,d1						; add base index address
		move.w	d1,(a6)+					; set index pattern
		move.w	d3,(a6)+					; save X position
		subi.w	#($1F*2)-8,d3					; move to left side for next master spark
		dbf	d0,.NextMaster					; repeat for other side

		move.l	(sp)+,a1					; reload spark mappings

; ---------------------------------------------------------------------------
; The sparks which fly off
; ---------------------------------------------------------------------------

	; --- The load loop ---

		addq.w	#$02,d5						; move sparks down a little (closer to floor)
		moveq	#DDZ_WORMBEAMS_MAXSIZE-1,d6			; number of beams to read through
		lea	(RDD_WormBeams).l,a0				; load beam objects

	.NextSpark:
		tst.b	WbD(a0)						; load distance from centre
		beq.w	.NoSpark					; if distance is 0, skip
		tst.b	WbT(a0)						; is this a spark?
		beq.w	.NoSpark					; if not, skip


		subq.w	#$01,d7						; decrease sprite count
		bpl.s	.ValidSpark					; if there's still space, continue
		addq.w	#$01,d7						; restore count
		bra.w	.NoParticles					; no more space for particles

	.ValidSpark:

		; --- Socket side ---
		; The side of the socket the beam is meant to
		; be on is interlaced, first slot left, second slot
		; right, etc...
		; -------------------

		moveq	#-$1B,d3					; set to go to left socket
		btst.l	#$00,d6						; are we on the left socket?
		beq.s	.OddSpark					; if so, continue
		neg.w	d3						; reverse side

	.OddSpark:

		; -------------------

		moveq	#$00,d0						; load angle
		move.b	WbA(a0),d0					; ''
		add.w	d0,d0						; multiply by size of word element
		moveq	#$00,d1						; load distance
		move.b	WbD(a0),d1					; ''
		muls.w	-$01(a2,d0.w),d1				; multiply by sine Y position
		asr.l	#$08,d1						; divide off the sine range
		add.w	d5,d1						; add central Y
		move.w	d1,(a6)+					; save Y position

		sf.b	(a6)+						; set shape (always one tile)
		addq.w	#$01,a6						; skip link ID

		; --- Angle Frame ---
		; Ensures the right spark frame is used depending on the
		; angle, including mirroring the frame if it's the other
		; side.
		; -------------------

		move.b	WbD(a0),d1					; load distance
		cmpi.b	#$08,d1						; is the spark in the middle of flying off?
		blo.s	.LargeSpark					; if so, branch to use the correct larger spark
		moveq	#$00,d1						; use smaller spark at beginning and end
		bra.s	.SmallSpark					; ''

	.LargeSpark:
		move.b	WbA(a0),d1					; load angle
		addi.w	#$0400,WbA(a0)					; rotate spark right
		btst.l	#$06,d1						; are using the right side?
		bne.s	.RightRot					; if so, keep angle direction
		not.b	d1						; reverse angle direction for left side
		subi.w	#$0400,WbA(a0)					; rotate spark left

	.RightRot:
		andi.w	#$0018,d1					; keep within the spark fly off range
		lsr.b	#$02,d1						; use angle as frame ID
	.SmallSpark:

		addq.w	#$02,d3						; move to right of beam
		move.w	(a1,d1.w),d1					; load correct spark angle frame
		add.w	d2,d1						; add base index
		btst.b	#$06,WbA(a0)					; is the spark on the right side?
		bne.s	.Right						; if so, keep using right art
		eori.w	#$0800,d1					; mirror the particle
		subq.w	#$02+2,d3					; move to left of beam instead

	.Right:
		move.w	d1,(a6)+					; save pattern index

		; ---------------------

		moveq	#$00,d1						; load distance
		move.b	WbD(a0),d1					; ''
		muls.w	+$7F(a2,d0.w),d1				; multiply by sine X position
		asr.l	#$08,d1						; divide off the sine range
		add.w	d1,d3						; add sine X position to side position
		add.w	d4,d3						; get correct socket X position
		move.w	d3,(a6)+					; save X position

		move.w	WbD(a0),d0					; load distance
		addi.w	#$0200,d0					; increase distance
		cmpi.w	#$1000,d0					; has distance reached maximum?
		blo.s	.NoGone						; if not, branch
		moveq	#$00,d0						; set no more spark

	.NoGone:
		move.w	d0,WbD(a0)					; set distance

	.NoSpark:
		lea	WormBeam_Size(a0),a0				; advance to next beam
		dbf	d6,.NextSpark					; repeat for all slots

	.NoParticles:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render the missiles and their explosion graphics
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

DDZ_Missiles:
		lea	(RDD_Missiles).l,a0				; load missile RAM address
		moveq	#DDZ_MISSILE_MAXSIZE-1,d6			; number of slots to check
		moveq	#$07,d5						; load timer
		and.b	(Level_frame_counter+1).w,d5			; ''
		add.w	d5,d5						; multiply by size of word for jump list

	.NextMissile:
		moveq	#$01,d0						; load type
		sub.b	MsT(a0),d0					; ''
		bgt.w	.FinishMissile					; if this slot is not valid, branch
		beq.s	.Missile					; if it's a missile, branch

	; --- explosion from missile ---

	.Explosion:
		move.w	#$0000|(VDD_FlameExpArt/$20),d3			; prepare pattern index
		moveq	#$00,d0						; load frame ID
		move.b	MsF(a0),d0					; ''
		subq.b	#$01,d0						; decrease
		bcs.w	.DeleteSlot					; if finished, delete
		move.b	d0,MsF(a0)					; update frame ID
		andi.w	#-4,d0						; convert frame count from 4 to A
		move.w	d0,d1						; ''
		add.w	d0,d0						; ''
		lsr.w	#$01,d1						; ''
		add.w	d0,d1						; ''
		lea	.Smoke(pc,d1.w),a1				; load correct smoke frame
		bra.w	.Draw						; continue...

	.Smoke:	dc.w	$0001,	$FFF0,$000F,$0034,$FFF0
		dc.w	$0001,	$FFF0,$000F,$0024,$FFF0
		dc.w	$0001,	$FFF0,$000F,$0014,$FFF0
		dc.w	$0001,	$FFF0,$000F,$0004,$FFF0
		dc.w	$0001,	$FFF8,$0005,$0000,$FFF8

	; --- Missile itself ---

	.Missile:
		tst.b	(RDD_Worm+WmHeadMode).l				; check head mode
		bpl.s	.NoEnd						; if not defeated, continue
		move.w	#$0200|(5*4),MsT(a0)				; set as explosion and starting frame
		bra.s	.Explosion					; run as explosion now

	.NoEnd:
		tst.b	MsS(a0)						; is the missile moving upwards?
		bpl.s	.WaitSmoke					; if not, ignore smoke
		subq.b	#$01,MsF(a0)					; decrease smoke loading timer
		bcs.s	.NoSmoke					; if finished, skip
		bne.s	.WaitSmoke					; if timer hasn't finished, wait for it
		bsr.w	DDZ_FindMissileSlot				; find a free slot for the smoke
		bne.s	.NoSmoke					; if there's no slot, skip
		move.w	#$0200|(5*4),MsT(a1)				; set as explosion and starting frame
		move.w	MsX(a0),MsX(a1)					; set X position
		move.w	MsY(a0),MsY(a1)					; set Y position
		addi.w	#$0010,MsY(a1)					; move down a bit to the bottom of the missile

	.NoSmoke:
		sf.b	MsF(a0)						; keep timer at 0 now

	.WaitSmoke:
		move.w	MsS(a0),d0					; load speed
		smi.b	d4						; change frame to dark upwards missiles if negative
		andi.w	#$0010,d4					; ''
		add.w	d5,d4						; ''
		lea	.Map(pc),a1					; load correct frame (up/down)
		move.w	(a1,d4.w),d4					; ''
		lea	(a1,d4.w),a1					; ''
		ext.l	d0						; extend Y speed to long-word
		asl.l	#$08,d0						; align for QQQQ.FFFF
		add.l	d0,MsY(a0)					; add to Y position
		moveq	#-$21,d1					; position above the screen
		cmp.w	MsY(a0),d1					; has it reached the top?
		bmi.s	.NoStop						; if not, continue moving it up
		addq.w	#$01,d1
		move.w	d1,MsY(a0)					; force it to the top
		clr.w	MsS(a0)						; clear Y speed
		moveq	#$3F,d1						; load random number
		and.b	(RNG_seed).w,d1					; ''
		moveq	#$00,d0						; load missile count as position
		move.b	d6,d0						; ''
		lsl.w	#$06,d0						; ''
		add.w	d0,d1						; advance to correct position in level
		divu.w	#DDZ_BOSS_ARENA-$20,d1				; keep in range of arena area
		swap	d1						; get remainder for arena position
		andi.w	#-$10,d1					; snap to nearest block
		add.w	#DDZ_BOSS_CENTRE_X-((DDZ_BOSS_ARENA-$20)/2),d1	; add starting arena position
		move.w	d1,MsX(a0)					; set as X position (random position in stage)
		move.w	d6,d1						; use slot count as timer
		addq.b	#$01,d1						; 0 = 1
		lsl.w	#$06,d1						; multiply to x$40 (less than a second between missiles)
	tst.b	(RDD_Worm+WmInLaserMode).l
	beq.s	.NoLaser
	move.w	d1,d0
	lsr.w	#$02,d0
	sub.w	d0,d1
	subi.w	#$001F,d1

	.NoLaser:
		subi.w	#$10,d1						; reduce time a bit for all missiles


		move.w	d1,MsD(a0)					; set as drop timer

	.NoStop:
		move.w	#$2000|(VDD_MissileArt/$20),d3			; pattern index base address of missiles

	.Draw:
		move.w	MsX(a0),d1					; load X position
		sub.w	(Camera_X_pos).w,d1				; get relative X position from camera
		moveq	#-$80,d2					; prepare void space
		sub.w	d2,d1						; add to X
		sub.w	MsY(a0),d2					; load Y position and add void space
		neg.w	d2						; ''

		bsr.w	.DrawArrow					; draw the arrow (if it needs drawing)
		bsr.w	RenderSpriteMap					; render the missile

	.FinishMissile:
		lea	Ms_Size(a0),a0					; advance to next slot
		dbf	d6,.NextMissile					; repeat for all slots
		rts							; return

	.Map:	binclude "Levels\DDZ\Code\Data\Phase 1\Missiles\Map.bin"

	; --- Drawing aim arrow (if needed) ---

	.DrawArrow:
		tst.b	MsS(a0)						; is the missile moving down?
		bmi.w	.NoArrow					; if not, skip
		cmpi.b	#$01,MsT(a0)					; is this a missile and not smoke?
		bne.w	.NoArrow					; if not, skip smoke
		subq.w	#$01,MsD(a0)					; decrease drop timer
		bcc.s	.NoDrop						; if not finished, branch
		clr.w	MsD(a0)						; keep at 0
		move.w	#$0800,d0					; speed to move down
		cmp.w	MsS(a0),d0					; has the speed already been set?
		beq.s	.NoSFX						; if not, skip SFX
		move.w	d0,MsS(a0)					; force the speed down
		sfx	SDD_MissileDrop					; play missile drop sound

	.NoSFX:
		cmpi.w	#(224-$40),MsY(a0)				; has the missile reached the bottom?
		bmi.s	.NoDrop						; if not, branch
	;	move.w	#$0200|(5*4),MsT(a0)				; change missile to an explosion and set the timer
	;	move.w	#(224-$30),MsY(a0)

		jsr	(Create_New_Sprite).w				; load a free object slot
		bne.s	.NoExplode					; if there's no slot, skip (see no reason not to be)
		move.l	#Obj_DEZExplosion,address(a1)			; set object address
		move.w	MsX(a0),x_pos(a1)				; set X position
		move.w	#(224-$30),y_pos(a1)				; set Y position
		sfx	SDD_MissileExplode				; play missile exploding SFX

	.NoExplode:
		addq.w	#$04,sp						; skip return address
		bra.s	.DeleteSlot					; delete the object and advance to next slot

	.NoDrop:
		cmpi.w	#60,MsD(a0)					; is it 1 second before dropping?
		bgt.s	.NoArrow					; if not, don't show arrow yet
		btst.b	#$02,(Level_frame_counter+1).w			; check frame to flicker on
		beq.s	.NoArrow					; skip on flicker
		subq.w	#$01,d7						; decrease sprite count
		bpl.s	.Arrow						; if not finished, draw the arrow
		addq.w	#$01,d7						; revert count
		bra.s	.NoArrow					; skip arrow

	.Arrow:
		move.w	#(224-$70)+$80,(a6)+				; Y position
		move.b	#$05,(a6)+					; shape
		addq.w	#$01,a6						; skip link
		move.w	#$8000|((VDD_ArrowAim/$20)+8),(a6)+		; pattern index
		move.w	d1,(a6)						; X position
		subq.w	#$08,(a6)+					; (centre the arrow towards missile)

	.NoArrow:
		rts							; return

	; --- Deleting a slot ---

	.DeleteSlot:
		moveq	#$00,d0						; clear d0
		move.w	#(Ms_Size/2)-1,d1				; size of slot

	.Clear:
		move.w	d0,(a0)+					; clear word of slot
		dbf	d1,.Clear					; repeat until slot is clear
		dbf	d6,.NextMissile					; repeat for remaining slots
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render worm body sprite pieces
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

DDS_WormBody:
		tst.b	(RDD_Worm+WmShow).l				; is the worm meant to show?
		bne.s	.Show						; if so, branch
		rts							; return

	.Show:
		moveq	#DDZ_WORMBODY_MAXSIZE-1,d6			; number of possible worm body parts

		lea	(RDD_WormObjects_End-WormObj_Size).l,a0		; load object list from the end
		lea	(RDD_PreRot_Mappings).l,a2			; load sprite mapping list
		addq.w	#$02,a2						; skip segment size (don't need it here)
		move.w	(a2)+,d5					; load angle rate

	.NextObj:
		moveq	#-$80,d2					; prepare void space size
		move.w	ObjX(a0),d1					; load X position
		sub.w	(Camera_X_pos).w,d1				; minus camera X position
		sub.w	d2,d1						; add void space
		move.w	d1,d0						; store a copy
		subi.w	#$0080-$18,d0					; check range on-screen
		cmpi.w	#320+($18*2),d0					; is it off-screen?
		bhi.s	.NoMap						; if so, skip rendering
		sub.w	ObjY(a0),d2					; load Y position and add void space
		neg.w	d2						; ''
		sub.w	(Camera_Y_pos).w,d2				; minus camera Y position
		move.w	d2,d0						; store a copy
		subi.w	#$0080-$18,d0					; check range on-screen
		cmpi.w	#224+($18*2),d0					; is it off-screen?
		bhi.s	.NoMap						; if so, skip rendering

		moveq	#$02,d4						; two pieces
		sub.w	d4,d7						; subtract from remaining amount
		bpl.s	.ValidMap					; if there's space, branch
		addq.b	#$01,d7						; increase by 1 (due to DBF)
		add.w	d7,d4						; set count to remaining space
		moveq	#-1,d7						; force sprite count to negative (no more space)

	.ValidMap:
		subq.w	#$01,d4						; minus 1 for dbf counter
		bmi.s	.Finish						; if there are no sprites, branch

		moveq	#$40,d3						; load angle (and rotate 90 degrees)
		add.b	ObjAngleDraw(a0),d3				; ''
		divu.w	d5,d3						; divide by angle rate to get frame number
		lsl.w	#$04,d3						; multiply by $10 (size of two sprite pieces in the list)
		lea	(a2,d3.w),a1					; advance to correct slot

	.NextMap:
		move.w	(a1)+,d0					; load Y position
		add.w	d2,d0						; move to centre of object
		move.w	d0,(a6)+					; save to sprite table
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a6)+					; save to sprite table
		addq.w	#$01,a6						; skip link ID
		move.l	(a1)+,d0					; load VRAM and X position
		add.w	d1,d0						; move to centre of object
		move.l	d0,(a6)+					; save to sprite table
		dbf	d4,.NextMap					; repeat for second piece

	.NoMap:
		lea	-WormObj_Size(a0),a0				; advance to next slot
		dbf	d6,.NextObj					; repeat for all body parts

	.Finish:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render sprites of level tiles on the far left for -1 bug
; BOTTOM FLOOR INFRONT OF BODY
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

DDS_MaskVScroll_Bottom:
		tst.w	d7						; are there any sprite slots left?
		bmi.w	.NoSlice					; if not, finish...

		tst.b	(RDD_SliceVScroll).l				; are we using sliced V-scroll mode?
		beq.w	.NoSlice					; if not, branch
		tst.b	(RDD_SlicePriority).l				; does FG have priority over the -1 slice?
		beq.w	.NoSlice					; if not, skip fix

		lea	(RDD_HScrollFG+((224-(($20+4+3)-1))*2)).l,a1	; load scroll table (from bottom of screen)
		lea	DDZ_VSF_Patterns(pc),a2				; load pattern index list

		moveq	#$0C,d2						; prepare pattern Y slot
		move.w	#$0081+(224-$30),d3				; starting Y position of sprites


		moveq	#$05,d4						; shape to use
		bsr.w	DDS_MaskVScroll.WriteSprite_Left		; write the sprite
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip
		moveq	#$05,d4						; shape to use
		bsr.w	DDS_MaskVScroll.WriteSprite_Right		; write a copy to the right
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip
		addi.w	#2*8,d3						; move Y position down for next sprite
		lea	2*8*2(a1),a1					; advance to next scroll position for next sprite
		moveq	#$07,d4						; shape to use
		bsr.w	DDS_MaskVScroll.WriteSprite			; write the sprite

	.NoSlice:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render sprites of level tiles on the far left for -1 bug
; TOP BG BEHIND BODY
; --- input -----------------------------------------------------------------
; d7.w = remaining sprites left
; a6.l = sprite table buffer
; ---------------------------------------------------------------------------

DDS_MaskVScroll:
		tst.w	d7						; are there any sprite slots left?
		bmi.w	.NoSlice					; if not, finish...

		tst.b	(RDD_SliceVScroll).l				; are we using sliced V-scroll mode?
		beq.w	.NoSlice					; if not, branch
		tst.b	(RDD_SlicePriority).l				; does FG have priority over the -1 slice?
		beq.w	.NoSlice					; if not, skip fix

		lea	(RDD_HScrollFG).l,a1				; load scroll table
		lea	DDZ_VSF_Patterns(pc),a2				; load pattern index list

		moveq	#$00,d2						; prepare pattern Y slot
		move.w	#$0081,d3					; starting Y position of sprites



		moveq	#$00,d5						; clear upper word
		move.w	(RDD_Worm+WmDispY).l,d5				; load worm Y position
		sub.w	(Camera_Y_pos).w,d5				; minus camera Y position

		moveq	#$07,d4						; shape to use
		bsr.w	.WriteSprite					; write the sprite
		beq.s	.HP0						; if the sprite wasn't drawn, skip
		cmpi.w	#$0040,d5					; is the worm low enough that the FG high plane is visible?
		blt.s	.HP0						; if not, ignore
		ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP0:	addi.w	#4*8,d3						; move Y position down for next sprite
		lea	4*8*2(a1),a1					; advance to next scroll position for next sprite
	addq.w	#$02,a1
		subq.w	#$01,d7						; decrease sprite count
		bmi.w	.NoSlice					; if finished, skip

		moveq	#$07,d4						; shape to use
		bsr.w	.WriteSprite					; write the sprite
		beq.s	.HP1						; if the sprite wasn't drawn, skip
		cmpi.w	#$0060,d5					; is the worm low enough that the FG high plane is visible?
		blt.s	.HP1						; if not, ignore
		ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP1:	addi.w	#4*8,d3						; move Y position down for next sprite
		lea	4*8*2(a1),a1					; advance to next scroll position for next sprite
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip

		moveq	#$07,d4						; shape to use
		bsr.w	.WriteSprite					; write the sprite
		beq.s	.HP2						; if the sprite wasn't drawn, skip
		cmpi.w	#$FFD8,d5					; is the worm low enough that the FG high plane is visible?
		ble.s	.LP2						; if not, ignore
		cmpi.w	#$0080,d5					; is the worm low enough that the FG high plane is visible?
		blt.s	.HP2						; if not, ignore
	.LP2:	ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP2:	addi.w	#4*8,d3						; move Y position down for next sprite
		lea	4*8*2(a1),a1					; advance to next scroll position for next sprite
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip

		moveq	#$07,d4						; shape to use
		bsr.w	.WriteSprite					; write the sprite
		beq.s	.HP3						; if the sprite wasn't drawn, skip
		cmpi.w	#$00A0,d5					; is the worm low enough that the FG high plane is visible?
		bge.s	.LP3						; if not, ignore
		cmpi.w	#$FFF8,d5					; is the worm low enough that the FG high plane is visible?
		bgt.s	.HP3						; if not, ignore
	.LP3:	ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP3:	addi.w	#4*8,d3						; move Y position down for next sprite
		lea	4*8*2(a1),a1					; advance to next scroll position for next sprite
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip

		moveq	#$05,d4						; shape to use
		bsr.w	.WriteSprite					; write the sprite
		beq.s	.HP4						; if the sprite wasn't drawn, skip
		cmpi.w	#$00C0,d5					; is the worm low enough that the FG high plane is visible?
		bge.s	.LP4						; if not, ignore
		cmpi.w	#$0008,d5					; is the worm low enough that the FG high plane is visible?
		bgt.s	.HP4						; if not, ignore
	.LP4:	ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP4:	addi.w	#2*8,d3						; move Y position down for next sprite
		lea	4*8*2(a1),a1					; advance to next scroll position for next sprite
		tst.w	d7						; check remaining sprite slots
		bmi.w	.NoSlice					; if finished, skip

		moveq	#$07,d4						; shape to use
		bsr.s	.WriteSprite					; write the sprite
		beq.s	.HP5						; if the sprite wasn't drawn, skip
		cmpi.w	#$00C0,d5					; is the worm low enough that the FG high plane is visible?
		bge.s	.LP5						; if not, ignore
		cmpi.w	#$0028,d5					; is the worm low enough that the FG high plane is visible?
		bgt.s	.HP5						; if not, ignore
	.LP5:	ori.b	#$80,-$04(a6)					; force the sprite higher
	.HP5:	addi.w	#4*8,d3						; move Y position down for next sprite
	;	lea	2*8*2(a1),a1					; advance to next scroll position for next sprite
		addi.w	#((4*8)-1)*2,a1					; get scroll position at bottom of block instead
;		tst.w	d7						; check remaining sprite slots
;		bmi.s	.NoSlice					; if finished, skip

;		moveq	#$05,d4						; shape to use
;		bsr.s	.WriteSprite_Left				; write the sprite
;		tst.w	d7						; check remaining sprite slots
;		bmi.w	.NoSlice					; if finished, skip
;		moveq	#$05,d4						; shape to use
;		bsr.s	.WriteSprite_Right				; write a copy to the right
;		addi.w	#2*8,d3						; move Y position down for next sprite
;		lea	2*8*2(a1),a1					; advance to next scroll position for next sprite
;		tst.w	d7						; check remaining sprite slots
;		bmi.w	.NoSlice					; if finished, skip
;
;		moveq	#$07,d4						; shape to use
;	;	bsr.s	.WriteSprite					; write the sprite
;	bsr.s	.WriteSprite_Left				; write the sprite
;	tst.w	d7						; check remaining sprite slots
;	bmi.w	.NoSlice					; if finished, skip
;	moveq	#$07,d4						; shape to use
;	bsr.s	.WriteSprite_Right				; write a copy to the right




	;	tst.w	d7						; check remaining sprite slots
	;	bmi.w	.NoSlice					; if finished, skip
	;	addi.w	#4*8,d3						; move Y position down for next sprite
	;	lea	4*8*2(a1),a1					; advance to next scroll position for next sprite

	.NoSlice:
		rts


	.WriteSprite_Left:
		lea	(a2),a0						; load pattern index list
		move.w	(a0)+,d0					; load starting position
		sub.w	(a1),d0						; get exact position of block
		moveq	#$0F,d1						; get within block
		and.w	d0,d1						; are we at an exact block position?
		bra.s	.NoEx

	.WriteSprite_Right:
	subq.w	#$02,d2						; go back up again
		lea	(a2),a0						; load pattern index list
		move.w	(a0)+,d0					; load starting position
		sub.w	(a1),d0						; get exact position of block
		moveq	#$0F,d1						; get within block
		and.w	d0,d1						; are we at an exact block position?
		subi.w	#$10,d1
		addi.w	#$10,d0
		andi.w	#$0030,d0					; wrap within range
		lsr.w	#$03,d0						; divide by $10 (size of block) then multiply by 2 (element jump table size)
		adda.w	(a0,d0.w),a0					; advance to pattern list
		adda.w	d2,a0						; advance to correct slot
		move.w	d3,(a6)+					; set Y position
		move.w	(a0)+,d0					; load pattern index
		bra.s	.NoNext

	.WriteSprite:
		lea	(a2),a0						; load pattern index list
		move.w	(a0)+,d0					; load starting position
		sub.w	(a1),d0						; get exact position of block
		moveq	#$0F,d1						; get within block
		and.w	d0,d1						; are we at an exact block position?
		beq.s	.Exact						; if so, skip this one (no need to render)
	.NoEx:	andi.w	#$0030,d0					; wrap within range
		lsr.w	#$03,d0						; divide by $10 (size of block) then multiply by 2 (element jump table size)
		adda.w	(a0,d0.w),a0					; advance to pattern list
		adda.w	d2,a0						; advance to correct slot

		move.w	d3,(a6)+					; set Y position
		move.w	(a0)+,d0					; load pattern index
		bclr.l	#$03,d1						; are we halfway to display a single tile?
		beq.s	.NoNext						; if not, skip correction
		add.b	.PattChange(pc,d4.w),d0				; advance pattern index forwards
		move.b	.ShapeSwap(pc,d4.w),d4				; change sprite to thinner version
		bra.s	.NoNext						; continue

	.PattChange:	dc.b	$00,$00,$00,$00,$01,$02,$03,$04
	.ShapeSwap:	dc.b	$00,$01,$02,$03,$00,$01,$02,$03

	.NoNext:
		move.b	d4,(a6)+					; save shape
		addq.w	#$01,a6						; skip link ID
		move.w	d0,(a6)+					; save pattern index
		neg.w	d1						; reverse into left boarder
		addi.w	#$0080,d1					; advance to left of screen
		move.w	d1,(a6)+					; save X position
		subq.w	#$01,d7						; decrease sprite count
		moveq	#$01,d1						; force block position return to be non-0

	.Exact:
		addq.w	#$02,d2						; advance to next pattern Y slot
		tst.w	d1						; recheck exact block position (for return)
		rts							; return


	; DDZ_VSF_Patterns:

		include	"../FixVSprites.asm"

; ===========================================================================

















