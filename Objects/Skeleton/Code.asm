Obj_Skeleton:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Skeleton_Index(pc,d0.w),d1
		jsr	Obj_Skeleton_Index(pc,d1.w)
                bsr.w   Obj_Skeleton_Process
		lea	Ani_Skeleton(pc),a1
		jsr	(AnimateSprite).w
		lea	DatDPLC_Skeleton(pc),a2
		jsr	Perform_DPLC
		jmp	(Obj_Skeleton_Display).l
; ===========================================================================
Obj_Skeleton_Index:
		dc.w Obj_Skeleton_Main-Obj_Skeleton_Index
		dc.w Obj_Skeleton_StandOnFloor-Obj_Skeleton_Index
		dc.w Obj_Skeleton_FindFloor-Obj_Skeleton_Index
		dc.w Obj_Skeleton_Preparing-Obj_Skeleton_Index
		dc.w Obj_Skeleton_WaitForHead-Obj_Skeleton_Index
		dc.w Obj_Skeleton_Delete-Obj_Skeleton_Index

DatDPLC_Skeleton:
		dc.l ArtUnc_Skeleton>>1, DPLC_Skeleton

ObjDat_Skeleton:
	SlotDataSCZ0	$0000, Map_Skeleton, 4*$80, $10, $10, $00, $22
; ===========================================================================

Obj_Skeleton_Process:
		tst.b   $29(a0)
		bne.s	.lacricium
		sfx	sfx_BreakBridge
		lea	ChildObjDat_BlueSkeletonRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.b  #$A,routine(a0)

.lacricium:
		rts

; ===========================================================================

Obj_Skeleton_Main:
		lea	ObjDat_Skeleton(pc),a1
		jsr	SetUp_ObjAttributesSlotted
                move.b  #1,$29(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Skeleton_Return
		move.l	#Obj_SkelBurnSkull,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.w	#$2A,obY(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,parent(a1)
; ===========================================================================
Obj_Skeleton_StandOnFloor:
		jsr	(ObjectFall).w
		jsr	(ObjFloorDist).w
		tst.w	d1		; is object above the ground?
		bpl.w	Obj_Skeleton_Return	; if yes, branch
		add.w	d1,obY(a0)	; match	object's position with the floor
		move.w	#0,obVelY(a0)
		bchg	#0,obStatus(a0)	; change object's orientation
		addq.b	#2,routine(a0)

Obj_Skeleton_Display:
		move.b	$33(a0),d0
		beq.s	Obj_Skeleton_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Skeleton_Return

Obj_Skeleton_Animate:
		jmp	Sprite_CheckDeleteTouchSlotted

Obj_Skeleton_LaunchHead:
		jsr	(Find_Sonic).w
		cmpi.w 	#$50,d2
		bcc.w 	Obj_Skeleton_Return
                jsr     (Obj_Eggman_LookOnSonic).l
                move.b  #2,obAnim(a0)
		move.w	#$2C,obTimer(a0)
                sfx     sfx_Switch
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Skeleton_Return
                move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#-$3C,$44(a1)			; Ypos
		move.w	#$2C,$2E(a1)			; Timer
		move.w	#$84D0,art_tile(a1)		; VRAM

		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($230),d2
		jsr	(Queue_Kos_Module).w
		move.b	#6,routine(a0)
                rts
; ===========================================================================

Obj_Skeleton_FindFloor:
		btst	#0,obStatus(a0)
		beq.s	.moveleft
		cmpi.w	#$100,obVelX(a0)
		bgt.s	.advance
		add.w	#8,obVelX(a0)
		bra.s	.advance

.moveleft:
		cmpi.w	#-$100,obVelX(a0)
		blt.s	.advance
		sub.w	#8,obVelX(a0)

.advance:
		jsr	(SpeedToPos).w
		move.w	x_pos(a0),d3
		subi.w	#$18,d3
		btst	#0,obStatus(a0)
		beq.s	+
		addi.w	#$30,d3
+  		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	Obj_Skeleton_Pause
		cmpi.w	#$C,d1
		bge.s	Obj_Skeleton_Pause
		add.w	d1,obY(a0)				; match object's position with the floor
                jmp     (Obj_Skeleton_LaunchHead).l
; ---------------------------------------------------------------------------

Obj_Skeleton_Pause:
		bchg	#0,obStatus(a0)
                rts

Obj_Skeleton_Preparing:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Skeleton_Return
		samp	sfx_FireAtkFire
		move.w	#$7A,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_Skeleton_WaitForHead:
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_Skeleton_Return
		sfx	sfx_BreakBridge
		lea	ChildObjDat_BlueSkeletonRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		addq.b	#2,routine(a0)

Obj_Skeleton_Delete:
                move.l	#Go_Delete_SpriteSlotted,address(a0)


Obj_Skeleton_Return:
		rts
; ===========================================================================
Obj_FireSkull_CheckXY:
		dc.w -16
		dc.w 32
		dc.w -32
		dc.w 64

ChildObjDat_BlueSkeletonRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DialogueFirebrandRadiusExplosion

Obj_SkelBurnSkull:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_SkelBurnSkull_Index(pc,d0.w),d1
		jsr	Obj_SkelBurnSkull_Index(pc,d1.w)
		bsr.w   Obj_SkelBurnSSkull_Process
		lea	Ani_Skeleton(pc),a1
		jsr	(AnimateSprite).w
		lea	DatDPLC_Skeleton(pc),a2
		jsr	Perform_DPLC
		jmp	Sprite_CheckDeleteTouchSlotted

; ===========================================================================
Obj_SkelBurnSkull_Index:
		dc.w	Obj_SkelBurnSkull_Main-Obj_SkelBurnSkull_Index
		dc.w	Obj_SkelBurnSkull_FollowBody-Obj_SkelBurnSkull_Index
		dc.w	Obj_SkelBurnSkull_Move-Obj_SkelBurnSkull_Index
; ===========================================================================

Obj_SkelBurnSSkull_Process:
		move.w	parent(a0),a1
                cmpi.b  #$A,routine(a1)
                beq.s   .delete

		tst.b   $29(a0)
		bne.w   Obj_SkelBurnSkull_Return
		sfx	sfx_BreakBridge
		lea	ChildObjDat_BlueSkeletonRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	parent(a0),a1
                move.b  #$A,routine(a1)

.delete:
                jsr     (SingleObjLoad).w
                bne.w   Obj_SkelBurnSkull_Return
                move.l  #Obj_Explosion,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.l	#Go_Delete_SpriteSlotted,address(a0)
                rts

Obj_SkelBurnSkull_Main:
		lea	ObjDat_SkelBurnSkull(pc),a1
		jsr	SetUp_ObjAttributesSlotted
                move.b  #1,$29(a0)
		move.b  #3,obAnim(a0)

Obj_SkelBurnSkull_FollowBody:
		move.w	parent(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
                sub.w   #$2A,obY(a0)
                move.b  obStatus(a1),obStatus(a0)
		add.w	#8,obX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		sub.w	#$F,obX(a0)
+		cmpi.b	#8,routine(a1)
		bne.w	Obj_SkelBurnSkull_Return
		add.w	#8,obY(a0)
		move.w	#$7A,obTimer(a0)
		addq.b	#2,routine(a0)
		move.b  #1,obAnim(a0)
		move.b	#$8B,obColType(a0)

Obj_SkelBurnSkull_Move:
		jsr	(Obj_Firebrand_ProduceExplosions).l
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Find_Sonic).w
		move.w	#$400,d0
		moveq	#$20,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_SkelBurnSkull_Return
                jsr     (SingleObjLoad).w
                bne.s   Obj_SkelBurnSkull_Return
                move.l  #Obj_Explosion,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.l	#Go_Delete_SpriteSlotted,address(a0)
; ===========================================================================

Obj_SkelBurnSkull_Return:
		rts

ObjDat_SkelBurnSkull:
	SlotDataSCZ0	$0000, Map_Skeleton, 3*$80, 4, 4, $00, $0B

ChildObjDat_SkeletonRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DialogueFirebrandRadiusExplosion

		include "Objects/Skeleton/Object data/Ani - Skeleton.asm"
		include "Objects/Skeleton/Object data/Map - Skeleton.asm"
		include "Objects/Skeleton/Object data/DPLC - Skeleton.asm"
