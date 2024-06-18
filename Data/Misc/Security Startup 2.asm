
		jsr	CheckSRAM					; initialise SRAM

		tst.b	(FirstSRAM).w					; is this the first time SRAM has been setup/read from?
		beq.s	.NoSetup					; if not, skip
		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		sf.b	SR_Zone(a0)					; set to run Zone 1
		sf.b	SR_Act(a0)					; set to run Act 1
		move.b	(Difficulty_Flag+1).w,SR_Difficulty(a0)		; set difficulty to normal
		sf.b	SR_Camera(a0)					; set camera to on
		sf.b	SR_Complete(a0)					; clear complete flag
		moveq	#$00,d0						; load from first slot
		jsr	SaveSlot					; load it
		beq.s	.NoSetup					; if failed, branch
		sf.b	(FirstSRAM).w					; set SRAM save slot as setup and ready

	.NoSetup:
		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; load from first slot
		jsr	LoadSlot					; load it
		beq.s	.FailLoad					; if failed, skip saving
		move.b	SR_Complete(a0),(v_Title_Levelselect_flag).w	; load level complete level select flag

	.FailLoad:

	if Debug_Title
		move.b	#id_SegaScreen,(Game_mode).w	; set Game Mode
	else
		move.b	#id_LevelSelect,(Game_mode).w	; set Game Mode
	endif

GameLoop:
		clr.w	(SwapPlanes).w					; MJ: clear plane swap flag
		move.b	(Game_mode).w,d0				; load Game Mode
		andi.w	#$7C,d0
		movea.l	GameModes(pc,d0.w),a0
		jsr	(a0)
		bra.s	GameLoop
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModes:
ptr_GM_LevelSelect:		dc.l LevelSelect_Screen		; Level Select ($00)
ptr_GM_Level:			dc.l GM_Level			; Level ($04)
ptr_Sega_Screen:			dc.l Sega_Screen			; Sega Screen
ptr_GM_TitleWithNotice:	dc.l Title_Screen			; Title screen (with notice)
ptr_GM_Title:			dc.l Title_Screen			; Title screen
ptr_Options_Screen:		dc.l Options_Screen
ptr_AssistWarning_Screen:	dc.l AssistWarning_Screen
ptr_DDZ_Phase2:			dc.l DDZ_Phase2			; MJ: phase 2 of final boss
ptr_DDZ_Ending:			dc.l DDZ_Phase2			; MJ: phase 2 ending scene
ptr_Thanks:				dc.l Thanks				; MJ: Thank you for playing screen
ptr_RedMiso:				dc.l RedMiso				; MJ: Red Miso logo
ptr_Results:				dc.l Results_Screen
ptr_EXMode:				dc.l EXMode_Screen
ptr_Dialog:				dc.l Dialog_Screen
