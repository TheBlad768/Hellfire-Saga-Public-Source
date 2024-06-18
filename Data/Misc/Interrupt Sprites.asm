; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer sprites, but transfer the pause sprites first - MarkeyJester
; ---------------------------------------------------------------------------
; Because of the nature of Sonic Team's pause method, no objects can render
; their sprites, and it would be a pain to set that up.
;
; This injects the pause sprites into the table in such a way the original
; table is unaffected...
; ---------------------------------------------------------------------------

VB_PauseList:	dc.l	VB_PauseResume
		dc.l	VB_PauseReset
		dc.l	VB_PauseExit

VB_SpritesPause:
		moveq	#$00,d0						; load pause slot
		move.b	(PauseSlot).w,d0				; ''
		add.w	d0,d0						; multiply by size of long-word pointer
		add.w	d0,d0						; ''
		move.l	VB_PauseList(pc,d0.w),a4			; load correct sprite list for pause menu

		moveq	#$00,d3						; set no Y adjustment
		lea	VB_DummyWave(pc),a3				; load sinewave position
		moveq	#$00,d2						; reset angle (always 0)
		moveq	#$01,d0						; load Y position of "You Died" text
		sub.b	(YouDiedY).w,d0					; ''
		bhi.w	.NoDied						; if the "You Died" text is NOT meant to show, branch
		bne.s	.NoLoadArt					; if it's not just loaded, branch
		cmpi.b	#id_DDZ_Phase2,(Game_mode).w			; is this the phase 2 final boss?
		beq.s	.FinalBoss					; if so, branch
		dma68kToVDP ArtUnc_YouDied,(ArtTile_Pause*$20),ArtUnc_YouDied_End-ArtUnc_YouDied,VRAM	; transfer "you died" art
		bra.s	.NoLoadArt					; continue

	.FinalBoss:
		dma68kToVDP ArtUnc_YouDied,VDE_Pause,ArtUnc_YouDied_End-ArtUnc_YouDied,VRAM	; transfer "you died" art

	.NoLoadArt:
		move.w	#(224/2)+8,d0					; get exact position on-screen to show
		sub.b	(YouDiedY).w,d0					; get distance to reach position
		lsr.b	#$04,d0						; get fraction as speed
		add.b	d0,(YouDiedY).w					; move position down
		move.b	(YouDiedY).w,d3					; load Y position of you died text
		lea	VB_PauseDied(pc),a4				; load "you died" sprite mappings
		lea	(SineTable).w,a3				; load sinewave position
		moveq	#$00,d2						; load timer as starting angle
		move.b	(Level_frame_counter+1).w,d2			; ''
		add.b	d2,d2						; speed it up a bit
		add.b	d2,d2						; ''

	.NoDied:

	; --- Pause Menu ---

		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		move.l	d4,(a6)						; set sprite table write address
		move.w	(a4)+,d5					; load size of pause sprites
		moveq	#$50,d7						; get first link address for rest of sprites
		sub.w	d5,d7						; ''
		move.w	d7,-(sp)					; store count for later

		; First pause piece

		move.l	#$40000000,d0					; prepare VDP write value
		move.w	d2,d0						; load wave angle
		addi.b	#$10,d2						; increase for next piece
		add.w	d0,d0						; convert to word
		move.w	(a3,d0.w),d0					; load correct sine position
		asr.w	#$07,d0						; reduce distance
		add.w	(a4)+,d0					; add Y position
		add.w	d3,d0						; add Y base
		move.w	d0,(a5)						; set Y position
		move.w	(a4)+,d0					; load shape
		move.b	d7,d0						; save link ID
		move.w	d0,(a5)						; set shape and link ID
		move.w	(a4)+,d1					; load pattern index
		add.w	d6,d1						; add pause index address
		move.w	d1,(a5)						; set pattern
		move.w	(a4)+,(a5)					; set X position
		ext.w	d0						; get VRAM address
		lsl.w	#$03,d0						; x8 per sprite slot
		swap	d6						; add VRAM address where sprites are
		add.w	d6,d0						; ''
		swap	d6						; ''
		rol.l	#$02,d0						; align for VDP port
		ror.w	#$02,d0						; ''
		swap	d0						; ''
		move.l	d0,(a6)						; set new VDP write address

		subq.w	#$02,d5						; get remaining pieces left
		bcs.s	.LastPiece					; if there are no pause pieces left, skip

		; Remaining pause pieces

	.PausePiece:
		move.w	d2,d0						; load wave angle
		addi.b	#$10,d2						; increase for next piece
		add.w	d0,d0						; convert to word
		move.w	(a3,d0.w),d0					; load correct sine position
		asr.w	#$07,d0						; reduce distance
		add.w	(a4)+,d0					; add Y position
		add.w	d3,d0						; add Y base
		move.w	d0,(a5)						; set Y position
		move.w	(a4)+,d0					; load shape
		addq.b	#$01,d7						; increase link ID
		move.b	d7,d0						; save link ID
		move.w	d0,(a5)						; set shape and link ID
		move.w	(a4)+,d1					; load pattern index
		add.w	d6,d1						; add pause index address
		move.w	d1,(a5)						; set pattern
		move.w	(a4)+,(a5)					; set X position
		dbf	d5,.PausePiece					; repeat for all pause pieces

	.LastPiece:

		; First piece of table

		lea	(Sprite_table_buffer).l,a4			; load the sprite table
		move.l	(a4)+,(a5)					; save Y position and shape, and link
		move.l	(a4)+,(a5)					; save pattern index and X position
		lea	(R_VDP97).w,a0					; load DMA registers
		move.w	(sp)+,d1					; reload count
		subq.w	#$01,d1						; minus 1 from size of table for first piece already written on end

		; The normal table now...

		move.l	a4,d0						; get DMA source address
		andi.l	#$00FFFFFF,d0					; ''
		lsr.l	#$01,d0						; divide by 2 for DMA word
		movep.l	d0,-$01(a0)					; store with registers
		move.w	(a0)+,(a6)					; set DMA source
		move.l	(a0)+,(a6)					; ''
		add.w	d1,d1						; multiply sprite count by x8 then divide by 2 for DMA
		add.w	d1,d1						; ''
		movep.w	d1,$01(a0)					; save DMA size
		move.l	(a0)+,(a6)					; ''
		addi.l	#$00080080,d4					; advance to second sprite slot (and set DMA bit)
		move.w	d4,(a0)						; store second destination in 68k RAM
		swap	d4						; get first destination
		move.w	d4,(a6)						; set DMA transfer
		move.w	(a0),(a6)					; ''
		rts							; return

; ---------------------------------------------------------------------------
; Pause mappings when "Resume" is highlighted
; ---------------------------------------------------------------------------

VB_PauseResume:	dc.w	(.End-*)/8

		; -> to Resume
		dc.w	$00E4,$0200,$0012,$0100				; Top selection

		; RESUME
		dc.w	$00E4,$0C00,$0008,$0108				; "RESU"
		dc.w	$00E4,$0000,$000C,$0128				; "M"
		dc.w	$00E4,$0000,$0009,$0130				; "E"

		; RESET
		dc.w	$00EC,$0800,$0008,$0108				; "RES"
		dc.w	$00EC,$0000,$0009,$0120				; "E"
		dc.w	$00EC,$0400,$000F,$0128				; "T "

		; EXIT
		dc.w	$00F4,$0000,$0009,$0108				; "E"
		dc.w	$00F4,$0C00,$000D,$0110				; "XIT "
		dc.w	$00F4,$0000,$0010,$0130				; " "

		; Boarder
		dc.w	$00DC,$0C00,$0004,$0100				; top bar
		dc.w	$00DC,$0C00,$0004,$0120				; ''
		dc.w	$00FC,$0C00,$0004,$0100				; bottom bar
		dc.w	$00FC,$0C00,$0004,$0120				; ''
		dc.w	$00DC,$0300,$0000,$00F8				; left bar
		dc.w	$00FC,$0000,$0000,$00F8				; ''
		dc.w	$00DC,$0700,$0800,$0138				; right bar
		dc.w	$00FC,$0400,$0803,$0138				; ''

	.End:

; ---------------------------------------------------------------------------
; Pause mappings when "Reset" is highlighted
; ---------------------------------------------------------------------------

VB_PauseReset:	dc.w	(.End-*)/8

		; -> to Reset
		dc.w	$00E4,$0200,$0011,$0100				; Top selection

		; RESUME
		dc.w	$00E4,$0C00,$0008,$0108				; "RESU"
		dc.w	$00E4,$0000,$000C,$0128				; "M"
		dc.w	$00E4,$0000,$0009,$0130				; "E"

		; RESET
		dc.w	$00EC,$0800,$0008,$0108				; "RES"
		dc.w	$00EC,$0000,$0009,$0120				; "E"
		dc.w	$00EC,$0400,$000F,$0128				; "T "

		; EXIT
		dc.w	$00F4,$0000,$0009,$0108				; "E"
		dc.w	$00F4,$0C00,$000D,$0110				; "XIT "
		dc.w	$00F4,$0000,$0010,$0130				; " "

		; Boarder
		dc.w	$00DC,$0C00,$0004,$0100				; top bar
		dc.w	$00DC,$0C00,$0004,$0120				; ''
		dc.w	$00FC,$0C00,$0004,$0100				; bottom bar
		dc.w	$00FC,$0C00,$0004,$0120				; ''
		dc.w	$00DC,$0300,$0000,$00F8				; left bar
		dc.w	$00FC,$0000,$0000,$00F8				; ''
		dc.w	$00DC,$0700,$0800,$0138				; right bar
		dc.w	$00FC,$0400,$0803,$0138				; ''

	.End:

; ---------------------------------------------------------------------------
; Pause mappings when "Exit" is highlighted
; ---------------------------------------------------------------------------

VB_PauseExit:	dc.w	(.End-*)/8

		; -> to Exit
		dc.w	$00E4,$0200,$0010,$0100				; Top selection

		; RESUME
		dc.w	$00E4,$0C00,$0008,$0108				; "RESU"
		dc.w	$00E4,$0000,$000C,$0128				; "M"
		dc.w	$00E4,$0000,$0009,$0130				; "E"

		; RESET
		dc.w	$00EC,$0800,$0008,$0108				; "RES"
		dc.w	$00EC,$0000,$0009,$0120				; "E"
		dc.w	$00EC,$0400,$000F,$0128				; "T "

		; EXIT
		dc.w	$00F4,$0000,$0009,$0108				; "E"
		dc.w	$00F4,$0C00,$000D,$0110				; "XIT "
		dc.w	$00F4,$0000,$0010,$0130				; " "

		; Boarder
		dc.w	$00DC,$0C00,$0004,$0100				; top bar
		dc.w	$00DC,$0C00,$0004,$0120				; ''
		dc.w	$00FC,$0C00,$0004,$0100				; bottom bar
		dc.w	$00FC,$0C00,$0004,$0120				; ''
		dc.w	$00DC,$0300,$0000,$00F8				; left bar
		dc.w	$00FC,$0000,$0000,$00F8				; ''
		dc.w	$00DC,$0700,$0800,$0138				; right bar
		dc.w	$00FC,$0400,$0803,$0138				; ''

	.End:

; ---------------------------------------------------------------------------
; "You Died" mappings
; ---------------------------------------------------------------------------

VB_PauseDied:	dc.w	(.End-*)/8

	;	dc.w	$0078,$0D00,$0000,$00F4	; Thick version
	;	dc.w	$0078,$0900,$0008,$0114
	;	dc.w	$0078,$0D00,$000E,$012C

		dc.w	$0078,$0100,$0000,$00F4
		dc.w	$0078,$0100,$0002,$00FC
		dc.w	$0078,$0100,$0004,$0104
		dc.w	$0078,$0100,$0006,$010C
		dc.w	$0078,$0100,$0008,$0114
		dc.w	$0078,$0100,$000A,$011C
		dc.w	$0078,$0100,$000C,$0124
		dc.w	$0078,$0100,$000E,$012C
		dc.w	$0078,$0100,$0010,$0134
		dc.w	$0078,$0100,$0012,$013C
		dc.w	$0078,$0100,$0014,$0144
		dc.w	$0078,$0100,$0016,$014C
	.End:

; ---------------------------------------------------------------------------
; This is a dummy sinewave for the pause menu so the same code can be used...
; ---------------------------------------------------------------------------

VB_DummyWave:	rept	$100
		dc.w	$0000
		endr

; ===========================================================================