Obj_EggStone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	EggStone_Index(pc,d0.w),d1
		jmp	EggStone_Index(pc,d1.w)
; ---------------------------------------------------------------------------

EggStone_Index:
		dc.w EggStone_Main-EggStone_Index
		dc.w EggStone_Action-EggStone_Index
		dc.w EggStone_Animate-EggStone_Index
		dc.w EggStone_Delete-EggStone_Index
; ---------------------------------------------------------------------------

EggStone_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#8,obAnim(a0)
		rts
; ---------------------------------------------------------------------------

.smoke:
		addq.b	#4,routine(a0)
		bra.w	EggStone_Animate
; ---------------------------------------------------------------------------

EggStone_Action:	; Routine 2
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	EggStone_ActIndex(pc,d0.w),d1
		jsr	EggStone_ActIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

EggStone_ActIndex:
		dc.w .moveup-EggStone_ActIndex
		dc.w .moveup2-EggStone_ActIndex
		dc.w .movedown-EggStone_ActIndex
		dc.w .movedown2-EggStone_ActIndex
; ---------------------------------------------------------------------------

.moveup:
		move.w	#-$500,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		addq.b	#2,routine_secondary(a0)
; ---------------------------------------------------------------------------

.moveup2:
		jsr	(SpeedToPos).w
		cmpi.w  #$120,obY(a0)
		bcc.w	EggStone_Return
		move.w	#0,obVelY(a0)
		move.b  #$A,obTimer(a0)
		move.w	#0,obVelX(a0)
		addq.b	#2,routine_secondary(a0)
; ---------------------------------------------------------------------------

.movedown:
		subq.b   #1,obTimer(a0)
		bpl.w    EggStone_Return
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		move.b	#$8B,obColType(a0)
		addq.b	#2,routine_secondary(a0)

.movedown2:
                jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	EggStone_Return
                add.w d1,obY(a0)
		moveq	#sfx_Wallbreak,d0
		jsr	(Play_Sound_2).l
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#2,obSubtype(a0)
; ---------------------------------------------------------------------------

EggStone_Animate:
		lea	(Ani_Eggman).l,a1
		jmp	(AnimateSprite).w
; ---------------------------------------------------------------------------

EggStone_Delete:
                jmp	(DeleteObject).w
; ---------------------------------------------------------------------------
EggStone_Return:
		rts