; ---------------------------------------------------------------------------
; Results Screen
; By TheBlad768 (2023)
; ---------------------------------------------------------------------------

; Constants
Results_Offset:				= *

; RAM
	phase ramaddr(Camera_RAM)

; text draw
vResults_ScrollText1:			ds.w 1
vResults_ScrollText2:			ds.w 1
vResults_ScrollText3:			ds.w 1
vResults_ScrollText4:			ds.w 1
vResults_ScrollText5:			ds.w 1
vResults_TimeText1:			ds.w 1
vResults_TimeText2:			ds.w 1
vResults_TimeText3:			ds.w 1
vResults_TimeText4:			ds.w 1
vResults_TimeText5:			ds.w 1

; score
vResults_Timer:				ds.b 1
vResults_Death:				ds.b 1
vResults_Secrets:				ds.b 1
vResults_Difficulty:			ds.b 1
vResults_Total:				ds.b 1
vResults_Routine:				ds.b 1
vResults_Rank:				ds.b 1
							ds.b 1	; even

	dephase
	!org	Results_Offset

; =============== S U B R O U T I N E =======================================

Results_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.l	#VInt,(V_int_addr).w							; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w							; MJ: restore H-blank address
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)									; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)					; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)					; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)							; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B03,(a6)									; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C81,(a6)									; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)									; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)									; Command $9200 - Window V position at default
		clr.b	(Water_full_screen_flag).w
		clr.b	(Water_flag).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		; set pos
		lea	(vResults_ScrollText1).w,a0
		move.l	#word_to_long(-(176+32),-(176+32)),d0
		move.l	d0,(a0)+
		move.l	d0,(a0)+
		move.w	d0,(a0)+

		; set time
		move.l	#word_to_long(20,40),(a0)+
		move.l	#word_to_long(60,80),(a0)+
		move.w	#100,(a0)+

		; load art
		lea	PLC_Results(pc),a5
		jsr	(LoadPLC_Raw_KosM).w

		; load map
		lea	(MapEni_ResultsBGStar).l,a0
		lea	(RAM_start).l,a1
		move.w	#$8001,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_bg, 320, 224
		lea	(MapEni_ResultsFGText).l,a0
		lea	(RAM_start).l,a1
		moveq	#0,d0
		jsr	(Eni_Decomp).w
		copyTilemap	(vram_fg+$208), 176, 152

		; load palette
		lea	(Pal_ResultsScreen).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line48).w

.waitplc
		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	.waitplc

		; play music
		music	mus_FinalResults
		command	cmd_FadeReset

		; set scroll pos
		bsr.w	Results_ScrollText

		; calc score
		bsr.w	Results_CalcScore

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.sloop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		bsr.w	Results_ScrollText
		bsr.w	Results_ScrollShowText
		tst.w	(H_scroll_buffer+(32*5*4)).w
		bne.s	.sloop

		; set wait
		move.w	#6*60-30,(vResults_ScrollText1).w

.dloop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		bsr.w	Results_DrawResults
		beq.s	.dloop

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop

.exit
		move.b	#id_Dialog,(Game_mode).w	; set Game Mode
		rts

; ---------------------------------------------------------------------------
; Draw results
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Results_DrawResults:
		subq.w	#1,(vResults_ScrollText1).w
		bpl.s	.end

		; get time
		moveq	#0,d0
		move.b	(vResults_Routine).w,d0
		move.w	.index(pc,d0.w),d1
		bmi.s	.finish
		move.w	d1,(vResults_ScrollText1).w
		addq.b	#4,(vResults_Routine).w

		; jump
		lea	.index(pc),a1
		adda.w	2(a1,d0.w),a1
		jsr	(a1)

.end
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.finish
		moveq	#1,d0
		rts
; ---------------------------------------------------------------------------

.index	; wait, jmp
		dc.w $001F, Results_DrawTimer-.index		; 0
		dc.w $001F, Results_DrawDeath-.index		; 4
		dc.w $001F, Results_DrawSecrets-.index		; 8
		dc.w $001F, Results_DrawTimerPt-.index		; C
		dc.w $001F, Results_DrawDeathPt-.index		; 10
		dc.w $001F, Results_DrawSecretsPt-.index	; 14
		dc.w $001F, Results_DrawDifficultyPt-.index	; 18
		dc.w $002F, Results_DrawTotalPt-.index		; 1C
		dc.w $001F, Results_DrawRank-.index		; 20
		dc.w -1									; end

; =============== S U B R O U T I N E =======================================

Results_DrawTimer:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (:)
		locVRAM	$C21C,d1

		; (:)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$812F,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$812F,VDP_data_port-VDP_data_port(a6)

		; draw (:)
		locVRAM	$C222,d1

		; (:)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$812F,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$812F,VDP_data_port-VDP_data_port(a6)

		; draw (||)
		locVRAM	$C228,d1

		; (||)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81308131,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81388938,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81418142,VDP_data_port-VDP_data_port(a6)

		; draw time
		locVRAM	tiles_to_bytes(.tvram),d0
		moveq	#0,d1
		move.b	(Timer_hour).w,d1
		jsr	(DrawTwoDigitNumber).w								; load hours
		locVRAM	tiles_to_bytes(.tvram+6),d0
		moveq	#0,d1
		move.b	(Timer_minute).w,d1
		jsr	(DrawTwoDigitNumber).w								; load minutes
		locVRAM	tiles_to_bytes(.tvram+12),d0
		moveq	#0,d1
		move.b	(Timer_second).w,d1
		jsr	(DrawTwoDigitNumber).w 								; load seconds

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawDeath:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (||)
		locVRAM	$C428,d1

		; (||)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81308131,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81388938,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81418142,VDP_data_port-VDP_data_port(a6)

		; draw death
		locVRAM	tiles_to_bytes(.tvram+18),d0
		moveq	#0,d1
		move.w	(Death_count).w,d1
		jsr	(DrawThreeDigitNumber).w							; load deaths

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawSecrets:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (/)
		locVRAM	$C622,d1

		; (/)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$8164,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$816C,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.w	#$8175,VDP_data_port-VDP_data_port(a6)

		; draw (||)
		locVRAM	$C628,d1

		; (||)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81308131,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81388938,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81418142,VDP_data_port-VDP_data_port(a6)

		; draw secrets
		locVRAM	tiles_to_bytes(.tvram+28),d0
		moveq	#0,d1
		move.b	(TSecrets_count).w,d1
		jsr	(DrawTwoDigitNumber).w								; load secrets
		locVRAM	tiles_to_bytes(.tvram+34),d0
		moveq	#0,d1
		move.b	(MSecrets_count).w,d1
		jsr	(DrawTwoDigitNumber).w								; load secrets

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawTimerPt:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (pt.)
		locVRAM	$C2B0,d1

		; (pt.)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$8139813A,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81438144,VDP_data_port-VDP_data_port(a6)

		; draw time (pt.)
		locVRAM	tiles_to_bytes(.tvram+40),d0
		moveq	#0,d1
		move.b	(vResults_Timer).w,d1
		jsr	(DrawTwoDigitNumber).w								; load time (pt.)

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawDeathPt:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (pt.)
		locVRAM	$C4B0,d1

		; (pt.)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$8139813A,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81438144,VDP_data_port-VDP_data_port(a6)

		; draw death (pt.)
		locVRAM	tiles_to_bytes(.tvram+46),d0
		moveq	#0,d1
		move.b	(vResults_Death).w,d1
		jsr	(DrawTwoDigitNumber).w								; load death (pt.)

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawSecretsPt:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (pt.)
		locVRAM	$C6B0,d1

		; (pt.)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$8139813A,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81438144,VDP_data_port-VDP_data_port(a6)

		; draw secrets (pt.)
		locVRAM	tiles_to_bytes(.tvram+52),d0
		moveq	#0,d1
		move.b	(vResults_Secrets).w,d1
		jsr	(DrawTwoDigitNumber).w								; load secrets (pt.)

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawDifficultyPt:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (pt.)
		locVRAM	$C8B0,d1

		; (pt.)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$8139813A,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$81438144,VDP_data_port-VDP_data_port(a6)

		; draw difficulty (pt.)
		locVRAM	tiles_to_bytes(.tvram+58),d0
		moveq	#0,d1
		move.b	(vResults_Difficulty).w,d1
		jsr	(DrawTwoDigitNumber).w								; load difficulty (pt.)

		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Results_DrawTotalPt:
		samp	sfx_WalkingArmorAtk

.tvram	= $200		; 3 tile - number size

		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw (pt.)
		locVRAM	$CAB0,d1

		; (pt.)
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$A139A13A,VDP_data_port-VDP_data_port(a6)
		add.l	d2,d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	#$A143A144,VDP_data_port-VDP_data_port(a6)

		; draw total (pt.)
		locVRAM	tiles_to_bytes(.tvram+64),d0
		moveq	#0,d1
		move.b	(vResults_Total).w,d1
		jsr	(DrawThreeDigitNumber).w							; load total (pt.)

		enableIntsSave
		rts

; ---------------------------------------------------------------------------
; Draw rank
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Results_DrawRank:

		; play sound
		sfx	sfx_Register

		; load art (rank text)
		move.l	#(ArtUnc_ResultsRank+$24C0)>>1,d1				; 0x4 ($80)
		move.w	#tiles_to_bytes($340),d2
		move.w	#$80/2,d3
		jsr	(Add_To_DMA_Queue).w

		; calc rank art
		moveq	#0,d1
		move.b	(vResults_Total).w,d1								; 70 = B, 71=A

		; get pt.
		lea	.datapt(pc),a1
		moveq	#6-1,d0											; 6 ranks

.nextpt
		cmp.b	(a1)+,d1
		dbls	d0,.nextpt

		; save current rank
		move.b	d0,(vResults_Rank).w

		; load art (rank)
		move.l	#ArtUnc_ResultsRank>>1,d1						; 0x31 ($620)
		mulu.w	#$620/2,d0
		add.l	d0,d1
		move.w	#tiles_to_bytes($300),d2
		move.w	#$620/2,d3
		jsr	(Add_To_DMA_Queue).w

		; set address
		move.l	#$C300C300,d0
		move.w	d0,d2
		addq.w	#1,d2
		swap	d0
		move.w	d2,d0

		; preparing to draw
		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		locVRAM	$C33A,d1
		move.l	#$20002,d3										; set next tiles
		move.l	#vdpCommDelta(planeLocH40(0,1)),d2

		; draw tile (56x56)

	rept 6
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		swap	d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		addq.w	#1,d0
		swap	d0
		addq.w	#1,d0
		add.l	d2,d1
	endr

		; last tiles
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		move.l	d0,VDP_data_port-VDP_data_port(a6)
		add.l	d3,d0
		swap	d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)

		; draw tile (rank text)
		locVRAM	$C23E,VDP_control_port-VDP_control_port(a5)
		move.l	#$C340C341,VDP_data_port-VDP_data_port(a6)		; RA
		move.l	#$C342C343,VDP_data_port-VDP_data_port(a6)		; NK

		; exit
		enableIntsSave
		rts
; ---------------------------------------------------------------------------

.datapt	dc.b 10, 20, 40, 60, 85, 100									; pt. (0-10, 11-20, 21-40, 41-60, 61-85, 86-100)
	even

; ---------------------------------------------------------------------------
; Calc score
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Results_CalcScore:

		; calc time
		moveq	#25,d2											; max pt.
		cmpi.w	#3,(Difficulty_Flag).w								; set max pt. for maniac
		beq.s	.settime
		move.w	#(0*$100)+45,d0									; main time (hours and minutes)
		move.w	d0,d1
		sub.w	(Timer).w,d1										; player time
		bpl.s	.settime

		; bad time
		moveq	#0,d3
		move.b	(Timer_hour).w,d3
		mulu.w	#60,d3
		moveq	#0,d1
		move.b	(Timer_minute).w,d1
		add.w	d1,d3
		sub.w	d0,d3											; 46-45
		sub.w	d3,d2
		bhs.s	.settime
		moveq	#0,d2

.settime
		move.b	d2,(vResults_Timer).w

		; calc death
		moveq	#26,d2											; max pt.
		cmpi.w	#3,(Difficulty_Flag).w								; set max pt. for maniac
		beq.s	.dnotneg
		move.w	(Death_count).w,d1								; 1
;		add.w	d1,d1											; 2
		sub.w	d1,d2											; 26-2
		bhs.s	.dnotneg
		moveq	#0,d2

.dnotneg
		move.b	d2,(vResults_Death).w

		; calc secrets
		moveq	#0,d1
		moveq	#24,d2											; max pt.
		move.b	(TSecrets_count).w,d1								; 4
		add.b	d1,d1											; 8
		cmp.b	d1,d2											; 8 and 24
		bhs.s	.snotmax
		move.b	d2,d1

.snotmax
		move.b	d1,(vResults_Secrets).w

		; calc difficulty
		move.w	(Difficulty_Flag).w,d0
		move.b	.calcdscore(pc,d0.w),(vResults_Difficulty).w

		; calc total
		moveq	#0,d0
		add.b	(vResults_Timer).w,d0
		add.b	(vResults_Death).w,d0
		add.b	(vResults_Secrets).w,d0
		add.b	(vResults_Difficulty).w,d0
		move.b	d0,(vResults_Total).w
		rts
; ---------------------------------------------------------------------------

.calcdscore
		dc.b 0	; Easy
		dc.b 0	; Normal
		dc.b 25	; Hard
		dc.b 25	; Maniac

; ---------------------------------------------------------------------------
; Scroll text (show)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Results_ScrollShowText:
		lea	(vResults_TimeText1).w,a1
		lea	(vResults_ScrollText1).w,a2
		moveq	#5-1,d1

.loop
		subq.w	#1,(a1)+		; wait
		bpl.s	.next
		tst.w	(a2)
		beq.s	.next
		addq.w	#4,(a2)		; scroll

.next
		addq.w	#2,a2
		dbf	d1,.loop
		rts

; ---------------------------------------------------------------------------
; Scroll text
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Results_ScrollText:
		lea	(vResults_ScrollText1).w,a2
		lea	(H_scroll_buffer+(32*4)).w,a1

	rept 4
		move.w	(a2)+,d0		; 1-4
		bsr.s	.scroll
	endr

		move.w	(a2),d0		; 5

.scroll

	rept 32-1
		move.w	d0,(a1)
		addq.w	#4,a1
	endr

		move.w	d0,(a1)
		rts
; ---------------------------------------------------------------------------

PLC_Results: plrlistheader
		plreq 1, ArtKosM_ResultsBGStar
		plreq $128, ArtKosM_ResultsFGText
PLC_Results_end
