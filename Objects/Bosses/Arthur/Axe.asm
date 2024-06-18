; ===========================================================================
; Axe, one of Arthur's weapons
; ===========================================================================

Obj_Axe:
		move.l	#Obj_Arthur_Mapp,obMap(a0)
		move.w	#$3A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#3,obWidth(a0)
		move.b	#3,obHeight(a0)
		move.b	#3,x_radius(a0)
		move.b	#3,y_radius(a0)
		move.b	#$B,obAnim(a0)
		move.l	#Obj_Axe_Move,(a0)

Obj_Axe_Move:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		jsr	(SpeedToPos).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================