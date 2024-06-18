; ---------------------------------------------------------------------------
; Level Select
; ---------------------------------------------------------------------------

; Constants
LevelSelect_Offset:				= *
LevelSelect_VRAM:				= $7B8

; Variables
LevelSelect_ZoneCount:			= 5
LevelSelect_ActFDZCount:			= 4	; FDZ
LevelSelect_ActSCZCount:			= 3	; SCZ
LevelSelect_ActGMZCount:			= 3	; GMZ
LevelSelect_ActDDZCount:			= 3	; DDZ
LevelSelect_ActCRECount:			= 2	; Credits
LevelSelect_DifficultyCount:		= 6
LevelSelect_PhotosensitivityCount:	= LevelSelect_DifficultyCount+1
LevelSelect_MusicTestCount:		= LevelSelect_PhotosensitivityCount+1
LevelSelect_SoundTestCount:		= LevelSelect_MusicTestCount+1
LevelSelect_SampleTestCount:		= LevelSelect_SoundTestCount+1
LevelSelect_MaxCount:			= 11

; RAM
	phase ramaddr(Object_load_addr_front)

vLevelSelect_MusicCount:			ds.w 1
vLevelSelect_SoundCount:			ds.w 1
vLevelSelect_SampleCount:			ds.w 1
vLevelSelect_CtrlTimer:			ds.w 1
vLevelSelect_VCount:				ds.w 1
vLevelSelect_HCount:				ds.w $10

	dephase
	!org	LevelSelect_Offset

; =============== S U B R O U T I N E =======================================

LevelSelect_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.w	#-1,(Previous_zone).w			; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w			; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w			; MJ: restore H-blank address
		disableScreen
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts

		jsr	(ClearScreen).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B03,(a6)					; Command $8B03 - Vscroll full, HScroll line-based
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		clr.b	(Water_full_screen_flag).w
		clr.b	(Water_flag).w
		jsr	(Clear_Palette).w
		clearRAM RAM_start, (RAM_start+$1000)
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		moveq	#0,d0
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Transition_Zone).w
		move.b	d0,(Last_star_post_hit).w
		move.b	d0,(Level_started_flag).w
		move.b	d0,(VilliansMeetingPassed).w
		move.b	d0,(SCZ1_Cutscene).w
		move.b	d0,(Check_dead).w
		move.w	d0,(AstarothCompleted).w
		move.w	d0,(Death_count).w
		move.l	d0,(Timer).w
		move.b	d0,(TSecrets_count).w
		move.b	d0,(Update_HUD_timer).w
		move.b	d0,(Extended_mode).w
		jsr	(Clear_Secrets).l
		ResetDMAQueue

		; load art text
		lea	(ArtKosM_LevelSelectText).l,a1
		move.w	#tiles_to_bytes($7C0),d2
		jsr	(Queue_Kos_Module).w

		; load palette
		lea	(Pal_LevelSelect).l,a1
		lea	(Target_palette).w,a2
		moveq	#32/2-1,d0

.loadpal
		move.l	(a1)+,(a2)+
		dbf	d0,.loadpal
		bsr.w	LevelSelect_LoadText
		move.w	#palette_line_1+LevelSelect_VRAM,d3
		bsr.w	LevelSelect_LoadMainText
		move.w	#palette_line_1,d3
		bsr.w	LevelSelect_MarkFields
		move.w	#palette_line_0+LevelSelect_VRAM,d3
		bsr.w	LevelSelect_MarkFields.difficulty
		move.w	#palette_line_0+LevelSelect_VRAM,d3
		bsr.w	LevelSelect_MarkFields.drawphoto

.waitplc
		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	.waitplc
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Wait_VSync).w
		bsr.w	LevelSelect_Deform
		disableInts
		moveq	#palette_line_0,d3
		bsr.w	LevelSelect_MarkFields
		bsr.w	LevelSelect_Controls
		move.w	#palette_line_1,d3
		bsr.w	LevelSelect_MarkFields
		enableInts
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop
		move.w	(vLevelSelect_VCount).w,d0			; MJ: load V menu position
		cmpi.w	#LevelSelect_ZoneCount,d0			; MJ: is it pointing on a level?
		blo.s	.RunLevel					; MJ: if so, run a level
		bne.s	.loop						; MJ: if it's lower than "Back to title screen", then loop the menu (don't allow start to work)
		move.b	#id_Title,(Game_mode).w				; MJ: set game mode to title screen
		rts							; MJ: return to title...

	.RunLevel:
		move.b	#id_Level,(Game_mode).w		; set screen mode to $04 (level)

		cmpi.w	#$0301,(Current_zone_and_act).w			; MJ: has DDZ act 2 been selected?
		bne.s	.NoDDZ2						; MJ: if not, run normally
		move.b	#id_DDZ_Phase2|$80,(Game_mode).w		; MJ: change game mode to DDZ phase 2 instead of running a level normally ($80 for signifying the boss was entered from level select menu)

	.NoDDZ2:
		cmpi.w	#$0302,(Current_zone_and_act).w			; MJ: has DDZ ending been selected?
		bne.s	.NoDDZ3						; MJ: if not, run normally
		move.b	#id_DDZ_Ending,(Game_mode).w			; MJ: change game mode to DDZ phase 2 ending

	.NoDDZ3:
		cmpi.w	#$0401,(Current_zone_and_act).w			; MJ: has thank you screen been selected?
		bne.s	.NoThanks					; MJ: if not, run normally
		move.b	#id_Thanks,(Game_mode).w			; MJ: change game mode to DDZ phase 2 ending

	.NoThanks:
		rts

; =============== S U B R O U T I N E =======================================

LevelSelect_Controls:

		; set vertical line
		move.w	#LevelSelect_MaxCount-1,d2
		move.w	(vLevelSelect_VCount).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.w	LevelSelect_FindUpDownControls
		move.w	d3,(vLevelSelect_VCount).w

		; check vertical line
		cmpi.w	#LevelSelect_DifficultyCount,d3
		beq.w	LevelSelect_LoadDifficultyNumber
		cmpi.w	#LevelSelect_PhotosensitivityCount,d3
		beq.w	LevelSelect_LoadPhotoNumber
		cmpi.w	#LevelSelect_SampleTestCount,d3
		beq.w	LevelSelect_LoadSampleNumber
		cmpi.w	#LevelSelect_SoundTestCount,d3
		beq.w	LevelSelect_LoadSoundNumber
		cmpi.w	#LevelSelect_MusicTestCount,d3
		beq.s	LevelSelect_LoadMusicNumber
		cmpi.w	#LevelSelect_ZoneCount,d3
		bhs.s	LevelSelect_LoadLevel_Return

		; start new zone
		lea	(vLevelSelect_HCount).w,a0
		move.w	(vLevelSelect_VCount).w,d4
		add.w	d4,d4
		move.w	(a0,d4.w),d3
		move.w	LevelSelect_LoadMaxActs(pc,d4.w),d2
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(a0,d4.w)
		move.w	(vLevelSelect_VCount).w,d2
		move.b	d2,(sp)
		move.w	(sp),d2
		clr.b	d2
		add.w	d2,d3
		move.w	d3,(Current_zone_and_act).w
		move.w	d3,(Transition_Zone).w

LevelSelect_LoadLevel_Return:
		rts
; ---------------------------------------------------------------------------

LevelSelect_LoadMaxActs:
		dc.w LevelSelect_ActFDZCount-1	; FDZ
		dc.w LevelSelect_ActSCZCount-1		; SCZ
		dc.w LevelSelect_ActGMZCount-1	; GMZ
		dc.w LevelSelect_ActDDZCount-1	; DDZ
		dc.w LevelSelect_ActCRECount-1	; Credits
; ---------------------------------------------------------------------------

LevelSelect_LoadDifficultyNumber:
		moveq	#4-1,d2
		move.w	(Difficulty_Flag).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Difficulty_Flag).w
		rts
; ---------------------------------------------------------------------------

LevelSelect_LoadPhotoNumber:
		moveq	#2-1,d2
		move.w	(Seizure_Flag).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(Seizure_Flag).w
		rts
; ---------------------------------------------------------------------------

LevelSelect_LoadMusicNumber:
		move.w	#(LevelSelect_MusicList_End-LevelSelect_MusicList)/2-1,d2
		move.w	(vLevelSelect_MusicCount).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.w	LevelSelect_FindLeftRightControls
		move.w	d3,(vLevelSelect_MusicCount).w

		lea	LevelSelect_MusicList(pc),a0
		bra.s	LevelSelect_LoadSampleMusic
; ---------------------------------------------------------------------------

LevelSelect_LoadSoundNumber:
		move.w	#(LevelSelect_SfxList_End-LevelSelect_SfxList)/2-1,d2
		move.w	(vLevelSelect_SoundCount).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.s	LevelSelect_FindLeftRightControls
		move.w	d3,(vLevelSelect_SoundCount).w

		lea	LevelSelect_SfxList(pc),a0
		bra.s	LevelSelect_LoadSampleMusic
; ---------------------------------------------------------------------------

LevelSelect_LoadSampleNumber:
		move.w	#(LevelSelect_SampleList_End-LevelSelect_SampleList)/2-1,d2
		move.w	(vLevelSelect_SampleCount).w,d3
		lea	(vLevelSelect_CtrlTimer).w,a3
		bsr.s	LevelSelect_FindLeftRightControls
		move.w	d3,(vLevelSelect_SampleCount).w

		lea	LevelSelect_SampleList(pc),a0

LevelSelect_LoadSampleMusic:
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#btnABC,d1
		beq.s	LevelSelect_FindUpDownControls.returnup

		move.w	d3,d0
		add.w	d0,d0
		move.w	(a0,d0.w),d0
		st.b	(ForceMuteYM2612).w
		jmp	dFractalQueue

; ---------------------------------------------------------------------------
; Control (Up/Down)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_FindUpDownControls:
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#btnUD,d1
		beq.s	.notpressed
		move.w	#16,(a3)
		bra.s	.pressed
; --------------------------------------------------------------------------

.notpressed
		move.b	(Ctrl_1_held).w,d1
		andi.b	#btnUD,d1
		beq.s	.returnup
		subq.w	#1,(a3)
		bpl.s	.returnup
		addq.w	#4,(a3)

.pressed
		btst	#button_up,d1
		beq.s	.notdown
		subq.w	#1,d3
		bpl.s	.returnup
		move.w	d2,d3

.returnup
		rts
; ---------------------------------------------------------------------------

.notdown
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s		.returndown
		moveq	#0,d3

.returndown
		rts

; ---------------------------------------------------------------------------
; Control (Left/Right)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_FindLeftRightControls:
		move.b	(Ctrl_1_pressed).w,d1
		andi.b	#btnLR,d1
		beq.s	.notpressed
		move.w	#16,(a3)
		bra.s	.pressed
; --------------------------------------------------------------------------

.notpressed
		move.b	(Ctrl_1_held).w,d1
		andi.b	#btnLR,d1
		beq.s	.returnleft
		subq.w	#1,(a3)
		bpl.s	.returnleft
		addq.w	#4,(a3)

.pressed
		btst	#button_left,d1
		beq.s	.notright
		subq.w	#1,d3
		bpl.s	.returnleft
		move.w	d2,d3

.returnleft
		rts
; ---------------------------------------------------------------------------

.notright
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s		.returnright
		moveq	#0,d3

.returnright
		rts

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadDifficultyText: offsetTable
		offsetTableEntry.w LevelSelect_Easy
		offsetTableEntry.w LevelSelect_Normal
		offsetTableEntry.w LevelSelect_Hard
		offsetTableEntry.w LevelSelect_Maniac

LevelSelect_Easy:		levselstr "EASY  "
LevelSelect_Normal:	levselstr "NORMAL"
LevelSelect_Hard:		levselstr "HARD  "
LevelSelect_Maniac:	levselstr "MANIAC"
; --------------------------------------------------------------------------

LevelSelect_LoadDifficulty:
		add.w	d0,d0
		move.w	LevelSelect_LoadDifficultyText(pc,d0.w),d0
		lea	LevelSelect_LoadDifficultyText(pc,d0.w),a0
		bra.s	LevelSelect_LoadMainText.loadtext

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadBoolean:
		lea	LevelSelect_Yes(pc),a0
		tst.w	d0				; check if boolean was != 0
		bne.s	LevelSelect_LoadMainText.loadtext	; if yes, branch
		lea	LevelSelect_No(pc),a0
		bra.s	LevelSelect_LoadMainText.loadtext
; --------------------------------------------------------------------------

LevelSelect_Yes:	levselstr "YES"
LevelSelect_No:	levselstr "NO "

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadAct:
		locVRAM	$C230,d2
		lea	(vLevelSelect_HCount).w,a0
		move.w	(vLevelSelect_VCount).w,d0
		move.w	d0,d1
		beq.s	.zero
		subq.w	#1,d0

.loop
		addi.l	#vdpCommDelta(planeLocH40(0,2)),d2
		dbf	d0,.loop

.zero
		move.l	d2,VDP_control_port-VDP_control_port(a5)
		add.w	d1,d1
		move.w	(a0,d1.w),d0
		add.w	d1,d1
		add.w	d1,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	LevelSelect_LoadActText(pc,d0.w),d0
		lea	LevelSelect_LoadActText(pc,d0.w),a0
		bra.s	LevelSelect_LoadMainText.loadtext

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadMainText:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		locVRAM	$C080,VDP_control_port-VDP_control_port(a5)
		lea	LevelSelect_MainText(pc),a0

.loadtext
		moveq	#0,d6
		move.b	(a0)+,d6

.copy
		moveq	#0,d0
		move.b	(a0)+,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d6,.copy
		rts
; --------------------------------------------------------------------------

LevelSelect_LoadActText: offsetTable
		offsetTableEntry.w LevelSelect_LoadAct11			; FDZ1
		offsetTableEntry.w LevelSelect_LoadAct12			; FDZ2
		offsetTableEntry.w LevelSelect_LoadAct2			; FDZ3
		offsetTableEntry.w LevelSelect_LoadAct3			; FDZ4

		offsetTableEntry.w LevelSelect_LoadAct1			; SCZ1
		offsetTableEntry.w LevelSelect_LoadAct2			; SCZ2
		offsetTableEntry.w LevelSelect_LoadAct3			; SCZ3
		offsetTableEntry.w LevelSelect_LoadAct4			; SCZ4

		offsetTableEntry.w LevelSelect_LoadAct1			; GMZ1
		offsetTableEntry.w LevelSelect_LoadAct2			; GMZ2
		offsetTableEntry.w LevelSelect_LoadAct3			; GMZ3
		offsetTableEntry.w LevelSelect_LoadAct4			; GMZ4

		offsetTableEntry.w LevelSelect_LoadDDZ1			; DDZ1
		offsetTableEntry.w LevelSelect_LoadDDZ2			; DDZ2
		offsetTableEntry.w LevelSelect_LoadEnding		; DDZ3
		offsetTableEntry.w LevelSelect_LoadAct4			; DDZ4

		offsetTableEntry.w LevelSelect_Credits			; Credits
		offsetTableEntry.w LevelSelect_Thanks			; Thank you for playing screen
; --------------------------------------------------------------------------

LevelSelect_LoadAct1:
		levselstr "ACT 1  "
LevelSelect_LoadAct2:
		levselstr "ACT 2  "
LevelSelect_LoadAct3:
		levselstr "ACT 3  "
LevelSelect_LoadAct4:
		levselstr "ACT 4  "
LevelSelect_LoadDDZ1:
		levselstr "FINALE 1"
LevelSelect_LoadDDZ2:
		levselstr "FINALE 2"
LevelSelect_LoadEnding:
		levselstr "ENDING SCENE"
LevelSelect_LoadAct11:
		levselstr "ACT 1.1"
LevelSelect_LoadAct12:
		levselstr "ACT 1.2"
LevelSelect_MainText:
		levselstr "             *HELLFIRE SAGA LEVEL SELECT SCREEN*                "
LevelSelect_Credits:
		levselstr "CREDITS"
LevelSelect_Thanks:
		levselstr "THANKS SCREEN"
	even

; ---------------------------------------------------------------------------
; Draw line and numbers
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_MarkFields:
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		lea	(RAM_start).l,a4
		lea	LevelSelect_MarkTable(pc),a3
		move.w	(vLevelSelect_VCount).w,d0
		add.w	d0,d0
		lea	(a3,d0.w),a3
		moveq	#0,d0
		move.b	(a3),d0
		mulu.w	#80,d0
		moveq	#0,d1
		move.b	1(a3),d1
		add.w	d1,d0
		lea	(a4,d0.w),a1
		moveq	#0,d1
		move.b	(a3),d1
		lsl.w	#7,d1
		add.b	1(a3),d1
		addi.w	#VRAM_Plane_A_Name_Table,d1
		lsl.l	#2,d1
		lsr.w	#2,d1
		ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
		swap	d1
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		moveq	#320/8-1,d2	; load line

.copy
		move.w	(a1)+,d0
		add.w	d3,d0	; VRAM shift
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d2,.copy

	if LevelSelect_VRAM<>0
		ori.w	#LevelSelect_VRAM,d3
	endif

		; check vertical line
		move.w	(vLevelSelect_VCount).w,d0
		cmpi.w	#LevelSelect_ZoneCount,d0
		blo.w	LevelSelect_LoadAct
		cmpi.w	#LevelSelect_DifficultyCount,d0
		beq.s	.difficulty
		cmpi.w	#LevelSelect_PhotosensitivityCount,d0
		beq.s	.drawphoto
		cmpi.w	#LevelSelect_SoundTestCount,d0
		beq.s	.drawsound
		cmpi.w	#LevelSelect_SampleTestCount,d0
		beq.s	.drawsample
		cmpi.w	#LevelSelect_MusicTestCount,d0
		bne.s	.return

		; draw music
		locVRAM	$CB30,VDP_control_port-VDP_control_port(a5)
		move.w	(vLevelSelect_MusicCount).w,d0
		bra.s	.drawnumbers
; ---------------------------------------------------------------------------

.difficulty
		locVRAM	$C930,VDP_control_port-VDP_control_port(a5)
		move.w	(Difficulty_Flag).w,d0
		bra.w	LevelSelect_LoadDifficulty
; ---------------------------------------------------------------------------

.drawphoto
		locVRAM	$CA30,VDP_control_port-VDP_control_port(a5)
		move.w	(Seizure_Flag).w,d0
		bra.w	LevelSelect_LoadBoolean
; ---------------------------------------------------------------------------

.drawsound
		locVRAM	$CC30,VDP_control_port-VDP_control_port(a5)
		move.w	(vLevelSelect_SoundCount).w,d0
		bra.s	.drawnumbers
; ---------------------------------------------------------------------------

.drawsample
		locVRAM	$CD30,VDP_control_port-VDP_control_port(a5)
		move.w	(vLevelSelect_SampleCount).w,d0

.drawnumbers
		move.b	d0,d2
		lsr.w	#8,d0
		bsr.s	.drawnumber
		move.b	d2,d0
		lsr.b	#4,d0
		bsr.s	.drawnumber
		move.b	d2,d0

.drawnumber
		andi.w	#$F,d0
		cmpi.b	#10,d0
		blo.s	.skipsymbols
		addq.b	#7,d0

.skipsymbols
		addq.b	#8,d0
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)

.return
		rts

; ---------------------------------------------------------------------------
; Deform
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_Deform:
		lea	(RAM_Start).l,a3
		lea	LevelSelectScroll_Data(pc),a2

HScroll_Deform:
		move.w	(a2)+,d6

.loop2
		movea.w	(a2)+,a1
		move.w	(a2)+,d2
		move.w	(a2)+,d5
		ext.l	d2
		asl.l	#8,d2

.loop
		add.l	d2,(a3)
		move.w	(a3)+,(a1)
		addq.w	#4,a1
		addq.w	#2,a3
		dbf	d5,.loop
		dbf	d6,.loop2
		rts
; ---------------------------------------------------------------------------

LevelSelectScroll_Data: dScroll_Header
		dScroll_Data 0, 8, -$100, 8
LevelSelectScroll_Data_End

; ---------------------------------------------------------------------------
; Load text
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

LevelSelect_LoadText:
		lea	LevelSelect_MappingOffsets(pc),a0
		lea	(RAM_start).l,a1
		lea	LevelSelect_Text(pc),a2
		move.w	#LevelSelect_VRAM,d3
		moveq	#LevelSelect_MaxCount-1,d1

.load
		moveq	#0,d2
		move.b	(a2)+,d2	; text size
		move.w	(a0)+,d0	; offset
		lea	(a1,d0.w),a3	; RAM shift

.copy
		moveq	#0,d0
		move.b	(a2)+,d0	; load letter
		add.w	d3,d0
		move.w	d0,(a3)+
		dbf	d2,.copy
		dbf	d1,.load
		copyTilemap	vram_fg, 320, 224, 1
; ---------------------------------------------------------------------------

LevelSelect_MarkTable:

		; 2 bytes per level select entry (ypos, xpos)
		dc.b 4, 0
		dc.b 6, 0
		dc.b 8, 0
		dc.b 10, 0
		dc.b 12, 0
		dc.b 14, 0
		dc.b 18, 0
		dc.b 20, 0
		dc.b 22, 0
		dc.b 24, 0
		dc.b 26, 0

LevelSelect_MappingOffsets:
		dc.w planeLocH28(0,4)
		dc.w planeLocH28(0,6)
		dc.w planeLocH28(0,8)
		dc.w planeLocH28(0,10)
		dc.w planeLocH28(0,12)
		dc.w planeLocH28(0,14)
		dc.w planeLocH28(0,18)
		dc.w planeLocH28(0,20)
		dc.w planeLocH28(0,22)
		dc.w planeLocH28(0,24)
		dc.w planeLocH28(0,26)

LevelSelect_Text:
		levselstr "   FOREST OF DECAY    - ACT 1           "
		levselstr "   SIN CITY           - ACT 1           "
		levselstr "   MALICIOUS GLANCE   - ACT 1           "
		levselstr "   DEVIL/S DESCENT    - FINALE 1        "
		levselstr "   CREDITS SCREEN     - CREDITS         "
		levselstr "   BACK TO TITLE SCREEN                 "
		levselstr "   DIFFICULTY:        - NORMAL          "
		levselstr "   PHOTOSENSITIVITY:  - NO              "
		levselstr "   MUSIC TEST:        - 000             "
		levselstr "   SOUND TEST:        - 000             "
		levselstr "   SAMPLE TEST:       - 000             "
	even
; ---------------------------------------------------------------------------

LevelSelect_MusicList:
		dc.w mus_FDZ1, mus_FDZ2, mus_FDZ3
		dc.w mus_SCZ1, mus_SCZ2, mus_SCZ3
		dc.w mus_GMZ1, mus_GMZ2, mus_GMZ3
		dc.w mus_Microboss, mus_Boss1, mus_Boss2
		dc.w mus_SCZ3Boss, mus_MGZ3Boss, mus_Hellfire
		dc.w mus_Gloam1, mus_Gloam2
		dc.w mus_Title, mus_Invincible
		dc.w mus_ArthurDeath, mus_Notice
		dc.w mus_Through, mus_Credits, mus_FBoss, mus_FinalResults
LevelSelect_MusicList_End:

LevelSelect_SfxList:
		dc.w sfx_RingLeft, sfx_RingRight, sfx_RingLoss
		dc.w sfx_Skid, sfx_Roll, sfx_Jump, sfx_Spindash, sfx_Teleport
		dc.w sfx_Grab, sfx_KnucklesKick, sfx_Splash, sfx_PushBlock
		dc.w sfx_DrownDing, sfx_Drown, sfx_Death, sfx_HitSpikes
		dc.w sfx_BlueShield, sfx_InstaShield, sfx_BubbleShield, sfx_BubbleAttack
		dc.w sfx_FireShield, sfx_FireAttack, sfx_LightShield, sfx_LightAttack
		dc.w sfx_SpikeMove, sfx_BreakItem, sfx_BreakWall, sfx_BreakBridge
		dc.w sfx_HitBoss, sfx_Explosion, sfx_Bomb, sfx_SpecialRumble, sfx_Shake, sfx_ScreenShake
		dc.w sfx_Transform, sfx_Lamppost, sfx_Signpost, sfx_Register, sfx_Start
		dc.w sfx_LavaBall, sfx_FireShot, sfx_FireShow, sfx_PigmanWalk, sfx_Squeak
		dc.w sfx_Spring, sfx_Signal, sfx_SpikeAttack, sfx_SpikeBall, sfx_Bumper
		dc.w sfx_Arthur1, sfx_Arthur2, sfx_Electro, sfx_Electro2, sfx_Activation
		dc.w sfx_Basaran, sfx_CutDown, sfx_LaserBeam, sfx_MickeyAss, sfx_HurtFire
		dc.w sfx_Switch, sfx_SegaKick, sfx_Boom, sfx_Bounce, sfx_Attachment
		dc.w sfx_Tear, sfx_Raid, sfx_Piff, sfx_Pump, sfx_LavaFall, sfx_Magic
		dc.w sfx_Heart, sfx_Magnet, sfx_Fall, sfx_RocketLaunch
LevelSelect_SfxList_End:

LevelSelect_SampleList:
		dc.w sfx_Mwahaha, sfx_WolfAwoo, sfx_WolfDeath, sfx_WolfJump
		dc.w sfx_ArcherArmorAtk, sfx_AstarothDeath, sfx_AxeGhostDeath, sfx_CryPCM
		dc.w sfx_UMK3PCM, sfx_FireDeath, sfx_Fire_Shield, sfx_FireAtkFire
		dc.w sfx_FireHurt, sfx_Thunderclamp, sfx_ThunderLightning
		dc.w sfx_ShaftDeath, sfx_ShaftAttack, sfx_ShaftAttack2, sfx_ShaftAttack3
		dc.w sfx_BossFlame, sfx_GhostDeath, sfx_GhoulDeath
		dc.w sfx_PhantomHand, sfx_WalkingArmorAtk, sfx_WeaselDeath
		dc.w sfx_HeadlissAtk, sfx_HoneyDeath, sfx_HoneyHurt
		dc.w sfx_GluttonySpew, sfx_RainPCM
LevelSelect_SampleList_End:
