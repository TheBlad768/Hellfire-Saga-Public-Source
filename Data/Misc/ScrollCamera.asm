; ===========================================================================
; ---------------------------------------------------------------------------
; Scroll control previous running the deform
; ---------------------------------------------------------------------------

ScrollCamera:
		tst.b	(Deform_lock).w
		bne.s	ScrollHoriz_Return

		clr.w	CamXdiff.w
		clr.w	CamYdiff.w
		tst.b	(Scroll_lock).w
		bne.s	+
		clr.w	ScrollFG.w
		clr.w	ScrollBG1.w
		clr.w	ScrollBG2.w
		clr.w	ScrollBG3.w
		bsr.s	ScrollHoriz
		bsr.w	ScrollVertical

		cmpi.w	#$0300,(Current_zone_and_act).w			; MJ: is this DDZ?
		bne.s	.NoForceY					; MJ: if not, resume normally
		move.w	#-1,(CamYFG).w

	.NoForceY:
		move.w	CamXFG.w,CamXFGcopy.w
		move.w	CamYFG.w,CamYFGcopy.w
+		bra.w	Do_ResizeEvents
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	scroll the level horizontally as Sonic moves
; ---------------------------------------------------------------------------


ScrollHoriz:
		bsr.w	Scroll_CamExtend
		move.w	CamXFG.w,d4	; save old screen position

		moveq	#0,d7		; clear difference counter
		pea	SH_Repeat(pc)	; should it run twice?

SH_Loop:
		bsr.w	MoveScreenHoriz ; Calculate new camera position

                ; Compare the new against the old and setup the map updating
		move.w	CamXFG.w,d0
		andi.w	#$10,d0
		move.b	CamPassMult.w,d1
		eor.b	d1,d0
		bne.s	locret_65B0
		eori.b	#$10,CamPassMult.w

		move.w	CamXFG.w,d0
		sub.w	d4,d0		; compare new with old screen position
		bpl.s	SH_Forward

		addq.b	#1,ScrollFG.l.w	; screen moves backward
		move.b	#0,ScrollFG.l+1.w

ScrollHoriz_Return:
		rts

SH_Forward:
		addq.b	#1,ScrollFG.r.w	; screen moves forward
		move.b	#0,ScrollFG.r+1.w

locret_65B0:
		rts

SH_Repeat:
	; to-do: increase limit for ScrolLVertical too
	; 	  > perhaps create a new ScrolLVertical based on ScrollHoriz, then add all vertical-specific checks manually?
		move.w	CamXdiff.w,d0			; get current difference block
		add.w	d0,d7				; add to difference counter
		asr.w	#8,d0				; arrange bits properly
-		neg.w	d0				; get abs
		bmi.s	-				; ''  ''
		cmpi.w	#$10,d0				; is it exactly $10 pixels (maximum?)
		bne.s	+				; if not, branch
		bsr.s	SH_Loop				; otherwise, run again
		add.w	CamXdiff.w,d7			; add to difference counter
		move.w	d7,CamXdiff.w			; save to variable
+		rts					; return
; ===========================================================================

Scroll_CamExtend:
		tst.w	(ExtendedCam_Flag).w
		bne.s	.locret

.XExtend:
		move.w	(Camera_X_Center).w,d1					; Get camera X center position
		move.w	(Player_1+ground_vel).w,d0				; Get how fast we are moving
		bpl.s	.PosInertia
		neg.w	d0

.PosInertia:
		cmpi.w	#$600,d0								; Are we going at max regular speed?
		bcs.s	.ResetPan								; If not, branch
		tst.w	(Player_1+ground_vel).w					; Are we moving right?
		bpl.s	.MovingRight								; If so, branch

.MovingLeft:
		addq.w	#2,d1									; Pan the camera to the right
		cmpi.w	#(320/2)+64,d1							; Has it panned far enough?
		bcs.s	.SetPanVal								; If not, branch
		move.w	#(320/2)+64,d1							; Cap the camera's position
		bra.s	.SetPanVal

.MovingRight:
		subq.w	#2,d1									; Pan the camera to the left
		cmpi.w	#(320/2)-64,d1							; Has it panned far enough
		bcc.s	.SetPanVal								; If not, branch
		move.w	#(320/2)-64,d1							; Cap the camera's position
		bra.s	.SetPanVal

.ResetPan:
		cmpi.w	#320/2,d1								; Has the camera panned back to the middle?
		beq.s	.SetPanVal								; If so, branch
		bcc.s	.ResetLeft								; If it's panning back left
		addq.w	#2,d1									; Pan back to the right
		bra.s	.SetPanVal

.ResetLeft:
		subq.w	#2,d1									; Pan back to the left

.SetPanVal:
		move.w	d1,(Camera_X_Center).w					; Update camera X center position

.locret:
		rts
; ===========================================================================

MoveScreenHoriz:
		move.b	CamLag.w,d1
		beq.s	.cont1
		tst.w	v_player+obVelX.w	; is Sonic moving horizontally?
		bne.s	.cont0
		clr.b	CamLag.w	; clear lag
		bra.s	.cont1

.cont0		sub.b	#1,d1
		move.b	d1,CamLag.w
		lsl.b	#2,d1
		addq.b	#4,d1
		move.w	Pos_Table_Index.w,d0
		sub.b	d1,d0

		lea	Pos_Table.w,a1
		move.w	(a1,d0.w),d0
		and.w	#$7FFF,d0	; Blad: Fixed $3FFF
		bra.s	.cont2

.cont1		move.w	v_player+obX.w,d0
.cont2		sub.w	CamXFG.w,d0 ; Sonic's distance from left edge of screen
		add.w	CamXExtend,d0
		bmi     SH_BehindMid2
		sub.w	(Camera_X_Center).w,d0
		bcs.s	SH_BehindMid	; if yes, branch
		bcc.s	SH_AheadOfMid	; if yes, branch
		clr.w	CamXdiff.w
		rts
; ===========================================================================

SH_AheadOfMid:
		cmpi.w	#$10,d0		; is Sonic within 16px of middle area?
		bcs.s	SH_Ahead16	; if yes, branch
		move.w	#$10,d0		; set to 16 if greater

SH_Ahead16:
		add.w	CamXFG.w,d0
		cmp.w	BoundRight.w,d0
		blt.s	SH_SetScreen
		move.w	BoundRight.w,d0

SH_SetScreen:
		move.w	d0,d1
		sub.w	CamXFG.w,d1
		asl.w	#8,d1
		move.w	d0,CamXFG.w ; set new screen position
		move.w	d1,CamXdiff.w ; set distance for screen movement
		rts
; ===========================================================================

SH_BehindMid:
		cmpi.w	#-$10,d0
		bgt.s	SH_Behind16

SH_BehindMid2:
		move.w	#-$10,d0

SH_Behind16:

		add.w	CamXFG.w,d0
		cmp.w	BoundLeft.w,d0
		bgt.s	SH_SetScreen
		move.w	BoundLeft.w,d0
		bra.s	SH_SetScreen

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	scroll the level vertically as Sonic moves
; ---------------------------------------------------------------------------

ScrollVertical:
		move.w	v_player+obY.w,d0
		moveq	#0,d1
		sub.w	CamYFG.w,d0		; Sonic's distance from top of screen
		add.w	CamYExtend,d0

		btst	#2,v_player+obStatus.w	; is Sonic rolling?
		beq.s	SV_NotRolling		; if not, branch
		subq.w	#5,d0

		tst.b	GravityAngle.w		; NAT: check if angle is negative
		bpl.s	SV_NotRolling		; if not set, we are set
		sub.w	#-10,d0			; move camera upwards instead!

SV_NotRolling:
		tst.b	f_pause.w		; check if paused
		bne.s	.inair			; if is, branch
		btst	#1,v_player+obStatus.w 	; is Sonic jumping?
		beq.s	loc_664A		; if not, branch

.inair		addi.w	#32,d0
		sub.w	CamYoff.w,d0
		bcs.s	loc_6696
		subi.w	#64,d0
		bcc.s	loc_6696
		tst.b	ScrollBGV.w
		bne.s	loc_66A8
		bra.s	loc_6656
; ===========================================================================

loc_664A:
		sub.w	CamYoff.w,d0
		bne.s	loc_665C
		tst.b	ScrollBGV.w
		bne.s	loc_66A8

loc_6656:
		clr.w	CamYdiff.w
		rts
; ===========================================================================

loc_665C:
		cmpi.w	#$60,CamYoff.w
		bne.s	loc_6684
		move.w	v_player+obInertia.w,d1
		bpl.s	loc_666C
		neg.w	d1

loc_666C:
		cmpi.w	#$800,d1
		bcc.s	loc_6696
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.w	loc_66F6
		cmpi.w	#-6,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_6684:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_66F6
		cmpi.w	#-2,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_6696:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_66F6
		cmpi.w	#-$10,d0
		blt.s	loc_66C0
		bra.s	loc_66AEa
; ===========================================================================

loc_66A8:
		moveq	#0,d0
		move.b	d0,ScrollBGV.w

loc_66AEa:
		moveq	#0,d1
		move.w	d0,d1
		add.w	CamYFG.w,d1
		sub.w	CamYExtend,d0
		tst.w	d0
		bpl.w	loc_6700
		bra.w	loc_66CC
; ===========================================================================

loc_66C0:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	CamYFG.w,d1
		swap	d1

loc_66CC:
		cmp.w	BoundTop.w,d1
		bgt.s	loc_6724
		cmpi.w	#-$100,d1
		bgt.s	loc_66F0

;		andi.w	#$7FF,d1
;		andi.w	#$7FF,v_player+obY.w
;		andi.w	#$7FF,CamYFG.w
;		andi.w	#$3FF,CamYBG.w

		and.w	(Screen_Y_wrap_value).w,d1

		bra.s	loc_6724
; ===========================================================================

loc_66F0:
		move.w	BoundTop.w,d1
		bra.s	loc_6724
; ===========================================================================

loc_66F6:
		ext.l	d1
		asl.l	#8,d1
		add.l	CamYFG.w,d1
		swap	d1

loc_6700:
		cmp.w	BoundBot.w,d1
		blt.s	loc_6724

		move.w	(Screen_Y_wrap_value).w,d3
		addq.w	#1,d3
		sub.w	d3,d1
		bcs.s	loc_6720
		sub.w	d3,CamYFG.w


;		subi.w	#$800,d1
;		bcs.s	loc_6720
;		andi.w	#$7FF,v_player+obY.w
;		subi.w	#$800,CamYFG.w
;		andi.w	#$3FF,CamYBG.w

		bra.s	loc_6724
; ===========================================================================

loc_6720:
		move.w	BoundBot.w,d1

loc_6724:
		move.w	CamYFG.w,d4
		swap	d1
		move.l	d1,d3
		sub.l	CamYFG.w,d3
		ror.l	#8,d3
		move.w	d3,CamYdiff.w
		move.l	d1,CamYFG.w
		move.w	CamYFG.w,d0
		andi.w	#$10,d0
		move.b	CamPassMult+1.w,d1
		eor.b	d1,d0
		bne.s	locret_6766
		eori.b	#$10,CamPassMult+1.w
		move.w	CamYFG.w,d0
		sub.w	d4,d0
		bpl.s	loc_6760
		add.b	#1,ScrollFG.u.w
		move.b	#0,ScrollFG.u+1.w
		rts
; ===========================================================================

loc_6760:
		add.b	#1,ScrollFG.d.w
		move.b	#0,ScrollFG.d+1.w

locret_6766:
		rts
; End of function ScrollVertical
; ===========================================================================
; ---------------------------------------------------------------------------
; Macro to update scroll flags for a BG plane
; in:
; v1 : Specified Camera's X pos address
; v2 : "Previous multiple" backup's address
; v3 : ScrollBG flags address
; d4 = how many x pixels to move (at high 16 bits), signed
; d5 = how many y pixels to move (at high 16 bits), signed
; To-do: 32px scroll support for bg?
; ---------------------------------------------------------------------------

ScrollBGX:	macro	v1,v2,v3
		move.l	v1.w,d2			; get this BG's X
		move.l	d2,d0			; copy to local register
		add.l	d4,d0			; add d4's input
		move.l	d0,v1.w			; store final result
		move.l	d0,d1			; copy final result to local register
		swap	d1			; swap high 16 bits
		andi.w	#$10,d1			; determine even/odd $10 value multiple (16px, size of block)
		move.b	v2.w,d3			; get "previous multiple" backup
		eor.b	d3,d1			; same as current?
		bne.s	.rts			; if yes, branch
		eori.b	#$10,v2.w		; update to new obStatus
		sub.l	d2,d0			; get difference between obX from past and current frame
		bpl.s	.setright		; if positive, branch
.setleft	move.b	#1,v3.l.w		; scrolls left
		move.b	#0,v3.l+1.w
		bra.s	.rts			; ++ deliberate patch to continue (to-do: find better way)
.setright	move.b	#1,v3.r.w		; scrolls right
		move.b	#0,v3.r+1.w
.rts
		endm

ScrollBGY:	macro	v1,v2,v3
.checky		move.l	v1.w,d3			; get this BG's Y
		move.l	d3,d0			; copy to local register
		add.l	d5,d0			; add d5's input
		move.l	d0,v1.w			; store final result
		move.l	d0,d1			; copy final result to local register
		swap	d1			; swap high 16 bits
		andi.w	#$10,d1			; determine even/odd $10 value multiple (16px, size of block)
		move.b	v2.w,d2			; get "previous multiple" backup
		eor.b	d2,d1			; same as current?
		bne.s	.rts			; if yes, branch
		eori.b	#$10,v2.w		; update to new obStatusus
		sub.l	d3,d0			; get difference between obX from past and current frame
		bpl.s	.setdown		; if positive, branch
.setup		move.b	#1,v3.u.w		; scrolls up
		move.b	#0,v3.u+1.w
		bra.s	.rts			; ++ deliberate patch to continue (to-do: find better way)
.setdown	move.b	#1,v3.d.w		; scrolls down
		move.b	#0,v3.d+1.w
.rts
		endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update scroll flags for BG1
; in:
; d4 = how many x pixels to move (at high 16 bits), signed
; d5 = how many y pixels to move (at high 16 bits), signed
; ---------------------------------------------------------------------------

MoveBG1:
.full		pea		.y(pc)
.x		ScrollBGX	CamXBG,CamPassMult+2,ScrollBG1
		move.w		CamXBG.w,Camera_X_pos_BG_copy.w
		rts
.y		ScrollBGY	CamYBG,CamPassMult+3,ScrollBG1
		move.w		CamYBG.w,Camera_Y_pos_BG_copy.w
		move.w		CamYBG.w,NullCam+4.w
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update scroll flags for BG2
; in:
; d4 = how many x pixels to move (at high 16 bits), signed
; d5 = how many y pixels to move (at high 16 bits), signed
; ---------------------------------------------------------------------------

MoveBG2:
.full		pea		.y(pc)
.x		ScrollBGX	CamXBG2,CamPassMult+4,ScrollBG2
		rts
.y		ScrollBGY	CamYBG2,CamPassMult+5,ScrollBG2
		move.w		CamYBG.w,CamYBG2.w
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to update scroll flags for BG3
; in:
; d4 = how many x pixels to move (at high 16 bits), signed
; d5 = how many y pixels to move (at high 16 bits), signed
; ---------------------------------------------------------------------------

MoveBG3:
.full		pea		.y(pc)
.x		ScrollBGX	CamXBG3,CamPassMult+6,ScrollBG3
		rts
.y		ScrollBGY	CamYBG3,CamPassMult+7,ScrollBG3
		move.w		CamYBG.w,CamYBG3.w
		rts
