; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

Pause_Game:
		cmpi.b	#$04,(Current_Zone).w				; is this the credits?
		beq.w	Pause_NoPause					; if so, no pausing allowed
		tst.b	(Game_paused).w					; has a frame just advanced?  i.e we're still paused
		bne.s	.FrameAdvance					; if so, skip start check
		tst.b	(Ctrl_1_pressed).w				; is Start pressed?
		bpl.w	Pause_NoPause					; if not, branch to return
		sf.b	(PauseHideDebug).w				; allow pause menu to show

	.FrameAdvance:
		tst.b	(NoPause_flag).w				; is the game allowed to pause?
		bne.w	Pause_NoPause					; if not, branch
		st	(Game_paused).w					; set game as paused
		command	cmd_Pause					; pause music

Pause_Loop:
		move.b	#VintID_Level,(V_int_routine).w			; set V-blank routine to run
		bsr.w	Wait_VSync					; wait for V-blank
		tst.b	(PauseHideDebug).w				; is the pause menu hidden?
		bne.s	.NoSelection					; if so, skip up/down checks
		moveq	#$03,d0						; get up/down buttons
		and.b	(Ctrl_1_pressed).w,d0				; ''
		beq.s	.NoSelection					; if none were pressed, branch
		lsr.b	#$01,d0						; check up
		bcc.s	.Down						; if not pressed, branch
		subq.b	#$01,(PauseSlot).w				; move menu option up
		bcc.s	.NoSelection					; if not gone too high, branch
		move.b	#$03-1,(PauseSlot).w				; reset to bottom
		bra.s	.NoSelection					; continue...

	.Down:
		addq.b	#$01,(PauseSlot).w				; move menu option down
		cmpi.b	#$03,(PauseSlot).w				; has it gone too low?
		blo.s	.NoSelection					; if not, branch
		sf.b	(PauseSlot).w					; reset to top

	.NoSelection:

	if GameDebug=1
		btst	#bitA,(Ctrl_1_pressed).w			; is button A pressed?
		beq.s	Pause_ChkFrameAdvance				; if not, branch
		st.b	(PauseHideDebug).w				; hide the pause menu
		sf.b	(PauseSlot).w					; reset menu to top
		move.b	#id_LevelSelect,(Game_mode).w			; set game mode
		bra.s	Pause_ResumeMusic

Pause_ChkFrameAdvance:
		btst	#bitB,(Ctrl_1_held).w				; is button B held?
		bne.s	Pause_FrameAdvance				; if yes, branch
		btst	#bitC,(Ctrl_1_pressed).w			; is button C pressed?
		bne.s	Pause_FrameAdvance				; if yes, branch

Pause_ChkStart:
	endif
		tst.b	(Ctrl_1_pressed).w				; is Start pressed?
		bpl.s	Pause_Loop					; if not, branch
		move.b	(PauseSlot).w,d0				; load pause slot
		subq.b	#$01,d0						; check slot
		bcs.s	Pause_ResumeMusic				; if pointing to "Resume", branch
		beq.s	.Reset						; if pointing to "Reset", branch
		move.b	#id_Title,(Game_mode).w				; set to exit to title screen
		bra.s	Pause_Unpause					; continue

	.Reset:
		move.b	#$01,(Restart_level_flag).w			; reset the level

Pause_ResumeMusic:
		command	cmd_Unpause
		cmpi.w	#$0300,(Current_zone_and_act).w			; is this DDZ phase 1 boss?
		bne.s	Pause_Unpause					; if not, skip
		tst.b	(RDD_Phase).l					; are we in the intro?
		bne.s	Pause_Unpause					; if not, skip
		samp	sfx_RainPCM					; request wind to play again... Not finished intro yet...

Pause_Unpause:
		clr.b	(Game_paused).w

Pause_NoPause:
		rts
; ---------------------------------------------------------------------------
	if GameDebug=1
Pause_FrameAdvance:
		st.b	(PauseHideDebug).w				; hide the pause menu
		sf.b	(PauseSlot).w					; reset menu to top
		st	(Game_paused).w
		command	cmd_Unpause
		rts
; End of function Pause_Game
	endif
