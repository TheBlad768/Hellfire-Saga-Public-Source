; ===========================================================================
; Flame produced by Arthur's bomb
; ===========================================================================

Obj_Arthur_Flame:
		move.l	#Obj_Arthur_Mapp,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#8,obWidth(a0)
		move.b	#4,obHeight(a0)
		move.b	#8,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#6,obAnim(a0)
		bset	#4,shield_reaction(a0)
		move.l	#Obj_Arthur_Flame_Stand,(a0)

Obj_Arthur_Flame_Stand:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		sub.w	#1,obTimer(a0)
		bpl.w	++

		jsr	(ChkObjOnScreen).w
		bne.s	+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Arthur_Flame,(a1)
		move.w	parent(a0),parent(a1)
		move.b	objoff_48(a0),objoff_48(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#4,obTimer(a1)
		sub.w	#$F,obX(a1)
		cmpi.b	#$1,objoff_48(a0)
		bne.s	+
		add.w	#$1E,obX(a1)

+		move.w	#20,obTimer(a0)
		move.l	#Obj_Arthur_Flame_Move,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w

Obj_Arthur_Flame_Move:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		subq.w	#1,obTimer(a0)
		bpl.s	+
		move.l  #Go_Delete_Sprite,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w