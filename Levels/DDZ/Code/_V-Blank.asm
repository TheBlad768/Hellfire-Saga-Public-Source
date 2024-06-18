; ===========================================================================
; ---------------------------------------------------------------------------
; V-blank specialised for DDZ - MarkeyJester
; ---------------------------------------------------------------------------

VBlank_DDZ:

	; --- Normal/standard Sonic 1 crap ---
	; can't make a carbon copy and modify faster, there's too much dependencies
	; if they change it there, it'd need changing here too, and it's a pain...
	; ------------------------------------

		movem.l	d0-a6,-(sp)					; store register contents
		tst.b	(V_int_routine).w				; is the 68k ready for V-blank?
		beq.w	.Late68k					; if not, branch
		sf.b	(V_int_routine).w				; set V-blank as now ran
		stopZ80
		jsr	Poll_Controllers				; obtain controller data
		startZ80

		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		move.w	#$8F04,(a6)					; set increment to skip a word
		tst.b	(SwapHScroll).w					; is H-scroll swapped?
		beq.s	.NormalHScroll					; if not, skip
		DMA	$01C0, VRAM, vram_hscroll+2, RDD_HScrollFG	; transfer H-scroll FG
		DMA	$01C0, VRAM, vram_hscroll,   RDD_HScrollBG	; transfer H-scroll BG
		bra.s	.SwappedHScroll

	.NormalHScroll:
		DMA	$01C0, VRAM, vram_hscroll,   RDD_HScrollFG	; transfer H-scroll FG
		DMA	$01C0, VRAM, vram_hscroll+2, RDD_HScrollBG	; transfer H-scroll BG

	.SwappedHScroll:
		move.w	#$8F02,(a6)					; restore increment mode




		cmpi.b	#$06,(Player_1+obRoutine).w			; MJ: is Sonic dying/dead?
		blo.w	.NoDied						; MJ: if not, resume
		tst.b	(YouDiedY).w					; MJ: has the Y "You died" position been set already?
		bne.s	.NoDied						; MJ: if so, don't set it again....
		move.b	#$01,(YouDiedY).w				; MJ: start the "You died" sprites off

	.NoDied:
		tst.b	(YouDiedY).w					; MJ: is the "You Died" text screen meant to show?
		bne.s	.DoPause					; MJ: if so, run special sprites
		tst.b	(Game_paused).w					; MJ: is the game paused?
		beq.s	.NoPause					; MJ: if not, skip
		tst.b	(PauseHideDebug).w				; MJ: is the pause menu allowed to show?
		bne.s	.NoPause					; MJ: if not, skip and render sprites normally

	.DoPause:
		move.l	#$8000|ArtTile_Pause|(vram_sprites<<$10),d6	; MJ: pattern index where pause menu sprites are
		move.l	#$40000000|vdpCommDelta(vram_sprites),d4	; MJ: VRAM address where sprites are
		jsr	VB_SpritesPause					; MJ: transfer sprites with pause sprites first
		bra.s	.YesPause					; MJ: skip over DMA

	.NoPause:
		DMA	$0280, VRAM, vram_sprites, Sprite_table_buffer	; transfer sprites

	.YesPause:



		DMA	$0080, CRAM, $0000, Normal_palette		; transfer palette

		bsr.w	PentagramDPLC					; transfer pentagram art if needed
		bsr.w	EggmanIntroDPLC					; transfer eggman on the intro
		bsr.w	WormHeadMap					; handle worm head mappings rendering

		jsr	Process_DMA_Queue				; run DMA queue
		tst.b	(RDD_NoLevelDraw).l				; is level drawing meant to be ignored?
		bne.s	.SkipDraw					; if so, skip...
		jsr	ScrollDraw_VInt					; transfer level tile strips

	.SkipDraw:
		jsr	(UpdateHUD).w					; let the hud art update
		subq.w	#$04,sp						; move stack back for kosinski routine
		jsr	Set_Kos_Bookmark				; setup kos to resume on return it were interrupted mid-way
		addq.w	#$04,sp						; restore stack
		st.b	(Lag_frame_count).w				; reset lag count

	.Late68k:
		addq.b	#$01,(Lag_frame_count).w			; increase lag count

	.Cont68k:
		jsr	dFractalExtra					; update extra functions
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; update Fractal
		jsr	Random_Number					; mix random number up more
		addq.l	#$01,(V_int_run_count).w			; increase frame count

	; --- Setting up for H-blank ---

		tst.b	(SwapPlanes).w					; MJ: haveplanes been requested to swap?
		bpl.s	.NoSwap						; MJ: if not, continue
		move.b	#$7F,(SwapPlanes).w				; MJ: clear flag
		move.w	#$8200+(vram_bg>>10),($C00004).l		; MJ: swap BG and FG planes
		move.w	#$8400+(vram_fg>>13),($C00004).l		; MJ: ''

	.NoSwap:
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port

		; Might be quicker to manually transfer...
		move.w	#$8B00|%00000011,d4				; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		tst.b	(RDD_SliceVScroll).l				; are we using sliced V-scroll mode?
		beq.w	.NoSlice					; if not, branch
		ori.b	#%00000100,d4					; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		move.w	#$8F04,(a6)					; set increment to skip a word
		tst.b	(RDD_SlicePriority).l				; does FG have priority over the -1 slice?
		bne.s	.SliceBG					; if not, skip fix
		move.w	(RDD_VScrollFG+$26).l,(RDD_VScrollBG+$26).l	; FG reads from BG on this slot

	.SliceBG:
		tst.b	(SwapVScroll).w					; MJ: are they swapped?
		beq.s	.NoSwapVSlice					; MJ: if not, branch

		DMA	$0028, VSRAM, $0000, RDD_VScrollBG		; transfer V-scroll BG
		DMA	$0028, VSRAM, $0002, RDD_VScrollFG		; transfer V-scroll FG
		move.w	#$8F02,(a6)					; restore increment mode
		bra.s	.Slice

	.NoSwapVSlice:
		DMA	$0028, VSRAM, $0000, RDD_VScrollFG		; transfer V-scroll FG
		DMA	$0028, VSRAM, $0002, RDD_VScrollBG		; transfer V-scroll BG
		move.w	#$8F02,(a6)					; restore increment mode
		bra.s	.Slice

	.NoSlice:
		move.l	#$40000010,(a6)					; set VDP to VSRAM write mode
		move.l	(V_scroll_value).w,d0				; load V-scroll positions

		tst.b	(SwapVScroll).w					; are they swapped?
		beq.s	.NoSwp						; if not, branch
		swap	d0						; swap FG and BG
	.NoSwp:	move.l	d0,(a5)						; write V-scroll positions

	.Slice:
		move.w	d4,(a6)						; set V-scroll mode

		movem.l	(sp)+,d0-a6					; restore register data
NullRTE:	rte							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer the pentagram line art correctly
; ---------------------------------------------------------------------------

PentagramDPLC:
		move.w	(RDD_PentAngle).l,d5				; load angle
		sf.b	d5						; clear fraction
		cmp.w	(RDD_PentAngPrev).l,d5				; check if only the quotient has changed
		beq.s	.NoArt						; if not, don't update the art
		move.w	d5,(RDD_PentAngPrev).l				; update previous angle
		moveq	#$05-1,d4					; number of angles for pentagram lines
		move.l	#ArtUnc_Pentagram/2,d2				; load source art address
		move.l	#$40200000|VDD_PentArt,d3			; starting VRAM address

	.NextAngle:
		move.w	d5,d1						; load angle
		addi.w	#DDZ_PENTAGRAM_ROTATE,d5			; rotate to next angle
		sf.b	d1						; clear fraction
		lsr.w	#$08-2,d1					; align quotient to size of long-word element
		lea	Plc_Pentagram(pc,d1.w),a1			; load pentagram PLC slot/entry
		lea	(R_VDP97).w,a2					; reload DMA list
		moveq	#$00,d1						; clear d1
		move.w	(a1)+,d1					; load tile address
		add.l	d2,d1						; add source art address
		movep.l	d1,-$01(a2)					; save DMA source
		move.w	(a2)+,(a6)					; ''
		move.l	(a2)+,(a6)					; ''
		move.w	(a1)+,d1					; load size
		movep.w	d1,+$01(a2)					; save DMA size
		move.l	(a2)+,(a6)					; ''
		move.l	d3,d0						; load VRAM address
		add.w	d1,d3						; advance to next VRAM slot
		add.w	d1,d3						; ''
		rol.l	#$02,d0						; correct address for VDP port
		ror.w	#$02,d0						; ''
		move.w	d0,(a6)						; set DMA destination
		swap	d0						; get second word
		move.w	d0,(a2)						; set from 68k RAM
		move.w	(a2),(a6)					; ''
		dbf	d4,.NextAngle					; repeat for all angles

	.NoArt:
		rts							; return

	; --- PLC pieces ---
	; Format: SSSS VVVV	(Size / 2) | (Relative VRAM / 2)
	; ------------------

Plc_Pentagram:	incbin	"Data\Intro\Line Maker\Line Plc.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer art for Eggman on the intro
; ---------------------------------------------------------------------------

EggmanIntroDPLC:
		moveq	#$00,d0						; clear d0
		move.b	(RDD_EggIntro_Frame).l,d0			; load frame ID
		cmp.b	(RDD_EggIntro_Prev).l,d0			; has it changed?
		beq.s	.NoUpdate					; if not, branch
		move.b	d0,(RDD_EggIntro_Prev).l			; update
		add.w	d0,d0						; multiply by size of word
		lea	Plc_EggIntro(pc),a1				; load PLC list
		adda.w	(a1,d0.w),a1					; advance to correct PLC frame
		move.l	#ArtUnc_EggmanIntro/2,d2			; set source art address
		move.l	#$40200000|VDD_EggIntroArt,d3			; set VRAM address to dump to
		bsr.s	TransferDPLC					; perform the transfer

	.NoUpdate:
		rts							; return

Plc_EggIntro:	incbin	"Data\Intro\Eggman\Plc.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; DPLC Transfer subroutine
; --- input -----------------------------------------------------------------
; d2.l = source art address divided by 2
; d3.l = VRAM address (with OR $40200000)
; a1.l = PLC address
; a6.l = VDP control port
; ---------------------------------------------------------------------------

TransferDPLC:
		move.w	(a1)+,d4					; load number of entries
		bmi.s	.NoEntries					; if there are no entries, branch

	.NextEntry:
		lea	(R_VDP97).w,a2					; reload DMA list
		moveq	#$00,d1						; clear d1
		move.w	(a1)+,d1					; load tile address
		add.l	d2,d1						; add source art address
		movep.l	d1,-$01(a2)					; save DMA source
		move.w	(a2)+,(a6)					; ''
		move.l	(a2)+,(a6)					; ''
		move.w	(a1)+,d1					; load size
		movep.w	d1,+$01(a2)					; save DMA size
		move.l	(a2)+,(a6)					; ''
		move.l	d3,d0						; load VRAM address
		add.w	d1,d3						; advance to next VRAM slot
		add.w	d1,d3						; ''
		rol.l	#$02,d0						; correct address for VDP port
		ror.w	#$02,d0						; ''
		move.w	d0,(a6)						; set DMA destination
		swap	d0						; get second word
		move.w	d0,(a2)						; set from 68k RAM
		move.w	(a2),(a6)					; ''
		dbf	d4,.NextEntry					; repeat for all entries

	.NoEntries:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render the worm head elements correctly on the plane
; ---------------------------------------------------------------------------

WormHeadMap:
		tst.b	(RDD_Worm+WmShow).l				; is the worm meant to show?
		beq.w	.NoWorm						; if not, skip
		tst.b	(Game_paused).w					; is the game paused?
		bne.w	.Display					; if so, just display

		tst.b	(RDD_Worm+WmBeamOn).l				; is the beam on?
		beq.w	.Off						; if not, branch
		move.b	(RDD_Worm+WmFrame).l,d0				; load frame
		addq.b	#$01,d0						; increase frame
		cmpi.b	#$04,d0						; have we reached maximum?
		blo.s	.OnCharge					; if not, branch
		subq.b	#$01,(RDD_Worm+WmBeamCharge).l			; decrease charge timer
		bcs.s	.Finish						; if finished, break...

		moveq	#$03,d1						; get within 4 frames
		and.b	(RDD_Worm+WmBeamCharge).l,d1			; has it been 4 frames?
		bne.w	.Display					; if not, skip particle
		bsr.w	WHM_LoadParticle				; load a beam particle
		bra.w	.Display					; continue display...

	.Finish:
		sf.b	(RDD_Worm+WmBeamCharge).l			; keep timer at finish
		move.b	(RDD_Worm+WmBeam).l,d1				; load beam height
		cmpi.b	#DDZ_WORM_BEAMMAX,d1				; is beam at maximum?
		blt.s	.NoFinishSparks					; if not, ignore sparks
		bsr.w	WHM_LoadSpark					; load a spark particle
		bra.s	.Display					; display the boss

	.NoFinishSparks:
		addq.b	#$01,d1						; increase beam length by 1
		cmpi.b	#DDZ_WORM_BEAMMAX,d1				; have we JUST reached maximum now?
		bne.s	.NoWobble					; if not, branch
		move.b	#$10,(ScreenWobble).w				; set screen to shake a bit from the impact
		move.w	d0,d2						; ...
		sfx	SDD_LaserHit					; play laser hit SFX
		move.w	d2,d0						; ...

	.NoWobble:
		move.b	d1,(RDD_Worm+WmBeam).l				; update beam height
		cmpi.b	#$04,d0						; is the frame at maximum beam?
		bne.s	.Display					; if not, don't update socket art
		bra.s	.SaveFrame

	.OnCharge:
		moveq	#$07,d1						; delay charge time by 8 frames
		and.b	(Level_frame_counter+1).w,d1			; ''
		bne.s	.Display					; ''

	.SaveFrame:
		move.b	d0,(RDD_Worm+WmFrame).l				; update frame
		bra.s	.Display					; updated... now time to display...

	.Off:
		move.b	#60*2,(RDD_Worm+WmBeamCharge).l			; reset beam timer
		move.b	(RDD_Worm+WmBeam).l,d0				; load beam height
		subq.b	#$01,d0						; decrease height
		bgt.s	.OffCharge					; if not finished, branch
		sf.b	(RDD_Worm+WmBeam).l				; force beam off
		move.b	(RDD_Worm+WmFrame).l,d1				; load socket frame
		subq.b	#$01,d1						; decrease frame
		bcs.s	.Display					; if finished, branch
		move.b	d1,(RDD_Worm+WmFrame).l				; update frame
		bra.s	.Display					; continue with rendering

	.OffCharge:
		move.b	d0,(RDD_Worm+WmBeam).l				; update beam height

	.Display:

	; --- Cover first ---

		moveq	#$01,d3						; load width of worm
		lea	Map_WormHead(pc),a1				; load worm head mappings
		add.b	(a1)+,d3					; ''
		add.w	d3,d3						; multiply by size of word mappings
		move.w	d3,d0						; keep a copy for later
		addq.w	#$01,a1						; skip height (it's height of full set, not just the head)
		mulu.w	#(DDZ_WORM_HEIGHT/8),d0				; multiply by height (size of entire head mappings)
		adda.w	d0,a1						; advance to worm covers
		pea	(a1)						; store address for beams later
		subq.w	#4*2,d3						; minus width of cover (for advancement)
		move.w	#$E000|(VDD_WormHeadArt/$20),d4			; prepare base index
		move.l	#($610C0003+(DDZ_WORM_PLANEPOS<<$10))&$6FFE0003,d5 ; prepare VRAM plane address of boss worm head mappings
		move.b	(Level_frame_counter+1).w,d0			; oad timer
		move.b	d0,d1						; load every 16th frame to the odd frame too
		lsr.b	#$04,d1						; '' (this will allow the frames to alternate on 30fps videos like on YouTube)
		add.b	d1,d0						; '' (since the normal blur effect won't be seen in that circumstance)
		btst.l	#$00,d0						; is this an odd frame?
		beq.s	.Even						; if not, stay on this frame/art
		addq.w	#4*2,a1						; advance to next cover frame/art

	.Even:
		moveq	#$06-1,d2					; height of cover itself

	.CoverY:
		move.l	d5,(a6)						; set VDP write address
		addi.l	#$00800000,d5					; advance to next row
		andi.l	#$6FFE0003,d5					; keep in the plane area
		rept	4
		move.w	(a1)+,d0					; load tile map
		add.w	d4,d0						; add base index
		move.w	d0,(a5)						; save to plane
		endm
		add.w	d3,a1						; advance to next row
		dbf	d2,.CoverY					; repeat for all rows

	; --- Socket ---

		move.l	(sp),a1						; reload worm cover address
		lea	8*2(a1),a1					; advance to socket mappings
		moveq	#$00,d0						; load frame
		move.b	(RDD_Worm+WmFrame).l,d0				; ''
		cmp.b	(RDD_Worm+WmFramePrev).l,d0			; has it changed?
		beq.s	.NoSocket					; if not, branch
		move.b	d0,(RDD_Worm+WmFramePrev).l			; update previous frame
		move.w	d3,d1						; load row width in mappings
		addq.w	#4*2,d1						; restore entire width
		add.w	d1,d1						; multiply by 2 (2 rows)
		mulu.w	d0,d1						; multiply frame number by width
		adda.w	d1,a1						; advance to correct row/frame
		move.l	#($64080003+(DDZ_WORM_PLANEPOS<<$10))&$6FFE0003,d5 ; starting VRAM address (left socket)
		moveq	#$02-1,d2					; number of rows for the socket

	.NextSocketY:
		move.l	d5,(a6)						; set VRAM address (left socket)
		rept	2
		move.w	(a1)+,d0					; load tile map
		add.w	d4,d0						; add base index
		move.w	d0,(a5)						; save to plane
		endm
		move.l	d5,d0						; load VRAM address
		addi.l	#$000C0000,d0					; advance to right socket
		move.l	d0,(a6)						; set VRAM address (right socket)
		rept	2
		move.w	(a1)+,d0					; load tile map
		add.w	d4,d0						; add base index
		move.w	d0,(a5)						; save to plane
		endm
		add.w	d3,a1						; advance to next map tile data row
		addi.l	#$00800000,d5					; advance to next plane row
		andi.l	#$6FFE0003,d5					; keep in the plane area
		dbf	d2,.NextSocketY					; repeat for socket rows of art

	.NoSocket:

	; --- Beams ---

		move.l	(sp)+,a1					; reload worm cover address
		lea	$0C*2(a1),a1					; advance to beam mappings
		moveq	#$00,d2						; load height
		move.b	(RDD_Worm+WmBeam).l,d2				; ''
;	move.b	(RDD_MaskBeam).l,d1
;	cmp.b	(RDD_MaskBeamPrev).l,d1
;	bne.s	.YesBeam
;
;	.NoBeamCheck:
		cmp.b	(RDD_Worm+WmBeamPrev).l,d2			; has it changed?
		beq.s	.NoBeam						; if not, branch
;		move.b	#$7E,(RDD_MaskBeamPrev).l			; force mask to update
;
;	.YesBeam:
		move.b	d2,(RDD_Worm+WmBeamPrev).l			; update height

		move.w	d4,d1						; put a copy of base index in the top word too
		swap	d4						; ''
		move.w	d1,d4						; ''

		moveq	#DDZ_WORM_BEAMMAX,d3				; maximum height
		sub.b	d2,d3						; get difference
		bcc.s	.NoCap						; if the beam is not too large, branch
		add.b	d3,d2						; correct the height
		moveq	#$00,d3						; set no remaining height

	.NoCap:
		move.l	#($65080003+(DDZ_WORM_PLANEPOS<<$10))&$6FFE0003,d5 ; starting VRAM address (left beam)
		move.l	(a1)+,d1					; load beam mappings
		add.l	d4,d1						; add base index
		subq.w	#$01,d2						; minus 1 for head
		bcs.s	.NoBeamHead					; if there's no beam at all, branch
		bsr.s	.DrawBeam					; jump into the loop
		move.l	(a1),d1						; load beam head
		add.l	d4,d1						; add base index
		moveq	#$01,d2						; set to render a single row
		bsr.s	.DrawBeam					; jump into the loop

	.NoBeamHead:
		moveq	#$00,d1						; clear mappings
		move.w	d3,d2						; load erase length
		bsr.s	.DrawBeam					; jump into the loop

	.NoBeam:

	; --- Checking if one of the beams needs masking ---

;		move.b	(RDD_MaskBeam).l,d0				; load beam mask
;		cmp.b	(RDD_MaskBeamPrev).l,d0				; has it changed?
;		beq.s	.NoWorm						; if not, branch to skip
;		move.b	d0,(RDD_MaskBeamPrev).l				; update
;		beq.s	.NoWorm						; if the beams are meant to unmask (then they already have been)
;		bpl.s	.NoLeft						; if the left beam does not need masking, branch
;		move.l	#($65080003+(DDZ_WORM_PLANEPOS<<$10))&$6FFE0003,d5 ; starting VRAM address (left beam)
;		bsr.s	.MaskBeam					; mask the left beam
;
;	.NoLeft:
;		btst.b	#$00,(RDD_MaskBeam).l				; does the right beam need masking?
;		beq.s	.NoWorm						; if not, branch
;		move.l	#($65140003+(DDZ_WORM_PLANEPOS<<$10))&$6FFE0003,d5 ; starting VRAM address (right beam)
;
;	.MaskBeam:
;		moveq	#DDZ_WORM_BEAMMAX-1,d3				; maximum height
;		moveq	#$00,d0						; clear d0
;
;	.NextMask:
;		move.l	d5,(a6)						; set address
;		addi.l	#$00800000,d5					; advance to next row
;		andi.l	#$6FFE0003,d5					; keep in the plane area
;		move.l	d0,(a5)						; clear tiles
;		dbf	d3,.NextMask					; repeat until all done
;
	.NoWorm:
		rts							; return

	.DrawBeamNext:
		move.l	d5,(a6)						; set VRAM address (left beam)
		move.l	d1,(a5)						; write beam mappings
		move.l	d5,d0						; load VRAM address
		addi.l	#$000C0000,d0					; advance to right socket
		move.l	d0,(a6)						; set VRAM address (right beam)
		move.l	d6,(a5)						; write beam mappings
		addi.l	#$00800000,d5					; advance to next row
		andi.l	#$6FFE0003,d5					; keep in the plane area
		dbf	d2,.DrawBeamNext				; repeat for beam length
		rts							; return

	.DrawBeam:
		move.l	d1,d6						; load tiles
		swap	d6						; create mirrored version for other side
		eori.l	#$08000800,d6					; ''
		dbf	d2,.DrawBeamNext				; jump back into beam draw loop (if any need to be drawn)
		rts							; return

	; --- Loading a beam particle ---

WHM_LoadParticle:
		moveq	#DDZ_WORMBEAMS_MAXSIZE-1,d6			; number of beams to read through
		lea	(RDD_WormBeams).l,a0				; load beam objects

	.NextBeam:
		tst.b	WbD(a0)						; check distance from centre
		beq.s	.NoBeam						; if distance is 0, use this slot
		lea	WormBeam_Size(a0),a0				; advance to next slot
		dbf	d6,.NextBeam					; repeat for all slots (until one is found)
		rts							; return

	.NoBeam:
		sf.b	WbT(a0)						; set as charge particle
		move.w	(RNG_Seed).w,WbA(a0)				; save random number as angle
		move.w	#$1000,WbD(a0)					; set default distance
		rts							; return

	; --- Loading a spark particle ---

WHM_LoadSpark:
		moveq	#DDZ_WORMBEAMS_MAXSIZE-1,d6			; number of beams to read through
		lea	(RDD_WormBeams).l,a0				; load beam objects

	.NextSpark:
		tst.b	WbD(a0)						; check distance from centre
		beq.s	.NoSpark					; if distance is 0, use the slot
		lea	WormBeam_Size(a0),a0				; advance to next slot
		dbf	d6,.NextSpark					; repeat for all slots (until one is found)
		rts							; return

	.NoSpark:
		st.b	WbT(a0)						; set as spark particle
		move.b	(RNG_Seed).w,d0					; load random number
		andi.b	#$5F,d0						; keep within 1F in two different angles 00 - 1F and 40 - 5F
		subi.b	#$70,d0						; rotate it around to top half of floor

		move.b	d0,WbA(a0)					; set angle
		move.w	#$0100,WbD(a0)					; set default distance
		rts							; return

Map_WormHead:	binclude "Levels\DDZ\Code\Data\Phase 1\Worm\HeadArt Map.map"

; ===========================================================================






