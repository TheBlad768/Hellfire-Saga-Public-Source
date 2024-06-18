; ===========================================================================
; Love bullet used by Hell Girl
; ===========================================================================

Obj_Love_Bullet:
		move.l	#SME_fMWF3,obMap(a0)
		cmpi.w	#$203,(Current_zone_and_act).w
		beq.s	.gmz4gfx
		move.w	#$375,obGfx(a0)
		bra.s	.contload

.gmz4gfx:
		move.w	#$420,obGfx(a0)

.contload:
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.l	#Obj_Love_Bullet_Move,(a0)

Obj_Love_Bullet_Move:
		lea	(Ani_HellGirl).l,a1
		jsr	(Animate_Sprite).w
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		subq.w	#1,obTimer(a0)
		bpl.s	+
; ---------------------------------------------------------------------------
;+		lea	(Child6_CreateBossExplosion).l,a2
;		jsr	(CreateChild1_Normal).w
;		bne.s	+
;		move.b	#8,$2C(a1)
;+		jsr	(Obj_HurtBloodCreate).l
;                jmp	(DeleteObject).w

        	move.l  #Obj_Explosion,(a0)
        	clr.b   routine(a0)
+		jmp	(Draw_And_Touch_Sprite).w