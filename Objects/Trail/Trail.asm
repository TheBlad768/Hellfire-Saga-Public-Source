; =============== S U B R O U T I N E =======================================

Obj_Sonic_Trail:
		move.l	#Map_Sonic,mappings(a0)	; If not, you must be Hyper Sonic, load Super/Hyper Sonic mappings
		move.w	#$680,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$100,priority(a0)
		moveq	#48,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,height_pixels(a0)
		move.l	#Sonic_Trail_Main,address(a0)

Sonic_Trail_Main:
		lea	(Player_1).w,a1
		cmpi.b	#id_SonicDeath,routine(a1)						; has Sonic just died?
		bhs.w	.remove										; if yes, branch
		btst	#Status_Roll,status(a1)
		bne.s	.return

		move.w	x_vel(a1),d0
		bpl.s	.plus
		neg.w	d0

.plus:
		cmpi.w	#$A00,d0									; check velocity
		blo.s		.return

		moveq	#$C,d1										; This will be subtracted from Pos_table_index, giving the object an older entry
		btst	#0,(Level_frame_counter+1).w						; Even frame? (Think of it as 'every other number' logic)
		beq.s	.evenframe									; If so, branch
		moveq	#$14,d1										; On every other frame, use a different number to subtract, giving the object an even older entry

.evenframe:
		move.w	(Pos_table_index).w,d0
		lea	(Pos_table).w,a1
		sub.b	d1,d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,x_pos(a0)								; Use previous player x_pos
		move.w	(a1)+,y_pos(a0)								; Use previous player y_pos


		move.b	(Player_1+mapping_frame).w,mapping_frame(a0)	; Use player's current mapping_frame
		move.b	(Player_1+render_flags).w,render_flags(a0)		; Use player's current render_flags
		move.w	(Player_1+priority).w,priority(a0)				; Use player's current priority

		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.remove:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.return:
		rts