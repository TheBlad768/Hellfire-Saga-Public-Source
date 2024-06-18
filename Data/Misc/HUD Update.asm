; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

UpdateHUD:
		locVRAM	tiles_to_bytes(ArtTile_HUD),d0					; set VRAM address

UpdateHUD_Indirect:
		lea	(VDP_data_port).l,a6
	if GameDebug=1
		tst.w	(Debug_placement_mode).w						; is debug mode on?
		bne.w	HudDb_XY										; if yes, branch
	endif
		tst.b	(Update_HUD_ring_count).w							; does the ring counter	need updating?
		beq.s	.chktime											; if not, branch
		clr.b	(Update_HUD_ring_count).w
		bsr.w	HUD_DrawRings

.chktime

		; check timer flag
		tst.b	(Update_HUD_timer).w
		beq.s	.return

		; check pause
		tst.b	(Game_paused).w										; is the game paused?
		bne.s	.return											; if yes, branch

		; check Sonic
		cmpi.b	#id_SonicDeath,(Player_1+routine).w				; has Sonic just died?
		bhs.s	.return											; if yes, branch

		; check intro flags
		tst.b	(NoPause_flag).w
		bne.s	.return
		tst.b	(Level_end_flag).w
		bne.s	.return
		tst.b	(Black_Stretch_flag).w
		bne.s	.return
		tst.b	(Ctrl_1_locked).w
		bne.s	.return

		; check time
		lea	(Timer).w,a1
		cmpi.l	#(23*$1000000)+(59*$10000)+(59*$100)+59,(a1)+	; is the time 23:59:59:59?
		beq.s	.return											; if yes, branch
		addq.b	#1,-(a1)											; increment 1/60s counter
		cmpi.b	#60,(a1)											; check if passed 60
		blo.s		.return
		clr.b	(a1)
		addq.b	#1,-(a1)											; increment second counter
		cmpi.b	#60,(a1)											; check if passed 60
		blo.s		.return
		clr.b	(a1)
		addq.b	#1,-(a1)											; increment minute counter
		cmpi.b	#60,(a1)											; check if passed 60
		blo.s		.return
		clr.b	(a1)
		addq.b	#1,-(a1)											; increment hour counter
		cmpi.b	#23,(a1)											; check if passed 23
		blo.s		.return
		move.b	#23,(a1)											; keep as 23

.return
		rts
; End of function UpdateHUD

	if GameDebug=1

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

Hud_MapWord macro	addr,tileid,vdpcomm
		locVRAM	vdpcomm,VDP_control_port-VDP_data_port(a6)
		move.w	#tileid,d2
		move.w	(addr).w,d0
		moveq	#4-1,d3			; 4 chars

-		rol.w	#4,d0
		move.b	d0,d1
		andi.w	#$F,d1
		add.w	d2,d1
		move.w	d1,VDP_data_port-VDP_data_port(a6)
		dbf	d3,-
	endm

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
		lea	(VDP_data_port).l,a6
		locVRAM	tiles_to_bytes($6EC),VDP_control_port-VDP_data_port(a6)
		move.l	#$86FF86FF,d1									; VRAM
		moveq	#20-1,d6											; Size of digits

-		move.l	d1,VDP_data_port-VDP_data_port(a6)
		dbf	d6,-
		rts
; End of function HUD_DrawInitial

; =============== S U B R O U T I N E =======================================

HUD_DrawWindow:
		move.w	#$8300+($DC00>>10),(VDP_control_port).l
		move.w	#$929B,(VDP_control_port).l
		rts
; End of function HUD_DrawWindow

; =============== S U B R O U T I N E =======================================

HUD_HideWindow:
		move.w	(VDP_windows_save).w,(VDP_control_port).l
		move.w	#$9200,(VDP_control_port).l
		rts
; End of function HUD_HideWindow
; ---------------------------------------------------------------------------
; Subroutine to load debug mode	numbers	patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HudDb_XY:
		Hud_MapWord	Camera_X_pos,$86EF,$DD8A
		Hud_MapWord	Camera_Y_pos,$86EF,$DD98
		Hud_MapWord	Player_1+x_pos,$86EF,$DDB0
		Hud_MapWord	Player_1+y_pos,$86EF,$DDBE
		rts
; End of function HudDb_XY
	endif
; ---------------------------------------------------------------------------
; Subroutine to	load HUD ring patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HUD_DrawRings:
		moveq	#0,d1					; NOV: Get HP
		move.b	(v_hp).w,d1				; NOV: ''

		move.l	d0,4(a6)				; NOV: Set VRAM write address
		lea	(ArtUnc_HudRings).l,a1		; NOV: Get ring art
		lea	(HP_Ani_Frames).w,a2		; NOV: Get animation frames

		divu.w	#5,d1					; NOV: Get number of full ring pieces and the amount of the partial ring piece

		moveq	#0,d3					; NOV: Get previous HP
		move.b	(v_prevhp).w,d3			; NOV: ''
		move.b	d1,(v_prevhp).w			; NOV: Update previous HP

		moveq	#0,d5					; NOV: Current ring ID

		tst.b	d1						; NOV: Was the last ring lost?
		bne.s	+						; NOV: If not, branch
		tst.b	d3						; NOV: Was the animation already set?
		beq.s	+						; NOV: If so, branch
		tst.b	(a2,d5.w)				; NOV: Is this ring already animating?
		bmi.s	+						; NOV: If so, branch
		move.b	#-4,(a2,d5.w)			; NOV: Set to animate
		move.b	#3,5(a2,d5.w)			; NOV: ''

+
		moveq	#0,d4					; NOV: Get animation frame offset
		tst.b	d1						; NOV: Only do animation frames if HP is 0
		bne.s	+						; NOV: ''
		move.b	(a2,d5.w),d4			; NOV: ''
		addq.b	#4,d4					; NOV: ''
		neg.b	d4						; NOV: ''
		ext.w	d4						; NOV: ''
		move.w	d4,d0					; NOV: ''
		add.w	d4,d4					; NOV: ''
		add.w	d0,d4					; NOV: ''
		add.w	d4,d4					; NOV: ''
		add.w	d0,d4					; NOV: ''
		asl.w	#6,d4					; NOV: ''
+
		addi.w	#$A40,d4				; NOV: ''
		lea		(a1,d4.w),a3			; NOV: ''

		moveq	#(14*8)-1,d0			; NOV: Draw the big ring
-
		move.l	(a3)+,(a6)				; NOV: ''
		dbf	d0,-						; NOV: ''

		addq.w	#1,d5					; NOV: Next ring
		subq.w	#1,d1					; NOV: Do not account for the big ring anymore
		bpl.s	+						; NOV: ''
		moveq	#0,d1					; NOV: ''
+
		subq.w	#1,d3					; NOV: ''
		bpl.s	+						; NOV: ''
		moveq	#0,d3					; NOV: ''
+
		; ----------------------

		move.w	d1,d2					; NOV: Copy the full ring piece count for looping
		subq.w	#1,d2					; NOV: ''
		bmi.s	HUD_DrawPartRing		; NOV: If there are no full rings to draw, branch

		move.w	d3,d0					; NOV: Get number of recently filled rings
		neg.w	d0						; NOV: ''
		subq.w	#1,d0					; NOV: ''

HUD_DrawFullRings:
		addq.w	#1,d0					; NOV: Should this be a recently filled ring?
		bmi.s	+						; NOV: If not, branch
		tst.b	(a2,d5.w)				; NOV: Is this ring already animating?
		bmi.s	+						; NOV: If so, branch
		move.b	#-3,(a2,d5.w)			; NOV: Set to animate
		move.b	#3,5(a2,d5.w)			; NOV: ''

+
		moveq	#0,d4					; NOV: Get animation frame offset
		move.b	(a2,d5.w),d4			; NOV: ''
		ext.w	d4						; NOV: ''
		asl.w	#6,d4					; NOV: ''
		addi.w	#$300,d4				; NOV: ''
		lea		(a1,d4.w),a3			; NOV: ''
		bsr.s	HUD_DrawSmallRing		; NOV: Draw the small ring piece

		addq.w	#1,d5					; NOV: Next ring
		dbf	d2,HUD_DrawFullRings		; NOV: Loop until finished

		; ----------------------

HUD_DrawPartRing:
		moveq	#4,d0					; NOV: Max number of blank rings if there is no partial ring

		move.l	d1,d2					; NOV: Copy the partial ring piece anount
		swap	d2						; NOV: ''
		tst.w	d2						; NOV: Is there any amount?
		beq.s	+						; NOV: If not, branch

		subq.b	#1,d0					; NOV: Max number of blank rings if there is a partial ring

		lsl.w	#6,d2					; NOV: Get offset for ring piece art
		addi.w	#$100,d2				; NOV: ''
		lea	(a1,d2.w),a3				; NOV: ''
		bsr.s	HUD_DrawSmallRing		; NOV: Draw the partial small ring piece

		addq.w	#1,d5					; NOV: Next ring

		; ----------------------

+
		move.w	d1,d2					; NOV: Get the number of blank rings to draw
		sub.w	d0,d2					; NOV: ''
		neg.w	d2						; NOV: ''
		subq.w	#1,d2					; NOV: Subtract 1 for looping
		bmi.s	+++						; NOV: If there are no blank rings to draw, branch

		move.w	d3,d0					; NOV: Get number of recently lost rings
		sub.w	d1,d0					; NOV: ''

HUD_DrawBlankRings:
		subq.w	#1,d0					; NOV: Should this be a recently lost ring?
		bmi.s	++						; NOV: If not, branch
		tst.b	(a2,d5.w)				; NOV: Is this ring already animating?
		beq.s	+						; NOV: If not, branch
		bpl.s	++						; NOV: If so, branch

+
		move.b	#4,(a2,d5.w)			; NOV: Set to animate
		move.b	#3,5(a2,d5.w)			; NOV: ''

+
		moveq	#0,d4					; NOV: Get animation frame offset
		move.b	(a2,d5.w),d4			; NOV: ''
		neg.w	d4						; NOV: ''
		asl.w	#6,d4					; NOV: ''
		addi.w	#$100,d4				; NOV: ''
		lea		(a1,d4.w),a3			; NOV: ''
		bsr.s	HUD_DrawSmallRing		; NOV: Draw the small ring piece

		addq.w	#1,d5					; NOV: Next ring
		dbf	d2,HUD_DrawBlankRings		; NOV: Loop until finished

+
		rts

HUD_DrawSmallRing:
	rept 16								; NOV: Draw small ring piece
		move.l	(a3)+,(a6)
	endm
		rts
; End of function HUD_DrawRings
; ---------------------------------------------------------------------------
; Subroutine to load rings numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
		lea	Hud_100(pc),a2
		moveq	#3-1,d6
		bra.s	Hud_LoadArt
; End of function DrawThreeDigitNumber
; ---------------------------------------------------------------------------
; Subroutine to load score numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
		lea	Hud_100000(pc),a2
		moveq	#6-1,d6

Hud_LoadArt:
		moveq	#0,d4
		lea	(ArtUnc_ResultsNumbers).l,a1

Hud_ScoreLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C8EC:
		sub.l	d3,d1
		bcs.s	loc_1C8F4
		addq.w	#1,d2
		bra.s	loc_1C8EC
; ---------------------------------------------------------------------------

loc_1C8F4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1C8FE
		move.w	#1,d4

loc_1C8FE:
;		tst.w	d4
;		beq.s	loc_1C92C

		lsl.w	#5,d2
		move.w	d2,d3
		add.w	d2,d2
		add.w	d3,d2
		move.l	d0,VDP_control_port-VDP_data_port(a6)
		lea	(a1,d2.w),a3
	rept 24
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endm

loc_1C92C:
		addi.l	#$600000,d0
		dbf	d6,Hud_ScoreLoop
		rts
; End of function DrawSixDigitNumber
; ---------------------------------------------------------------------------
; HUD counter sizes
; ---------------------------------------------------------------------------
Hud_100000:	dc.l 100000
Hud_10000:		dc.l 10000
Hud_1000:		dc.l 1000
Hud_100:		dc.l 100
Hud_10:			dc.l 10
Hud_1:			dc.l 1
; ---------------------------------------------------------------------------
; Subroutine to	load time numbers patterns
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
		lea	Hud_1(pc),a2
		moveq	#1-1,d6
		bra.s	loc_1C9BA
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
		lea	Hud_10(pc),a2
		moveq	#2-1,d6

loc_1C9BA:
		moveq	#0,d4
		lea	(ArtUnc_ResultsNumbers).l,a1

Hud_TimeLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C9C4:
		sub.l	d3,d1
		bcs.s	loc_1C9CC
		addq.w	#1,d2
		bra.s	loc_1C9C4
; ---------------------------------------------------------------------------

loc_1C9CC:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1C9D6
		move.w	#1,d4

loc_1C9D6:
		lsl.w	#5,d2
		move.w	d2,d3
		add.w	d2,d2
		add.w	d3,d2
		move.l	d0,VDP_control_port-VDP_data_port(a6)
		lea	(a1,d2.w),a3
	rept 24
		move.l	(a3)+,VDP_data_port-VDP_data_port(a6)
	endm
		addi.l	#$600000,d0
		dbf	d6,Hud_TimeLoop
		rts
; End of function DrawTwoDigitNumber
