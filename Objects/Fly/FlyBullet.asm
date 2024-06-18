; ===========================================================================
; Bullet used by Fly
; ===========================================================================

Obj_Fly_Bullet:
		move.l	#SME_JMzMZ,obMap(a0)
		move.w	#$3C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$9C,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.l	#Obj_Fly_Bullet_Move,(a0)

Obj_Fly_Bullet_Move:
		lea	(Ani_Fly).l,a1
		jsr	(Animate_Sprite).w
		jsr	(SpeedToPos).w
		jsr 	(ChkObjOnScreen).w
		beq.w 	+
                move.l  #loc_85088,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------