; ---------------------------------------------------------------------------
; Sound Test Screen
; ---------------------------------------------------------------------------

; RAM
EQ_Buffer_Values:			= Camera_RAM		; word	; $10 bytes
EQ_Buffer_Keys:				= Camera_RAM+$10	; word	; $20 bytes
MusicPlay_Count:				= Camera_RAM+$30	; word
MusicPlay_Current_Count:		= Camera_RAM+$32	; word
Driver_Control_Text:			= Camera_RAM+$34	; word
ST_PCM1_Timer:				= Camera_RAM+$36	; word
ST_PCM1_Save:				= Camera_RAM+$38	; word
v_ST_ProcessEnd:			= Camera_RAM+$3A	; byte
v_ST_Deform:				= Camera_RAM+$3C	; word
v_ST_FirstPlay:				= Camera_RAM+$3E	; byte

; =============== S U B R O U T I N E =======================================

SoundTest_Screen:
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Camera_RAM, Camera_RAM_End

		lea	(H_scroll_buffer).w,a1
		move.w	#224-1,d6
		move.w	#-5,d0

-		move.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-

		move.w	#1,(V_scroll_value).w
		lea	PLC_SoundTest(pc),a5
		jsr	(LoadPLC_Raw_KosM).w

		lea	(Pal_SoundTest).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(64/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		move.w	#-1,(MusicPlay_Current_Count).w
		clr.b	(v_ST_FirstPlay).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w

		lea	(H_scroll_buffer+2).w,a1
		move.w	#224-1,d6
		moveq	#2,d0

-		add.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-
		cmpi.w	#-98,(H_scroll_buffer+2).w
		bne.s	--

		lea	(Object_RAM).w,a0
		move.l	#Obj_SoundTestBGText,address(a0)
		move.l	#Map_SoundTestBGText,mappings(a0)
		move.w	#$8151,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$230,x_pos(a0)
		move.w	#$144,y_pos(a0)

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_ST_ProcessEnd).w
		beq.s	-
		sf	(v_ST_ProcessEnd).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		jsr	(Render_Sprites).w
		bsr.w	Equalizer_Process
		disableInts
		bsr.w	Equalizer_Update
		bsr.w	Load_DriverText
		enableInts
		bsr.w	SoundTest_Deform
		bsr.w	LoadPlaySound_MusicTest
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-

		disableInts
		dmaFillVRAM 0,$C000,(256<<4)	; clear plane A PNT
		enableInts
		fadeout

		lea	(H_scroll_buffer+2).w,a1
		move.w	#224-1,d6
		move.w	#-98,d0

-		move.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_ST_ProcessEnd).w
		beq.s	-
		sf	(v_ST_ProcessEnd).w

		clearRAM Object_RAM, Object_RAM_End
		clearRAM Camera_RAM, Camera_RAM_End
		lea	PLC_Options(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_Sonic).l,a1
		lea	(Normal_palette_line_1).w,a2
		moveq	#(16/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		lea	(Pal_Options).l,a1
		lea	(Normal_palette_line_2).w,a2
		moveq	#(16/2)-1,d0
		jsr	(PalLoad_Line.loop).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w

ReturnToOptions:
		lea	(H_scroll_buffer+2).w,a1
		move.w	#224-1,d6
		moveq	#2,d0

-		sub.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-

		cmpi.w	#-170,(H_scroll_buffer+2).w
		bne.s	--
		music	mus_Boss2
		command	cmd_Reset
		move.w	#0,(V_scroll_value).w

		lea	(H_scroll_buffer).w,a1
		move.w	#224-1,d6
		moveq	#0,d0

-		move.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-

		bra.w	Options_Screen2

; =============== S U B R O U T I N E =======================================

SoundTest_Deform:
		moveq	#0,d0
		move.w	(v_ST_Deform).w,d0
		beq.s	.deform
		subq.w	#1,(v_ST_Deform).w

.deform
		lea	(H_scroll_buffer+2).w,a1
		move.w	#(224/2)-1,d6

-	rept 2
		move.w	d0,d1
		addi.w	#-98,d1
		move.w	d1,(a1)+
		addq.w	#2,a1
		neg.w	d0
	endm
		dbf	d6,-

SoundTest_Deform_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_SoundTestBGText:
		move.w	#-$400,x_vel(a0)
		move.l	#SoundTestBGText_CheckFrame,address(a0)

SoundTestBGText_CheckFrame:
		cmpi.w	#$1B0,x_pos(a0)
		bge.s	SoundTestBGText_Draw
		addq.b	#1,mapping_frame(a0)
		move.l	#SoundTestBGText_Stop,address(a0)

SoundTestBGText_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	SoundTestBGText_Draw
		clr.w	x_vel(a0)
		st	(v_ST_ProcessEnd).w
		move.l	#SoundTestBGText_CheckStart,address(a0)

SoundTestBGText_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	SoundTestBGText_Draw
		move.l	#SoundTestBGText_CheckFrame2,address(a0)

SoundTestBGText_CheckFrame2:
		subi.w	#$38,x_vel(a0)
		cmpi.w	#$60,x_pos(a0)
		bge.s	SoundTestBGText_Draw
		addq.b	#1,mapping_frame(a0)
		move.l	#SoundTestBGText_Stop2,address(a0)

SoundTestBGText_Stop2:
		subi.w	#$38,x_vel(a0)
		cmpi.w	#-$30,x_pos(a0)
		bge.s	SoundTestBGText_Draw
		clr.w	x_vel(a0)
		move.w	#$17,$2E(a0)
		move.l	#SoundTestBGText_Wait,address(a0)

SoundTestBGText_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	SoundTestBGText_Draw
		st	(v_ST_ProcessEnd).w
		move.l	#Delete_Current_Sprite,address(a0)

SoundTestBGText_Draw:
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Equalizer_Process:
		bsr.w	Equalizer_CopyData
		lea	(EQ_Buffer_Values).w,a0
		lea	(EQ_Buffer_Keys).w,a1
		moveq	#10-1,d7

Equalizer_CurrentKeys:
		tst.b	(v_ST_FirstPlay).w
		beq.s	KeyOff
		tst.b	(a1)
		beq.s	KeyOff

KeyOn:
		addq.b	#2*4,(a0)
		cmpi.b	#80,(a0)
		ble.s	NextKey
		move.b	#80,(a0)
		bra.s	NextKey
; ---------------------------------------------------------------

KeyOff:
		subq.b	#2*4,(a0)
		cmpi.b	#2,(a0)
		bge.s	NextKey
		move.b	#2,(a0)

NextKey:
		addq.w	#1,a0
		addq.w	#1,a1
		dbf	d7,Equalizer_CurrentKeys
		rts

; =============== S U B R O U T I N E =======================================

Equalizer_Channels:
		dc.w mFM1+cTrackFlags, mFM2+cTrackFlags, mFM3o1+cTrackFlags
		dc.w mFM4+cTrackFlags, mFM5+cTrackFlags
		dc.w mFM6+cTrackFlags

		dc.w 0, mDAC1

		dc.w mPSG1+cTrackFlags, mPSG2+cTrackFlags, mPSG3+cTrackFlags
	;	dc.w mPSG4+cTrackFlags
		dc.w 0

Equalizer_CopyData:
		tst.b	(v_ST_FirstPlay).w
		beq.s	.rts

		lea	(EQ_Buffer_Keys).w,a2
		lea	Equalizer_Channels(pc),a3; load channel data table to a3
		move.w	(a3)+,d7		; load next table entry to d7

.loopFM
		move.w	d7,a1			; copy next entry to a1
		clr.b	(a2)+			; clear EQ flag
		tst.b	(a1)			; check if tracker is running
		bpl.s	.fmclear		; if not, branch
		btst	#cfRest,(a1)		; check if resting
		seq	-1(a2)			; if not, set EQ flag, else clear it

.fmclear
		move.w	(a3)+,d7		; load next table entry to d7
		bne.s	.loopFM			; if not zero, loop

; Sample
		clr.b	(a2)+			; clear EQ flag
		move.w	(a3)+,a1		; load dac channel to a1

		tst.b	(a1)
		bpl.s	.doPSG			; ignore if not in use

		btst	#cfCut,(a1)		; check if is cut
		bne.s	.doPSG			; ignore if so
		btst	#cfRest,(a1)		; check if is rest
		bne.s	.doPSG			; ignore if so

		moveq	#4,d1			; check for 4
		moveq	#4,d2			; deformation
		move.b	cLastDelay(a1),d0	; load last delay count

		cmp.b	#20,d0			; check if at least 20 ticks
		bhs.s	.yes			; branch if yes
		moveq	#3,d2			; deformation

		cmp.b	#12,d0			; check if at least 12 ticks
		bhs.s	.yes			; branch if yes
		moveq	#2,d1			; check for 2
		moveq	#2,d2			; deformation

		cmp.b	#6,d0			; check if at least 6 ticks
		bhs.s	.yes			; branch if yes
		moveq	#1,d1			; check for 1

.yes
		sub.b	cDelay(a1),d0		; subtract current delay
		cmp.b	d1,d0			; check if difference is < 4
		bgt.s	.doPSG			; branch if not

		st	-1(a2)			; set EQ flag
		move.w	d2,(v_ST_Deform).w	; enable deformation
; ---------------------------------------------------------------

.doPSG
		move.w	(a3)+,d7		; load next table entry to d7

.loopPSG
		move.w	d7,a1			; copy next entry to a1
		clr.b	(a2)+			; clear EQ flag
		tst.b	(a1)			; check if tracker is running
		bpl.s	.psgclear		; if not, branch
		btst	#cfCut,(a1)		; check if resting
		seq	-1(a2)			; if not, set the flag, else clear it

.psgclear
		move.w	(a3)+,d7		; load next table entry to d7
		bne.s	.loopPSG		; if not zero, loop

.rts
		rts

; =============== S U B R O U T I N E =======================================

Equalizer_Update:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		lea	(EQ_Buffer_Values).w,a1
		locVRAM	$C414,d1
		move.l	#$800000,d2
		move.w	#$38,d3	; VRAM
		moveq	#8*9,d7

DoVertLine:
		movea.w	a1,a0
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		moveq	#10-1,d6

DoChannel:
		moveq	#0,d0
		move.b	(a0)+,d0
		sub.b	d7,d0
		bpl.s	+
		moveq	#0,d0
		bra.s	DispTile

; ---------------------------------------------------------------
+		cmpi.b	#8,d0
		bcs.s	+
		moveq	#4,d0
		bra.s	DispTile

; ---------------------------------------------------------------
+		andi.w	#6,d0
		move.w	EQ_Tiles(pc,d0.w),d0

DispTile:
		add.w	d3,d0
		cmpi.w	#8*5,d7
		bhs.s	+
		ori.w	#$2000,d0
+		cmpi.w	#8*3,d7
		bhs.s	+
		ori.w	#$4000,d0
+		move.l	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,DoChannel
		add.l	d2,d1
		subq.w	#8,d7
		bpl.s	DoVertLine
		rts
; ---------------------------------------------------------------

EQ_Tiles:	dc.w 0, 1, 2, 3

; =============== S U B R O U T I N E =======================================

Control_Text:
		move.b	d1,-(sp)
		moveq	#0,d4
		move.w	(Driver_Control_Text).w,d3
		andi.b	#JoyUpDown,d1
		beq.s	+
		move.w	#$10,d3
		bra.s	++

+		move.b	(Ctrl_1_held).w,d1
		andi.b	#JoyUpDown,d1
		beq.s	Control_Text_Wait
		subq.w	#1,d3
		bpl.s	Control_Text_Wait
		move.w	#3,d3

+		btst	#button_Down,d1
		beq.s	+
		subq.w	#1,d0
		bpl.s	+
		move.w	d2,d0

+		btst	#button_Up,d1
		beq.s	Control_Text_Wait
		addq.w	#1,d0
		cmp.w	d2,d0
		ble.s	Control_Text_Wait
		moveq	#0,d0

Control_Text_Wait:
		move.w	d3,(Driver_Control_Text).w
		move.b	(sp)+,d1

Control_Text_Return:
		rts

; =============== S U B R O U T I N E =======================================

Current_Music_Control:
		move.w	(MusicPlay_Count).w,d0
		btst	#button_Left,d1
		beq.s	+
		subq.w	#1,d0
		bpl.s	+
		move.w	d2,d0

+		btst	#button_Right,d1
		beq.s	+
		addq.w	#1,d0
		cmp.w	d2,d0
		ble.s	+
		moveq	#0,d0

+		bsr.s	Control_Text
		move.w	d0,(MusicPlay_Count).w
		btst	#button_B,d1
		beq.s	Control_Text_Return

Load_DriverText_StopMusic:
		fadeout
		clr.b	(v_ST_FirstPlay).w
		rts

; =============== S U B R O U T I N E =======================================

LoadPlaySound_MusicTest:
		move.w	#(LevelSelect_MusicList_End-LevelSelect_MusicList)/2-1,d2
		move.b	(Ctrl_1_pressed).w,d1
		bsr.w	Current_Music_Control
		andi.b	#JoyAC+JoyLeftRight,d1
		beq.w	Control_Text_Return

		lea	LevelSelect_MusicList(pc),a0
		add.w	d0,d0
		move.w	(a0,d0.w),d0
		st.b	(ForceMuteYM2612).w
		jsr	dFractalQueue
		command	cmd_FadeReset
		st	(v_ST_FirstPlay).w
		rts

; =============== S U B R O U T I N E =======================================

Load_DriverText:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.w	(MusicPlay_Count).w,d0
		cmp.w	(MusicPlay_Current_Count).w,d0
		beq.s	Load_DriverText_Return
		move.w	d0,(MusicPlay_Current_Count).w
		lea	Off_MusicName_Text(pc),a1
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		locVRAM	$C100,d5
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; clear line
		moveq	#0,d0
		moveq	#40-1,d1			; max 40 characters

.clear
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d1,.clear
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; get pos
		moveq	#40-1,d1			; max 40 characters
		bsr.w	Calculate_TextPosition
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; load text
.load
		moveq	#0,d0
		move.b	(a1)+,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,.load

		; load additional text
		lea	Off_MusicAuthor_Text(pc),a1
		move.w	(MusicPlay_Count).w,d0
		add.w	d0,d0
		adda.w	(a1,d0.w),a1
		locVRAM	$C200,d1
		moveq	#0,d3
		jmp	(Load_PlaneText).w
; ---------------------------------------------------------------------------

Load_DriverText_Return:
		rts
; ---------------------------------------------------------------------------
; Calculates the position to display text in the middle of the screen (v2.0)
; Inputs:
; d5 = plane address
; a1 = source address
; Outputs:
; d1 = calculated data
; d5 = calculated plane address
; d6 = text size
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Calculate_TextPosition:

		; calc center position
		moveq	#0,d0
		move.b	(a1)+,d0		; get name size
		move.w	d0,d6
		addq.w	#1,d1		; fix dbf count(-1)
		sub.w	d0,d1
		lsr.w	d1			; even value
		add.w	d1,d1
		swap	d1
		clr.w	d1
		add.l	d1,d5
		rts

; =============== S U B R O U T I N E =======================================

PLC_SoundTest:
		dc.w ((PLC_SoundTest_End-PLC_SoundTest)/6)-1
		plreq 1, ArtKosM_SoundTestText
		plreq $38, ArtKosM_SoundTestEQ
		plreq $151, ArtKosM_SoundTestBGText
PLC_SoundTest_End
; ---------------------------------------------------------------------------

	save
	codepage	MUSICSCREEN
		include "Data/Screens/Sound Test/Text Data/Text.asm"
		include "Data/Screens/Sound Test/Text Data/Text2.asm"
	restore

; ---------------------------------------------------------------------------

		include "Data/Screens/Sound Test/Object data/Map - BG Text.asm"
