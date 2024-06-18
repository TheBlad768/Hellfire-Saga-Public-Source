; ===========================================================================
; Love bullet used by Hell Girl
; ===========================================================================

Obj_Love_BulletFDZ4:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$420,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.l	#Obj_Love_BulletFDZ4_Move,(a0)

Obj_Love_BulletFDZ4_Move:
		lea	(Ani_HellGirl).l,a1
		jsr	(Animate_Sprite).w
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.s	+
		move.l	#Go_Delete_Sprite,(a0)
		rts
+		jmp	(Draw_And_Touch_Sprite).w