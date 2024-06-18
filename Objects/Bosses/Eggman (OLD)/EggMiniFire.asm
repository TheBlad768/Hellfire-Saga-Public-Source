; ===========================================================================
;
; ===========================================================================

Obj_EggMiniFire:
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#9,obAnim(a0)
		move.l	#Obj_EggMiniFire_Move,(a0)

Obj_EggMiniFire_Move:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	+
                move.l 	#loc_85088,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================