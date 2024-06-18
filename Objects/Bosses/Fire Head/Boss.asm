; ---------------------------------------------------------------------------
; Boss Fire Head from Sparkster.
; Version 1.0
; By TheBlad768 (2021).
; ---------------------------------------------------------------------------

; Hits
BossFireHead_Hits			= 9

; Dynamic object variables
obBFH_XVel					= $30	; .l
obBFH_Jump				= $34	; .l
obBFH_YVel					= $38	; .l
obBFH_Routine				= $3E	; .b
obBFH_VelRoutine			= $3F	; .b

; RAM
vInsertCoin_TextFactor		= Warper_Flag

; =============== S U B R O U T I N E =======================================

BossFireHead_HP:
		dc.b BossFireHead_Hits/2	; Easy
		dc.b BossFireHead_Hits	; Normal
		dc.b BossFireHead_Hits+2	; Hard
		dc.b BossFireHead_Hits+2	; Maniac
; ---------------------------------------------------------------------------

Obj_BossFireHead:
		tst.w	(Kos_modules_left).w
		bne.w	BossFireHead_Intro_Return
		move.l	#BossFireHead_Setup,address(a0)

; Init
		lea	ObjDat3_BossFireHead(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.w	(Difficulty_Flag).w,d0
		move.b	BossFireHead_HP(pc,d0.w),collision_property(a0)
		move.w	x_pos(a0),objoff_30(a0)
		move.w	y_pos(a0),objoff_38(a0)
		move.l	#BossFireHead_Intro,obBFH_Jump(a0)
		lea	(Pal_FireHead).l,a1
		jsr	(PalLoad_Line1).w
		st	(Screen_shaking_flag).w
		move.b	#$14,(vInsertCoin_TextFactor).w
		lea	ChildObjDat6_BossFireHead_LoadArt_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.nofreeslot
		move.w	#7,$2E(a1)
		move.w	#7,$30(a1)
		move.w	#tiles_to_bytes($320),$32(a1)
		move.l	#ArtUnc_FireBall,$34(a1)
		move.w	#(ArtUnc_FireBall_End-ArtUnc_FireBall)/2,$3E(a1)
		move.w	#((ArtUnc_FireBall_End-ArtUnc_FireBall)/$20)-1,$40(a1)

.nofreeslot
		lea	ChildObjDat6_BossFireHead_Blowout_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat6_BossFireHead_SmallBlowout_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat6_BossFireHead_BallTails(pc),a2
		jsr	(CreateChild6_Simple).w

BossFireHead_Setup:
		move.b	(V_int_run_count+3).w,d0
		andi.b	#$F,d0
		bne.s	BossFireHead_Setup2
		sfx	sfx_SpecialRumble

BossFireHead_Setup2:
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_30(a0)
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_38(a0)
		move.b	angle(a0),d0
		addq.b	#1,angle(a0)
		jsr	(GetSineCosine).w
		muls.w	#4,d0
		asr.l	#8,d0
		add.w	objoff_30(a0),d0
		move.w	d0,x_pos(a0)
		move.w	objoff_38(a0),y_pos(a0)
		pea	BossFireHead_MainProcess(pc)
		jmp	(Obj_Wait).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_Intro:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	BossFireHead_Intro_Return
		move.w	#-$100,y_vel(a0)
		move.l	#BossFireHead_IntroLoadArt,obBFH_Jump(a0)

BossFireHead_Intro_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_IntroLoadArt:
		move.l	#BossFireHead_IntroWaitLoadArt,obBFH_Jump(a0)
		move.b	#$14,(vInsertCoin_TextFactor).w
		lea	ChildObjDat6_BossFireHead_LoadArt_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFireHead_IntroLoadArt_Return
		move.w	#7,$2E(a1)
		move.w	#7,$30(a1)
		move.w	#tiles_to_bytes($2A0),$32(a1)
		move.l	#ArtUnc_FireHead,$34(a1)
		move.w	#(ArtUnc_FireHead_End-ArtUnc_FireHead)/2,$3E(a1)
		move.w	#((ArtUnc_FireHead_End-ArtUnc_FireHead)/$20)-1,$40(a1)

BossFireHead_IntroLoadArt_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_IntroWaitLoadArt:
		tst.b	(vInsertCoin_TextFactor).w
		bne.s	BossFireHead_IntroWaitLoadArt_Return
		move.l	#BossFireHead_IntroCheckPos,obBFH_Jump(a0)

BossFireHead_IntroWaitLoadArt_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_IntroCheckPos:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$30,d0
		cmp.w	objoff_38(a0),d0
		blo.s	BossFireHead_IntroCheckPos_Return
		move.w	d0,objoff_38(a0)
		clr.w	y_vel(a0)
		clr.b	(Screen_shaking_flag).w
		move.b	#$11,collision_flags(a0)
		move.l	#BossFireHead_Setup2,address(a0)
		move.l	#BossFireHead_IntroSetAttack,obBFH_Jump(a0)

;		sfx	sfx_PigmanWalk

		jsr	(Create_New_Sprite3).w
		bne.s	BossFireHead_IntroCheckPos_Return
		move.l	#Obj_BossFireHead_ChainLink,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$28,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		subi.w	#$C0,d2
		move.w	d2,y_pos(a1)

BossFireHead_IntroCheckPos_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_IntroSetAttack:
		move.b	#1,anim(a0)
		move.w	#$4F,$2E(a0)
		move.l	#BossFireHead_MoveUpDown,obBFH_Jump(a0)

;		clr.b	obBFH_Routine(a0)
;		clr.b	obBFH_VelRoutine(a0)

		rts

; ---------------------------------------------------------------------------
; Process
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_LoadSubroutine:
		moveq	#0,d0
		move.b	obBFH_Routine(a0),d0
		addq.b	#1,obBFH_Routine(a0)
		move.b	BossFireHead_SetMovement(pc,d0.w),d0
		bmi.s	.end
		move.b	BossFireHead_Movement(pc,d0.w),obBFH_VelRoutine(a0)
		move.l	#BossFireHead_MoveUpDown,obBFH_Jump(a0)
		rts
; ---------------------------------------------------------------------------

.end
		clr.b	obBFH_Routine(a0)
		rts
; ---------------------------------------------------------------------------

_EightAttack				= 0
_EightAttackDown		= 1
_EightAttackUp			= 2
_EightAttackDown2		= 3
_EightAttackUp2			= 4

_EightBigAttack			= 5
_EightBigAttackDown		= 6
_EightBigAttackUp		= 7
_EightBigAttackDown2	= 8
_EightBigAttackUp2		= 9

_StormCloseAttack		= 10
_StormCloseAttackDown	= 11
_StormCloseAttackUp		= 12
_StormCloseAttackDown2	= 13
_StormCloseAttackUp2	= 14

_StormFarAttack			= 15
_StormFarAttackDown		= 16
_StormFarAttackUp		= 17
_StormFarAttackDown2	= 18
_StormFarAttackUp2		= 19
; ---------------------------------------------------------------------------

BossFireHead_SetMovement:
		dc.b _EightAttackDown
		dc.b _EightAttackDown
		dc.b _EightAttackUp
		dc.b _EightAttackDown
		dc.b _StormCloseAttackUp
		dc.b _StormFarAttackUp
		dc.b _EightAttackDown2
		dc.b _StormFarAttackUp2
		dc.b _EightBigAttackDown2
		dc.b _EightAttackUp
		dc.b _StormFarAttackUp

		dc.b -1	; End
	even

BossFireHead_Movement:

; Attack 1
		dc.b 0					; Stop			; 0
		dc.b 1					; Down			; 1
		dc.b 2					; Up				; 2
		dc.b 3					; Down (x2)		; 3
		dc.b 4					; Up (x2)			; 4

; Attack 1 (Alt)
		dc.b $10					; Stop			; 5
		dc.b $10+1				; Down			; 6
		dc.b $10+2				; Up				; 7
		dc.b $10+3				; Down (x2)		; 8
		dc.b $10+4				; Up (x2)			; 9

; Attack 2
		dc.b $80					; Stop			; 10
		dc.b $80+1				; Down			; 11
		dc.b $80+2				; Up				; 12
		dc.b $80+3				; Down (x2)		; 13
		dc.b $80+4				; Up (x2)			; 14

; Attack 2 (Alt)
		dc.b $90					; Stop			; 15
		dc.b $90+1				; Down			; 16
		dc.b $90+2				; Up				; 17
		dc.b $90+3				; Down (x2)		; 18
		dc.b $90+4				; Up (x2)			; 19

	even

; ---------------------------------------------------------------------------
; First attack
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_MoveUpDown:
		move.b	obBFH_VelRoutine(a0),d0
		andi.w	#7,d0
		add.w	d0,d0
		add.w	d0,d0
		lea	BossFireHead_VelData(pc,d0.w),a1
		move.w	(a1)+,y_vel(a0)
		move.w	(a1)+,$2E(a0)
		move.l	#BossFireHead_Stop,obBFH_Jump(a0)
		clr.b	anim(a0)
		rts
; ---------------------------------------------------------------------------

BossFireHead_VelData:
		dc.w 0, $1F			; 0
		dc.w $200, $1F		; 1
		dc.w -$200, $1F		; 2
		dc.w $200, $1F*2		; 3
		dc.w -$200, $1F*2		; 4
; ---------------------------------------------------------------------------

BossFireHead_Stop:
		move.b	#1,anim(a0)
		move.w	#60,$2E(a0)
		move.l	#BossFireHead_SetAttack,obBFH_Jump(a0)
		clr.w	y_vel(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFireHead_Stop_Return
		lea	BossFireHead_Aim01(pc),a2
		move.b	obBFH_VelRoutine(a0),d0
		bpl.s	BossFireHead_Stop_TestData
		lea	BossFireHead_Aim03(pc),a2

BossFireHead_Stop_TestData:
		andi.b	#$10,d0
		beq.s	BossFireHead_Stop_LoadData
		addq.w	#6,a2

BossFireHead_Stop_LoadData:
		move.w	(a2)+,$42(a1)			; Xpos
		move.w	(a2)+,$44(a1)			; Ypos
		move.b	(a2)+,subtype(a1)		; Jump|Art ID nibble
		move.w	#$8400,art_tile(a1)	; VRAM
		move.w	$2E(a0),$2E(a1)		; Timer

BossFireHead_Stop_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_Aim01:
		dc.w -32
		dc.w 16
		dc.b $00, $00

BossFireHead_Aim02:
		dc.w -32
		dc.w 16
		dc.b $04, $00

BossFireHead_Aim03:
		dc.w $A0
		dc.w $C0
		dc.b $10, $00

BossFireHead_Aim04:
		dc.w $30
		dc.w $C0
		dc.b $10, $00
; ---------------------------------------------------------------------------

BossFireHead_SetAttack:
		move.l	#BossFireHead_Attack,d0
		tst.b	obBFH_VelRoutine(a0)
		bpl.s	.skip
		move.l	#BossFireHead_Attack2,d0

.skip
		move.l	d0,obBFH_Jump(a0)
		rts
; ---------------------------------------------------------------------------

BossFireHead_Attack:
		move.b	#2,anim(a0)
		move.w	#$4F,$2E(a0)
		move.l	#BossFireHead_SetClose,obBFH_Jump(a0)
		lea	ChildObjDat6_BossFireHead_EightAttack(pc),a2
		move.b	obBFH_VelRoutine(a0),d0
		andi.w	#$10,d0		; $00 or $10
		beq.s	.skip
		move.w	#$4F+$20,$2E(a0)
		lea	ChildObjDat6_BossFireHead_BigAttack(pc),a2

.skip
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFireHead_SetClose:
		move.b	#3,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossFireHead_LoadSubroutine,obBFH_Jump(a0)
		rts

; ---------------------------------------------------------------------------
; Second attack
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_Attack2:
		move.b	#2,anim(a0)
		move.w	#$7F,$2E(a0)
		move.l	#BossFireHead_SetClose,obBFH_Jump(a0)
		lea	ChildObjDat6_BossFireHead_FallAttack(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	BossFireHead_Attack2_Return
		move.b	obBFH_VelRoutine(a0),d0
		andi.w	#$10,d0		; $80 or $90
		beq.s	.skip
		moveq	#4,d0

.skip
		move.l	FallAttack_XYData(pc,d0.w),x_vel(a1)

BossFireHead_Attack2_Return:
		rts
; ---------------------------------------------------------------------------

FallAttack_XYData:
		dc.w -$180, -$80		; 0
		dc.w -$300, -$180		; 4

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_MainProcess:
		bsr.s	BossFireHead_CheckTouch
		lea	Ani_BossFireHead(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossFireHead_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossFireHead_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	BossFireHead_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	.flash
		move.b	#$40,$1C(a0)
		sfx	sfx_HurtFire
		bset	#6,status(a0)
		cmpi.b	#2,anim(a0)
		beq.s	.flash
		move.b	#4,anim(a0)

.flash
		tst.w	Seizure_flag.w				; check if photosensitivity
		bne.s	.noflash				; branch if yes

		move.w	#$A2A0,d0
		btst	#0,$1C(a0)
		bne.s	.skip
		move.w	#$82A0,d0

.skip
		move.w	d0,art_tile(a0)

.noflash
		subq.b	#1,$1C(a0)
		bne.s	BossFireHead_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)
		cmpi.b	#4,anim(a0)
		bne.s	BossFireHead_CheckTouch_Return
		clr.b	anim(a0)

BossFireHead_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_CheckTouch_WaitExplosive:
		move.b	#4,anim(a0)
		samp	sfx_AxeGhostDeath
		move.b	#5,(Hyper_Sonic_flash_timer).w		; Yes... AF: changed this because it was way too strong
		move.l	#BossFireHead_CheckTouch_DownExplosive,address(a0)
		bclr	#7,status(a0)
		move.l	#$00000100,x_vel(a0)

BossFireHead_CheckTouch_WaitExplosive_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_CheckTouch_DownExplosive:
		move.b	(V_int_run_count+3).w,d0
		andi.b	#$F,d0
		bne.s	.skip
		sfx	sfx_SpecialRumble
		st	(Screen_shaking_flag).w			; Yes...

.skip
		pea	(Draw_Sprite).w
		move.w	x_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_30(a0)
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,objoff_38(a0)
		move.b	angle(a0),d0
		addq.b	#8,angle(a0)
		jsr	(GetSineCosine).w
		muls.w	#2,d0
		asr.l	#8,d0
		add.w	objoff_30(a0),d0
		move.w	d0,x_pos(a0)
		move.w	objoff_38(a0),y_pos(a0)

		tst.w	Seizure_flag.w				; check if photosensitivity
		bne.s	.noflash				; branch if yes
		eori.w	#$2000,art_tile(a0)

.noflash
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$120,d0
		cmp.w	objoff_38(a0),d0
		bhs.s	BossFireHead_CheckTouch_WaitExplosive_Return
		addq.b	#2,(Dynamic_resize_routine).w
		clr.b	(Boss_flag).w
		clr.b	(Screen_shaking_flag).w
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Tail
; ---------------------------------------------------------------------------

BallTails_Data:		; X, Y
		dc.w 0, 15	; 1
		dc.w 10, 29	; 2
		dc.w 16, 49	; 3
		dc.w 16, 69	; 4
		dc.w 16, 89	; 5
		dc.w 16, 109	; 6
		dc.w 16, 129	; 7
		dc.w 16, 149	; 8
		dc.w 16, 169	; 9

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_BallTails:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	#3,objoff_40(a0)
		btst	#1,d0
		beq.s	.skip
		neg.b	objoff_40(a0)

.skip
		add.w	d0,d0
		move.l	BallTails_Data(pc,d0.w),$42(a0)
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		addq.b	#2,mapping_frame(a0)
		move.l	#BossFireHead_BallTails_ChildPosition,address(a0)

BossFireHead_BallTails_ChildPosition:
		movea.w	parent3(a0),a1
		move.w	objoff_30(a1),d2
		move.w	$42(a0),d4
		move.b	objoff_40(a0),d0
		add.b	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	#2,d0
		asr.l	#8,d0
		add.w	d0,d4
		add.w	d4,d2
		move.w	d2,x_pos(a0)
		move.w	objoff_38(a1),d2
		move.w	$44(a0),d4
		add.w	d4,d2
		move.w	d2,y_pos(a0)
		move.w	art_tile(a1),d0
		andi.w	#$E000,d0
		ori.w	#$320,d0
		move.w	d0,art_tile(a0)

BossFireHead_BallTails_Draw:
		jmp	(Child_DrawTouch_Sprite).w

; ---------------------------------------------------------------------------
; Big flame (process)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_Blowout_Process:
		move.b	#4,objoff_40(a0)
		move.l	#BossFireHead_Blowout_Process_Wait,address(a0)

BossFireHead_Blowout_Process_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_Blowout_Process_CheckParent
		move.w	#7,$2E(a0)
		tst.w	Seizure_flag.w				; check if photosensitivity
		beq.s	.nophoto				; if not, branch
		move.w	#16,$2E(a0)

.nophoto
		moveq	#0,d2
		moveq	#2-1,d6

.loop
		jsr	(Create_New_Sprite3).w
		bne.s	BossFireHead_Blowout_Process_CheckParent
		move.l	#Obj_BossFireHead_Blowout,address(a1)
		move.b	objoff_40(a0),objoff_40(a1)
		movea.w	parent3(a0),a2
		jsr	(Random_Number).w
		move.w	x_pos(a2),d2
		andi.w	#$1F,d0
		add.w	d0,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$E0,d2
		move.w	d2,y_pos(a1)
		move.w	parent3(a0),parent3(a1)
		move.b	d2,subtype(a1)
		addq.w	#2,d2
		neg.b	objoff_40(a0)
		dbf	d6,.loop

BossFireHead_Blowout_Process_CheckParent:
		jmp	(Child_CheckParent).w

; ---------------------------------------------------------------------------
; Big flame
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_Blowout:
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$80,priority(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#Delete_Current_Sprite,$34(a0)
		move.l	#BossFireHead_Blowout_Draw,address(a0)

BossFireHead_Blowout_Draw:
		move.b	objoff_40(a0),d0
		add.b	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#2,d0
		move.w	d0,x_vel(a0)
		jsr	(MoveSprite2).w
		lea	AniRaw_BossFireHead_Blowout(pc),a1
		jsr	(Animate_RawNoSSTMultiDelay).w
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Small flame (process)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_SmallBlowout_Process:
		move.b	#4,objoff_40(a0)
		move.l	#BossFireHead_SmallBlowout_Process_Wait,address(a0)

BossFireHead_SmallBlowout_Process_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_SmallBlowout_Process_CheckParent
		move.w	#7,$2E(a0)
		tst.w	Seizure_flag.w				; check if photosensitivity
		beq.s	.nophoto				; if not, branch
		move.w	#22,$2E(a0)

.nophoto
		cmpi.b	#6*4,subtype(a0)
		blo.s	BossFireHead_SmallBlowout_Process_Create
		clr.b	subtype(a0)

BossFireHead_SmallBlowout_Process_Create:
		jsr	(Create_New_Sprite3).w
		bne.s	BossFireHead_SmallBlowout_Process_CheckParent
		move.l	#Obj_BossFireHead_SmallBlowout,address(a1)
		move.b	objoff_40(a0),objoff_40(a1)
		movea.w	parent3(a0),a2
		move.w	x_pos(a2),x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$E0,d2
		move.w	d2,y_pos(a1)
		move.w	parent3(a0),parent3(a1)
		move.b	subtype(a0),subtype(a1)
		addq.b	#4,subtype(a0)

BossFireHead_SmallBlowout_Process_CheckParent:
		jmp	(Child_CheckParent).w

; ---------------------------------------------------------------------------
; Small flame
; ---------------------------------------------------------------------------

SmallBallTails_Data:			; X, Y
		dc.w $100, -$600		; 1
		dc.w -$200, -$600	; 2
		dc.w $300, -$600		; 3
		dc.w -$400, -$600	; 4
		dc.w -$500, -$600	; 5
		dc.w $600, -$600		; 6

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_SmallBlowout:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.l	SmallBallTails_Data(pc,d0.w),x_vel(a0)
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$80,priority(a0)
		move.w	#$B,$2E(a0)
		move.l	#Delete_Current_Sprite,$34(a0)
		move.l	#BossFireHead_SmallBlowout_Draw,address(a0)

BossFireHead_SmallBlowout_Draw:
		jsr	(Obj_Wait).w
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Eight balls
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_EightAttack:
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	d0,$2E(a0)
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		addq.b	#2,mapping_frame(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#BossFireHead_EightAttack_Wait,address(a0)

BossFireHead_EightAttack_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_EightAttack_NoDraw
		move.w	#-$600,x_vel(a0)
		sfx	sfx_FireShow
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#BossFireHead_EightAttack_Move,address(a0)

BossFireHead_EightAttack_Move:
		jsr	(MoveSprite2).w
		btst	#1,subtype(a0)
		bne.s	BossFireHead_EightAttack_Move2

		tst.w	Seizure_flag.w					; check if photosensitivity
		bne.s	BossFireHead_EightAttack_Draw			; branch if not
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossFireHead_EightAttack_NoDraw

BossFireHead_EightAttack_Draw:
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

BossFireHead_EightAttack_Move2:
		tst.w	Seizure_flag.w					; check if photosensitivity
		bne.s	BossFireHead_EightAttack_NoDraw			; branch if not
		btst	#0,(Level_frame_counter+1).w
		bne.s	BossFireHead_EightAttack_Draw

BossFireHead_EightAttack_NoDraw:
		jmp	(Child_CheckParent).w

; ---------------------------------------------------------------------------
; Falling ball
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_FallAttack:
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		addq.b	#2,mapping_frame(a0)
		move.b	#24/2,y_radius(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#BossFireHead_FallAttack_Wait,address(a0)

BossFireHead_FallAttack_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_FallAttack_Draw
		sfx	sfx_FireShow
		move.l	#BossFireHead_FallAttack_Fall,address(a0)

BossFireHead_FallAttack_Fall:
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)
		bmi.s	BossFireHead_FallAttack_Draw
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	BossFireHead_FallAttack_Draw
		add.w	d1,y_pos(a0)
		move.l	#Delete_Current_Sprite,address(a0)
		clr.l	x_vel(a0)
		move.w	#$14,(Screen_shaking_flag).w
		lea	ChildObjDat6_BossFireHead_FallFourAttack(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossFireHead_FallAttack_Draw:
		jmp	(Child_DrawTouch_Sprite).w

; ---------------------------------------------------------------------------
; Falling shooting ball
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_FallFourAttack:
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	d0,$2E(a0)
		add.w	d0,d0
		sub.w	d0,x_pos(a0)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		move.w	a1,parent3(a0)
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$80,priority(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#Delete_Current_Sprite,$34(a0)
		move.l	#BossFireHead_FallFourAttack_Wait,address(a0)

BossFireHead_FallFourAttack_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_FallFourAttack_NoDraw
		move.w	#-$600,y_vel(a0)
		sfx	sfx_FireShow
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#BossFireHead_FallFourAttack_Draw,address(a0)

		tst.w	Seizure_flag.w				; check if photosensitivity
		bne.s	BossFireHead_FallFourAttack_Draw	; branch if yes
		lea	ChildObjDat6_BossFireHead_FallFourRepeatAttack(pc),a2
		jsr	(CreateChild6_Simple).w

BossFireHead_FallFourAttack_Draw:
		jsr	(MoveSprite2).w
		lea	AniRaw_BossFireHead_FallBlowout(pc),a1
		jsr	(Animate_RawNoSSTMultiDelay).w
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

BossFireHead_FallFourAttack_NoDraw:
		jmp	(Child_CheckParent).w

; ---------------------------------------------------------------------------
; Falling shooting ball (shot)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_FallFourRepeatAttack:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,$2E(a0)
		jsr	(Random_Number).w
		andi.b	#7,d0
		move.b	d0,anim_frame_timer(a0)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		move.w	a1,parent3(a0)
		lea	ObjDat3_BossFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$80,priority(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#Delete_Current_Sprite,$34(a0)
		move.l	#BossFireHead_FallFourRepeatAttack_Wait,address(a0)

BossFireHead_FallFourRepeatAttack_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_FallFourAttack_NoDraw
		move.w	#-$600,y_vel(a0)
		sfx	sfx_FireShow
		move.w	#$14,(Screen_shaking_flag).w
		move.l	#BossFireHead_FallFourRepeatAttack_Draw,address(a0)

BossFireHead_FallFourRepeatAttack_Draw:
		jsr	(MoveSprite2).w
		lea	AniRaw_BossFireHead_FallBlowout(pc),a1
		jsr	(Animate_RawNoSSTMultiDelay).w
		jmp	(Child_DrawTouch_Sprite).w

; ---------------------------------------------------------------------------
; Load art process
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_LoadArt_Process:
		move.l	#BossFireHead_LoadArt_Process_Load,address(a0)
		clearRAM Kos_decomp_buffer, Kos_decomp_buffer_End

BossFireHead_LoadArt_Process_Return:
		rts
; ---------------------------------------------------------------------------

BossFireHead_LoadArt_Process_Load:
		tst.b	(vInsertCoin_TextFactor).w
		beq.s	BossFireHead_LoadArt_Process_Remove
		subq.w	#1,$2E(a0)
		bpl.s	BossFireHead_LoadArt_Process_Return
		move.w	$30(a0),$2E(a0)
		movea.l	$34(a0),a1										; Original Art
		lea	(Kos_decomp_buffer).w,a2								; Mod Art
		move.w	$40(a0),d5										; Art size
		bsr.s	InsertCoin_SmoothDrawArtText
		move.l	#Kos_decomp_buffer>>1,d1
		move.w	$32(a0),d2										; VRAM
		move.w	$3E(a0),d3										; Size/2
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

BossFireHead_LoadArt_Process_Remove:
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Pixel-by-pixel loading
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

InsertCoin_SmoothDrawArtText:
		move.b	(vInsertCoin_TextFactor).w,d2
		add.b	d2,d2
		andi.w	#$3E,d2

InsertCoin_SmoothDrawArtText3:
		lea	.factor(pc,d2.w),a3

.loop
		movea.l	a3,a4

	rept 8	; 1 tile
		move.l	(a1)+,d0
		and.l	(a4)+,d0
		or.l	d0,(a2)+
	endr

		dbf	d5,.loop
		subq.b	#1,(vInsertCoin_TextFactor).w
		rts
; ---------------------------------------------------------------------------

.factor
		dc.l $00F00000		; 0		; 0
		dc.l $0000000F		; 4		; 1
		dc.l $0000F000		; 8		; 2
		dc.l $0F000000		; $C		; 3
		dc.l $00000F00		; $10	; 4
		dc.l $000F0000		; $14	; 5
		dc.l $F0000000		; $18	; 6
		dc.l $000000F0		; $1C	; 7
		dc.l $00F00000		; $20	; 8
		dc.l $0000000F		; $24	; 9
		dc.l $0000F000		; $28	; $A
		dc.l $0F000000		; $2C	; $B
		dc.l $00000F00		; $30	; $C
		dc.l $000F0000		; $34	; $D
		dc.l $F0000000		; $38	; $E
		dc.l $000000F0		; $3C	; $F
		dc.l $00F00000		; $40	; $10
		dc.l $0000000F		; $44	; $11

; ---------------------------------------------------------------------------
; ChainLink
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossFireHead_ChainLink:
		move.l	#Map_FBZChainLink,mappings(a0)
		move.w	#$4420,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#$10,width_pixels(a0)
		move.b	#-$80,height_pixels(a0)
		move.b	#4,mapping_frame(a0)
		move.l	#BossFireHead_ChainLink_Move,address(a0)

BossFireHead_ChainLink_Move:
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$1C,d0
		addq.w	#4,y_pos(a0)
		cmp.w	y_pos(a0),d0
		bge.s	BossFireHead_ChainLink_Main
		move.l	#Obj_FBZ_ChainLink,address(a0)

BossFireHead_ChainLink_Main:
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat3_BossFireHead:
		dc.l Map_BossFireHead
		dc.w $A2A0
		dc.w $200
		dc.b 64/2
		dc.b 64/2
		dc.b 0
		dc.b $11|$80
ObjDat3_BossFireBall:
		dc.l Map_BossFireBall
		dc.w $A320
		dc.w $280
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b 6|$80
ChildObjDat6_BossFireHead_BallTails:
		dc.w 9-1
		dc.l Obj_BossFireHead_BallTails
ChildObjDat6_BossFireHead_Blowout_Process:
		dc.w 1-1
		dc.l Obj_BossFireHead_Blowout_Process
ChildObjDat6_BossFireHead_SmallBlowout_Process:
		dc.w 1-1
		dc.l Obj_BossFireHead_SmallBlowout_Process
ChildObjDat6_BossFireHead_EightAttack:
		dc.w 8-1
		dc.l Obj_BossFireHead_EightAttack
ChildObjDat6_BossFireHead_BigAttack:
		dc.w 16-1
		dc.l Obj_BossFireHead_EightAttack
ChildObjDat6_BossFireHead_FallAttack:
		dc.w 1-1
		dc.l Obj_BossFireHead_FallAttack
ChildObjDat6_BossFireHead_FallFourAttack:
		dc.w 8-1
		dc.l Obj_BossFireHead_FallFourAttack
ChildObjDat6_BossFireHead_FallFourRepeatAttack:
		dc.w 4-1
		dc.l Obj_BossFireHead_FallFourRepeatAttack
ChildObjDat6_BossFireHead_LoadArt_Process:
		dc.w 1-1
		dc.l Obj_BossFireHead_LoadArt_Process
AniRaw_BossFireHead_Blowout:
		dc.b 2, $1F
		dc.b 2, $1F
		dc.b 1, $F
		dc.b 0, 7
		dc.b $F4
AniRaw_BossFireHead_FallBlowout:
		dc.b 2, $F
		dc.b 2, $F
		dc.b 1, 7
		dc.b 0, 3
		dc.b $F4
	even
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Fire Head/Object data/Anim - Boss Head.asm"
		include "Objects/Bosses/Fire Head/Object data/Map - Boss Ball.asm"
		include "Objects/Bosses/Fire Head/Object data/Map - Boss Head.asm"
