; ---------------------------------------------------------------------------
; ����-Great Blue Lord
; ---------------------------------------------------------------------------

; Hits
BossGreatBlueLord_Hits	= BossGreatAxeLord_Hits

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6

; Animates
setBGBLWait				= 0
setBGBLWalk				= 1
setBGBLWalk2			= 2
setBGBLAttack			= 3
setBGBLAttack2			= 4
setBGBLAttack3			= 5
setBGBLAttack4			= 6
setBGBLJump			= 7
setBGBLJump2			= 8
setBGBLJump3			= 9
setBGBLDefeated			= $A

; Dynamic object variables
obBGBL_Swing			= $30	; .b
obBGBL_Wait			= $31	; .b
obBGBL_Jump			= $32	; .b
obBGBL_Flash			= $33	; .b
obBGBL_Attack			= $39	; .b

; =============== S U B R O U T I N E =======================================

Obj_GreatBlueLord:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	GreatBlueLord_Index(pc,d0.w),d0
		jsr	GreatBlueLord_Index(pc,d0.w)
		bsr.w	GreatBlueLord_CheckTouch
		bsr.w	GreatBlueLord_CheckAnim
		bsr.w	GreatBlueLord_Acceleration
		bsr.w	GreatBlueLord_Warning
		lea	Ani_GreatBlueLord_Feet(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

GreatBlueLord_Index: offsetTable
		offsetTableEntry.w GreatBlueLord_Init		; 0
		offsetTableEntry.w GreatBlueLord_Setup		; 2
		offsetTableEntry.w GreatBlueLord_Setup2	; 4
		offsetTableEntry.w GreatBlueLord_Setup3	; 6
; ---------------------------------------------------------------------------

GreatBlueLord_Init:
		lea	ObjDat3_GreatBlueLord(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#113/2,y_radius(a0)
		lea	GreatAxeLord_HP(pc),a1
		move.w	(Difficulty_Flag).w,d0
		move.b	(a1,d0.w),collision_property(a0)
		move.l	#GreatBlueLord_MoveLeftRight,$34(a0)
		lea	ChildObjDat_GreatBlueLord_Torso(pc),a2
		jsr	(CreateChild1_Normal).w
		lea	(Pal_BossGreatBlueLord).l,a1
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------

GreatBlueLord_Setup2:
		jsr	(MoveSprite).w
		tst.b	render_flags(a0)
		bpl.s	GreatBlueLord_CheckCameraPosition_Return
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

GreatBlueLord_Setup3:
		bsr.s	GreatBlueLord_CheckCameraPosition

GreatBlueLord_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

GreatBlueLord_CheckCameraPosition:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		clr.w	x_vel(a0)
+		addi.w	#$100,d0
		cmp.w	x_pos(a0),d0
		bgt.s	GreatBlueLord_CheckCameraPosition_Return
		clr.w	x_vel(a0)

GreatBlueLord_CheckCameraPosition_Return:
		rts
; ---------------------------------------------------------------------------
; �������� ����� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_MoveLeftRight:
		move.b	#5,obBGBL_Wait(a0)

GreatBlueLord_MoveLeftRight2:
		sf	obBGBL_Swing(a0)
		move.b	#setBGBLWalk,anim(a0)
		move.w	#$17,$2E(a0)
		move.l	#GreatBlueLord_WaitMove,$34(a0)
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

GreatBlueLord_WaitMove:
		clr.w	x_vel(a0)
		move.b	#setBGBLWalk2,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatBlueLord_MoveLeftRight2,$34(a0)
		subq.b	#1,obBGBL_Wait(a0)
		bne.s	GreatBlueLord_StopMove3
		move.l	#GreatBlueLord_StopMove,$34(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_StopMove:
		clr.w	x_vel(a0)
		sf	obBGBL_Swing(a0)
		clr.b	anim(a0)
		move.w	#$2F,$2E(a0)
		move.l	#GreatBlueLord_MoveJump,$34(a0)
		cmpi.b	#3,obBGBL_Jump(a0)
		bne.s	GreatBlueLord_StopMove2
		clr.b	obBGBL_Jump(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_StopMove2:
		tst.b	obBGBL_Attack(a0)
		bne.s	GreatBlueLord_Return
		move.l	#GreatBlueLord_MoveLeftRight,$34(a0)

GreatBlueLord_StopMove3:
		jsr	(Find_SonicTails).w
		cmpi.w	#96,d2
		bhs.s	GreatBlueLord_Return
		st	obBGBL_Swing(a0)
		move.b	#setBGBLAttack,anim(a0)
		move.w	#$1F,$2E(a0)
		move.l	#GreatBlueLord_HandAttack,$34(a0)

GreatBlueLord_Return:
		rts
; ---------------------------------------------------------------------------
; ���� ������� � ������� ����� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_HandAttack:
		sfx	sfx_SpikeBall
		move.b	#setBGBLAttack2,anim(a0)
		st	obBGBL_Attack(a0)
		move.w	#$1F,$2E(a0)
		move.l	#GreatBlueLord_MoveLeftRight_HandAttack,$34(a0)
		lea	ChildObjDat_GreatBlueLord_Hand_Collision(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------
; �������� ����� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_MoveLeftRight_HandAttack:
		move.b	#_Setup3,routine(a0)
		move.b	#3,obBGBL_Wait(a0)

GreatBlueLord_MoveLeftRight_HandAttack2:
		sf	obBGBL_Swing(a0)
		move.b	#setBGBLWalk,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatBlueLord_HandAttack_WaitMove,$34(a0)
		move.w	#$200,d0
		btst	#0,status(a0)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_HandAttack_WaitMove:
		clr.w	x_vel(a0)
		move.b	#setBGBLWalk2,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatBlueLord_MoveLeftRight_HandAttack2,$34(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		bra.s	GreatBlueLord_HandAttack_WaitMove2
+		addi.w	#$100,d0
		cmp.w	x_pos(a0),d0
		bgt.s	GreatBlueLord_HandAttack_Return

GreatBlueLord_HandAttack_WaitMove2:
		move.b	#_Setup1,routine(a0)
		move.l	#GreatBlueLord_MoveJump,$34(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$1F,d0
		cmp.w	x_pos(a0),d0
		ble.s		+
		bra.s	GreatBlueLord_HandAttack_WaitMove3
+		addi.w	#$102,d0
		cmp.w	x_pos(a0),d0
		bge.s	GreatBlueLord_HandAttack_Return

GreatBlueLord_HandAttack_WaitMove3:
		move.l	#GreatBlueLord_MoveLeftRight,$34(a0)
		sf	obBGBL_Attack(a0)

GreatBlueLord_HandAttack_Return:
		rts
; ---------------------------------------------------------------------------
; ���� ������� � ������� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_MoveJump:
		move.b	#_Setup2,routine(a0)
		sfx	sfx_Tear
		st	obBGBL_Swing(a0)
		sf	obBGBL_Attack(a0)
		move.b	#setBGBLJump,anim(a0)
		move.l	#GreatBlueLord_MoveJump_CheckFloor,$34(a0)
		move.w	#-$300,d0
		btst	#0,status(a0)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		move.w	#-$900,y_vel(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_MoveJump_CheckFloor:
		move.b	#_Setup1,routine(a0)
		move.b	#setBGBLJump2,anim(a0)
		move.w	#$2F,$2E(a0)
		move.l	#GreatBlueLord_MoveJump_Return,$34(a0)
		sfx	sfx_Raid
		move.w	#$14,(Screen_shaking_flag).w
		clr.l	x_vel(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_MoveJump_Return:
		move.b	#setBGBLJump3,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatBlueLord_FlyHandAttack,$34(a0)
		rts
; ---------------------------------------------------------------------------
; ���� ������� � ������� ����� �������� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_FlyHandAttack:
		sfx	sfx_Signal
		move.b	#$A,obBGBL_Flash(a0)
		move.b	#setBGBLAttack3,anim(a0)
		bchg	#0,status(a0)
		bchg	#0,render_flags(a0)
		st	obBGBL_Swing(a0)
		st	obBGBL_Attack(a0)
		move.l	#GreatBlueLord_HandAttack_Return,$34(a0)
		lea	ChildObjDat_GreatBlueLord_FlyHand(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHandAttack_Return:
		sfx	sfx_Attachment
		move.b	#setBGBLAttack4,anim(a0)
		move.l	#GreatBlueLord_FlyHandAttack_StopVelocity,$34(a0)
		move.w	#$200,d0
		btst	#0,status(a0)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHandAttack_StopVelocity:
		move.w	x_vel(a0),d0
		cmpi.w	#$80,d0
		blo.s	GreatBlueLord_FlyHandAttack_Stop
		cmpi.w	#-$80,d0
		bhs.s	GreatBlueLord_FlyHandAttack_Stop
		asr.w	d0
		move.w	d0,x_vel(a0)
		move.w	#7,$2E(a0)
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHandAttack_Stop:
		sf	obBGBL_Attack(a0)
		move.w	#$F,$2E(a0)
		move.l	#GreatBlueLord_MoveLeftRight,$34(a0)
		clr.w	x_vel(a0)
		rts
; ---------------------------------------------------------------------------
; �������� ����� ��� ������ ��������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_CheckAnim:
		btst	#6,status(a0)
		bne.s	+
		moveq	#0,d0
		move.b	anim(a0),d0
		move.b	GreatBlueLord_Collision(pc,d0.w),collision_flags(a0)
+		rts
; ---------------------------------------------------------------------------

GreatBlueLord_Collision:
		dc.b $25|$80	; Wait
		dc.b $25|$80	; Walk
		dc.b $25|$80	; Walk2
		dc.b $25|$80	; Attack
		dc.b $25|$80	; Attack2
		dc.b $25		; Attack3
		dc.b $25|$80	; Attack4
		dc.b $25|$80	; Jump
		dc.b $25|$80	; Jump2
		dc.b $25|$80	; Jump3
; ---------------------------------------------------------------------------
; ��������� �������� ����� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_Acceleration:
		moveq	#0,d0
		move.b	anim(a0),d0
		cmpi.b	#setBGBLAttack3,d0
		bne.s	GreatBlueLord_Acceleration_Return
		btst	#6,status(a0)
		beq.s	GreatBlueLord_Acceleration_Return
		tst.w	x_vel(a0)
		beq.s	GreatBlueLord_Acceleration_Return
		btst	#0,$1C(a0)
		bne.s	GreatBlueLord_Acceleration_Return
		asr.w	x_vel(a0)

GreatBlueLord_Acceleration_Return:
		rts
; ---------------------------------------------------------------------------
; ������� ����� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_Warning:
		tst.b	obBGBL_Flash(a0)
		beq.s	GreatBlueLord_Acceleration_Return
		subq.b	#1,obBGBL_Flash(a0)
		btst	#6,status(a0)
		bne.s	GreatBlueLord_Acceleration_Return
		lea	(Pal_BossGreatBlueLord).l,a1

		tst.w	Seizure_Flag.w			; check if photosensitivity mode
		beq.s	.normal				; branch if not
		tst.b	obBGAL_Flash(a0)
		beq.s	.palette
		bra.s	.altpal

.normal
		btst	#0,obBGBL_Flash(a0)
		beq.s	.palette

.altpal
		lea	$20(a1),a1

.palette
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

GreatBlueLord_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	GreatBlueLord_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	GreatBlueLord_CheckTouch_WaitExplosive
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
		bne.s	+
		addi.w	#7*2,d0

+
		bsr.w	BossGreatBlueLord_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	GreatBlueLord_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

		; fix pal
		moveq	#0,d0
		bsr.w	BossGreatBlueLord_PalFlash

GreatBlueLord_CheckTouch_Return:
		move.b	#80,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_CheckTouch_WaitExplosive:
		move.l	#GreatBlueLord_CheckTouch_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		bset	#4,$38(a0)
		st	obBGBL_Swing(a0)
		move.b	#setBGBLDefeated,anim(a0)
		move.w	#$2020,$3A(a0)
		clr.l	x_vel(a0)
		jmp	(BossDefeated).w
; ---------------------------------------------------------------------------

GreatBlueLord_CheckTouch_WaitPlayerExplosive:
		bsr.w	BossCerberus_CreateFire
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge

+
		moveq	#0,d0
		tst.w	Seizure_Flag.w			; check if photosensitivity mode
		beq.s	.normal				; branch if not
		btst	#3,(Level_frame_counter+1).w
		bra.s	.checkflag

.normal
		btst	#0,(Level_frame_counter+1).w

.checkflag
		bne.s	+
		addi.w	#7*2,d0
+
		bsr.w	BossGreatBlueLord_PalFlash

		jsr	(Draw_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	GreatBlueLord_CheckTouch_Return

		lea	(Pal_GMZ).l,a1
		jsr	(PalLoad_Line1).w
	;	music	mus_GMZ1

		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#2,(AstarothCompleted).w
		move.l	#Obj_Shielder_Explosion,address(a0)
		bset	#7,status(a0)
		rts
; ---------------------------------------------------------------------------
; ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatBlueLord_Torso:
		lea	ObjDat3_GreatBlueLord_Torso(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		move.l	#GreatBlueLord_Torso_Main,address(a0)

GreatBlueLord_Torso_Main:
		moveq	#0,d0
		movea.w	parent3(a0),a1
		tst.b	obBGBL_Swing(a1)
		bne.s	GreatBlueLord_Torso_SetSwing
		move.b	angle(a0),d0
		addq.b	#4,d0
		move.b	d0,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#5,d0

GreatBlueLord_Torso_SetSwing:
		move.b	d0,child_dy(a0)
		jsr	(Refresh_ChildPositionAdjusted_Animate).w
		move.b	anim(a1),anim(a0)
		lea	Ani_GreatBlueLord_Torso(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	GreatBlueLord_Torso_Remove

GreatBlueLord_Torso_Draw:
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

GreatBlueLord_Torso_Remove:
		bclr	#7,status(a1)
		move.w	#$6A,y_vel(a0)
		move.l	#GreatBlueLord_Torso_MoveDown_Remove,address(a0)

GreatBlueLord_Torso_MoveDown_Remove:
		jsr	(MoveSprite2).w
		bra.s	GreatBlueLord_Torso_Draw
; ---------------------------------------------------------------------------
; ���� �����(��������)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatBlueLord_Hand_Collision:
		bset	#2,render_flags(a0)
		move.b	#6|$80,collision_flags(a0)
		move.l	#GreatBlueLord_Hand_Collision_Main,address(a0)
		jsr	(Refresh_ChildPositionAdjusted).w

GreatBlueLord_Hand_Collision_Main:
		movea.w	parent3(a0),a1
		cmpi.b	#setBGBLAttack2,anim(a1)
		bne.s	GreatBlueLord_Hand_Collision_Remove
		jmp	(Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

GreatBlueLord_Hand_Collision_Remove:
		move.l	#Delete_Current_Sprite,address(a0)
		rts
; ---------------------------------------------------------------------------
; �������� ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatBlueLord_FlyHand:
		lea	ObjDat3_GreatBlueLord_FlyHand(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		ori.b	#$80,art_tile(a0)
		move.l	#GreatBlueLord_FlyHand_WaitFire,address(a0)
		movea.w	parent3(a0),a1
		move.w	#$1F,$2E(a0)
		bclr	#0,render_flags(a0)
		btst	#0,status(a1)
		beq.s	GreatBlueLord_FlyHand_WaitFire
		bset	#0,render_flags(a0)

GreatBlueLord_FlyHand_WaitFire:
		bsr.w	GreatBlueLord_CreateFire
		jsr	(Refresh_ChildPositionAdjusted).w
		subq.w	#1,$2E(a0)
		bpl.w	GreatBlueLord_FlyHand_Draw
		movea.w	parent3(a0),a2
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		btst	#0,status(a2)
		beq.s	+
		addi.w	#$100,d0
+		move.w	d0,$30(a0)
		lea	(Player_1).w,a1
		move.w	y_pos(a1),$32(a0)
		sfx	sfx_Boom
		move.l	#GreatBlueLord_FlyHand_AttackSonic,address(a0)

		lea	ChildObjDat_GreatBlueLord_FlyHand_Chain(pc),a2
		jsr	(CreateChild8_TreeListRepeated).w

GreatBlueLord_FlyHand_AttackSonic:
		bsr.w	GreatBlueLord_FlyHand_CheckSonic
		bsr.s	GreatBlueLord_FlyHand_SonicPosition
		move.w	$30(a0),d0
		sub.w	x_pos(a0),d0
		bne.s	+
		move.l	#GreatBlueLord_FlyHand_AttackReturn,address(a0)
+		moveq	#5,d1
		asl.w	d1,d0
		move.w	d0,x_vel(a0)
		move.w	$32(a0),d0
		sub.w	y_pos(a0),d0
		asl.w	d1,d0
		move.w	d0,y_vel(a0)
		bra.w	GreatBlueLord_FlyHand_Draw
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHand_CheckSonic:
		movea.w	parent3(a0),a1
		btst	#6,status(a1)
		bne.s	GreatBlueLord_FlyHand_SonicPosition_Return
		tst.b	$3B(a0)
		bne.s	GreatBlueLord_FlyHand_SonicPosition_Return
		jsr	(Find_SonicTails).w
		move.w	#24,d1
		cmp.w	d1,d2
		bhs.s	GreatBlueLord_FlyHand_SonicPosition_Return
		cmp.w	d1,d3
		bhs.s	GreatBlueLord_FlyHand_SonicPosition_Return
		st	$3B(a0)
		st	(Ctrl_1_locked).w
		move.b	#$81,object_control(a1)
		move.w	#id_Hurt<<8,anim(a1)
		bset	#Status_InAir,status(a1)
		bclr	#Status_Roll,status(a1)
		bclr	#Status_RollJump,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHand_SonicPosition:
		tst.b	$3B(a0)
		beq.s	GreatBlueLord_FlyHand_SonicPosition_Return
		lea	(Player_1).w,a1
		movea.w	parent3(a0),a2
		move.w	x_pos(a0),d0
		move.w	#-16,d1
		btst	#0,status(a2)
		beq.s	+
		neg.w	d1
+		add.w	d1,d0
		move.w	d0,x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)

GreatBlueLord_FlyHand_SonicPosition_Return:
		rts
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHand_AttackReturn:
		bsr.s	GreatBlueLord_FlyHand_SonicPosition
		moveq	#0,d1
		moveq	#5,d2
		movea.w	parent3(a0),a1
		move.b	child_dx(a0),d1
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		ext.w	d1
		btst	#0,status(a1)
		beq.s	+
		neg.w	d1
+		add.w	d1,d0
		asl.w	d2,d0
		move.w	d0,x_vel(a0)
		moveq	#0,d1
		move.b	child_dy(a0),d1
		move.w	y_pos(a1),d0
		sub.w	y_pos(a0),d0
		ext.w	d1
		add.w	d1,d0
		asl.w	d2,d0
		move.w	d0,y_vel(a0)
		jsr	(Find_OtherObject).w
		move.w	#64,d1
		cmp.w	d1,d2
		bhs.s	GreatBlueLord_FlyHand_Draw
		cmp.w	d1,d3
		bhs.s	GreatBlueLord_FlyHand_Draw
		clr.l	x_vel(a0)
		bset	#7,status(a0)
		move.l	#Delete_Current_Sprite,address(a0)
		move.l	#GreatBlueLord_FlyHandAttack_Return,$34(a1)
		tst.b	$3B(a0)
		beq.s	GreatBlueLord_FlyHand_Draw
		lea	(Player_1).w,a1
		jsr	(sub_24280).l
		sf	(Ctrl_1_locked).w

GreatBlueLord_FlyHand_Draw:
		jsr	(MoveSprite2).w
		moveq	#$1C,d0
		jmp	(Child_Draw_Sprite2_FlickerMove).w
; ---------------------------------------------------------------------------
; �������� ���� ����� (����)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_GreatBlueLord_FlyHand_Chain:
		lea	ObjDat3_GreatBlueLord_FlyHand_Chain(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		ori.b	#$80,art_tile(a0)
		lsr	subtype(a0)
		move.b	#-$18,child_dy(a0)
		movea.w	$44(a0),a1				; Arm
		move.b	#-$3A,child_dx(a0)
		btst	#0,render_flags(a1)
		beq.s	+
		move.b	#$18,child_dx(a0)
+		move.l	#GreatBlueLord_FlyHand_Chain_Main,address(a0)

GreatBlueLord_FlyHand_Chain_Main:
		movea.w	$44(a0),a1				; Arm
		movea.w	parent3(a1),a3			; Torso
		move.w	x_pos(a1),d1
		move.w	x_pos(a3),d0
		move.b	child_dx(a0),d5
		ext.w	d5
		add.w	d5,d0
		sub.w	d0,d1
		move.w	d1,d3
		move.w	y_pos(a1),d2
		move.w	y_pos(a3),d0
		move.b	child_dy(a0),d5
		ext.w	d5
		add.w	d5,d0
		sub.w	d0,d2
		move.w	d2,d4
		movem.w	d3-d4,-(sp)
		jsr	(GetArcTan).w
		movem.w	(sp)+,d3-d4
		jsr	(GetSineCosine).w
		moveq	#0,d2
		move.b	subtype(a0),d2
		muls.w	d2,d3		; X
		muls.w	d2,d4		; Y
		swap	d0
		clr.w	d0
		swap	d1
		clr.w	d1
		swap	d3
		clr.w	d3
		swap	d4
		clr.w	d4
		asr.l	d1,d3			; X
		asr.l	d0,d4			; Y
		asr.l	#3,d3
		move.l	d3,d0
		asr.l	#4,d0
		add.l	d0,d3
		asr.l	#3,d4
		move.l	d4,d0
		asr.l	#4,d0
		add.l	d0,d4
		move.l	x_pos(a3),d0
		add.l	d3,d0
		move.b	child_dx(a0),d5
		ext.w	d5
		ext.l	d5
		swap	d5
		add.l	d5,d0
		move.l	d0,x_pos(a0)
		move.l	y_pos(a3),d0
		add.l	d4,d0
		move.b	child_dy(a0),d5
		ext.w	d5
		ext.l	d5
		swap	d5
		add.l	d5,d0
		move.l	d0,y_pos(a0)
		moveq	#7*4,d0
		btst	#0,subtype(a0)
		bne.s	GreatBlueLord_FlyHand_Chain_Check
		btst	#0,(Level_frame_counter+1).w
		bne.s	GreatBlueLord_FlyHand_Chain_CheckParent

GreatBlueLord_FlyHand_Chain_Draw:
		jmp	(Child_Draw_Sprite_FlickerMove).w
; ---------------------------------------------------------------------------

GreatBlueLord_FlyHand_Chain_Check:
		btst	#0,(Level_frame_counter+1).w
		bne.s	GreatBlueLord_FlyHand_Chain_Draw

GreatBlueLord_FlyHand_Chain_CheckParent:
		jmp	(Child_CheckParent_FlickerMove).w

; =============== S U B R O U T I N E =======================================

GreatBlueLord_CreateFire:
		btst	#0,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_GreatBlueLord_FlyHand_Fire(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.b	#16/2,$3A(a1)
		move.b	#16/2,$3B(a1)
		move.w	#$300,$3C(a1)
+		rts
; ---------------------------------------------------------------------------
; ��� �� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGreatBlueLord_Fire:
		move.w	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.w	++
		move.l	#Obj_BossGreatBlueLord_Fire_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$8310,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	$3C(a0),priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(loc_83E90).l
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		movea.w	parent3(a0),a2
		btst	#0,render_flags(a2)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.s	Obj_BossGreatBlueLord_Fire_Remove
; ---------------------------------------------------------------------------

Obj_BossGreatBlueLord_Fire_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	Obj_BossGreatBlueLord_Fire_Remove
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_BossGreatBlueLord_Fire_Remove:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

BossGreatBlueLord_PalFlash:
		lea	LoadBossGreatBlueLord_PalRAM(pc),a1
		lea	LoadBossGreatBlueLord_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

LoadBossGreatBlueLord_PalRAM:
		dc.w Normal_palette_line_2+4
		dc.w Normal_palette_line_2+6
		dc.w Normal_palette_line_2+$10
		dc.w Normal_palette_line_2+$12
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
LoadBossGreatBlueLord_PalCycle:
		dc.w $220, $660, $EC6, $A86, $864, $642, $EE8
		dc.w $220, $60, $ACE, $68A, $468, $246, $EE8

; =============== S U B R O U T I N E =======================================

ObjDat3_GreatBlueLord:
		dc.l Map_GreatBlueLord
		dc.w $23CF
		dc.w $280
		dc.b 104/2
		dc.b 120/2
		dc.b 0
		dc.b $25|$80
ObjDat3_GreatBlueLord_Torso:
		dc.w $200
		dc.b 104/2
		dc.b 120/2
		dc.b 1
		dc.b 0
ObjDat3_GreatBlueLord_FlyHand:
		dc.w $200
		dc.b 16/2
		dc.b 16/2
		dc.b $14
		dc.b 0
ObjDat3_GreatBlueLord_FlyHand_Chain:
		dc.w $200
		dc.b 16/2
		dc.b 16/2
		dc.b $13
		dc.b 0
ChildObjDat_GreatBlueLord_Torso:
		dc.w 1-1
		dc.l Obj_GreatBlueLord_Torso
		dc.b 0, -24
ChildObjDat_GreatBlueLord_Hand_Collision:
		dc.w 1-1
		dc.l Obj_GreatBlueLord_Hand_Collision
		dc.b -72, 24
ChildObjDat_GreatBlueLord_FlyHand:
		dc.w 1-1
		dc.l Obj_GreatBlueLord_FlyHand
		dc.b -56, -24
ChildObjDat_GreatBlueLord_FlyHand_Chain:
		dc.w 8-1
		dc.l Obj_GreatBlueLord_FlyHand_Chain
ChildObjDat_GreatBlueLord_FlyHand_Fire:
		dc.w 1-1
		dc.l Obj_BossGreatBlueLord_Fire
		dc.b 0, 0
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Great Blue Lord/Object data/Anim - Great Blue Lord(Feet).asm"
		include "Objects/Bosses/Great Blue Lord/Object data/Anim - Great Blue Lord(Torso).asm"
		include "Objects/Bosses/Great Blue Lord/Object data/Map - Great Blue Lord.asm"
