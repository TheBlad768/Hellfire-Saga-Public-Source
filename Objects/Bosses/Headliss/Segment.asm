
; =============== S U B R O U T I N E =======================================

Obj_HSegm:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d1
		neg.b	d1
		move.b	d1,child_dy(a0)
		lsl.b	#3,d0
		neg.w	d0
		move.w	d0,subtype(a0)
		move.b	#-40/2,child_dx(a0)
		tst.b	subtype(a0)
		bne.s	+
		clr.b	child_dx(a0)
+		lea	ObjDat3_HSegm(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#+,address(a0)
+		jsr	(Refresh_ChildPosition).w
		movea.w	$44(a0),a2
		cmpi.b	#6,routine(a2)
		bcs.s	Obj_HSegm_Move
		clr.b	child_dy(a0)
		move.l	#+,address(a0)
+		movea.w	parent3(a0),a1
		movea.w	$44(a0),a2
		move.w	subtype(a0),d1
		move.w	x_pos(a2),d0
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	#$A0,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectYOnly).l

Obj_HSegm_Move:
		jsr	(SpeedToPos).w
		movea.w	$44(a0),a2
		move.b	$1C(a2),d0
		beq.s	+
		lsr.b	#3,d0
		bcc.s	++
+		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		jmp	(Child_DrawTouch_Sprite_FlickerMove).l
+		rts
; ---------------------------------------------------------------------------

ObjDat3_HSegm:
		dc.l SME_WmmBn
		dc.w $23A0
		dc.w 4*$80
		dc.b 48/2
		dc.b 48/2
		dc.b 4
		dc.b 0
ChildObjDat_HSegm:
		dc.w 8-1				; Размер хвоста
		dc.l Obj_HSegm