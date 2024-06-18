Obj_PhHand:
	jsr	(Obj_WaitOffscreen).w
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	PhHand_Index(pc,d0.w),d1
	jsr	PhHand_Index(pc,d1.w)
	lea	Ani_PhHand(pc),a1
	jsr	(AnimateSprite).w
	lea	DatDPLC_PhHand(pc),a2
	jsr	Perform_DPLC
	jmp	Sprite_CheckDeleteTouchSlotted

PhHand_Index:
	dc.w	PhHand_Main-PhHand_Index
	dc.w	PhHand_StandOnFloor-PhHand_Index
	dc.w	PhHand_Move-PhHand_Index
	dc.w	PhHand_FindFloor-PhHand_Index
	dc.w	PhHand_Jump-PhHand_Index
	dc.w	PhHand_HedgeInVise-PhHand_Index
        dc.w    PhHand_Death-PhHand_Index

DatDPLC_PhHand:
		dc.l ArtUnc_PhantomHand>>1, DPLC_PhantomHand

PhHand_ChkSonicClose:
	cmpi.w	#$38,d0
	bcc.w	PhHand_FindFloor_checksides
	move.w	#-$400,obVelY(a0)
	move.b	#1,obAnim(a0)
	samp	sfx_WalkingArmorAtk
	move.b	#8,routine(a0)
	rts

PhHand_Main:
	lea	ObjDat_PhantomHand(pc),a1
	jsr	SetUp_ObjAttributesSlotted

PhHand_StandOnFloor:
	jsr	(ObjectFall).w
	jsr	(ObjFloorDist).w
	tst.w	d1		; is object above the ground?
	bpl.s	PhHand_NotOnFloor	; if yes, branch
	add.w	d1,obY(a0)	; match	object's position with the floor
	move.w	#0,obVelY(a0)
	bchg	#0,obStatus(a0)
	addq.b	#2,routine(a0)

PhHand_NotOnFloor:
	rts

PhHand_Move:
	addq.b	#2,routine(a0)
	move.w	#-$180,obVelX(a0)	; move object to the left
	move.b	#0,obAnim(a0)
	bchg	#0,obStatus(a0)
	bne.w	PhHand_Return
	neg.w	obVelX(a0)			; change direction
; ---------------------------------------------------------------------------

PhHand_FindFloor:
	cmpi.w	#1,(Hand_Squeezes_Player).w
	beq.s	PhHand_FindFloor_checksides
	sub.w	#1,obTimer(a0)
	bpl.w	PhHand_FindFloor_checksides
;	jsr	(Find_Sonic).w
;	cmpi.w	#$30,d2
;	bcc.w	PhHand_FindFloor_checksides
	btst	#0,obStatus(a0)
	beq.s	PhHand_FindFloor_otherside
	move.w	(Player_1+obX).w,d0
	sub.w	obX(a0),d0
	jsr	(PhHand_ChkSonicClose).l
	rts

PhHand_FindFloor_otherside:
	move.w	obX(a0),d0
	sub.w	(Player_1+obX).w,d0
	jsr	(PhHand_ChkSonicClose).l
	rts

PhHand_FindFloor_checksides:
	jsr	(SpeedToPos).w
	move.w	x_pos(a0),d3
	subq.w	#7,d3
	btst	#0,obStatus(a0)
	beq.s	+
	addi.w	#$E,d3
+	jsr	(ObjCheckFloorDist).w
	cmpi.w	#-8,d1
	blt.s	PhHand_Pause
	cmpi.w	#$C,d1
	bge.s	PhHand_Pause
	add.w	d1,obY(a0)
	rts
; ---------------------------------------------------------------------------

PhHand_Pause:
	subq.b	#2,routine(a0)
	bra.w   PhHand_Return

PhHand_Jump:
	jsr	(Obj_Feal_CheckWalls).l
	jsr	(ObjectFall).w
	jsr	(ObjHitFloor).w
	tst.w	d1		; is object above the ground?
	bpl.w	PhHand_Return	; if yes, branch
	add.w	d1,obY(a0)	; match	object's position with the floor
	move.w	#0,obVelY(a0)
	move.b	#0,obAnim(a0)
	move.w	#$3C,obTimer(a0)
	move.b	#6,routine(a0)
	rts

PhHand_HedgeInVise:
	move.w	(Player_1+obX).w,d0
	sub.w	obX(a0),d0
	asl.w	#7,d0
	move.w	d0,obVelX(a0)
	move.w	(Player_1+obY).w,d0
	sub.w	obY(a0),d0
	asl.w	#7,d0
	move.w	d0,obVelY(a0)
	jsr	(SpeedToPos).l
	cmpi.w	#1,(Debug_placement_mode).w	; is debug mode	active?
	bne.s	PhHand_Return	; if no, branch

PhHand_Death:
        jsr	(Obj_HurtBloodCreate).l
	clr.w  (Hand_Squeezes_Player).w
	samp	sfx_PhantomHand
	move.w	#$600,(Sonic_Knux_top_speed).w		; restore top speed
	move.w	#$C,(Sonic_Knux_acceleration).w
	jsr	(SingleObjLoad).w
	bne.s	+
	move.l	#Obj_Explosion,(a1)
	move.w	obX(a0),obX(a1)
	move.w	obY(a0),obY(a1)
+       move.l	#Go_Delete_SpriteSlotted,address(a0)
        bset	#7,status(a0)

PhHand_Return:
	rts

; ---------------------------------------------------------------------------

ObjDat_PhantomHand:
	SlotDataSCZ0	$0000, SME_v4Jx9, 4*$80, $1C, $14, $00, $5B


		include "Objects/Phantom Hand/Object data/Ani - Phantom Hand.asm"
		include "Objects/Phantom Hand/Object data/Map - Phantom Hand.asm"
		include "Objects/Phantom Hand/Object data/DPLC - Phantom Hand.asm"