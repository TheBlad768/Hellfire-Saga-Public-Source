; ---------------------------------------------------------------------------
; Dialog
; ---------------------------------------------------------------------------

Dialog_VRAM:				= $500

; Attributes
_Null						= 0
_FDZ1Start					= 2
_FDZ1						= 4
_FDZ2						= 6
_FDZ3						= 8
_FDZ4						= $A
_FDZ4End					= $C
_FDZ4End2					= $E
_FDZ4EndHell				= $10
_FDZ4End3					= $12
_GMZ3						= $14
_NPC						= $16
_DDZStart					= $18
_GMZ1						= $1A
_SCZ1Start1					= $1C
_SCZ1Start2					= $1E
_GMZ3Start					= $20
_SCZ3						= $22
_Credits						= $24

; Misc
_WindowSize:				= 6		; .b

; Dynamic object variables
obDialogWinowsPos:			= $18	; .l
obDialogWinowsSavePos:		= $1C	; .l
obDialogWinowsCom:			= $20	; .w
obDialogTextPointer:			= $30	; .l
obDialogTextSavePointer:		= $34	; .l
obDialogWinowsSize:			= $38	; .b
obDialogWinowsText:			= $39	; .b
obDialogTextLock:			= $3A	; .b
obDialogNoName:				= $3B	; .b

; =============== S U B R O U T I N E =======================================

Obj_Dialog_Process:
		disableInts
		lea	(MapUnc_DialogWindow).l,a1
		copyTilemap2	$8080, $450, 320, 40
		move.w	#$8300+($8000>>10),d0
		move.w	d0,(VDP_windows_save).w
		move.w	d0,VDP_control_port-VDP_data_port(a6)
		enableInts
		lea	PLC_Dialog(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		clr.w	(Normal_palette_line_1+$A).w
		move.w	#$9200,obDialogWinowsCom(a0)
		move.b	#_WindowSize,obDialogWinowsSize(a0)
		move.w	#$4F,$2E(a0)
		move.l	#Dialog_Process_ShowWindow,address(a0)

Dialog_Process_ShowWindow:
		subq.w	#1,$2E(a0)
		bpl.w	Dialog_Process_Return
		move.w	#1,$2E(a0)
		move.w	obDialogWinowsCom(a0),d0
		addq.w	#1,d0
		move.w	d0,obDialogWinowsCom(a0)
		move.w	d0,(VDP_control_port).l
		subq.b	#1,obDialogWinowsSize(a0)
		bne.w	Dialog_Process_Return

Dialog_Process_SetPrint:
		moveq	#0,d0
		movea.l	obDialogTextSavePointer(a0),a1
		move.b	obDialogWinowsText(a0),d0
		add.w	d0,d0
		add.w	d0,d0
		add.w	d0,d0
		adda.w	d0,a1
		moveq	#0,d0
		move.b	(a1),d0
		smi	obDialogNoName(a0)			; -1 = no name

		; clear text
		movem.l	d0/a1,-(sp)
		lea	Dialog_ProcessTextNull(pc),a1
		locVRAM	$810E,d1
		tst.b	d0
		beq.s	.loadtext
		lea	Dialog_ProcessTextNull2(pc),a1
		locVRAM	$8102,d1

.loadtext
		move.w	#$8417,d3
		jsr	(Load_PlaneText).w
		movem.l	(sp)+,d0/a1

		; check name flag
		tst.b	d0
		bmi.s	.loadarttext

		; load name
		add.w	d0,d0
		add.w	d0,d0
		move.l	a1,-(sp)
		lea	DialogName_Process_Index(pc),a1
		movea.l	(a1,d0.w),a1
		locVRAM	$8102,d1
		move.w	#$845F,d3
		jsr	(Load_PlaneText).w
		movea.l	(sp)+,a1

.loadarttext
		move.l	(a1),d0
		andi.l	#$FFFFFF,d0
		move.l	d0,obDialogTextPointer(a0)
		movea.l	-(a1),a1
		move.w	#tiles_to_bytes($45F),d2
		jsr	(Queue_Kos_Module).w

		; set plane pos
		locVRAM	$8110,d0
		tst.b	obDialogNoName(a0)
		beq.s	.setpos
		locVRAM	$8102,d0

.setpos
		move.l	d0,obDialogWinowsPos(a0)
		move.l	d0,obDialogWinowsSavePos(a0)
		move.w	#$F,$2E(a0)
		move.l	#Dialog_Process_CheckPrint,address(a0)

Dialog_Process_CheckPrint:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyABC+JoyStart,d0
		bne.s	Dialog_Process_WaitPrint
		move.l	#Dialog_Process_Print,address(a0)

Dialog_Process_Print:
		move.b	(Ctrl_1_held).w,d0
		andi.b	#JoyABC+JoyStart,d0
		bne.s	Dialog_Process_SkipPrint

Dialog_Process_WaitPrint:
		subq.w	#1,$2E(a0)
		bpl.s	Dialog_Process_Return
		move.w	#1,$2E(a0)

Dialog_Process_SkipPrint:
		move.w	#$417,d3
		bsr.w	Dialog_LoadText
		beq.s	Dialog_Process_Return
		move.l	#Dialog_Process_WaitButton,address(a0)
		subq.b	#1,obDialogWinowsText(a0)
		beq.s	Dialog_Process_SetHideWindow

Dialog_Process_WaitButton:
		tst.b	obDialogTextLock(a0)
		bne.s	Dialog_Process_Return
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#JoyABC+JoyStart,d0
		beq.s	Dialog_Process_Return
		move.l	#Dialog_Process_SetPrint,address(a0)

Dialog_Process_Return:
		rts
; ---------------------------------------------------------------------------

Dialog_Process_SetHideWindow:
		move.b	#_WindowSize,obDialogWinowsSize(a0)
		move.w	#$4F,$2E(a0)
		move.l	#Dialog_Process_HideWindow,address(a0)
		moveq	#0,d0
		move.b	routine(a0),d0
		beq.s	Dialog_Process_HideWindow
		move.w	DialogBefore_Index-2(pc,d0.w),d0
		jsr	DialogBefore_Index(pc,d0.w)

Dialog_Process_HideWindow:
		subq.w	#1,$2E(a0)
		bpl.s	Dialog_Process_Return
		clr.w	$2E(a0)
		tst.l	(CreditsRoutine).w
		beq.s	.NoWait
		cmpi.l	#CRE_RT_MoveOut,(CreditsRoutine).w
		blt.s	Dialog_Process_Return

	.NoWait:
		move.w	#1,$2E(a0)
		move.w	obDialogWinowsCom(a0),d0
		subq.w	#1,d0
		move.w	d0,obDialogWinowsCom(a0)
		move.w	d0,(VDP_control_port).l
		subq.b	#1,obDialogWinowsSize(a0)
		bne.s	Dialog_Process_HideWindow_Return
		move.w	(Target_palette_line_1+$A).w,(Normal_palette_line_1+$A).w
		moveq	#0,d0
		move.b	routine(a0),d0
		beq.s	Dialog_Process_HideWindow_Remove
		movea.w	parent3(a0),a1
		move.w	DialogAfter_Index-2(pc,d0.w),d0
		jsr	DialogAfter_Index(pc,d0.w)

Dialog_Process_HideWindow_Remove:
		move.l	#Delete_Current_Sprite,address(a0)

Dialog_Process_HideWindow_Return:
		rts
; ---------------------------------------------------------------------------

DialogBefore_Index: offsetTable
		offsetTableEntry.w DialogBefore_Null		; 2
		offsetTableEntry.w DialogBefore_Null		; 4
		offsetTableEntry.w DialogBefore_Null		; 6
		offsetTableEntry.w DialogBefore_Null		; 8
		offsetTableEntry.w DialogBefore_Null		; $A
		offsetTableEntry.w DialogBefore_Null		; $C
		offsetTableEntry.w DialogBefore_Null		; $E
		offsetTableEntry.w DialogBefore_Null		; $10
		offsetTableEntry.w DialogBefore_Null		; $12
		offsetTableEntry.w DialogBefore_Null		; $14
		offsetTableEntry.w DialogBefore_Null		; $16
		offsetTableEntry.w DialogBefore_Null		; $18 (_DDZStart)
		offsetTableEntry.w DialogBefore_Null		; $1A
		offsetTableEntry.w DialogBefore_Null		; $1C
		offsetTableEntry.w DialogBefore_Null		; $1E
		offsetTableEntry.w DialogBefore_Null		; $20
		offsetTableEntry.w DialogBefore_Null		; $22
		offsetTableEntry.w DialogBefore_Null		; $24
DialogAfter_Index: offsetTable
		offsetTableEntry.w DialogAfter_FDZ1Start	; 2
		offsetTableEntry.w DialogAfter_FDZ1			; 4
		offsetTableEntry.w DialogAfter_FDZ2		; 6
		offsetTableEntry.w DialogAfter_FDZ1			; 8
		offsetTableEntry.w DialogAfter_FDZ4		; $A
		offsetTableEntry.w DialogAfter_FDZ4End		; $C
		offsetTableEntry.w DialogAfter_FDZ4End2	; $E
		offsetTableEntry.w DialogAfter_FDZ4EndHell	; $10
		offsetTableEntry.w DialogAfter_FDZ4End3	; $12
		offsetTableEntry.w DialogAfter_GMZ3		; $14
		offsetTableEntry.w DialogAfter_NPC			; $16
		offsetTableEntry.w DialogAfter_DDZ			; $18 (_DDZStart)
		offsetTableEntry.w DialogAfter_GMZ1		; $1A
		offsetTableEntry.w DialogAfter_SCZ1Start1	; $1C
		offsetTableEntry.w DialogAfter_SCZ1Start2	; $1E
		offsetTableEntry.w DialogAfter_GMZ3Start	; $20
		offsetTableEntry.w DialogAfter_SCZ3Start	; $22
		offsetTableEntry.w DialogAfter_Credits		; $24
; ---------------------------------------------------------------------------

DialogBefore_Null:
		rts
; ---------------------------------------------------------------------------

DialogAfter_Null:
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ1Start:
		move.l	#Delete_Current_Sprite,(a1)
		addq.b #2,(Dynamic_resize_routine).w
		move.w	#1*60,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ1:
		move.l	#Delete_Current_Sprite,(a1)
		addq.b #2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_GMZ3:
		move.l	#Delete_Current_Sprite,(a1)
		addq.b #2,(Dynamic_resize_routine).w
                rts
; ---------------------------------------------------------------------------

DialogAfter_NPC:
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ2:
		addq.b #2,(Dynamic_resize_routine).w
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_FDZ4:
		addq.b	#2,routine(a1)
		move.w	#1,(DialogueAlreadyShown).w
		move.b	#0,(Lust_Cutscene).w
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,HUD_State.w				; enable HUD
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_FDZ4End:
		move.l	#Obj_Gloamglozer_CutsceneCreateHellGirl,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ4End2:
		addq.b	#2,routine(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ4EndHell:
		move.l	#HellgirlFDZ4_Remove,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_FDZ4End3:
		move.l	#Obj_Gloamglozer_Cutscene_Remove,address(a1)
		rts
; ---------------------------------------------------------------------------

DialogAfter_DDZ:
		addq.b #2,(Dynamic_resize_routine).w
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,HUD_State.w				; enable HUD
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_Credits:
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,HUD_State.w				; enable HUD
		rts						; return

; ---------------------------------------------------------------------------


DialogAfter_GMZ1:
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,(HUD_State).w
		addq.b #2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_SCZ1Start1:
		addq.b #2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_SCZ1Start2:
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		sf	(Ctrl_1_locked).w
		sf	(NoPause_flag).w
		move.b	#1,(HUD_State).w
		addq.b #2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

DialogAfter_SCZ3Start:
		move.b	#1,(Check_dead).w
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,(HUD_State).w
		addq.b #2,(Dynamic_resize_routine).w
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

DialogAfter_GMZ3Start:
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		move.b	#1,(HUD_State).w
		addq.b #2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

ChildObjDat_Dialog_Process:
		dc.w 1-1
		dc.l Obj_Dialog_Process
PLC_Dialog: plrlistheader
		plreq $417, ArtKosM_DialogText
		plreq $450, ArtKosM_DialogWindow
		plreq $45F, ArtKosM_DialogText
PLC_Dialog_End
; ---------------------------------------------------------------------------
; Dialog(Load Text)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Dialog_LoadText:
		disableInts
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		movea.l	obDialogTextPointer(a0),a1
		moveq	#0,d1
		move.l	obDialogWinowsPos(a0),d1	; Plane position
		move.l	#$1000000,d2	; Next line
		move.w	#$8000,d0		; VRAM

Dialog_LoadText_Loop:
		move.l	d1,VDP_control_port-VDP_control_port(a5)
		move.b	(a1)+,d0
		bmi.s	Dialog_LoadText_Set
		add.w	d3,d0
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		move.l	a1,obDialogTextPointer(a0)
		addi.l	#$20000,obDialogWinowsPos(a0)
		enableInts
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

Dialog_LoadText_Set:
		cmpi.b	#-1,d0
		beq.s	Dialog_LoadText_Done
		moveq	#0,d1
		move.l	obDialogWinowsSavePos(a0),d1
		add.l	d2,d1
		move.l	d1,obDialogWinowsPos(a0)
		move.l	d1,obDialogWinowsSavePos(a0)
		bra.s	Dialog_LoadText_Loop
; ---------------------------------------------------------------------------

Dialog_LoadText_Done:
		enableInts
		moveq	#1,d0
		rts

; =============== S U B R O U T I N E =======================================

	; set the character
		CHARSET ' ', 0
		CHARSET '0','9', 1
		CHARSET 'A','Z', 18
		CHARSET 'a','z', 18
		CHARSET '!', 11
		CHARSET '?', 12
		CHARSET '*', 13
		CHARSET ',', 14
		CHARSET '-', 15
		CHARSET '.', 16
		CHARSET ':', 17

DialogName_Process_Index:
		dc.l DialogSonic_ProcessText		; 0
		dc.l DialogGloam_ProcessText		; 1
		dc.l DialogHell_ProcessText		; 2
		dc.l DialogNobody_ProcessText	; 3
		dc.l DialogShaft_ProcessText		; 4
		dc.l DialogSatan_ProcessText		; 5
		dc.l DialogEggman_ProcessText		; 6
		dc.l DialogDialog_ProcessText		; 7
; ---------------------------------------------------------------------------

DialogSonic_ProcessText:
		dc.b "SONIC: ",-1
DialogGloam_ProcessText:
		dc.b "GLOAM: ",-1
DialogHell_ProcessText:
		dc.b "DEATH: ",-1
DialogNobody_ProcessText:
		dc.b "       ",-1
DialogShaft_ProcessText:
		dc.b "SHAFT: ",-1
DialogSatan_ProcessText:
		dc.b "?????: ",-1
DialogEggman_ProcessText:
		dc.b "EGGMAN:",-1
DialogDialog_ProcessText:
		dc.b "GAME:  ",-1
Dialog_ProcessTextNull:
		dc.b "                                 ",$81
		dc.b "                                 ",-1
Dialog_ProcessTextNull2:
		dc.b "                                       ",$81
		dc.b "                                       ",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ1Start_Process_Index:
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1Start_ProcessText4|0<<24	; 4
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1Start_ProcessText3|0<<24	; 3
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1Start_ProcessText2|0<<24	; 2
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1Start_ProcessText1|0<<24	; 1
DialogFDZ1Start_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ1Start_ProcessText1:	; Sonic
		dc.b "Where am I?",$80
		dc.b "How did I get here?", -1
	even
DialogFDZ1Start_ProcessText2:	; Sonic
		dc.b "Hm.", -1
	even
DialogFDZ1Start_ProcessText3:	; Sonic
		dc.b "All I remember is",$80
		dc.b "a bright flash, and then...",-1
	even
DialogFDZ1Start_ProcessText4:	; Sonic
		dc.b "Everything was gone,",$80
		dc.b "and now I*m here.",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ1_Process_Index:
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1_ProcessText10|0<<24	; Sonic
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1_ProcessText9|0<<24	; Sonic
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText8|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText7|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText6|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText5|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText4|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText3|1<<24	; Gloam
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ1_ProcessText2|0<<24	; Sonic
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ1_ProcessText1|1<<24	; Gloam
DialogFDZ1_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ1_ProcessText1:	; Gloam
		dc.b "Not another step, mortal!",-1
	even
DialogFDZ1_ProcessText2:	; Sonic
		dc.b "?!..",-1
	even
DialogFDZ1_ProcessText3:	; Gloam
		dc.b "I am Gloamglozer,",$80
		dc.b "the guardian of the gates!",-1
	even
DialogFDZ1_ProcessText4:	; Gloam
		dc.b "And you... You have been",$80
		dc.b "disturbing my forest.",-1
	even
DialogFDZ1_ProcessText5:	; Gloam
		dc.b "How reckless!",$80
		dc.b "Go no further, peasant.",-1
	even
DialogFDZ1_ProcessText6:	; Gloam
		dc.b "Once you enter the deep woods,",$80
		dc.b "you*re completely doomed!",-1
	even
DialogFDZ1_ProcessText7:	; Gloam
		dc.b "Doomed, I say!",-1
	even
DialogFDZ1_ProcessText8:	; Gloam
		dc.b "This is my domain,",$80
		dc.b "and I*ll be watching. Away!",-1
	even
DialogFDZ1_ProcessText9:	; Sonic
		dc.b "...",-1
	even
DialogFDZ1_ProcessText10:	; Sonic
		dc.b "Well. At least now I know",$80
		dc.b "where I should be going.",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_ProcessText7|1<<24	; 7
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_ProcessText6|1<<24	; 6
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_ProcessText5|1<<24	; 5
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ4_ProcessText4|0<<24	; 4
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ4_ProcessText3|0<<24	; 3
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ4_ProcessText2|0<<24	; 2
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_ProcessText1|1<<24	; 1
DialogFDZ4_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4_ProcessText1:	; Gloam
		dc.b "How dare you defy my orders?!",-1
	even
DialogFDZ4_ProcessText2:	; Sonic
		dc.b "You!",$80
		dc.b "I*ve finally found you!",-1
	even
DialogFDZ4_ProcessText3:	; Sonic
		dc.b "What happened to my world?!",$80
		dc.b "Where are my friends?!",-1
	even
DialogFDZ4_ProcessText4:	; Sonic
		dc.b "Answer me!",-1
	even
DialogFDZ4_ProcessText5:	; Gloam
		dc.b "W-What are you talking about?",$80
		dc.b "And...",-1
	even
DialogFDZ4_ProcessText6:	; Gloam
		dc.b "You have the gall to yell",$80
		dc.b "at me?! I am the Guardian!",-1
	even
DialogFDZ4_ProcessText7:	; Gloam
		dc.b "Now you*ve crossed the line.",$80
		dc.b "No mercy!",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4End_Process_Index:
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogFDZ4End_ProcessText2|0<<24	; 2
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4End_ProcessText1|1<<24		; 1
DialogFDZ4End_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4End_ProcessText1:	; Gloam
		dc.b "!!!",-1
DialogFDZ4End_ProcessText2:	; Sonic
		dc.b "Hey!",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4End2_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4End2_ProcessText1|1<<24	; 1
DialogFDZ4End2_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4End2_ProcessText1:	; Gloam
		dc.b "Enough!",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4EndHell_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText13|1<<24	; Gloam
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText12|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText11|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText10|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText9|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText8|2<<24	; Death
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText7|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText6|1<<24	; Gloam
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText5|2<<24	; Death
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText4|1<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText3|1<<24	; Gloam
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogFDZ4EndHell_ProcessText2|2<<24	; Death
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4EndHell_ProcessText1|1<<24	; Gloam
DialogFDZ4EndHell_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4EndHell_ProcessText1:	; Gloam
		dc.b "Oh no... It*s him...",-1
	even
DialogFDZ4EndHell_ProcessText2:	; Death
		dc.b "Did you not hear what",$80
		dc.b "I said, Gloamglozer?",-1
	even
DialogFDZ4EndHell_ProcessText3:	; Gloam
		dc.b "B-But... We shouldn*t let",$80
		dc.b "a mortal in!",-1
	even
DialogFDZ4EndHell_ProcessText4:	; Gloam
		dc.b "That*s what the rules say!",-1
	even
DialogFDZ4EndHell_ProcessText5:	; Death
		dc.b "Have you already",$80
		dc.b "forgotten who*s in charge?",-1
	even
DialogFDZ4EndHell_ProcessText6:	; Gloam
		dc.b "...",-1
	even
DialogFDZ4EndHell_ProcessText7:	; Gloam
		dc.b "No, sir.",-1
	even
DialogFDZ4EndHell_ProcessText8:	; Death
		dc.b "Precisely.",-1
	even
DialogFDZ4EndHell_ProcessText9:	; Death
		dc.b "How long has it been since",$80
		dc.b "we*ve seen a mortal...",-1
	even
DialogFDZ4EndHell_ProcessText10:	; Death
		dc.b "descend this far?",-1
	even
DialogFDZ4EndHell_ProcessText11:	; Death
		dc.b "What a fascinating specimen!",$80
		dc.b "I want myself a show!",-1
	even
DialogFDZ4EndHell_ProcessText12:	; Death
		dc.b "Let him into the City.",-1
	even
DialogFDZ4EndHell_ProcessText13:	; Gloam
		dc.b "Understood.",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4End3_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4End3_ProcessText1|1<<24	; 1
DialogFDZ4End3_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4End3_ProcessText1:	; Gloam
		dc.b "Don*t say I haven*t warned you.",$80
		dc.b "Out of my sight, now.",-1
	even
; ---------------------------------------------------------------------------

DialogFDZ4_EX_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_EX_ProcessText5|1<<24	; 5
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_EX_ProcessText4|1<<24	; 4
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_EX_ProcessText3|1<<24	; 3
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_EX_ProcessText2|1<<24	; 2
		dc.l ArtKosM_DialogTextRed
		dc.l DialogFDZ4_EX_ProcessText1|1<<24	; 1
DialogFDZ4_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogFDZ4_EX_ProcessText1:	; Gloam
		dc.b "You!",$80
		dc.b "We*ve fought before, haven*t we?",-1
	even
DialogFDZ4_EX_ProcessText2:	; Gloam
		dc.b "We*ve fought countless times!",-1
	even
DialogFDZ4_EX_ProcessText3:	; Gloam
		dc.b "And yet here you are.",$80
		dc.b "Breaking into the city again.",-1
	even
DialogFDZ4_EX_ProcessText4:	; Gloam
		dc.b "You pest!",-1
	even
DialogFDZ4_EX_ProcessText5:	; Gloam
		dc.b "Just how in the world",$80
		dc.b "do you keep coming here?!",-1
	even
; ---------------------------------------------------------------------------

DialogSCZ1Start1_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText7|2<<24	; 7
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText6|2<<24	; 6
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText5|2<<24	; 5
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogSCZ1Start1_ProcessText4|0<<24	; 4
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText3|2<<24	; 3
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText2|2<<24	; 2
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_ProcessText1|2<<24	; 1
DialogSCZ1Start1_Process_Index_End
; ---------------------------------------------------------------------------

DialogSCZ1Start1_ProcessText1:	; Death
		dc.b "Hello, mortal.",$80
		dc.b "I am Death.",-1
	even

DialogSCZ1Start1_ProcessText2:	; Death
		dc.b "Welcome to the",$80
		dc.b "Capital of Sin.",-1
	even

DialogSCZ1Start1_ProcessText3:	; Death
		dc.b "Your first venture into",$80
		dc.b "Hell proper!",-1
	even

DialogSCZ1Start1_ProcessText4:	; Sonic
		dc.b "Why did you save me?",$80
		dc.b "What do you want?",-1
	even

DialogSCZ1Start1_ProcessText5:	; Death
		dc.b "Save you?",$80
		dc.b "Don*t be absurd.",-1
	even

DialogSCZ1Start1_ProcessText6:	; Death
		dc.b "You*re not just a competent",$80
		dc.b "fighter, you*re also funny!",-1
	even

DialogSCZ1Start1_ProcessText7:	; Death
		dc.b "I like you more every minute.",-1
	even
; ---------------------------------------------------------------------------

DialogSCZ1Start2_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start2_ProcessText2|2<<24	; 2
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start2_ProcessText1|2<<24	; 1
DialogSCZ1Start2_Process_Index_End
; ---------------------------------------------------------------------------

DialogSCZ1Start2_ProcessText1:	; Death
		dc.b "I have an array of challengers",$80
		dc.b "lined up for you.",-1
	even

DialogSCZ1Start2_ProcessText2:	; Death
		dc.b "I*m sure you*ll enjoy it!",$80
		dc.b "Let*s see how you fare!",-1
	even
; ---------------------------------------------------------------------------

DialogSCZ1Start1_EX_Process_Index:
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogSCZ1Start1_EX_ProcessText4|0<<24	; 4
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_EX_ProcessText3|2<<24	; 3
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_EX_ProcessText2|2<<24	; 2
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start1_EX_ProcessText1|2<<24	; 1
DialogSCZ1Start1_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogSCZ1Start1_EX_ProcessText1:	; Death
		dc.b "It*s you again!",-1
	even

DialogSCZ1Start1_EX_ProcessText2:	; Death
		dc.b "You know...",$80
		dc.b "You*ve made me quite happy.",-1
	even

DialogSCZ1Start1_EX_ProcessText3:	; Death
		dc.b "Tormenting those immune",$80
		dc.b "to death is such a pleasure!",-1
	even

DialogSCZ1Start1_EX_ProcessText4:	; Sonic
		dc.b "...",-1
	even

; ---------------------------------------------------------------------------

DialogSCZ1Start2_EX_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start2_EX_ProcessText2|2<<24	; 2
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogSCZ1Start2_EX_ProcessText1|2<<24	; 1
DialogSCZ1Start2_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogSCZ1Start2_EX_ProcessText1:	; Death
		dc.b "What?",$80
		dc.b "You don*t agree?",-1
	even

DialogSCZ1Start2_EX_ProcessText2:	; Death
		dc.b "Well would you look at that!",$80
		dc.b "Fascinating...",-1
	even
; ---------------------------------------------------------------------------

DialogDeathSCZ3_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText8|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText7|2<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogDeathSCZ3_ProcessText6|0<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText5|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText4|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText3|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText2|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_ProcessText1|2<<24
DialogDeathSCZ3_Process_Index_End
; ---------------------------------------------------------------------------

DialogDeathSCZ3_ProcessText1:	; Death
		dc.b "You*re still here!",-1
		even

DialogDeathSCZ3_ProcessText2:	; Death
		dc.b "I expected you*d be",$80
		dc.b "long gone by now!", -1
		even

DialogDeathSCZ3_ProcessText3:	; Death
		dc.b "I*m impressed.",$80
		dc.b "You*re a real warrior.", -1
		even

DialogDeathSCZ3_ProcessText4:	; Death
		dc.b "You*ve provided me with",$80
		dc.b "some good entertainment.", -1
		even

DialogDeathSCZ3_ProcessText5:	; Death
		dc.b "But... I don*t have anything",$80
		dc.b "more for you here.", -1
		even

DialogDeathSCZ3_ProcessText6:	; Sonic
		dc.b "What do you mean?",-1
		even

DialogDeathSCZ3_ProcessText7:	; Death
		dc.b "You*ve reached the end of",$80
		dc.b "the line, my friend.", -1
		even

DialogDeathSCZ3_ProcessText8:	; Death
		dc.b "I*ll make this quick.",$80
		dc.b "I have other things to do.", -1
		even
; ---------------------------------------------------------------------------

DialogDeathSCZ3_EX_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText7|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText6|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText5|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText4|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText3|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText2|2<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDeathSCZ3_EX_ProcessText1|2<<24
DialogDeathSCZ3_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogDeathSCZ3_EX_ProcessText1:	; Death
		dc.b "Hey. That deal with us",$80
		dc.b "you*ve made forever ago.",-1
		even

DialogDeathSCZ3_EX_ProcessText2:	; Death
		dc.b "Is is working out for you?",-1
		even

DialogDeathSCZ3_EX_ProcessText3:	; Death
		dc.b "...",-1
		even

DialogDeathSCZ3_EX_ProcessText4:	; Death
		dc.b "You don*t even bother",$80
		dc.b "to answer anymore. I see.",-1
		even

DialogDeathSCZ3_EX_ProcessText5:	; Death
		dc.b "You know. One day, you*ll stop",$80
		dc.b "paying attention entirely.",-1
		even

DialogDeathSCZ3_EX_ProcessText6:	; Death
		dc.b "I*m not tiring out",$80
		dc.b "any time soon, though!",-1
		even

DialogDeathSCZ3_EX_ProcessText7:	; Death
		dc.b "Are you up",$80
		dc.b "for one more round?", -1
		even
; ---------------------------------------------------------------------------

DialogMGZ1Shaft_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText7|4<<24	; 6
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText6|4<<24	; 6
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText5|4<<24	; 5
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText4|4<<24	; 4
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText3|4<<24	; 3
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogMGZ1Shaft_ProcessText2|0<<24	; 2
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_ProcessText1|4<<24	; 1
DialogMGZ1Shaft_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ1Shaft_ProcessText1:		; Shaft
		dc.b "Hello, Sonic.",$80
		dc.b "Welcome to Devil*s Castle.",-1
	even
DialogMGZ1Shaft_ProcessText2:		; Sonic
		dc.b "How do you know my name?",-1
	even
DialogMGZ1Shaft_ProcessText3:		; Shaft
		dc.b "My master knows a lot",$80
		dc.b "about your kind.",-1
	even
DialogMGZ1Shaft_ProcessText4:		; Shaft
		dc.b "I*ve been watching you",$80
		dc.b "for a while now.",-1
	even
DialogMGZ1Shaft_ProcessText5:		; Shaft
		dc.b "Your fighting prowess",$80
		dc.b "is quite admirable.",-1
	even
DialogMGZ1Shaft_ProcessText6:		; Shaft
		dc.b "However, I*ve been",$80
		dc.b "ordered to stop you.",-1
	even
DialogMGZ1Shaft_ProcessText7:		; Shaft
		dc.b "Prepare for an onslaught.",-1
	even
; ---------------------------------------------------------------------------

DialogMGZ1Shaft_EX_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText6|4<<24	; 6
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText5|4<<24	; 5
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText4|4<<24	; 4
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText3|4<<24	; 3
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText2|4<<24	; 2
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ1Shaft_EX_ProcessText1|4<<24	; 1
DialogMGZ1Shaft_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ1Shaft_EX_ProcessText1:		; Shaft
		dc.b "...I see. You*re back.",-1
	even
DialogMGZ1Shaft_EX_ProcessText2:		; Shaft
		dc.b "I take it last time wasn*t",$80
		dc.b "good enough. I pity you.",-1
	even
DialogMGZ1Shaft_EX_ProcessText3:		; Shaft
		dc.b "It pains me too.",-1
	even
DialogMGZ1Shaft_EX_ProcessText4:		; Shaft
		dc.b "Once, I was your most",$80
		dc.b "loyal servant. And now...",-1
	even
DialogMGZ1Shaft_EX_ProcessText5:		; Shaft
		dc.b "...",-1
	even
DialogMGZ1Shaft_EX_ProcessText6:		; Shaft
		dc.b "Let*s just",$80
		dc.b "get this over with.",-1
	even
; ---------------------------------------------------------------------------

DialogMGZ3ShaftStart_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText10|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText9|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText8|4<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogMGZ3ShaftStart_ProcessText7|0<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogMGZ3ShaftStart_ProcessText6|0<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogMGZ3ShaftStart_ProcessText5|0<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText4|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText3|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText2|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_ProcessText1|4<<24
DialogMGZ3ShaftStart_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ3ShaftStart_ProcessText1:		; Shaft
		dc.b "So my calculations were true.",$80
		dc.b "Your power is exceptional.",-1
	even
DialogMGZ3ShaftStart_ProcessText2:		; Shaft
		dc.b "I don*t believe I can stop you,",$80
		dc.b "But I can still delay you.",-1
	even
DialogMGZ3ShaftStart_ProcessText3:		; Shaft
		dc.b "If it means I can buy my",$80
		dc.b "master more time...",-1
	even
DialogMGZ3ShaftStart_ProcessText4:		; Shaft
		dc.b "...I*ll gladly face",$80
		dc.b "my demise.",-1
	even
DialogMGZ3ShaftStart_ProcessText5:		; Sonic
		dc.b "Hey. This shouldn*t be",$80
		dc.b "how it ends.",-1
	even
DialogMGZ3ShaftStart_ProcessText6:		; Sonic
		dc.b "I*m going to save the world.",$80
		dc.b "I*m going to save my friends.",-1
	even
DialogMGZ3ShaftStart_ProcessText7:		; Sonic
		dc.b "And I*m going to save you!",$80
		dc.b "Just let me through. Please.",-1
	even
DialogMGZ3ShaftStart_ProcessText8:		; Shaft
		dc.b "...",-1
	even
DialogMGZ3ShaftStart_ProcessText9:		; Shaft
		dc.b "No. This is not an option.",$80
		dc.b "I swore an oath to my master.",-1
	even
DialogMGZ3ShaftStart_ProcessText10:		; Shaft
		dc.b "Goodbye, Sonic.",$80
		dc.b "It was an honor.",-1
	even
; ---------------------------------------------------------------------------

DialogMGZ3ShaftStart_EX_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText6|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText5|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText4|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText3|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText2|4<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3ShaftStart_EX_ProcessText1|4<<24
DialogMGZ3ShaftStart_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ3ShaftStart_EX_ProcessText1:		; Shaft
		dc.b "I see the sorrow in your eyes.",-1
	even
DialogMGZ3ShaftStart_EX_ProcessText2:		; Shaft
		dc.b "You are cast into the body",$80
		dc.b "of the one you hate the most...",-1
	even
DialogMGZ3ShaftStart_EX_ProcessText3:		; Shaft
		dc.b "Forced to walk his path",$80
		dc.b "again and again...",-1
	even
DialogMGZ3ShaftStart_EX_ProcessText4:		; Shaft
		dc.b "...facing harsh judgement",$80
		dc.b "every time.",-1
	even
DialogMGZ3ShaftStart_EX_ProcessText5:		; Sonic
		dc.b "I do what I must, but",$80
		dc.b "I want you to know.",-1
	even
DialogMGZ3ShaftStart_EX_ProcessText6:		; Shaft
		dc.b "For your sake. I hope",$80
		dc.b "this time will be the last.",-1
	even
; ---------------------------------------------------------------------------

DialogMGZ3Shaft_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3Shaft_ProcessText1|4<<24
DialogMGZ3Shaft_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ3Shaft_ProcessText1:		; Shaft
		dc.b "My master...",$80
		dc.b "I*m sorry...",-1
	even
; ---------------------------------------------------------------------------

DialogMGZ3Shaft_EX_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogMGZ3Shaft_EX_ProcessText1|4<<24
DialogMGZ3Shaft_EX_Process_Index_End
; ---------------------------------------------------------------------------

DialogMGZ3Shaft_EX_ProcessText1:		; Shaft
		dc.b "Doctor...",$80
		dc.b "You must endure...",-1
	even
; ---------------------------------------------------------------------------

DialogDDZStart_Process_Index:
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText17|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText16|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText15|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText14|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText13|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText12|6<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogDDZStart_ProcessText11|0<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText10|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText9|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText8|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText7|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText6|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText5|6<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogDDZStart_ProcessText4|0<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText3|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZStart_ProcessText2|6<<24
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogDDZStart_ProcessText1|0<<24
DialogDDZStart_Process_Index_End
; ---------------------------------------------------------------------------

DialogDDZStart_ProcessText1:
		dc.b "Eggman!",-1
		even
DialogDDZStart_ProcessText2:
		dc.b " I knew you*d come. I knew it!",$80
		dc.b " Even if I was expecting you...",-1
		even
DialogDDZStart_ProcessText3:
		dc.b " ...much later than this.",-1
		even
DialogDDZStart_ProcessText4:
		dc.b "What are you doing here?",-1
		even
DialogDDZStart_ProcessText5:
		dc.b " I*m here to take over",$80
		dc.b " the world! What else?",-1
		even
DialogDDZStart_ProcessText6:
		dc.b " After countless defeats at",$80
		dc.b " your hands, I felt...",-1
		even
DialogDDZStart_ProcessText7:
		dc.b " Humiliated. Destroyed.",$80
		dc.b " I had to do something.",-1
		even
DialogDDZStart_ProcessText8:
		dc.b " In my desperation, I made",$80
		dc.b " a deal with the devil.",-1
		even
DialogDDZStart_ProcessText9:
		dc.b " He gave me the throne of Hell,",$80
		dc.b " imprisoning all your friends.",-1
		even
DialogDDZStart_ProcessText10:
		dc.b " And I*m the one who*s",$80
		dc.b " going to rule it all.",-1
		even
DialogDDZStart_ProcessText11:
		dc.b "You*re not going to",$80
		dc.b "get away with it!",-1
		even
DialogDDZStart_ProcessText12:
		dc.b " Oh, I*m not going to",$80
		dc.b " get away with it?",-1
		even
DialogDDZStart_ProcessText13:
		dc.b " I*m going to get away",$80
		dc.b " with it in style!",-1
		even
DialogDDZStart_ProcessText14:
		dc.b " This machine embodies the",$80
		dc.b " power of the devil himself...",-1
		even
DialogDDZStart_ProcessText15:
		dc.b " ...infused with my",$80
		dc.b " brilliant mind.",-1
		even
DialogDDZStart_ProcessText16:
		dc.b " Even though it*s not ready yet,",$80
		dc.b " I*ll show you what it can do!",-1
		even
DialogDDZStart_ProcessText17:
		dc.b " Say your prayers, hedgehog!",-1
		even
; ---------------------------------------------------------------------------

DialogDDZEnd_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDDZEnd_ProcessText6|5<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZEnd_ProcessText5|6<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDDZEnd_ProcessText4|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDDZEnd_ProcessText3|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogDDZEnd_ProcessText2|5<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogDDZEnd_ProcessText1|6<<24
DialogDDZEnd_Process_Index_End
; ---------------------------------------------------------------------------

DialogDDZEnd_ProcessText1:
		dc.b " How could it end like this?!",$80
		dc.b " I was so close!",-1
	even
DialogDDZEnd_ProcessText2:
		dc.b "You were close, but not",$80
		dc.b "close enough.",-1
	even
DialogDDZEnd_ProcessText3:
		dc.b "I gave you everything.",$80
		dc.b "My army, my power...",-1
	even
DialogDDZEnd_ProcessText4:
		dc.b "And yet you still failed.",$80
		dc.b "You*re pathetic.",-1
	even
DialogDDZEnd_ProcessText5:
		dc.b " Oh god, no!",$80
		dc.b " Give me another chance!",-1
	even
DialogDDZEnd_ProcessText6:
		dc.b "No. You*ve had your chance.",$80
		dc.b "Your fate is now sealed.",-1
	even
; ---------------------------------------------------------------------------

DialogCredits_Process_Index:
		dc.l ArtKosM_DialogTextBlue
		dc.l DialogCredits_ProcessText1|7<<24
DialogCredits_Process_Index_End
; ---------------------------------------------------------------------------

DialogCredits_ProcessText1:
		dc.b " Writing by pixelcat,",$80
		dc.b " Hotmilk and DetlaWooloo!",-1
	even
; ---------------------------------------------------------------------------

DialogEnding_Good_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText15|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText14|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText13|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText12|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText11|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText10|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText9|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText8|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText7|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText6|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText5|(-1)<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText4|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText3|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText2|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Good_ProcessText1|5<<24
DialogEnding_Good_Process_Index_End

DialogEnding_Bad_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Bad_ProcessText6|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Bad_ProcessText5|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Bad_ProcessText4|5<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogEnding_Bad_ProcessText3|6<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogEnding_Bad_ProcessText2|6<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Bad_ProcessText1|5<<24
DialogEnding_Bad_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_DiffC_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DiffC_ProcessText2|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DiffC_ProcessText1|5<<24
DialogEnding_DiffC_Process_Index_End

DialogEnding_DiffB_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DiffB_ProcessText1|5<<24
DialogEnding_DiffB_Process_Index_End

DialogEnding_DiffA_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DiffA_ProcessText2|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DiffA_ProcessText1|5<<24
DialogEnding_DiffA_Process_Index_End
; ---------------------------------------------------------------------------

;DialogEnding_Finally_Process_Index:
;		dc.l ArtKosM_DialogTextOrange
;		dc.l DialogEnding_Finally_ProcessText1|5<<24
;DialogEnding_Finally_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_KeysC_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Finally_ProcessText1|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_KeysC_ProcessText2|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_KeysC_ProcessText1|5<<24
DialogEnding_KeysC_Process_Index_End

DialogEnding_KeysB_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Finally_ProcessText1|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_KeysB_ProcessText1|5<<24
DialogEnding_KeysB_Process_Index_End

DialogEnding_KeysA_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Finally_ProcessText1|5<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_KeysA_ProcessText1|5<<24
DialogEnding_KeysA_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_DeathsC_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DeathsC_ProcessText1|5<<24
DialogEnding_DeathsC_Process_Index_End

DialogEnding_DeathsB_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DeathsB_ProcessText1|5<<24
DialogEnding_DeathsB_Process_Index_End

DialogEnding_DeathsA_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_DeathsA_ProcessText1|5<<24
DialogEnding_DeathsA_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_TimeC_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_TimeC_ProcessText1|5<<24
DialogEnding_TimeC_Process_Index_End

DialogEnding_TimeB_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_TimeB_ProcessText1|5<<24
DialogEnding_TimeB_Process_Index_End

DialogEnding_TimeA_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_TimeA_ProcessText1|5<<24
DialogEnding_TimeA_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_Beginning_Process_Index:
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Beginning_ProcessText3|5<<24
		dc.l ArtKosM_DialogTextRed
		dc.l DialogEnding_Beginning_ProcessText2|6<<24
		dc.l ArtKosM_DialogTextOrange
		dc.l DialogEnding_Beginning_ProcessText1|5<<24
DialogEnding_Beginning_Process_Index_End
; ---------------------------------------------------------------------------

DialogEnding_Beginning_ProcessText1:
		dc.b "You*ve arrived.",-1
	even

DialogEnding_Beginning_ProcessText2:
		dc.b " Yes.",-1
	even

DialogEnding_Beginning_ProcessText3:
		dc.b "Let*s see how you did.",-1
	even

DialogEnding_TimeA_ProcessText1:
		dc.b "You took your time.",-1
	even

DialogEnding_TimeB_ProcessText1:
		dc.b "You were quite quick, but...",$80
		dc.b "could*ve done better.",-1
	even

DialogEnding_TimeC_ProcessText1:
		dc.b "You truly embodied your",$80
		dc.b "enemy*s swiftness. Impressive.",-1
	even

DialogEnding_DeathsA_ProcessText1:
		dc.b "I*ve had to resurrect you",$80
		dc.b "a lot.",-1
	even

DialogEnding_DeathsB_ProcessText1:
		dc.b "I*ve had to resurrect you",$80
		dc.b "at some points.",-1
	even

DialogEnding_DeathsC_ProcessText1:
		dc.b "I didn*t have to resurrect you",$80
		dc.b "at all this time.",-1
	even

DialogEnding_KeysA_ProcessText1:
		dc.b "You haven*t gathered",$80
		dc.b "any keys.",-1
	even

DialogEnding_KeysB_ProcessText1:
		dc.b "You*ve brought a few keys,",$80
		dc.b "yet missed some.",-1
	even

DialogEnding_KeysC_ProcessText1:
		dc.b "You*ve scoured the entire",$80
		dc.b "underworld...",-1
	even

DialogEnding_KeysC_ProcessText2:
		dc.b "...and found all the keys.",-1
	even

DialogEnding_Finally_ProcessText1:
		dc.b "And finally...",-1
	even

DialogEnding_DiffA_ProcessText1:
		dc.b "You didn*t have it in you,",$80
		dc.b "so you*ve asked Hell...",-1
	even

DialogEnding_DiffA_ProcessText2:
		dc.b "to go easier on you.",-1
	even

DialogEnding_DiffB_ProcessText1:
		dc.b "You*ve had the courage to",$80
		dc.b "face Hell at its fiercest.",-1
	even

DialogEnding_DiffC_ProcessText1:
		dc.b "You*ve opened up your heart",$80
		dc.b "and faced Hell...",-1
	even

DialogEnding_DiffC_ProcessText2:
		dc.b "...at your most fragile.",$80
		dc.b "I am truly impressed.",-1
	even

DialogEnding_Bad_ProcessText1:
		dc.b "You did well.",$80
		dc.b "And yet, you can do better.",-1
	even

DialogEnding_Bad_ProcessText2:
		dc.b " No! I beg you!",-1
	even

DialogEnding_Bad_ProcessText3:
		dc.b " Please... ",$80
		dc.b " Have mercy.",-1
	even

DialogEnding_Bad_ProcessText4:
		dc.b "Mercy can not ",$80
		dc.b "be given lightly.",-1
	even

DialogEnding_Bad_ProcessText5:
		dc.b "In your case,",$80
		dc.b "it must be earned.",-1
	even

DialogEnding_Bad_ProcessText6:
		dc.b "And for that...",$80
		dc.b "we will meet again.",-1
	even

DialogEnding_Good_ProcessText1:
		dc.b "I had promised you",$80
		dc.b "a way out.",-1
	even

DialogEnding_Good_ProcessText2:
		dc.b "And I hold my promises.",-1
	even

DialogEnding_Good_ProcessText3:
		dc.b "Your purgatorium",$80
		dc.b "is over.",-1
	even

DialogEnding_Good_ProcessText4:
		dc.b "Go.",$80
		dc.b "The world is waiting.",-1
	even

DialogEnding_Good_ProcessText5:
		dc.b "A light",$80
		dc.b "enveloped Eggman.",-1
	even

DialogEnding_Good_ProcessText6:
		dc.b "He woke up. A sigh of relief.",$80
		dc.b "The torment was over!",-1
	even

DialogEnding_Good_ProcessText7:
		dc.b "Then, the realization ",$80
		dc.b "crept in.",-1
	even

DialogEnding_Good_ProcessText8:
		dc.b "Eggman was now a hostage",$80
		dc.b "of his own creation.",-1
	even

DialogEnding_Good_ProcessText9:
		dc.b "He violently banged",$80
		dc.b "on the walls,",-1
	even

DialogEnding_Good_ProcessText10:
		dc.b "screamed to be let out...",$80
		dc.b "just to be met with silence.",-1
	even

DialogEnding_Good_ProcessText11:
		dc.b "The only thing separating",$80
		dc.b "him from freedom...",-1
	even

DialogEnding_Good_ProcessText12:
		dc.b "...was a button on top.",-1
	even

DialogEnding_Good_ProcessText13:
		dc.b "But who knows when it*ll",$80
		dc.b "be pressed to set him free?",-1
	even

DialogEnding_Good_ProcessText14:
		dc.b "The only thing he could do ",$80
		dc.b "was to endure.",-1
	even

DialogEnding_Good_ProcessText15:
		dc.b "You reap what you sow.",-1
	even
; ---------------------------------------------------------------------------

		CHARSET ; reset character set
