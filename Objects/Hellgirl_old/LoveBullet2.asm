; ===========================================================================
; other type of Love Bullet (turns in Mickey,s thunder in FDZ4)
; ===========================================================================

Obj_Love_Bullet2:
		cmpi.w	#003,(Current_zone_and_act).w
		bne.s	.SCZ
		move.l	#SME_uvwMe,obMap(a0)
		move.w	#$380,obGfx(a0)
		move.b	#2,obAnim(a0)
		bra.w	.contload
.SCZ:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obAnim(a0)

.contload:
		move.b	#$8B,obColType(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.l	#Obj_Love_Bullet2_Move,(a0)

Obj_Love_Bullet2_Move:

		cmpi.w	#003,(Current_zone_and_act).w
		bne.s	.SCZ
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_48(a1)
		beq.w	Obj_Love_Bullet2_Delete
		lea	(Ani_MickeyFantom).l,a1
		bra.w	.contload

.SCZ:
		lea	(Ani_Hellgirl).l,a1

.contload:
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	+
		cmpi.w	#003,(Current_zone_and_act).w
		beq.s	Obj_Love_Bullet2_Delete
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
                sfx	sfx_Bomb
+		jmp	(Draw_And_Touch_Sprite).w

Obj_Love_Bullet2_Delete:
		jmp	(DeleteObject).w
; ===========================================================================

Obj_Love_Bullet2_Return:
		rts
