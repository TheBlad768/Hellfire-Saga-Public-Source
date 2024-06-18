; ---------------------------------------------------------------------------
; Sega Screen
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Sega_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.w	#-1,(Previous_zone).w			; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w			; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w			; MJ: restore H-blank address
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B00,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		clr.b	(Water_full_screen_flag).w
		clr.b	(Water_flag).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts


	move.b	#id_RedMiso,(Game_mode).w			; MJ: set game mode to red miso screen next
	rts							; MJ: return... no SEGA logo here

		lea	(ArtKosM_Sega).l,a1
		move.w	#tiles_to_bytes(1),d2
		jsr	(Queue_Kos_Module).w
		lea	(MapBG_Sega).l,a0
		lea	(RAM_start).l,a1
		move.w	#$8000,d0
		jsr	EniDec.w
		copyTilemap	$C59C, 98, 32
		btst	#6,(Graphics_flags).w
		bne.s	+	; branch if it isn't a PAL system
		locVRAM	$C5B0
		move.l	#$80308031,(VDP_data_port).l
+		lea	(Pal_Sega).l,a1
		lea	(Target_palette_line_1).w,a2
		moveq	#(16/2)-1,d0
-		move.l	(a1)+,(a2)+
		dbf	d0,-
		move.w	#6*60,(Demo_timer).w			; Set to wait for 3 seconds

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	Pal_FadeFromBlack.w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		bsr.s	AnPal_SegaScreen
		tst.b	(Ctrl_1_pressed).w
		bmi.s	+
		tst.w	(Demo_timer).w
		bne.s	-
+
		move.b	#id_RedMiso,(Game_mode).w			; MJ: set game mode to red miso screen next

	; In-case you're wondering where the debug/title screen/disclaimer
	; settings are, don't panic, they are in the RedMiso screen now:

	; See "Data\Screens\Red Miso\Red Miso.asm"

		rts

; =============== S U B R O U T I N E =======================================

AnPal_SegaScreen:
		subq.w	#1,(PalCycle_Timer).w
		bpl.s	++
		move.w	#2,(PalCycle_Timer).w
		lea	(Pal_SegaAni).l,a0
		move.w	(PalCycle_Frame).w,d0
		addq.w	#2,(PalCycle_Frame).w
		cmpi.w	#$20,(PalCycle_Frame).w
		blo.s	+
		move.w	#0,(PalCycle_Frame).w
+		lea	(a0,d0.w),a1
		lea	(Normal_palette_line_2-4).w,a2
		moveq	#4-1,d0
-		move.w	(a1)+,-(a2)
		move.w	(a1)+,-(a2)
		move.w	(a1)+,-(a2)
		dbf	d0,-
+		rts
