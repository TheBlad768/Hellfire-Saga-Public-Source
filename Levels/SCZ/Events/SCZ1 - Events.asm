; ---------------------------------------------------------------------------
; SCZ1 events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SCZ1_ScreenEvent_Boss:
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		rts

; =============== S U B R O U T I N E =======================================

SCZ1_BackgroundEvent_Boss:

		; deform
		lea	(H_scroll_buffer).w,a1
		move.w	(Level_frame_counter).w,d1
		asr.w	#3,d1
		move.w	(Camera_X_pos_copy).w,d0
		add.w	d1,d0
		neg.w	d0
		moveq	#bytesToXcnt(224,8),d1

.loop
	rept 8
		move.w	d0,(a1)
		addq.w	#4,a1		; skip BG
	endr
		dbf	d1,.loop

		jmp	(ShakeScreen_Setup).w

; =============== S U B R O U T I N E =======================================

SCZ1_BackgroundEvent_RefleshFG:

		; init FG
		jsr	(Reset_TileOffsetPositionActual).w
		addi.w	#240,d0
		and.w	(Camera_Y_pos_mask).w,d0
		move.w	d0,(DrawPlane_Position).w			; redraw entire BG plane bottom to top.
		move.w	#(256/16)-1,(DrawPlane_Count).w	; redraw this many rows
		move.l	#.waitFG,(Level_data_addr_RAM.BackgroundEvent).w

.waitFG
		jsr	InitFGCam
		move.w	(Camera_X_pos_copy).w,d4
		move.w	(Camera_Y_pos_copy).w,d3
		jsr	(DrawPlane_SlowFromBottom).w		; refresh FG plane
		bpl.s	.bevent

		; init BG
		jsr	InitBGCam
		move.w	#$F0,DrawPlane_Position.w		; redraw entire BG plane bottom to top.
		move.w	#(256/16)-1,(DrawPlane_Count).w	; redraw this many rows
		move.l	#.refleshBG,(Level_data_addr_RAM.BackgroundEvent).w

.refleshBG
		jsr	InitBGCam
		moveq	#0,d4
		moveq	#0,d3
		moveq	#$40-1,d6
		jsr	(DrawPlane_SlowFromBottom2).w		; refresh BG plane
		bpl.s	.bevent
		move.l	#SCZ1_BackgroundEvent,(Level_data_addr_RAM.BackgroundEvent).w

.bevent
		jmp	SCZ1_BackgroundEvent











