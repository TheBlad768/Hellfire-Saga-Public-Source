; ---------------------------------------------------------------------------
; Walking Armor
; ---------------------------------------------------------------------------

Obj_WalkArmor:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	WalkArmor_Index(pc,d0.w),d1
		jsr	WalkArmor_Index(pc,d1.w)
		bsr.w	Obj_WalkArmor_Process

		lea	Ani_WalkArmor(pc),a1
		jsr	AnimateSprite
		lea	DatDPLC_WalkArmor(pc),a2
		jsr	Perform_DPLC
		jmp	WalkArmor_AnimScan(pc)
; ---------------------------------------------------------------------------
WalkArmor_Index:
		dc.w WalkArmor_Main-WalkArmor_Index
		dc.w WalkArmor_Move-WalkArmor_Index
		dc.w WalkArmor_FindFloor-WalkArmor_Index
		dc.w WalkArmor_Atk-WalkArmor_Index

DatDPLC_WalkArmor:
		dc.l ArtUnc_WalkArmor>>1, ObjDPLC_WalkArmor
; ===========================================================================

Obj_WalkArmor_Process:
		tst.b	$28(a0)
		bne.w	.rts
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.whatizit		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	(a2),d0			; load to d0
		and.b	#$7F,d0			; clear custom bits
		or.b	$29(a0),d0		; put the hit counter there
		move.b	d0,(a2)			; save it back

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.s	.rts
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)

.rts
		rts

.gone:
		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.norespawn		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	#$82,(a2)		; make sure object does not respawn

.norespawn
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.l	#Go_Delete_SpriteSlotted2,(a0)

.lacricium:
		jmp	Go_Delete_SpriteSlotted3
; ===========================================================================

WalkArmor_ChkSonicNear:
		jsr	(ChkObjOnScreen).w
		bne.s	WalkArmor_ChkSonicNear_Locret
		sub.b	#1,objoff_1D(a0)
		bpl.s	WalkArmor_ChkSonicNear_Locret
		move.w 	(Player_1+obX).w,d0
		sub.w 	obX(a0),d0
		bpl.s 	WalkArmor_Command
		neg.w 	d0

WalkArmor_Command:
		cmpi.w 	#$75,d0
		blt.s 	WalkArmor_DoAxeKick

WalkArmor_ChkSonicNear_Locret:
		rts

WalkArmor_DoAxeKick:
		jsr	(Obj_Eggman_LookOnSonic).l
		move.b	#1,obAnim(a0)
		clr.b	objoff_47(a0)
		move.w	#37,obTimer(a0)
		move.b	#6,routine(a0)
		move.b	#$59,objoff_1D(a0)
		rts
; ===========================================================================

WalkArmor_AnimScan:
		btst	#6,$2A(a0)
		bne.s	+
		move.b	#0,d0
		move.b	obAnim(a0),d0
		move.b	WalkArmor_Data_Collision(pc,d0.w),d1
		move.b	d1,obColType(a0)

+  		move.b	$1C(a0),d0
		beq.s	Obj_WalkArmor_Animate
		lsr.b	#3,d0
		bcc.w	WalkArmor_Return

Obj_WalkArmor_Animate:
		jmp	Sprite_CheckDeleteTouchSlotted		; NAT: Also delete object if offscreen
; ---------------------------------------------------------------------------

WalkArmor_Data_Collision:
		dc.b  $23, $23, $10|$80, 0
; ===========================================================================

WalkArmor_Main:
		lea	ObjDat_WalkArmor(pc),a1
		jsr	SetUp_ObjAttributesSlotted

		or.b	#4,obRender(a0)
		move.b	#16,x_radius(a0)
		move.b	#$1A,y_radius(a0)
		move.b	#1,$29(a0)
                move.w	(Difficulty_Flag).l,d0
                beq.s   +
		move.b	#2,$29(a0)

+		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.norespawn		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	(a2),d0			; get contents to d0
		and.b	#$7F,d0			; get only custom bits
		sub.b	d0,$29(a0)		; sub from hit counter

.norespawn
		move.b	#1,objoff_1D(a0)
		jsr	(ObjectFall).w
		jsr	(ObjFloorDist).w
		tst.w	d1			; is object above the ground?
		bpl.s	WalkArmor_NotOnFloor	; if yes, branch
		add.w	d1,obY(a0)		; match	object's position with the floor
		move.w	#0,obVelY(a0)
		bchg	#0,obStatus(a0)		; change object's orientation

WalkArmor_NotOnFloor:
		rts
; -----------------------------------------------------------------------------
WalkArmor_Move:
		addq.b	#2,routine(a0)
		move.w	#-$100,obVelX(a0)	; move object to the left
		move.b	#0,obAnim(a0)			; change direction
		bchg	#0,obStatus(a0)
		bne.w	WalkArmor_Return
		neg.w	obVelX(a0)			; change direction
; ---------------------------------------------------------------------------

WalkArmor_FindFloor:
		jsr	(SpeedToPos).w
		move.w	x_pos(a0),d3
		subi.w	#8,d3
		btst	#0,obStatus(a0)
		beq.s	+
		addi.w	#$F,d3
+		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	WalkArmor_Pause
		cmpi.w	#$C,d1
		bge.s	WalkArmor_Pause
		add.w	d1,obY(a0)				; match object's position with the floor
		jmp	(WalkArmor_ChkSonicNear).l
; ---------------------------------------------------------------------------

WalkArmor_Pause:
		subq.b	#2,routine(a0)
		rts

WalkArmor_Atk:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(WalkArmor_SendSignal).l
		jsr	(WalkArmor_PlaySoundSignal).l
		sub.w	#1,obTimer(a0)
		bpl.s	WalkArmor_Return
		subq.b	#2,routine(a0)
		move.b	#0,obAnim(a0)
		move.w	#$100,obVelX(a0)	; move object to the left
		move.b	#0,obAnim(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		rts			; change direction

WalkArmor_Return:
		rts

WalkArmor_SendSignal:
		cmpi.b	#2,objoff_47(a0)
		beq.s	WalkArmor_Return
		cmpi.b	#2,obAnim(a0)
		bne.s	WalkArmor_Return
		move.b	#1,objoff_47(a0)
		rts

WalkArmor_PlaySoundSignal:
		cmpi.b	#1,objoff_47(a0)
		bne.s	WalkArmor_Return
		move.b	#2,objoff_47(a0)
		samp	sfx_WalkingArmorAtk
		rts
; ---------------------------------------------------------------------------

ObjDat_WalkArmor:
	SlotDataMGZ0	$0000, Map_WalkArmor, 3*$80, 48/2, $22, $00, $29

		include "Objects/Walking Armor/Object data/Ani - Walking Armor.asm"
		include "Objects/Walking Armor/Object data/Map - Walking Armor.asm"

ObjDPLC_WalkArmor:
		include "Objects/Walking Armor/Object data/DPLC - Walking Armor.asm"
