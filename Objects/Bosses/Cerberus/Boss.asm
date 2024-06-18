; ---------------------------------------------------------------------------
; ����-Cerberus
; ---------------------------------------------------------------------------

; Hits
BossCerberus_Hits		= 10

; Attributes
_Setup1					= 2
_Setup2					= 4
_Setup3					= 6

; Dynamic object variables
obBCerberus_PSave		= $38	; .l
obBCerb_Flash			= $3C	; .b

; =============== S U B R O U T I N E =======================================

Obj_Cerberus:
		tst.w	(Kos_modules_left).w
		bne.w	Shaft2_CreateExplosion
		move.l	#Obj_Wait,address(a0)
		move.w	#$17,$2E(a0)
		move.l	#Obj_Cerberus_Start,$34(a0)
		lea	ChildObjDat_Cerberus_FireShow(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

Obj_Cerberus_Start:
		move.w	(Camera_X_pos).w,d0
		subi.w	#$80,d0
		move.w	d0,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0
		move.w	d0,(Camera_max_X_pos).w
		move.l	#Obj_Cerberus_Main,address(a0)

Obj_Cerberus_Main:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Cerberus_Index(pc,d0.w),d0
		jsr	Cerberus_Index(pc,d0.w)
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		bsr.w	BossCerberus_CheckTouch
		bsr.w	BossCerberus_CheckFrame
		bsr.w	BossCerberus_Warning
		bsr.w	BossCerberus_CheckPos
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Cerberus_Index: offsetTable
		offsetTableEntry.w BossCerberus_Init	; 0
		offsetTableEntry.w BossCerberus_Setup	; 2
		offsetTableEntry.w BossCerberus_Setup2	; 4
		offsetTableEntry.w BossCerberus_Setup3	; 6
BossCerberus_HP:
		dc.b BossCerberus_Hits/2	; Easy
		dc.b BossCerberus_Hits	; Normal
		dc.b BossCerberus_Hits+2	; Hard
		dc.b BossCerberus_Hits+2	; Maniac
; ---------------------------------------------------------------------------

BossCerberus_Init:
		lea	ObjDat3_BossCerberus(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(Boss_flag).w
		move.b	#46/2,y_radius(a0)
		clr.b	obBCerb_Flash(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	BossCerberus_HP(pc,d0.w),collision_property(a0)
		move.l	#BossCerberus_CheckSubroutine,$34(a0)
		move.l	#AniRaw_CerberusWait,$30(a0)
		rts
; ---------------------------------------------------------------------------

BossCerberus_Setup3:
		bsr.w	Obj_Cerberus_SendPos

BossCerberus_Setup:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

BossCerberus_Setup2:
		move.b	(Level_frame_counter+1).w,d0
		move.w	(Difficulty_Flag).w,d1
		add.w	d1,d1
		lea	Cerberus_FireBall_Time(pc),a1
		and.w	(a1,d1.w),d0
		bne.s	+
		lea	ChildObjDat_Cerberus_FireFallBall(pc),a2
		jsr	(CreateChild1_Normal).w
+		bsr.w	Obj_Cerberus_SendPos
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------
; �������� ������� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_CheckPos:
		move.w	(Camera_min_X_pos).w,d0
		move.w	x_pos(a0),d1
		addi.w	#$10,d0
		cmp.w	d0,d1
		bgt.s	+
		bra.s	++
+		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$130,d0
		cmp.w	d0,d1
		blt.s		++
+		move.w	d0,x_pos(a0)
		neg.w	x_vel(a0)
		bchg	#0,render_flags(a0)
+		rts
; ---------------------------------------------------------------------------
; ������ � ����� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_CheckSubroutine:
		moveq	#0,d0
		move.b	obBCerberus_PSave(a0),d0
		addq.b	#1,obBCerberus_PSave(a0)
		move.b	BossCerberus_SetMovement(pc,d0.w),d0
		bpl.s	+
		clr.b	obBCerberus_PSave(a0)
		rts
; ---------------------------------------------------------------------------
+		lsl.w	#2,d0
		move.l	BossCerberus_Movement(pc,d0.w),$34(a0)
		rts
; ---------------------------------------------------------------------------

BossCerberus_Movement:
		dc.l BossCerberus_MoveAttack_Start		; 0 ; 0
		dc.l BossCerberus_JumpAttack_Start	; 4 ; 1
		dc.l BossCerberus_FlightAttack_Start	; 8 ; 2
		dc.l BossCerberus_ShotAttack_Start		; C ; 3
; ---------------------------------------------------------------------------

BossCerberus_SetMovement:
		dc.b 0
		dc.b 3
		dc.b 0
		dc.b 2
		dc.b 0
		dc.b 3
		dc.b 0
		dc.b 1
		dc.b -1	; Restart
	even
; ---------------------------------------------------------------------------
; ���� ������� � ������� ���������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_MoveAttack_Start:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#-$100,d0
		jsr	(Change_VelocityWithFlipX).w
		move.w	#$40,$2E(a0)
		move.l	#BossCerberus_MoveAttack_Signal,$34(a0)
		lea	AniRaw_CerberusWalk(pc),a1
		jmp	(Set_Raw_Animation).w
; ---------------------------------------------------------------------------

BossCerberus_MoveAttack_Signal:
		sfx	sfx_Bounce
		move.b	#$F,obBCerb_Flash(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossCerberus_MoveAttack_Stop,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossCerberus_MoveAttack_Stop:
		clr.w	x_vel(a0)
		move.l	#BossCerberus_CheckSubroutine,$34(a0)
		lea	AniRaw_CerberusWait(pc),a1
		jmp	(Set_Raw_Animation).w
; ---------------------------------------------------------------------------
; ���� ������� � ������� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_JumpAttack_Start:
		clearRAM Pos_objtable_Start, Pos_objtable_End
		move.b	#_Setup2,routine(a0)
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#-$300,d0
		jsr	(Change_VelocityWithFlipX).w
		move.w	#-$780,y_vel(a0)
		move.l	#BossCerberus_JumpAttack_Stop,$34(a0)
		lea	AniRaw_CerberusJump(pc),a1
		jsr	(Set_Raw_Animation).w
		lea	ChildObjDat_Cerberus_FireShow(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_Cerberus_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossCerberus_JumpAttack_Stop:
		clr.l	x_vel(a0)
		move.b	#_Setup3,routine(a0)
		move.w	#$17,$2E(a0)
		move.l	#BossCerberus_JumpAttack_Return,$34(a0)
		lea	ChildObjDat_Cerberus_FireShow(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossCerberus_JumpAttack_Return:
		move.b	#_Setup1,routine(a0)
		move.l	#BossCerberus_CheckSubroutine,$34(a0)
		lea	AniRaw_CerberusWait(pc),a1
		jmp	(Set_Raw_Animation).w
; ---------------------------------------------------------------------------
; ���� ������� � ������� ��������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_FlightAttack_Start:
		clearRAM Pos_objtable_Start, Pos_objtable_End
		move.b	#_Setup3,routine(a0)
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#-$400,d0
		jsr	(Change_VelocityWithFlipX).w
		move.w	#-$480,y_vel(a0)
		move.w	#9,$2E(a0)
		move.l	#BossCerberus_FlightAttack_MoveStop,$34(a0)
		lea	AniRaw_CerberusJump(pc),a1
		jsr	(Set_Raw_Animation).w
		lea	ChildObjDat_Cerberus_FireShow(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ChildObjDat_Cerberus_Trail(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossCerberus_FlightAttack_MoveStop:
		clr.w	y_vel(a0)
		move.w	#$27,$2E(a0)
		move.l	#BossCerberus_FlightAttack_Fall,$34(a0)

BossCerberus_FlightAttack_Return:
		rts
; ---------------------------------------------------------------------------

BossCerberus_FlightAttack_Fall:
		move.b	#_Setup2,routine(a0)
		move.l	#BossCerberus_JumpAttack_Stop,$34(a0)
		rts
; ---------------------------------------------------------------------------
; ���� ������� � ������� �������� ��������� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_ShotAttack_Start:
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#$100,d0
		jsr	(Change_VelocityWithFlipX).w
		move.w	#$2F,$2E(a0)
		move.l	#BossCerberus_ShotAttack_MoveStop,$34(a0)
		lea	AniRaw_CerberusWalk(pc),a1
		jmp	(Set_Raw_Animation).w
; ---------------------------------------------------------------------------

BossCerberus_ShotAttack_MoveStop:
		clr.w	x_vel(a0)
		move.w	#$17,$2E(a0)
		move.l	#BossCerberus_CheckSubroutine,$34(a0)
		lea	AniRaw_CerberusWait(pc),a1
		jsr	(Set_Raw_Animation).w
		sfx	sfx_FireShot
		lea	ChildObjDat_Cerberus_FireBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------
; �������� ����� ��� ������ ��������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_CheckFrame:
		btst	#6,status(a0)
		bne.s	+
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		move.b	CheckFrame_Index(pc,d0.w),collision_flags(a0)
+		rts
; ---------------------------------------------------------------------------

CheckFrame_Index:
		dc.b $39
		dc.b $39
		dc.b $39|$80
		dc.b $39|$80
; ---------------------------------------------------------------------------
; ������� ����� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_Warning:
		btst	#6,status(a0)
		bne.w	BossCerberus_CheckTouch_Return
		tst.b	obBCerb_Flash(a0)
		beq.w	BossCerberus_CheckTouch_Return
		subq.b	#1,obBCerb_Flash(a0)
		lea	(Pal_BossCerberus).l,a1

		moveq	#0,d0				; check every frame
		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		beq.s	.gotcheck			; branch if no
		moveq	#3,d0				; check every 8 frames

.gotcheck
		btst	d0,obBCerb_Flash(a0)
		beq.s	+
		lea	$20(a1),a1
+		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossCerberus_CheckTouch:
		tst.b	collision_flags(a0)
		bne.w	BossCerberus_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	BossCerberus_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$40,$1C(a0)
		sfx	sfx_HurtFire
		bset	#6,status(a0)

+
		moveq	#0,d0
		moveq	#0,d1				; check every frame
		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		beq.s	.gotcheck			; branch if no
		moveq	#3,d1				; check every 8 frames

.gotcheck
		btst	d1,$1C(a0)
		bne.s	+
		addi.w	#8*2,d0
+		bsr.w	BossCerberus_PalFlash

		subq.b	#1,$1C(a0)
		bne.w	BossCerberus_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

BossCerberus_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossCerberus_CheckTouch_WaitExplosive:
		move.l	#BossCerberus_CheckTouch_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		bset	#7,status(a0)
		clr.l	x_vel(a0)
		jmp	(BossDefeated_StopTimer).w
; ---------------------------------------------------------------------------

BossCerberus_CheckTouch_WaitPlayerExplosive:
		bsr.w	BossCerberus_CreateFire
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge

+		moveq	#0,d0
		moveq	#0,d1				; check every frame
		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		beq.s	.gotcheck			; branch if no
		moveq	#3,d1				; check every 8 frames

.gotcheck
		btst	d1,(Level_frame_counter+1).w
		bne.s	+
		addi.w	#8*2,d0
+		bsr.w	BossCerberus_PalFlash

		jsr	(Draw_Sprite).w
		subq.w	#1,$2E(a0)
		bne.w	BossCerberus_CheckTouch_Return
		addq.b	#2,(Dynamic_resize_routine).w
		move.l	#Obj_Shielder_Explosion,address(a0)
		lea	(Pal_BossCerberus).l,a1
		jmp	(PalLoad_Line1).w

; =============== S U B R O U T I N E =======================================

BossCerberus_CreateFire:
		moveq	#1,d0
		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		beq.s	.gotcheck			; branch if no
		moveq	#3,d0

.gotcheck
		and.b	(Level_frame_counter+1).w,d0
		bne.s	+
		lea	ChildObjDat_BossCerberus_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		rts
; ---------------------------------------------------------------------------
; ����� ����� ���������� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Cerberus_FireShow:
		sfx	sfx_FireShow
		lea	ObjDat3_BossCerberusFireShow(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#Cerberus_FireShow_Main,address(a0)
		move.l	#AniRaw_Cerberus_FireShow,$30(a0)

Cerberus_FireShow_Main:
		jsr	(Animate_Raw).w
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Cerberus_Trail:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#3,d0
		addi.b	#16,d0
		move.b	d0,subtype(a0)
		lea	ObjDat3_BossCerberus_Trail(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#+,address(a0)
		move.l	#AniRaw_Cerberus_FireTail,$30(a0)
+		bsr.w	Obj_Cerberus_CopyPos
		bsr.s	Cerberus_Trail_Remove
		jsr	(Animate_Raw).w
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

Cerberus_Trail_Remove:
		movea.w	parent3(a0),a1
		cmpi.l	#BossCerberus_CheckSubroutine,$34(a1)
		bne.s	+
		move.l	#Go_Delete_Sprite,address(a0)
+		rts
; ---------------------------------------------------------------------------
; �������� ���
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Cerberus_FireBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Cerberus_FireBall_Index(pc,d0.w),d0
		jsr	Cerberus_FireBall_Index(pc,d0.w)
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

Cerberus_FireBall_Index: offsetTable
		offsetTableEntry.w Cerberus_FireBall_Init	; 0
		offsetTableEntry.w Cerberus_FireBall_Setup	; 2
; ---------------------------------------------------------------------------

Cerberus_FireBall_Init:
		lea	ObjDat3_BossCerberus_FireBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#Cerberus_FireBall_Shot,$34(a0)
		move.l	#AniRaw_Cerberus_FireBall,$30(a0)

Cerberus_FireBall_Setup:
		jsr	(Animate_RawMultiDelay).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

Cerberus_FireBall_Shot:
		move.l	#Cerberus_FireBall_Check,$34(a0)
		move.w	#-$400,d0
		jsr	(Change_VelocityWithFlipXUseParent).w
		move.w	#-$780,y_vel(a0)

Cerberus_FireBall_Check:
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$20,d0
		cmp.w	y_pos(a0),d0
		blo.w	Cerberus_FireFallBall_Return
		move.l	#Cerberus_FireBall_Create,$34(a0)
		clr.w	y_vel(a0)

Cerberus_FireBall_Create:
		move.w	(Difficulty_Flag).w,d0
		add.w	d0,d0
		move.w	Cerberus_FireBall_Time(pc,d0.w),$2E(a0)
		lea	ChildObjDat_Cerberus_FireFallBall(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	.return
		movea.w	parent3(a0),a2
		move.w	parent3(a2),parent3(a1)

.return
		rts
; ---------------------------------------------------------------------------

Cerberus_FireBall_Time:
		dc.w $1F	; Easy
		dc.w $17	; Normal
		dc.w $F	; Hard
		dc.w $F	; Maniac
; ---------------------------------------------------------------------------
; �������� �������� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Cerberus_FireFallBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Cerberus_FireFallBall_Index(pc,d0.w),d0
		jsr	Cerberus_FireFallBall_Index(pc,d0.w)
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

Cerberus_FireFallBall_Index: offsetTable
		offsetTableEntry.w Cerberus_FireFallBall_Init		; 0
		offsetTableEntry.w Cerberus_FireFallBall_Setup	; 2
; ---------------------------------------------------------------------------

Cerberus_FireFallBall_Init:
		lea	ObjDat3_BossCerberus_FireFallBall(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		ori.b	#$A0,art_tile(a0)
		bset	#Status_FireShield,shield_reaction(a0)
		move.l	#Cerberus_FireFallBall_Fall,$34(a0)
		move.l	#AniRaw_Cerberus_FireFallBall,$30(a0)

Cerberus_FireFallBall_Setup:
		jsr	(Animate_RawMultiDelay).w
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

Cerberus_FireFallBall_Fall:
		move.l	#Cerberus_FireFallBall_Return,$34(a0)
		move.w	#$180,y_vel(a0)

Cerberus_FireFallBall_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_Cerberus_SendPos:
		move.w	(Pos_objTable_index).w,d0
		lea	(Pos_objTable).w,a1
		lea	(a1,d0.w),a1
		move.w	x_pos(a0),(a1)+
		move.w	y_pos(a0),(a1)+
		addq.b	#4,(Pos_objTable_byte).w
		rts
; ---------------------------------------------------------------------------

Obj_Cerberus_CopyPos:
		move.w	(Pos_objTable_index).w,d0
		lea	(Pos_objTable).w,a1
		sub.b	subtype(a0),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,x_pos(a0)
		move.w	(a1)+,y_pos(a0)
		rts
; ---------------------------------------------------------------------------
; ��� �� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossCerberus_Fire:
		move.w	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.w	+++
		move.l	#Obj_BossCerberus_Fire_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)


		move.w	#$859C,d3
		cmpi.w	#$201,(Current_zone_and_act).w
		bne.s	+
		move.w	#$8310,d3
+		move.w	d3,art_tile(a1)


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
		tst.w	x_vel(a2)
		bmi.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.s	Obj_BossCerberus_Fire_Remove
; ---------------------------------------------------------------------------

Obj_BossCerberus_Fire_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	Obj_BossCerberus_Fire_Remove
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_BossCerberus_Fire_Remove:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

BossCerberus_PalFlash:
		lea	LoadBossCerberus_PalRAM(pc),a1
		lea	LoadBossCerberus_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_8).w
; ---------------------------------------------------------------------------

LoadBossCerberus_PalRAM:
		dc.w Normal_palette_line_2+6
		dc.w Normal_palette_line_2+8
		dc.w Normal_palette_line_2+$10
		dc.w Normal_palette_line_2+$12
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1A
LoadBossCerberus_PalCycle:
		dc.w $6E, $8E, 8, $A, $C, $E, $6CE, $8EE
		dc.w $E60, $E80, $800, $A00, $C00, $E00, $CCC, $EEE

; =============== S U B R O U T I N E =======================================

ObjDat3_BossCerberus:
		dc.l Map_Cerberus
		dc.w $23CF
		dc.w $200
		dc.b 96/2
		dc.b 64/2
		dc.b 0
		dc.b $39
ObjDat3_BossCerberus_Trail:
		dc.w $280
		dc.b 80/2
		dc.b 56/2
		dc.b 7
		dc.b $39|$80
ObjDat3_BossCerberusFireShow:
		dc.l Map_Cerberus
		dc.w $23CF
		dc.w $180
		dc.b 112/2
		dc.b 56/2
		dc.b 4
		dc.b 0
ObjDat3_BossCerberus_FireBall:
		dc.w $280
		dc.b 24/2
		dc.b 24/2
		dc.b 9
		dc.b $1A|$80
ObjDat3_BossCerberus_FireFallBall:
		dc.w $280
		dc.b 24/2
		dc.b 32/2
		dc.b $B
		dc.b $B|$80
AniRaw_CerberusWait:
		dc.b $F, 0, $FC, 0
AniRaw_CerberusWalk:
		dc.b $F, 0, 1, $FC
AniRaw_CerberusJump:
		dc.b 4, 2, 3, $FC
AniRaw_Cerberus_FireShow:
		dc.b 9, 4, 5, 6, 5, $F4
AniRaw_Cerberus_FireTail:
		dc.b 9, 7, 8, $FC
AniRaw_Cerberus_FireBall:
		dc.b 9, 1
		dc.b $A, 3
		dc.b $FC, 0
AniRaw_Cerberus_FireFallBall:
		dc.b $B, 9
		dc.b $C, 4
		dc.b $FC, 0
ChildObjDat_Cerberus_FireShow:
		dc.w 1-1
		dc.l Obj_Cerberus_FireShow
ChildObjDat_Cerberus_Trail:
		dc.w 4-1
		dc.l Obj_Cerberus_Trail
ChildObjDat_Cerberus_FireBall:
		dc.w 1-1
		dc.l Obj_Cerberus_FireBall
ChildObjDat_Cerberus_FireFallBall:
		dc.w 1-1
		dc.l Obj_Cerberus_FireFallBall
		dc.b 0, 16
ChildObjDat_BossCerberus_Fire:
		dc.w 1-1
		dc.l Obj_BossCerberus_Fire
PLC_BossCerberus: plrlistheader
		plreq $3CF, ArtKosM_BossCerberus
		plreq $310, ArtKosM_DEZExplosion
PLC_BossCerberus_End
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Cerberus/Object data/Map - Cerberus.asm"
		include "Objects/Bosses/Cerberus/Object data/Map - Explosion.asm"
