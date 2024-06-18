; ===========================================================================
; Special version of Feal used in FDZ2 boss fight
; ===========================================================================

Obj_Feal2:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Feal2_Index(pc,d0.w),d1
		jsr	Obj_Feal2_Index(pc,d1.w)
		bsr.w	Obj_Feal2_process
		lea	(Ani_Feal).l,a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

Obj_Feal2_Index:
		dc.w Obj_Feal2_Main-Obj_Feal2_Index	; 0
		dc.w Obj_Feal2_Fall-Obj_Feal2_Index	; 4
		dc.w Obj_Feal2_Jump-Obj_Feal2_Index	; 2
		dc.w Obj_Feal2_Dead-Obj_Feal2_Index	; 6
; ---------------------------------------------------------------------------

Obj_Feal2_CorrectAni:
		cmpi.w  #0,obVelY(a0)
		bpl.s   +
		move.b	#0,obAnim(a0)
		rts
+		move.b	#1,obAnim(a0)
		rts

Obj_Feal2_Main:
		addq.b	#2,routine(a0)
		move.l	#SME_SAE0M,obMap(a0)
		move.w	#$420,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$5,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$0C,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$0C,y_radius(a0)
		move.b	#0,obAnim(a0)
		move.b  #1,$29(a0)
		addq.w	#1,(HeadlissIsFeal).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	+
		add.w	d1,obY(a0)
+		rts

Obj_Feal2_process:
		cmpi.b	#6,routine(a0)
		bcc.w	.lacricium
		tst.b   $29(a0)
		bne.s	.lacricium

.gone:
		subq.w	#1,(HeadlissIsFeal).w
		move.b	#6,routine(a0)

.lacricium:
		rts

Obj_Feal2_Fall:
		jsr	(Obj_Feal2_CorrectAni).l
		jsr	(Obj_HAxt_CheckBossAlive).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Feal2_Return
		add.w d1,obY(a0)
		addq.b	#2,routine(a0)
		move.w	#$3C,obTimer(a0)
		clr.l	obVelX(a0)
		bra.w   Obj_Feal2_Return

Obj_Feal2_Jump:
		jsr	(Obj_Feal2_CorrectAni).l
		jsr	(Obj_HAxt_CheckBossAlive).l
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Feal2_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		subq.b	#2,routine(a0)
		jsr	(Find_Sonic).w
		cmpi.w	#$20,d2
		bcc.w	+
		move.w	#-$400,obVelY(a0)
		move.w	#-$200,obVelX(a0)
		rts
+		move.w	#-$200,obVelY(a0)
		move.w	#-$200,obVelX(a0)
		rts

Obj_Feal2_Dead:
		samp	sfx_WeaselDeath
		jsr	(Obj_HurtBloodCreate).l
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Feal2_Return
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Go_Delete_Sprite,(a0)

Obj_Feal2_Return:
		rts