; ===========================================================================
; Spear, one of Arthur's weapons
; ===========================================================================

Obj_Spear:
		move.l	#Obj_Arthur_Mapp,obMap(a0)
		move.w	#$3A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$27|$80,obColType(a0)
		move.b	#8,obWidth(a0)
		move.b	#4,obHeight(a0)
		move.b	#8,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#4,obAnim(a0)
		move.l	#Obj_Spear_Move,(a0)

Obj_Spear_Move:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		jsr	(SpeedToPos).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================