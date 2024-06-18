; ---------------------------------------------------------------------------
; ����-Great Axe Lord
; ---------------------------------------------------------------------------

; Hits
BossGreatAxeLord_Hits	= 4

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6

; Animates
setBGALWait				= 0
setBGALWalk				= 1
setBGALWalk2			= 2
setBGALAttack			= 3
setBGALAttack2			= 4
setBGALJump			= 5
setBGALJump2			= 6
setBGALJump3			= 7
setBGALJump4			= 8
setBGALDefeated			= 9

; Dynamic object variables
obBGAL_Swing			= $30	; .b
obBGAL_Wait			= $31	; .b
obBGAL_Jump			= $32	; .b
obBGAL_Flash			= $33	; .b
obBGAL_Attack			= $39	; .b

; =============== S U B R O U T I N E =======================================

Obj_GreatAxeLord:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	GreatAxeLord_Index(pc,d0.w),d0
		jsr	GreatAxeLord_Index(pc,d0.w)
		bsr.w	GreatAxeLord_CheckTouch
		bsr.w	GreatAxeLord_CheckAnim
		bsr.w	GreatAxeLord_Acceleration
		bsr.w	GreatAxeLord_Warning
		lea	Ani_GreatAxeLord_Feet(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

GreatAxeLord_Index: offsetTable
		offsetTableEntry.w GreatAxeLord_Init	; 0
		offsetTableEntry.w GreatAxeLord_Setup	; 2
		offsetTableEntry.w GreatAxeLord_Setup2	; 4
GreatAxeLord_HP:
		dc.b BossGreatAxeLord_Hits/2	; Easy
		dc.b BossGreatAxeLord_Hits	; Normal
		dc.b BossGreatAxeLord_Hits+2	; Hard
		dc.b BossGreatAxeLord_Hits+2	; Maniac
; ---------------------------------------------------------------------------

GreatAxeLord_Init:
		lea	ObjDat3_GreatAxeLord(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#113/2,y_radius(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	GreatAxeLord_HP(pc,d0.w),collision_property(a0)
		move.l	#GreatAxeLord_MoveLeftRight,$34(a0)
		lea	ChildObjDat_GreatAxeLord_Torso(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------

GreatAxeLord_Setup2:
		jsr	(MoveSprite).w
		tst.b	render_flags(a0)
		bpl.w	GreatAxeLord_Return
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

GreatAxeLord_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------
; �������� ����� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_MoveLeftRight:
		move.b	#5,obBGAL_Wait(a0)
		addq.b	#1,obBGAL_Jump(a0)

GreatAxeLord_MoveLeftRight2:
		sf	obBGAL_Swing(a0)
		move.b	#setBGALWalk,anim(a0)
		move.w	#$17,$2E(a0)
		move.l	#GreatAxeLord_WaitMove,$34(a0)
		jsr	(Find_SonicTails).w
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)
		tst.w	d0
		beq.s	+
		bset	#0,status(a0)
		bset	#0,render_flags(a0)
+		move.w	#-$100,d0
		btst	#0,status(a0)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

GreatAxeLord_WaitMove:
		clr.w	x_vel(a0)
		move.b	#setBGALWalk2,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatAxeLord_MoveLeftRight2,$34(a0)
		subq.b	#1,obBGAL_Wait(a0)
		bne.s	GreatAxeLord_StopMove3
		move.l	#GreatAxeLord_StopMove,$34(a0)
		rts
; ---------------------------------------------------------------------------

GreatAxeLord_StopMove:
		clr.w	x_vel(a0)
		sf	obBGAL_Swing(a0)
		clr.b	anim(a0)
		move.w	#$2F,$2E(a0)
		move.l	#GreatAxeLord_MoveJump,$34(a0)
		cmpi.b	#3,obBGAL_Jump(a0)
		bne.s	GreatAxeLord_StopMove2
		clr.b	obBGAL_Jump(a0)
		rts
; ---------------------------------------------------------------------------

GreatAxeLord_StopMove2:
		tst.b	obBGAL_Attack(a0)
		bne.s	GreatAxeLord_Return
		move.l	#GreatAxeLord_MoveLeftRight,$34(a0)

GreatAxeLord_StopMove3:
		jsr	(Find_SonicTails).w
		cmpi.w	#96,d2
		bhs.s	GreatAxeLord_Return
		st	obBGAL_Swing(a0)
		move.b	#setBGALAttack,anim(a0)
		move.w	#$2F,$2E(a0)
		move.l	#GreatAxeLord_AxeAttack,$34(a0)

GreatAxeLord_Return:
		rts
; ---------------------------------------------------------------------------
; ���� ������� � ������� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_AxeAttack:
		sfx	sfx_SpikeBall
		move.b	#setBGALAttack2,anim(a0)
		st	obBGAL_Attack(a0)
		move.w	#$1F,$2E(a0)
		move.l	#GreatAxeLord_StopMove,$34(a0)
		lea	ChildObjDat_GreatAxeLord_Axe_Collision(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------
; ���� ������� � ������� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_MoveJump:
		move.b	#_Setup2,routine(a0)
		sfx	sfx_Tear
		st	obBGAL_Swing(a0)
		sf	obBGAL_Attack(a0)
		move.b	#setBGALJump,anim(a0)
		move.l	#GreatAxeLord_MoveJump_CheckFloor,$34(a0)
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asl.w	#1,d0
		move.w	d0,x_vel(a0)
		move.w	#-$D00,y_vel(a0)
		bclr	#0,render_flags(a0)
		bclr	#0,status(a0)
		tst.w	x_vel(a0)
		bmi.s	+
		bset	#0,status(a0)
		bset	#0,render_flags(a0)
+		rts
; ---------------------------------------------------------------------------

GreatAxeLord_MoveJump_CheckFloor:
		move.b	#_Setup1,routine(a0)
		move.b	#$10,obBGAL_Flash(a0)
		move.b	#setBGALJump2,anim(a0)
		move.w	#$2F,$2E(a0)
		move.l	#GreatAxeLord_MoveJump_CheckFloor_Wait,$34(a0)
		sfx	sfx_Raid
		move.w	#$14,(Screen_shaking_flag).w
		clr.l	x_vel(a0)
		lea	ChildObjDat_GreatAxeLord_AxeGround(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

GreatAxeLord_MoveJump_CheckFloor_Wait:
		move.b	#setBGALJump3,anim(a0)
		move.w	#$4F,$2E(a0)
		move.l	#GreatAxeLord_MoveJump_Return,$34(a0)
		rts
; ---------------------------------------------------------------------------

GreatAxeLord_MoveJump_Return:
		move.b	#setBGALJump4,anim(a0)
		move.w	#$1F,$2E(a0)
		sfx	sfx_SpikeBall
		move.l	#GreatAxeLord_MoveLeftRight,$34(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------
; �������� ����� ��� ������ ��������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_CheckAnim:
		btst	#6,status(a0)
		bne.s	+
		moveq	#0,d0
		move.b	anim(a0),d0
		move.b	GreatAxeLord_Collision(pc,d0.w),collision_flags(a0)
+		rts
; ---------------------------------------------------------------------------

GreatAxeLord_Collision:
		dc.b $25|$80	; Wait
		dc.b $25|$80	; Walk
		dc.b $25|$80	; Walk2
		dc.b $25|$80	; Attack
		dc.b $25|$80	; Attack2
		dc.b $25|$80	; Jump
		dc.b $F		; Jump2
		dc.b $F		; Jump3
		dc.b $25|$80	; Jump4
	even
; ---------------------------------------------------------------------------
; ��������� �������� ����� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_Acceleration:
		moveq	#0,d0
		move.b	anim(a0),d0
		cmpi.b	#setBGALJump2,d0
		beq.s	+
		cmpi.b	#setBGALJump3,d0
		bne.s	GreatAxeLord_Acceleration_Return
+		btst	#6,status(a0)
		beq.s	GreatAxeLord_Acceleration_Return
		tst.w	x_vel(a0)
		beq.s	GreatAxeLord_Acceleration_Return
		btst	#0,$1C(a0)
		bne.s	GreatAxeLord_Acceleration_Return
		asr.w	x_vel(a0)

GreatAxeLord_Acceleration_Return:
		rts
; ---------------------------------------------------------------------------
; ������� ����� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_Warning:
		tst.b	obBGAL_Flash(a0)
		beq.s	GreatAxeLord_Acceleration_Return
		subq.b	#1,obBGAL_Flash(a0)
		btst	#6,status(a0)
		bne.s	GreatAxeLord_Acceleration_Return
		lea	(Pal_BossGreatAxeLord).l,a1

		tst.w	Seizure_Flag.w			; check if photosensitivity mode
		beq.s	.normal				; branch if not
		tst.b	obBGAL_Flash(a0)
		beq.s	.palette
		bra.s	.altpal

.normal
		btst	#0,obBGAL_Flash(a0)
		beq.s	.palette

.altpal
		lea	$20(a1),a1

.palette
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatAxeLord_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	GreatAxeLord_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	GreatAxeLord_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	++
		move.b	#$40,$1C(a0)
		sfx	sfx_HitBoss
		bset	#6,status(a0)
		jsr	(Find_SonicTails).w
		move.w	#$300,d1
		tst.w	d0
		beq.s	+
		neg.w	d1
+		move.w	d1,x_vel(a0)

+		moveq	#0,d0
		tst.w	Seizure_Flag.w			; check if photosensitivity mode
		beq.s	.normal				; branch if not
		btst	#3,$1C(a0)
		bra.s	.checkflag

.normal
		btst	#0,$1C(a0)

.checkflag
		bne.s	.loadpal
		addi.w	#7*2,d0

.loadpal
		bsr.w	BossGreatAxeLord_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	GreatAxeLord_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

		; fix pal
		moveq	#0,d0
		bsr.w	BossGreatAxeLord_PalFlash

GreatAxeLord_CheckTouch_Return:
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		rts
; ---------------------------------------------------------------------------

GreatAxeLord_CheckTouch_WaitExplosive:
		move.l	#GreatAxeLord_CheckTouch_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		st	obBGAL_Swing(a0)
		move.b	#setBGALDefeated,anim(a0)
		move.w	#$2020,$3A(a0)
		clr.l	x_vel(a0)
		jmp	(BossDefeated).w
; ---------------------------------------------------------------------------

GreatAxeLord_CheckTouch_WaitPlayerExplosive:
		bsr.w	BossCerberus_CreateFire
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge


+		moveq	#0,d0
		tst.w	Seizure_Flag.w			; check if photosensitivity mode
		beq.s	.normal				; branch if not
		btst	#3,(Level_frame_counter+1).w
		bra.s	.checkflag

.normal
		btst	#0,(Level_frame_counter+1).w

.checkflag
		bne.s	.loadpal
		addi.w	#7*2,d0

.loadpal
		bsr.w	BossGreatAxeLord_PalFlash

		jsr	(Draw_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	GreatAxeLord_CheckTouch_Return
		addq.b	#2,(Dynamic_resize_routine).w
		move.l	#Obj_Shielder_Explosion,address(a0)
		bset	#7,status(a0)
		rts
; ---------------------------------------------------------------------------
; ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatAxeLord_Torso:
		lea	ObjDat3_GreatAxeLord_Torso(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#GreatAxeLord_Torso_Main,address(a0)
		lea	ChildObjDat_GreatAxeLord_Axe(pc),a2
		jsr	(CreateChild6_Simple).w

GreatAxeLord_Torso_Main:
		moveq	#0,d0
		movea.w	parent3(a0),a1
		tst.b	obBGAL_Swing(a1)
		bne.s	GreatAxeLord_Torso_SetSwing
		move.b	angle(a0),d0
		addq.b	#4,d0
		move.b	d0,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#5,d0

GreatAxeLord_Torso_SetSwing:
		move.b	d0,child_dy(a0)
		jsr	(Refresh_ChildPositionAdjusted_Animate).w
		move.b	anim(a1),anim(a0)
		lea	Ani_GreatAxeLord_Torso(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	GreatAxeLord_Torso_Remove

GreatAxeLord_Torso_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

GreatAxeLord_Torso_Remove:
		bclr	#7,status(a1)
		move.w	#$6A,y_vel(a0)
		move.l	#GreatAxeLord_Torso_MoveDown_Remove,address(a0)

GreatAxeLord_Torso_MoveDown_Remove:
		jsr	(MoveSprite2).w
		bra.s	GreatAxeLord_Torso_Draw
; ---------------------------------------------------------------------------
; ������ �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatAxeLord_Axe:
		lea	ObjDat3_GreatAxeLord_Axe(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#GreatAxeLord_Axe_Main,address(a0)

GreatAxeLord_Axe_Main:
		jsr	(Refresh_ChildPositionAdjusted_Animate).w
		move.b	anim(a1),anim(a0)
		lea	Ani_GreatAxeLord_Axe(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; ������ �����(��������)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatAxeLord_Axe_Collision:
		bset	#2,render_flags(a0)
		move.b	#$2D|$80,collision_flags(a0)
		move.l	#GreatAxeLord_Axe_Collision_Main,address(a0)
		jsr	(Refresh_ChildPositionAdjusted).w

GreatAxeLord_Axe_Collision_Main:
		movea.w	parent3(a0),a1
		cmpi.b	#setBGALAttack2,anim(a1)
		bne.s	GreatAxeLord_Axe_Collision_Remove
		jmp	(Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

GreatAxeLord_Axe_Collision_Remove:
		move.l	#Delete_Current_Sprite,address(a0)
		rts
; ---------------------------------------------------------------------------
; ����� �� ��� ������ �����
; ---------------------------------------------------------------------------

AxeGround_Speed:
		dc.w -$100, -$100, $100, -$100		; XY(Left), XY(Right)
		dc.w -$100, -$200, $100, -$200		; XY(Left), XY(Right)
		dc.w -$200, -$200, $200, -$200	; XY(Left), XY(Right)
		dc.w -$200, -$300, $200, -$300	; XY(Left), XY(Right)
		dc.w -$300, -$300, $300, -$300		; XY(Left), XY(Right)
		dc.w -$300, -$400, $300, -$400	; XY(Left), XY(Right)

; =============== S U B R O U T I N E =======================================

Obj_GreatAxeLord_AxeGround:
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.l	AxeGround_Speed(pc,d0.w),x_vel(a0)
		lea	ObjDat3_GreatAxeLord_AxeGround(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#GreatAxeLord_AxeGround_Main,address(a0)

GreatAxeLord_AxeGround_Main:
		jsr	(MoveSprite).w
		jmp	(Sprite_CheckDeleteXY).w

; =============== S U B R O U T I N E =======================================

BossGreatAxeLord_PalFlash:
		lea	LoadBossGreatAxeLord_PalRAM(pc),a1
		lea	LoadBossGreatAxeLord_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

LoadBossGreatAxeLord_PalRAM:
		dc.w Normal_palette_line_2+4
		dc.w Normal_palette_line_2+6
		dc.w Normal_palette_line_2+$10
		dc.w Normal_palette_line_2+$12
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
LoadBossGreatAxeLord_PalCycle:
		dc.w 2, $48, $66E, $64A, $428, $206, $CEE
		dc.w 2, $248, $8EE, $6AA, $488, $266, $CEE

; =============== S U B R O U T I N E =======================================

ObjDat3_GreatAxeLord:
		dc.l Map_GreatAxeLord
		dc.w $23CF
		dc.w $280
		dc.b 96/2
		dc.b 96/2
		dc.b 0
		dc.b $25|$80
ObjDat3_GreatAxeLord_Torso:
		dc.w $200
		dc.b 96/2
		dc.b 96/2
		dc.b 1
		dc.b 0
ObjDat3_GreatAxeLord_Axe:
		dc.w $180
		dc.b 96/2
		dc.b 96/2
		dc.b $14
		dc.b 0
ObjDat3_GreatAxeLord_AxeGround:
		dc.w $180
		dc.b 8/2
		dc.b 8/2
		dc.b $1D
		dc.b 0
ChildObjDat_GreatAxeLord_Torso:
		dc.w 1-1
		dc.l Obj_GreatAxeLord_Torso
		dc.b 0, -24
ChildObjDat_GreatAxeLord_Axe:
		dc.w 1-1
		dc.l Obj_GreatAxeLord_Axe
ChildObjDat_GreatAxeLord_Axe_Collision:
		dc.w 1-1
		dc.l Obj_GreatAxeLord_Axe_Collision
		dc.b -80, 24
ChildObjDat_GreatAxeLord_AxeGround:
		dc.w 12-1
		dc.l Obj_GreatAxeLord_AxeGround
PLC_GreatAxeLord: plrlistheader
		plreq $3CF, ArtKosM_BossGreatAxeLord
		plreq $310, ArtKosM_DEZExplosion
PLC_GreatAxeLord_End
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Great Axe Lord/Object data/Anim - Great Axe Lord(Feet).asm"
		include "Objects/Bosses/Great Axe Lord/Object data/Anim - Great Axe Lord(Torso).asm"
		include "Objects/Bosses/Great Axe Lord/Object data/Anim - Great Axe Lord(Axe).asm"
		include "Objects/Bosses/Great Axe Lord/Object data/Map - Great Axe Lord.asm"
