
; =============== S U B R O U T I N E =======================================

Obj_Crow:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Crow_Index(pc,d0.w),d0
		jsr	Crow_Index(pc,d0.w)
		lea	Ani_Crow(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

Crow_Index: offsetTable
		offsetTableEntry.w Crow_Init				; 0
		offsetTableEntry.w Crow_CheckPos			; 2
		offsetTableEntry.w Crow_Fly				; 4
		offsetTableEntry.w Crow_SetMoveUp			; 6
		offsetTableEntry.w Crow_MoveUp			; 8
		offsetTableEntry.w Crow_MoveWait			; A
		offsetTableEntry.w Crow_MoveCircularDown	; C
Crow_Vram:
		dc.w $2412	; Act 1
		dc.w $2412	; Act 2
		dc.w $23C0	; Act 3
		dc.w $2412	; Act 4
; ---------------------------------------------------------------------------

Crow_Init:
		lea	ObjDat3_Crow(pc),a1
		jsr	(SetUp_ObjAttributes).w
		moveq	#0,d0
		move.b	(Current_act).w,d0
		add.w	d0,d0
		move.w	Crow_Vram(pc,d0.w),obGfx(a0)
		jsr	(Find_SonicTails).w
		bclr	#0,status(a0)
		tst.w	d0
		beq.s	+
		bset	#0,status(a0)
+		tst.b	subtype(a0)
		bne.s	Crow_Return
		clr.b	collision_flags(a0)

Crow_Return:
		rts
; ---------------------------------------------------------------------------

Crow_CheckPos:
		jsr	(Find_SonicTails).w
		cmpi.w	#96,d2	; X
		bhs.s	Crow_Return
		addq.b	#4,routine(a0)
		move.b	#1,anim(a0)
		tst.b	subtype(a0)
		bne.s	Crow_Return
		subq.b	#2,routine(a0)
		sfx	sfx_Basaran
		move.w	#-$18,d1
		bclr	#0,status(a0)
		tst.w	d0
		bne.s	+
		bset	#0,status(a0)
		neg.w	d1
+		move.w	d1,$30(a0)
		clr.w	respawn_addr(a0)		; Mark object as destroyed
		lea	ChildObjDat_CrowFeather(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

Crow_Fly:
		move.w	$30(a0),d0
		add.w	d0,x_vel(a0)
		subi.w	#$28,y_vel(a0)
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

Crow_SetMoveUp:
		addq.b	#2,routine(a0)
		sfx	sfx_Basaran
		move.w	(Camera_Y_Pos).w,$30(a0)

Crow_MoveUp:
		subi.w	#$28,y_vel(a0)
		jsr	(MoveSprite2).w
		move.w	$30(a0),d0
		addi.w	#$20,d0
		cmp.w	obY(a0),d0
		blo.s		+
		addq.b	#2,routine(a0)
		move.w	#7,$2E(a0)
		move.b	#3,anim(a0)
		clr.w	y_vel(a0)
+		rts
; ---------------------------------------------------------------------------

Crow_MoveWait:
		subq.w	#1,$2E(a0)
		bpl.s	+
		addq.b	#2,routine(a0)
		move.b	#1,anim(a0)
		move.w	#$300,y_vel(a0)
		jsr	(Find_SonicTails).w
		move.w	#-$400,x_vel(a0)
		bclr	#0,status(a0)
		tst.w	d0
		beq.s	+
		bset	#0,status(a0)
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

Crow_MoveCircularDown:
		subi.w	#$10,y_vel(a0)
		jmp	(MoveSprite2).w

; =============== S U B R O U T I N E =======================================

Obj_CrowFeather:
		lea	ObjDat3_CrowFeather(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.b	#6/2,y_radius(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsr.b	#1,d1
		move.b	d1,d2
		andi.w	#3,d1
		addq.b	#7,d1
		move.b	d1,mapping_frame(a0)
		lsl.w	#1,d0
		addi.w	#$10,d0
		move.w	d0,$2E(a0)
		moveq	#2,d1
		andi.w	#1,d2
		bne.s	+
		neg.b	d1
+		move.b	d1,$41(a0)
		move.l	#CrowFeather_Wait,address(a0)

CrowFeather_Wait:
		jsr	(Refresh_ChildPositionAdjusted_Animate).w
		subq.w	#1,$2E(a0)
		bpl.s	CrowFeather_CheckFloor_Return
		move.l	#CrowFeather_Move,address(a0)
		move.w	#$68,y_vel(a0)

CrowFeather_Move:
		move.b	$41(a0),d0
		add.b	d0,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#1,d0
		move.w	d0,x_vel(a0)
		jsr	(MoveSprite2).w
		bsr.s	CrowFeather_CheckFloor
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

CrowFeather_CheckFloor:
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	CrowFeather_CheckFloor_Return
		add.w	d1,y_pos(a0)
		move.l	#Delete_Current_Sprite,address(a0)

CrowFeather_CheckFloor_Return:
		rts

; =============== S U B R O U T I N E =======================================

ObjDat3_Crow:
		dc.l Map_Crow
		dc.w $24C0
ObjDat3_CrowFeather:
		dc.w $180
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b $B
ChildObjDat_CrowFeather:
		dc.w 4-1
		dc.l Obj_CrowFeather
; ---------------------------------------------------------------------------

		include "Objects/Crow/Object data/Anim - Crow.asm"
		include "Objects/Crow/Object data/Map - Crow.asm"
