; ---------------------------------------------------------------------------
; Assist Warning
; ---------------------------------------------------------------------------

Assist_Line_Count:			= Camera_RAM		; word
Assist_SaveLine_Count:		= Camera_RAM+2	; word
Assist_VCount:				= Camera_RAM+4	; word
Assist_ProcessEnd:			= Camera_RAM+6	; byte

; =============== S U B R O U T I N E =======================================

AssistWarning_Screen:
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
		move.w	#$8B03,(a6)					; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue
		lea	PLC_Assist(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(MapEni_SeizureBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$30,d0
		jsr	(EniDec).w
		copyTilemap	vram_bg, 320, 224
		lea	(MapEni_AssistFG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$3C2,d0
		jsr	(EniDec).w
		copyTilemap	(vram_fg+$1CC), 16, 152
		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w						; load Sonic's palette
		move.w	#-1,(Assist_SaveLine_Count).w
		bsr.w	Assist_DrawText
		lea	Assist_Text1(pc),a1
		locVRAM	$C104,d1
		moveq	#0,d3
		jsr	(Load_PlaneText).w

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		disableInts
		bsr.w	Assist_Process
		bsr.w	Assist_DrawText
		enableInts
		bsr.w	Assist_ControlText
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(Assist_ProcessEnd).w
		beq.s	-
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-
		move.b	#id_Title,(Game_mode).w
		tst.w	(Assist_VCount).w
		beq.s	+
		move.b	#id_Level,(Game_mode).w

;		move.b	#id_Intro,(Game_mode).w
+		rts

; =============== S U B R O U T I N E =======================================

Assist_Process:
		moveq	#0,d0
		move.b	(Object_load_routine).w,d0
		move.w	Assist_Process_Index(pc,d0.w),d0
		jmp	Assist_Process_Index(pc,d0.w)
; ---------------------------------------------------------------------------

Assist_Process_Index: offsetTable
		offsetTableEntry.w  Assist_Process_Check		; 0
		offsetTableEntry.w  Assist_Process_Draw		; 2
; ---------------------------------------------------------------------------

Assist_Process_Check:
		cmpi.w	#10-1,(Assist_Line_Count).w
		bne.s	Assist_Process_Return
		addq.b	#2,(Object_load_routine).w
		st	(Assist_ProcessEnd).w
		lea	Assist_Text2(pc),a1
		locVRAM	$CA84,d1
		moveq	#0,d3
		jsr	(Load_PlaneText).w

Assist_Process_Draw:
		bsr.w	Assist_SetDrawVCount
		bsr.w	Assist_Control

Assist_Process_Return:
		rts

; =============== S U B R O U T I N E =======================================

Assist_ControlText:
		moveq	#10-1,d2
		move.b	(Ctrl_1_pressed).w,d1
		move.w	(Assist_Line_Count).w,d3
		bsr.s	Assist_UpDownControls
		move.w	d3,(Assist_Line_Count).w
		rts

; =============== S U B R O U T I N E =======================================

Assist_Control:
		moveq	#2-1,d2
		move.b	(Ctrl_1_pressed).w,d1
		move.w	(Assist_VCount).w,d3
		bsr.s	Assist_LeftRightControls
		move.w	d3,(Assist_VCount).w
		rts

; =============== S U B R O U T I N E =======================================

Assist_UpDownControls:
		btst	#button_up,d1
		beq.s	+
		tst.w	d3
		beq.s	+
		samp	sfx_WalkingArmorAtk		; Yes/No?
		subq.w	#1,d3
+
		btst	#button_down,d1
		beq.s	+
		cmp.w	d2,d3
		bhs.s	+
		samp	sfx_WalkingArmorAtk		; Yes/No?
		addq.w	#1,d3
		cmp.w	d2,d3
		ble.s	+
		move.w	d2,d3
+
		rts

; =============== S U B R O U T I N E =======================================

Assist_LeftRightControls:
		btst	#button_left,d1
		beq.s	+
		tst.w	d3
		beq.s	+
		samp	sfx_WalkingArmorAtk		; Yes/No?
		subq.w	#1,d3
+
		btst	#button_right,d1
		beq.s	+
		cmp.w	d2,d3
		bhs.s	+
		samp	sfx_WalkingArmorAtk		; Yes/No?
		addq.w	#1,d3
		cmp.w	d2,d3
		ble.s	+
		move.w	d2,d3
+
		rts

; =============== S U B R O U T I N E =======================================

Assist_SetDrawVCount:
		move.w	(Assist_VCount).w,d0
		locVRAM	$CD36,d1
		move.l	#$220000,d2
		moveq	#2-1,d7

Assist_DrawVCount:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		moveq	#0,d3
-		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.b	#47,d3		; Пробел
		cmp.w	d0,d7
		bne.s	+
		move.b	#13,d3		; *
+		move.w	d3,VDP_data_port-VDP_data_port(a6)
		sub.l	d2,d1
		dbf	d7,-
		rts

; =============== S U B R O U T I N E =======================================

Assist_DrawText:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.w	(Assist_Line_Count).w,d0
		cmp.w	(Assist_SaveLine_Count).w,d0
		beq.s	Assist_DrawText_Return
		move.w	d0,(Assist_SaveLine_Count).w
		add.w	d0,d0
		lea	Assist_Text(pc,d0.w),a0
		locVRAM	$C284,d5
		move.l	#$1000000,d2
		moveq	#7-1,d7

.next
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; clear line
		moveq	#0,d0
		moveq	#36-1,d1			; max 37 characters

.clear
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d1,.clear
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; get pos
		move.w	(a0),d0
		lea	(a0,d0.w),a1
		moveq	#36-1,d1		; max 37 characters
		bsr.w	Calculate_TextPosition
		move.l	d5,VDP_control_port-VDP_control_port(a5)
		sub.l	d1,d5

		; load text
.load
		moveq	#0,d0	; VRAM
		move.b	(a1)+,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,.load
		add.l	d2,d5
		addq.w	#2,a0
		dbf	d7,.next

Assist_DrawText_Return:
		rts
; ---------------------------------------------------------------------------

PLC_Assist:
		dc.w ((PLC_Assist_End-PLC_Assist)/6)-1
		plreq 1, ArtKosM_CreditsText
		plreq $30, ArtKosM_SeizureBG
		plreq $3C2, ArtKosM_AssistArrow
PLC_Assist_End
; ---------------------------------------------------------------------------

Assist_Text:
		offsetEntry.w AssistName_Text1
		offsetEntry.w AssistName_Text2
		offsetEntry.w AssistName_Text3
		offsetEntry.w AssistName_Text4
		offsetEntry.w AssistName_Text5
		offsetEntry.w AssistName_Text6
		offsetEntry.w AssistName_Text7
		offsetEntry.w AssistName_Text8
		offsetEntry.w AssistName_Text9
		offsetEntry.w AssistName_Text10
		offsetEntry.w AssistName_Text11
		offsetEntry.w AssistName_Text12
		offsetEntry.w AssistName_Text13
		offsetEntry.w AssistName_Text14
		offsetEntry.w AssistName_Text15
		offsetEntry.w AssistName_Text16

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

AssistName_Text1:		namemstr "Assist Mode contains a number of"
AssistName_Text2:		namemstr "tweaks to the game that reduce"
AssistName_Text3:		namemstr "its difficulty including health"
AssistName_Text4:		namemstr "regeneration and boss HP reduction."
AssistName_Text5:		namemstr " "
AssistName_Text6:		namemstr "Hellfire Saga was created to be a"
AssistName_Text7:		namemstr "challenging but fair game anyone can"
AssistName_Text8:		namemstr "beat with proper strategies. We"
AssistName_Text9:		namemstr "believe the difficulty is a crucial"
AssistName_Text10:		namemstr "part of the experience and strongly"
AssistName_Text11:		namemstr "recommend playing on Normal Mode"
AssistName_Text12:		namemstr "your first time."
AssistName_Text13:		namemstr " "
AssistName_Text14:		namemstr "However, if the difficulty renders"
AssistName_Text15:		namemstr "Hellfire Saga unenjoyable for you,"
AssistName_Text16:		namemstr "we hope Assist Mode can fix that."
	even

Assist_Text1:
		dc.b "              Warning!",-1
	even
Assist_Text2:
		dc.b "    Would you like to play with",$81
		dc.b "            Assist Mode?",$81
		dc.b "        NO               YES",-1
	even

		CHARSET ; reset character set
