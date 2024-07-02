; ---------------------------------------------------------------------------
; Vertical interrupt handler
; ---------------------------------------------------------------------------

VInt:
		movem.l	d0-a6,-(sp)							; save all the registers to the stack

.main
		tst.b	(V_int_routine).w
		beq.w	VInt_Lag_Main

-		move.w	(VDP_control_port).l,d0
		andi.w	#8,d0
		beq.s	-	; wait until vertical blanking is taking place

		tst.b	(SwapPlanes).w					; MJ: haveplanes been requested to swap?
		bpl.s	.NoSwap						; MJ: if not, continue
		move.b	#$7F,(SwapPlanes).w				; MJ: clear flag
		move.w	#$8200+(vram_bg>>10),($C00004).l		; MJ: swap BG and FG planes
		move.w	#$8400+(vram_fg>>13),($C00004).l		; MJ: ''

	.NoSwap:
		move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	;	move.l	(V_scroll_value).w,(VDP_data_port).l
		move.l	(V_scroll_value).w,d0				; MJ: load V-scroll positions
		tst.b	(SwapVScroll).w					; MJ: are they swapped?
		beq.s	.NoSwapVScroll					; MJ: if not, branch
		swap	d0						; MJ: swap them

	.NoSwapVScroll:
		move.l	d0,(VDP_data_port).l				; MJ: update V-scroll positions


;		btst	#6,(Graphics_flags).w
;		beq.s	+								; branch if it's not a PAL system
;		move.w	#$700,d0
;		dbf	d0,*								; otherwise, waste a bit of time here
;+

		move.b	(V_int_routine).w,d0
		sf	(V_int_routine).w
		move.w	#1,(H_int_flag).w						; Allow H Interrupt code to run
		andi.w	#$3E,d0
		move.w	VInt_Table(pc,d0.w),d0
		jsr	VInt_Table(pc,d0.w)

VInt_Music:
		jsr	dFractalExtra							; update extra functions
		jsr	dForceMuteYM2612						; force YM2612 channels to mute when requested
		jsr	dFractalSound							; Update Fractal

VInt_Done:
		bsr.w	Random_Number
		addq.l	#1,(V_int_run_count).w
	if Debug_Lagometer
		cmpi.b	#4,(Current_Zone).w		; MJ: is this the Credits?
		beq.s	.NoLag				; MJ: if so, skip the annoying meter...
		move.w	#$9193,VDP_control_port						; NAT: Enable window
	.NoLag:
	endif
		movem.l	(sp)+,d0-a6							; return saved registers from the stack
		rte
; ---------------------------------------------------------------------------

VInt_Table: offsetTable
ptr_VInt_Lag:		offsetTableEntry.w VInt_Lag		; 0
ptr_VInt_Main:		offsetTableEntry.w VInt_Main		; 2
ptr_VInt_Sega:		offsetTableEntry.w VInt_Sega		; 4
ptr_VInt_Title:		offsetTableEntry.w VInt_Title		; 6
ptr_VInt_Menu:		offsetTableEntry.w VInt_Menu		; 8
ptr_VInt_Level:		offsetTableEntry.w VInt_Level		; A
ptr_VInt_TitleCard:	offsetTableEntry.w VInt_TitleCard	; C
ptr_VInt_Fade:		offsetTableEntry.w VInt_Fade		; E
; ---------------------------------------------------------------------------

VInt_Lag:
		addq.w	#4,sp

VInt_Lag_Main:
		addq.w	#1,(Lag_frame_count).w

		; branch if a level is running
		cmpi.b	#$80+id_Level,(Game_mode).w
		beq.s	VInt_Lag_Level
		cmpi.b	#id_Level,(Game_mode).w				; is game on a level?
		bne.s	VInt_Music					; otherwise, return from V-int
; ---------------------------------------------------------------------------

VInt_Lag_Level:
		tst.b	(Water_flag).w
		beq.w	VInt_Lag_NoWater
		move.w	(VDP_control_port).l,d0
		btst	#6,(Graphics_flags).w
		beq.s	+									; branch if it isn't a PAL system
		move.w	#$700,d0
		dbf	d0,*										; otherwise waste a bit of time here

+		move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	;	move.l	(V_scroll_value).w,(VDP_data_port).l
		move.l	(V_scroll_value).w,d0				; MJ: load V-scroll positions
		tst.b	(SwapVScroll).w					; MJ: are they swapped?
		beq.s	.NoSwapVScroll					; MJ: if not, branch
		swap	d0						; MJ: swap them

	.NoSwapVScroll:
		move.l	d0,(VDP_data_port).l				; MJ: update V-scroll positions

		move.w	#1,(H_int_flag).w						; set HInt flag
		tst.b	(Water_full_screen_flag).w					; is water above top of screen?
		bne.s	VInt_Lag_FullyUnderwater 			; if yes, branch
		dma68kToVDP Normal_palette,$0000,$80,CRAM
		bra.s	VInt_Lag_Water_Cont
; ---------------------------------------------------------------------------

VInt_Lag_FullyUnderwater:
		dma68kToVDP Water_palette,$0000,$80,CRAM

VInt_Lag_Water_Cont:
		move.l	(H_int_counter_command).w,(a5)
		bra.w	VInt_Music
; ---------------------------------------------------------------------------

VInt_Lag_NoWater:
		move.w	(VDP_control_port).l,d0
		btst	#6,(Graphics_flags).w
		beq.s	+	; branch if it isn't a PAL system
		move.w	#$700,d0
		dbf	d0,*		; otherwise, waste a bit of time here

+		move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	;	move.l	(V_scroll_value).w,(VDP_data_port).l
		move.l	(V_scroll_value).w,d0				; MJ: load V-scroll positions
		tst.b	(SwapVScroll).w					; MJ: are they swapped?
		beq.s	.NoSwapVScroll					; MJ: if not, branch
		swap	d0						; MJ: swap them

	.NoSwapVScroll:
		move.l	d0,(VDP_data_port).l				; MJ: update V-scroll positions
		move.w	#1,(H_int_flag).w
		move.l	(H_int_counter_command).w,(VDP_control_port).l

VInt_Lag_Done:
		bra.w	VInt_Music
; ---------------------------------------------------------------------------

VInt_Main:
		bsr.s	Do_ControllerPal
		tst.w	(Demo_timer).w
		beq.s	+
		subq.w	#1,(Demo_timer).w
+		rts
; ---------------------------------------------------------------------------

VInt_Title:
		bsr.s	Do_ControllerPal
		tst.w	(Demo_timer).w
		beq.s	+
		subq.w	#1,(Demo_timer).w
+		rts
; ---------------------------------------------------------------------------

VInt_Fade:
		bsr.s	Do_ControllerPal
		move.l	(H_int_counter_command).w,(a5)
		rts

; =============== S U B R O U T I N E =======================================

Do_ControllerPal:
		stopZ80
		jsr	(Poll_Controllers).w
		startZ80
		dma68kToVDP Sprite_table_buffer,vram_sprites,$280,VRAM
		dma68kToVDP H_scroll_buffer,vram_hscroll,$380,VRAM
		tst.b	(Water_full_screen_flag).w
		bne.s	+
		dma68kToVDP Normal_palette,$0000,$80,CRAM
		bra.s	++

+		dma68kToVDP Water_palette,$0000,$80,CRAM
+
		bra.w	Process_DMA_Queue
; End of function Do_ControllerPal
; ---------------------------------------------------------------------------

VInt_Sega:
		move.b	(V_int_run_count+3).w,d0
		andi.w	#$F,d0
		bne.s	+	; run the following code once every 16 frames
		stopZ80
		jsr	(Poll_Controllers).w
		startZ80
+		tst.w	(Demo_timer).w
		beq.s	+
		subq.w	#1,(Demo_timer).w
+		bra.w	Set_Kos_Bookmark
; ---------------------------------------------------------------------------

VInt_Menu:
		bsr.w	Do_ControllerPal
		tst.w	(Demo_timer).w
		beq.s	+
		subq.w	#1,(Demo_timer).w
+		bra.w	Set_Kos_Bookmark
; ---------------------------------------------------------------------------

VInt_TitleCard:
		bsr.w	Do_ControllerPal
		move.l	(H_int_counter_command).w,(a5)
		bra.w	Set_Kos_Bookmark
; ---------------------------------------------------------------------------

VInt_Level:
		stopZ80
		jsr	(Poll_Controllers).w
		startZ80
		dma68kToVDP H_scroll_buffer,vram_hscroll,$380,VRAM

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
		dma68kToVDP Sprite_table_buffer,vram_sprites,$280,VRAM	; MJ: standard DMA version

	.YesPause:

		tst.w	(Seizure_Flag).w
		bne.s	VInt_Level_NoNegativeFlash
		tst.b	(Game_paused).w
		bne.s	VInt_Level_NoNegativeFlash
		tst.b	(Hyper_Sonic_flash_timer).w
		beq.s	VInt_Level_NoFlash

		; flash screen white
		subq.b	#1,(Hyper_Sonic_flash_timer).w
		lea	(VDP_data_port).l,a6
		move.l	#vdpComm($0000,CRAM,WRITE),VDP_control_port-VDP_data_port(a6)
		move.w	#cWhite,d0
		moveq	#$40-1,d1			; fill entire palette with white

-
		move.w	d0,(a6)				; NAT: imo, it does not look good when
		dbf	d1,-				; some part of the screen stays black!

;		move.w	#$1F,d1

;-		move.w	d0,VDP_data_port-VDP_data_port(a6)
;		dbf	d1,-	; fill entire first and second palette lines with white
;		move.w	#0,VDP_data_port-VDP_data_port(a6)	; keep backdrop black
;		move.w	#$1E,d1

;-		move.w	d0,VDP_data_port-VDP_data_port(a6)
;		dbf	d1,-	; fill remaining colours with white
		bra.w	VInt_Level_Cont
; ---------------------------------------------------------------------------

VInt_Level_NoFlash:
		tst.b	(Negative_flash_timer).w
		beq.s	VInt_Level_NoNegativeFlash
		subq.b	#1,(Negative_flash_timer).w
		btst	#2,(Negative_flash_timer).w
		beq.s	VInt_Level_NoNegativeFlash
		lea	(VDP_data_port).l,a6
		move.l	#vdpComm($0000,CRAM,WRITE),VDP_control_port-VDP_data_port(a6)
		moveq	#(64/2)-1,d1
		move.l	#$0EEE0EEE,d2
		lea	(Normal_palette).w,a1

-		move.l	(a1)+,d0
		not.l	d0
		and.l	d2,d0
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d1,-
		bra.s	VInt_Level_Cont
; ---------------------------------------------------------------------------

VInt_Level_NoNegativeFlash:
		tst.b	(Water_full_screen_flag).w
		bne.s	+
		dma68kToVDP Normal_palette,$0000,$80,CRAM
		bra.s	++

+		dma68kToVDP Water_palette,$0000,$80,CRAM
+		move.l	(H_int_counter_command).w,(a5)

VInt_Level_Cont:
		jsr	Process_DMA_Queue

		tst.b	(CreditsFinalText).w				; MJ: have credits text for final credits roll been requested?
		beq.s	.NoCreditRoll					; MJ: if not, skip
		sf.b	(CreditsFinalText).w				; MJ: clear flag
		dma68kToVDP CRE_CreditsArt, VRAM_CreditsText, (CRE_CredBigArt-CRE_CreditsArt), VRAM
		dma68kToVDP CRE_CredBigArt, VRAM_CreditsLargeChars, (CRE_CredArtEnd-CRE_CredBigArt), VRAM
		move.l	#VInt_Done,(sp)					; MJ: Skip fractal for one frame...  Just too slow...

	.NoCreditRoll:
		tst.b	(CreditsMapText).w				; MJ: are we doing credits mappings transfers now?
		beq.s	.NoCreditMap					; MJ: if not, skip
		move.l	(CreditsPlane).l,d0				; MJ: load plane destination
		beq.s	.NoCreditMap					; MJ: if nothing to transfer right now, branch
		clr.l	(CreditsPlane).l				; MJ: clear so it only transfers once
		move.l	#$94009340,(a5)					; MJ: set DMA size (plane width)
		move.l	#$96009500|((((CreditsPlane+4)/2)&$FF00)<<8)|(((CreditsPlane+4)/2)&$FF),(a5) ; MJ: set DMA source
		move.w	#$977F,(a5)					; MJ: last source (it's always from RAM)
		move.w	d0,(a5)						; MJ: first destination
		swap	d0						; MJ: second destination from 68k RAM
		move.w	d0,(DMA_trigger_word).w				; MJ: ''
		move.w	(DMA_trigger_word).w,(a5)			; MJ: ''

	.NoCreditMap:
		lea	(ScrollDraw_VInt).l,a0				; MJ: load normal render routine
		cmpi.b	#4,(Current_Zone).w				; MJ: is this the credits?
		bne.s	.NormalRender					; MJ: if not, continue normally
		lea	(ScrollDraw_Credits_VInt).l,a0			; MJ: load special render routine

	.NormalRender:
		jsr	(a0)						; MJ: run tile rendering code
		enableInts
		pea	Set_Kos_Bookmark(pc)

; =============== S U B R O U T I N E =======================================

Do_Updates:
		jsr	(UpdateHUD).w
		clr.w	(Lag_frame_count).w
		tst.w	(Demo_timer).w ; is there time left on the demo?
		beq.s	+
		subq.w	#1,(Demo_timer).w ; subtract 1 from time left
+		rts
; End of function Do_Updates

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HInt:
		disableInts
		tst.w	(H_int_flag).w
		beq.w	HInt_Done
		clr.w	H_int_flag.w

		movem.l	a0-a1,-(sp)
		lea	(VDP_data_port).l,a1
		move.w	#$8A00+223,VDP_control_port-VDP_data_port(a1)
		lea	(Water_palette).w,a0
		move.l	#vdpComm($0000,CRAM,WRITE),VDP_control_port-VDP_data_port(a1)
	rept 32
		move.l	(a0)+,VDP_data_port-VDP_data_port(a1)
	endm
		movem.l	(sp)+,a0-a1

HInt_Done:
		rte
; ---------------------------------------------------------------------------
; GMZ Lava horizontal interrupt
; ---------------------------------------------------------------------------

H_GMZ1Lava:
		disableInts

		tst.w	H_int_flag.w
		beq.s	H_GMZ1Lava2.done
		clr.w	H_int_flag.w

		movem.l	d0-d1/a1,-(sp)
		lea	VDP_control_port,a1
	;	move.l	#$8AFF8220,(a1)			; disable h-ints and set the background plane location

		move.w	4(a1),d1			; NAT: Getting v-line from VDP instead of flag.	This makes it more accurate
		lsr.w	#8,d1				; get the v-line to low byte
		moveq	#$69-1,d0			; MJ: -1 to account for delayed scanline
		sub.b	d1,d0				; sub the current line from 8
		ext.w	d0				; extend to word

		move.l	#$40000010,(a1)			; setup VSRAM WRITE $0000
		move.w	d0,-4(a1)			; write as the plane y-position to VSRAM

	.Wait:	move.w	4(a1),d0			; MJ: wait for next H-blank (V-scroll takes too long to update)
		cmpi.b	#$90,d0				; MJ: has the beam finished the scanline?
		bcs.s	.Wait				; MJ: if not loop and wait

		move.l	#$8AFF8220,(a1)			; disable h-ints and set the background plane location


		movem.l	(sp)+,d0-d1/a1

H_GMZ1Lava2:
.done		rte

; ===========================================================================


