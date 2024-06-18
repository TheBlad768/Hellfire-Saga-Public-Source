; ---------------------------------------------------------------------------
; Subroutine to remember whether an object is destroyed/collected
; ---------------------------------------------------------------------------

MarkObjGone:
RememberState:
Sprite_OnScreen_Test:
		move.w	x_pos(a0),d0

Sprite_OnScreen_Test2:
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

MarkObjGone_Collision:
RememberState_Collision:
Sprite_CheckDeleteTouch3:
Sprite_OnScreen_Test_Collision:
		move.w	x_pos(a0),d0

.skipxpos:
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jsr	(Add_SpriteToCollisionResponseList).l
		bra.w	Draw_Sprite
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Sprite_If_Not_In_Range:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		rts
; ---------------------------------------------------------------------------

.offscreen:
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete:
		bra.w	Delete_Current_Sprite
; End of function Delete_Sprite_If_Not_In_Range

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	loc_85088
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_85088:
		move.w	respawn_addr(a0),d0
		beq.s	loc_85094
		movea.w	d0,a2
		bclr	#7,(a2)

loc_85094:
		bset	#7,$2A(a0)
		cmpi.l	#Obj_Feal2,(a0)
		bne.s	+
		subq.w	#1,(HeadlissIsFeal).w
+		move.l	#Delete_Current_Sprite,(a0)
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDelete2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	loc_850BA
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_850BA:
		move.w	respawn_addr(a0),d0
		beq.s	loc_850C6
		movea.w	d0,a2
		bclr	#7,(a2)

loc_850C6:
		bset	#4,$38(a0)
		move.l	#Delete_Current_Sprite,(a0)

locret_8405E:
		rts

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteXY_NoDraw:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		rts

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteXY:
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	$14(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	$46(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteXY_NoDraw:
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite

Sprite_ChildCheckDeleteXY_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_FlickerMove:
		jsr	(MoveSprite).w
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite_3
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite_3
		bchg	#6,$38(a0)
		beq.s	Sprite_ChildCheckDeleteXY_Return
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	loc_85088
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouch2:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	loc_850BA
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchXY:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_ChildCheckDeleteTouchXY:
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.w	Go_Delete_Sprite
		move.w	$14(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.w	Go_Delete_Sprite
		movea.w	$46(a0),a1
		btst	#7,status(a1)
		bne.w	Go_Delete_Sprite
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteSlotted:
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Go_Delete_SpriteSlotted:
		move.w	respawn_addr(a0),d0
		beq.s	Go_Delete_SpriteSlotted2
		movea.w	d0,a2
		bclr	#7,(a2)

Go_Delete_SpriteSlotted2:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#7,status(a0)

Remove_From_TrackingSlot:
		move.b	$3B(a0),d0			; load bit number t0 d0
		movea.w	$3C(a0),a1			; clear address to clear
		bclr	d0,(a1)				; clear bit from that address
		rts
; End of function Remove_From_TrackingSlot

; =============== S U B R O U T I N E =======================================

Sprite_CheckDeleteTouchSlotted:
		tst.b	status(a0)
		bmi.s	Go_Delete_SpriteSlotted3
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	Go_Delete_SpriteSlotted
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Go_Delete_SpriteSlotted3:
		move.l	#Delete_Current_Sprite,(a0)
		bra.s	Remove_From_TrackingSlot

; =============== S U B R O U T I N E =======================================

Obj_WaitOffscreen:
		move.l	#Map_Offscreen,mappings(a0)
		bset	#2,render_flags(a0)
		move.b	#$20,width_pixels(a0)
		move.b	#$20,height_pixels(a0)
		move.l	(sp)+,$34(a0)
		move.l	#loc_85AD2,(a0)

loc_85AD2:
		tst.b	render_flags(a0)
		bmi.s	loc_85B02
		bra.w	Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

loc_85B02:
		move.l	$34(a0),(a0)			; Restore normal object operation when onscreen
		rts
; End of function Obj_WaitOffscreen
; ---------------------------------------------------------------------------
Map_Offscreen:	dc.w 0
