; ===========================================================================
; Firebomb, one of weapons used by Arthur
; ===========================================================================

Obj_Arthur_Firebomb:
		move.l	#Obj_Arthur_Mapp,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#5,obAnim(a0)
		move.l	#Obj_Arthur_Firebomb_Action,(a0)

Obj_Arthur_Firebomb_Action:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		jsr	(Sprite_CheckDeleteTouchXY).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Arthur_Firebomb_Rts
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Arthur_Firebomb_Rts
		move.l	#Obj_Arthur_Flame,(a1)
		move.w	parent(a0),parent(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#0,obVelY(a1)
		cmpi.w  #0,obVelX(a0)
		blt.s   +
		move.b  #1,objoff_48(a1)
		bra.s   Obj_Arthur_Firebomb_Del
+               move.b  #0,objoff_48(a1)

Obj_Arthur_Firebomb_Del:
   		move.l #Obj_Explosion,(a0)
    		clr.b routine(a0)
		move.w	#1,obSubtype(a0)

Obj_Arthur_Firebomb_Rts:
		rts
; ===========================================================================