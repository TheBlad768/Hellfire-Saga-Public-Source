; ---------------------------------------------------------------------------
; Subroutine to animate level graphics
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Animate_Tiles:
		lea	(Level_data_addr_RAM.AnimateTiles).w,a0
		movea.l	(a0)+,a1
		movea.l	(a0)+,a2
		jmp	(a1)

; =============== S U B R O U T I N E =======================================

AnimateTiles_SCZ2:

PanelSCZ2Buffer		= RAM_Start+$6000
UpdatePanelSCZ2		= FDZ3Rain_Process

; not use a2

.sizeart	= 25
.sizetile	= $20

		tst.b	(UpdatePanelSCZ2).w
		beq.s	.continue
		clr.b	(UpdatePanelSCZ2).w

		lea	(PanelSCZ2Buffer).l,a0
		lea	(ArtUnc_AniSCZ_Panel).l,a1	; get dark panel
		lea	.sizeart*.sizetile(a1),a3			; get light panel
		moveq	#0,d0					; count
		moveq	#.sizeart/8-1,d6			; 3-1

.check
		cmp.b	(SCZ2_WaterLevel).w,d0	; 0x0, 0x1, 0x2 level
		bne.s	.notlight
		move.b	d0,(sp)					; .b
		move.w	(sp),d1					; .w
		clr.b	d1							; "
		adda.w	d1,a3					; shift the light panel
		exg	a3,a1						; swap light and dark panel
		bsr.s	.copytile					; from ROM to RAM
		exg	a1,a3						; swap dark and light panel
		lea	8*.sizetile(a1),a1				; skip 8 tiles ; error — 9 tile will be ignored

;		tst.w	d6						; I'm not sure if it is necessary... this is the last check...
;		bne.s	.nexttile
;		lea	.sizetile(a1),a1					; skip 1 tile

		bra.s	.nexttile

.notlight
		bsr.s	.copytile					; from ROM to RAM

.nexttile
		addq.b	#1,d0					; add to count
		dbf	d6,.check

; load from buffer
		move.l	#(PanelSCZ2Buffer)>>1,d1
		move.w	#tiles_to_bytes($24A),d2
		move.w	#$320/2,d3
		jsr	(Add_To_DMA_Queue).w

.continue
		tst.b	(Boss_flag).w
		bne.w	AnimateTiles_NULL
		bra.w	AnimateTiles_DoAniPLC
; ---------------------------------------------------------------------------

.copytile
		tst.w	d6
		bne.s	.notlasttile

	rept	8		; load +1 tile
		move.l	(a1)+,(a0)+
	endr

.notlasttile

	rept	8*8		; load 8 tiles
		move.l	(a1)+,(a0)+
	endr
		rts

; =============== S U B R O U T I N E =======================================

AnimateTiles_SCZ1:
		tst.b	(Boss_flag).w
		bne.s	AnimateTiles_NULL
		bra.s	AnimateTiles_DoAniPLC

; =============== S U B R O U T I N E =======================================

AnimateTiles_GMZ1:
		bra.s	AnimateTiles_DoAniPLC			; NAT: Enabled this for the final boss!

AnimateTiles_NULL:
		rts

; =============== S U B R O U T I N E =======================================

AnimateTiles_DoAniPLC:
		lea	(Anim_Counters).w,a3
		move.w	(a2)+,d6			; Get number of scripts in list
		bpl.s	.listnotempty		; If there are any, continue
		rts
; ---------------------------------------------------------------------------
.listnotempty:
AnimateTiles_DoAniPLC_Part2:
.loop:
		subq.b	#1,(a3)			; Tick down frame duration
		bcc.s	.nextscript		; If frame isn't over, move on to next script

;.nextframe:
		moveq	#0,d0
		move.b	1(a3),d0			; Get current frame
		cmp.b	6(a2),d0			; Have we processed the last frame in the script?
		blo.s		.notlastframe
		moveq	#0,d0			; If so, reset to first frame
		move.b	d0,1(a3)

.notlastframe:
		addq.b	#1,1(a3)			; Consider this frame processed; set counter to next frame
		move.b	(a2),(a3)			; Set frame duration to global duration value
		bpl.s	.globalduration
		; If script uses per-frame durations, use those instead
		add.w	d0,d0
		move.b	9(a2,d0.w),(a3)	; Set frame duration to current frame's duration value

.globalduration:
; Prepare for DMA transfer
		; Get relative address of frame's art
		move.b	8(a2,d0.w),d0	; Get tile ID
		lsl.w	#4,d0				; Turn it into an offset
		; Get VRAM destination address
		move.w	4(a2),d2
		; Get ROM source address
		move.l	(a2),d1			; Get start address of animated tile art
		andi.l	#$FFFFFF,d1
		add.l	d0,d1			; Offset into art, to get the address of new frame
		; Get size of art to be transferred
		moveq	#0,d3
		move.b	7(a2),d3
		lsl.w	#4,d3				; Turn it into actual size (in words)
		; Use d1, d2 and d3 to queue art for transfer
		jsr	(Add_To_DMA_Queue).w

.nextscript:
		move.b	6(a2),d0			; Get total size of frame data
		tst.b	(a2)					; Is per-frame duration data present?
		bpl.s	.globalduration2	; If not, keep the current size; it's correct
		add.b	d0,d0			; Double size to account for the additional frame duration data

.globalduration2:
		addq.b	#1,d0
		andi.w	#$FE,d0			; Round to next even address, if it isn't already
		lea	8(a2,d0.w),a2			; Advance to next script in list
		addq.w	#2,a3			; Advance to next script's slot in a3 (usually Anim_Counters)
		dbf	d6,.loop
		rts
; End of function AnimateTiles_DoAniPLC
; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The AnimateTiles_DoAniPLC subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done.

;    zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
;	-1			Global frame duration. If -1, then each frame will use its own duration, instead

;	ArtUnc_Flowers1			Source address
;	ArtTile_ArtUnc_Flowers1	Destination VRAM address
;	6						Number of frames
;	2						Number of tiles to load into VRAM for each frame

;    dc.b   0,$7F				Start of the script proper
;	0						Tile ID of first tile in ArtUnc_Flowers1 to transfer
;	$7F						Frame duration. Only here if global duration is -1
; ---------------------------------------------------------------------------

AniPLC_SCZ1:	zoneanimstart

; Block
	zoneanimdecl  3, (ArtUnc_AniSCZ_Block>>1),  $400,  12,  $10
	dc.b 0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $40
	dc.b $50
	dc.b $60
	dc.b $70
	dc.b $80
	dc.b $90
	dc.b $A0
	dc.b $B0
	even

; Line1
	zoneanimdecl  7, (ArtUnc_AniSCZ_Line1>>1),  $3B,  4,  7
	dc.b 0
	dc.b 7
	dc.b $E
	dc.b 7
	even

; Line2
	zoneanimdecl  7, (ArtUnc_AniSCZ_Line2>>1),  $42,  4,  7
	dc.b $E
	dc.b 7
	dc.b 0
	dc.b 7
	even

; Penta
	zoneanimdecl  -1, (ArtUnc_AniSCZ_Penta>>1),  $49,  37,  $10
	dc.b 0,  1
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  3
	dc.b $10,  0
	dc.b 0,  1
	dc.b $10,  0
	dc.b $20,  7
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  1
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  2
	dc.b 0,  1
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  3
	dc.b $10,  0
	dc.b 0,  1
	dc.b $10,  0
	dc.b $20,  7
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  0
	dc.b 0,  1
	dc.b $10,  0
	dc.b 0,  0
	dc.b $10,  2
	dc.b 0,  0
	dc.b $10,  0
	dc.b $20,  $4F
	dc.b $10,  2
	even

	zoneanimend

AniPLC_GMZ1:	zoneanimstart

; Lava  ( for Lava_Event, template?)
	zoneanimdecl  4, (ArtUnc_AniGMZ__1>>1),  $3B7,  8,  $18
	dc.b 0
	dc.b $18
	dc.b $30
	dc.b $48
	dc.b $60
	dc.b $78
	dc.b $90
	dc.b $A8
	even

; Eye 1
	zoneanimdecl  -1, (ArtUnc_AniGMZ__2>>1),  $84,  8,  8
	dc.b 0,  $26
	dc.b 8,  6
	dc.b $10,  6
	dc.b $18,  6
	dc.b $20,  $26
	dc.b $18,  6
	dc.b $10,  6
	dc.b 8,  6
	even

; Eye 2
	zoneanimdecl  -1, (ArtUnc_AniGMZ__3>>1),  $F,  6,  $B
	dc.b 0,  $36
	dc.b $B,  6
	dc.b $16,  6
	dc.b $21,  $36
	dc.b $B,  6
	dc.b $16,  6
	even

	zoneanimend

AniPLC_GMZ2:	zoneanimstart

; Lava
	zoneanimdecl  6, (ArtUnc_AniGMZ__1>>1),  $3B7,  4,  $18
	dc.b 0
	dc.b $18
	dc.b $30
	dc.b $48
	even

; Eye 1
	zoneanimdecl  -1, (ArtUnc_AniGMZ__2>>1),  $84,  8,  8
	dc.b 0,  $26
	dc.b 8,  6
	dc.b $10,  6
	dc.b $18,  6
	dc.b $20,  $26
	dc.b $18,  6
	dc.b $10,  6
	dc.b 8,  6
	even

; Eye 2
	zoneanimdecl  -1, (ArtUnc_AniGMZ__3>>1),  $F,  6,  $B
	dc.b 0,  $36
	dc.b $B,  6
	dc.b $16,  6
	dc.b $21,  $36
	dc.b $B,  6
	dc.b $16,  6
	even

	zoneanimend

AniPLC_NULL:	zoneanimstart

	zoneanimend
