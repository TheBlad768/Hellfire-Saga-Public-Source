; ===========================================================================
; ...
; ===========================================================================

Obj_EggFireball:
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#2,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#2,y_radius(a0)
		move.b	#7,obAnim(a0)
		cmpi.w  #0,obVelX(a0)
		blt.s	+
		bchg	#0,obStatus(a0)
+		move.l	#Obj_EggFireball_Move,(a0)

Obj_EggFireball_Move:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).w
		jsr     (SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	+
                move.l 	#loc_85088,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================