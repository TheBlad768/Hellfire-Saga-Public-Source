; ---------------------------------------------------------------------------
; Grounder
; ---------------------------------------------------------------------------

Obj_Grounder:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Grounder_Index(pc,d0.w),d1
		jsr	Grounder_Index(pc,d1.w)
		lea	Ani_Grounder(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------
Grounder_Index:
		dc.w Grounder_Main-Grounder_Index
		dc.w Grounder_Move-Grounder_Index
		dc.w Grounder_FindFloor-Grounder_Index
; ---------------------------------------------------------------------------

Grounder_Main:
		move.l	#Map_Grounder,obMap(a0)
		move.w	#$2450,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#3,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$18,obHeight(a0)
		move.b	#$18,obWidth(a0)
		move.b	#$18,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b	#2,obAnim(a0)
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	+
		add.w	d1,obY(a0)			; match	object's position with the floor
		move.w	#0,obVelY(a0)
		addq.b	#2,routine(a0)
		bchg	#0,obStatus(a0)	; change object's orientation
+		rts
; -----------------------------------------------------------------------------
Grounder_Move:
		sub.w	#1,obTimer(a0)
		bpl.w	Grounder_Return
		addq.b	#2,routine(a0)
		move.w	#-$400,obVelX(a0)	; move object to the left
		move.b	#3,obAnim(a0)
		bchg	#0,obStatus(a0)
		bne.w	Grounder_Return
		neg.w	obVelX(a0)			; change direction
; ---------------------------------------------------------------------------

Grounder_FindFloor:
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Dust,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$1F,obY(a1)
		move.w	obVelX(a0),d1
		neg.w	d1
		move.w	d1,obVelX(a1)
		jsr	(RandomNumber).w
		andi.w	#2,d0
		mulu.w	#2,d0
		lea	(Obj_FDZDust_Gfxes).l,a2
                move.w  (a2,d0.w),obGfx(a1)
+		jsr	(SpeedToPos).w
		move.w	x_pos(a0),d3
		subi.w	#$10,d3
		btst	#0,obStatus(a0)
		beq.s	+
		addi.w	#$20,d3
+		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	Grounder_Pause
		cmpi.w	#$C,d1
		bge.s	Grounder_Pause
		add.w	d1,obY(a0)				; match object's position with the floor
		rts
; ---------------------------------------------------------------------------

Grounder_Pause:
		subq.b	#2,routine(a0)
		move.b	#2,obAnim(a0)
		move.w	#0,obVelX(a0)	; move object to the left
		move.w	#45,obTimer(a0)

Grounder_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Dust:
		move.l	#SME__C8I2,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		jsr	(RandomNumber).w
		andi.w	#$600,d0
		move.w	d0,obVelY(a0)
		move.w	#5,obTimer(a0)
		move.l	#Obj_Dust_Fly,(a0)

Obj_Dust_Fly:
		jsr	(Draw_Sprite).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.s	+
		move.l	#Go_Delete_Sprite,(a0)
+		rts

SME__C8I2:
		dc.w SME__C8I2_2-SME__C8I2
SME__C8I2_2:	dc.b 0, 1
		dc.b $E0, 0, 0, 0, $FF, $F8
		even

Obj_FDZDust_Gfxes:
		dc.w	$247B
		dc.w	$247C
		dc.w	$247D
		dc.w	$247E
		dc.w	$247D









