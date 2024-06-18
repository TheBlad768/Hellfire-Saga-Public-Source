; ---------------------------------------------------------------------------
; EX Mode
; By TheBlad768 (2023)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

EXMode_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.w	#-1,(Previous_zone).w			; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w			; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w			; MJ: restore H-blank address
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(1<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B00,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue
		lea	PLC_Title(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(MapEni_TitleBGStar).l,a0
		lea	(RAM_start).l,a1
		move.w	#$8030,d0
		jsr	(EniDec).w
		copyTilemap	vram_bg, 320, 224
		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w						; load Sonic's palette

		; clear
		moveq	#0,d0
		move.w	d0,(Death_count).w
		move.l	d0,(Timer).w
		move.b	d0,(TSecrets_count).w
		jsr	(Clear_Secrets).l

.waitplc
		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	.waitplc

		; load text
		lea	EXMode_Text(pc),a1			; normal
		tst.w	(Difficulty_Flag).w
		bne.s	.loadtext
		lea	EXMode_Text2(pc),a1			; assist

.loadtext
		locVRAM	$C104,d1
		move.w	#$8000,d3
		jsr	(Load_PlaneText).w

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		moveq	#id_Level,d0
		tst.w	(Difficulty_Flag).w
		bne.s	.loadgame
		moveq	#id_Title,d0

.loadgame
		move.b	d0,(Game_mode).w
		rts

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', 47
		CHARSET '0','9', 1
		CHARSET 'A','Z', 19
		CHARSET 'a','z', 19
		CHARSET '?', 11
		CHARSET '!', 12
		CHARSET '-', 13
		CHARSET ',', 14
		CHARSET '@', 15
		CHARSET '.', 16
		CHARSET '*', 17
		CHARSET '/', 18

EXMode_Text:
		dc.b "             EXTRA MODE",$82
		dc.b "   This mode allows you to replay",$80
		dc.b " the 3 main zones of Hellfire Saga.",$82
		dc.b "     There are two keys hidden",$80
		dc.b "       within each full stage.",$81
		dc.b "  Your run will be judged based on",$80
		dc.b "      speed, deaths, difficulty",$80
		dc.b "    and number of collected keys.",$80
		dc.b "    Your game will not be saved.",$82
		dc.b "      Getting the perfect rank",$80
		dc.b "   will require multiple attempts.",$82
		dc.b " The world remembers your misdeeds.",$80
		dc.b "       You reap what you sow.",$82
		dc.b "        Press *start* button",-1
	even

EXMode_Text2:
		dc.b "               Notice",$84
		dc.b "   Extra mode is a challenge mode",$80
		dc.b "  that is intended for players who",$80
		dc.b "  have completed the original game",$80
		dc.b "   and want to test their skills.",$82
		dc.b "     Because of that, it is not",$80
		dc.b "      available in Assist mode,",$80
		dc.b "   as it can not be substantially",$80
		dc.b "   adjusted to be more accessible.",$83
		dc.b "         Please change your",$80
		dc.b "       difficulty to proceed.",$83
		dc.b "        Press *start* button",-1
	even

		CHARSET ; reset character set
