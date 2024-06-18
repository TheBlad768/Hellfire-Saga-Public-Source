; ---------------------------------------------------------------------------
; ����-Shielder
; ---------------------------------------------------------------------------

; Hits
BossShielder_Hits			= 4

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6
_Setup4					= 8
_Setup5					= $A

Shielder_VRAM =			$170

; =============== S U B R O U T I N E =======================================

Obj_Shielder:
		tst.w	(Kos_modules_left).w
		bne.w	Shaft_CreateExplosion
		move.l	#Obj_Shielder_Main,address(a0)

Obj_Shielder_Main:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Shielder_Index(pc,d0.w),d0
		jsr	Shielder_Index(pc,d0.w)
		move.b	#200,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		lea	Ani_ShielderBody(pc),a1
		jsr	(Animate_Sprite).w
		tst.w	obShaft_Timer(a0)
		beq.s	+
		subq.w	#1,obShaft_Timer(a0)

		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		bne.s	+				; branch if yes
		btst	#0,(V_int_run_count+3).w
		beq.w	BossShielder_Wait
+		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Shielder_Index: offsetTable
		offsetTableEntry.w BossShielder_Init		; 0
		offsetTableEntry.w BossShielder_Setup	; 2
		offsetTableEntry.w BossShielder_Setup2	; 4
		offsetTableEntry.w BossShielder_Setup3	; 6
		offsetTableEntry.w BossShielder_Setup4	; 8
		offsetTableEntry.w BossShielder_Setup5	; A
; ---------------------------------------------------------------------------

BossShielder_Init:
		lea	ObjDat3_BossShielder(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#_Setup4,routine(a0)
;		st	(Boss_flag).w
		st	obShaft_Timer(a0)
		move.w	#$A00,y_vel(a0)
		move.b	#110/2,y_radius(a0)
		move.l	#BossShielder_CheckFall,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossShielder_Setup5:
		bsr.w	Shaft_CreateExplosion
		bra.w	BossShielder_Setup
; ---------------------------------------------------------------------------

BossShielder_Setup4:
		bsr.w	Shaft_CreateExplosion
		jsr	(MoveSprite2).w
		jmp	(ObjHitFloor_DoRoutine).w
; ---------------------------------------------------------------------------

BossShielder_Setup3:
		bsr.w	BossShielder_CheckTouch
		bsr.w	BossShielder_CreateFire
		cmpi.b	#6,(Player_1+routine).w
		bhs.s	BossShielder_Setup2
		subq.w	#1,$30(a0)
		bpl.s	BossShielder_Setup2
		move.w	#$4F,$30(a0)
		sfx	sfx_FireShot
		lea	ChildObjDat_BossShielderFireBall(pc),a2
		jsr	(CreateChild1_Normal).w

BossShielder_Setup2:
		lea	(Player_1).w,a1
		cmpi.b	#4,routine(a1)
		bne.s	+
		move.w	#-$400,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
+		subq.w	#1,$32(a0)
		bpl.s	BossShielder_Setup
		move.w	#$1B,$32(a0)
		sfx	sfx_Attachment
		move.w	#$14,(Screen_Shaking_Flag).w

BossShielder_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

BossShielder_CheckFall:
		move.b	#_Setup5,routine(a0)
		move.l	#BossShielder_CreateBody,$34(a0)
		clr.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

BossShielder_CreateBody:
		move.l	#BossShielder_Wait,$34(a0)
		lea	ChildObjDat_ShielderBody(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------

BossShielder_Move:
		move.b	#_Setup2,routine(a0)
		move.l	#BossShielder_Wait,$34(a0)
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#-$200,x_vel(a0)
		addq.b	#1,anim(a0)

BossShielder_Wait:
		rts
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

BossShielder_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	BossShielder_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	BossShielder_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$40,$1C(a0)
		sfx	sfx_HitBoss
		bset	#6,status(a0)
		lea	(Player_1).w,a1
		move.w	#-$600,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)

+		moveq	#0,d0
		moveq	#0,d1				; check every frame
		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		beq.s	.gotcheck			; branch if no
		moveq	#3,d1				; check every 8 frames

.gotcheck
		btst	d1,$1C(a0)
		bne.s	+
		addi.w	#6*2,d0
+		bsr.w	ShielderBody_PalFlash

		subq.b	#1,$1C(a0)
		bne.s	BossShielder_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

		; fix pal
		moveq	#0,d0
		bsr.w	ShielderBody_PalFlash

BossShielder_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

BossShielder_CheckTouch_WaitExplosive:
		addq.b	#2,(Dynamic_resize_routine).w
		move.l	#BossShielder_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		bset	#7,status(a0)
		move.w	#$3F,$2E(a0)
		lea	(Player_1).w,a1
		move.w	#-$600,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

BossShielder_WaitPlayerExplosive:
		bsr.w	ShielderHead_CreateFire2
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge
		move.w	#$14,(Screen_Shaking_Flag).w
+		jsr	(Draw_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	+
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$14,(Screen_Shaking_Flag).w
		move.l	#Obj_Shielder_Explosion,address(a0)
+		rts
; ---------------------------------------------------------------------------
; ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShielderBody:
		lea	ObjDat3_BossShielderBody(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		ori.b	#$A0,art_tile(a0)
		move.l	#ShielderBody_Intro,address(a0)

ShielderBody_Intro:
		subq.b	#8,child_dy(a0)
		cmpi.b	#-40,child_dy(a0)
		bne.s	ShielderBody_Draw
		lea	ChildObjDat_ShielderHand(pc),a2
		jsr	(CreateChild1_Normal).w
		move.l	#ShielderBody_Main,address(a0)
		bra.s	ShielderBody_Main
; ---------------------------------------------------------------------------

ShielderBody_Main2:
		bsr.w	ShielderBody_CheckTouch
		bsr.w	ShielderBody_CreateFire
		subq.w	#1,$2E(a0)
		bpl.s	ShielderBody_Main
		move.w	#$1F,$2E(a0)
		sfx	sfx_FireShot
		lea	ChildObjDat_ShielderBodyFireBall(pc),a2
		jsr	(CreateChild1_Normal).w

ShielderBody_Main:
		movea.w	parent3(a0),a1
		tst.w	x_vel(a1)
		beq.s	ShielderBody_Draw
		moveq	#-40,d0
		btst	#4,(V_int_run_count+3).w
		beq.s	+
		addq.b	#4,d0
+		move.b	d0,child_dy(a0)

ShielderBody_Draw:
		jsr	(Refresh_ChildPosition).w
		movea.w	parent3(a0),a1
		tst.w	obShaft_Timer(a1)
		beq.s	+

		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		bne.s	+				; branch if yes
		btst	#0,(V_int_run_count+3).w
		beq.s	ShielderBody_CheckTouch_Return
+		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

ShielderBody_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	ShielderBody_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	ShielderBody_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$40,$1C(a0)
		sfx	sfx_HitBoss
		bset	#6,status(a0)
		lea	(Player_1).w,a1
		move.w	#-$600,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)

+
		moveq	#0,d0
		moveq	#0,d1
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.gotcount			; if not, spawn all
		moveq	#3,d1

.gotcount
		btst	d1,$1C(a0)
		bne.s	+
		addi.w	#6*2,d0
+		bsr.w	ShielderBody_PalFlash

		subq.b	#1,$1C(a0)
		bne.s	ShielderBody_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

		; fix pal
		moveq	#0,d0
		bsr.w	ShielderBody_PalFlash

ShielderBody_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

ShielderBody_CheckTouch_WaitExplosive:
		move.l	#ShielderBody_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		bset	#7,status(a0)
		move.w	#$3F,$2E(a0)
		lea	(Player_1).w,a1
		move.w	#-$600,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

ShielderBody_WaitPlayerExplosive:
		bsr.w	ShielderBody_CreateFire
		bsr.w	ShielderHead_CreateFire2
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge
+		jsr	(Refresh_ChildPosition).w
		jsr	(Child_DrawTouch_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	+
		move.l	#Obj_Shielder_Explosion,address(a0)
		movea.w	parent3(a0),a1
		move.b	#_Setup3,routine(a1)
		move.w	#$4F,$30(a1)
		eori.b	#$80,collision_flags(a1)

		move.w	(Difficulty_Flag).w,d0
		move.b	ShielderBody_HP(pc,d0.w),collision_property(a1)

+		rts
; ---------------------------------------------------------------------------

ShielderBody_HP:
		dc.b 4/2	; Easy
		dc.b 4	; Normal
		dc.b 4+2	; Hard
		dc.b 4+2	; Maniac
; ---------------------------------------------------------------------------
; ���� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShielderHand:
		lea	ObjDat3_BossShielderHand(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#ShielderHand_Main,address(a0)
		lea	ChildObjDat_ShielderHead(pc),a2
		jsr	(CreateChild1_Normal).w

ShielderHand_Main:
		jsr	(Refresh_ChildPosition).w
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		tst.w	obShaft_Timer(a1)
		beq.s	+

		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		bne.s	+				; branch if yes
		btst	#0,(V_int_run_count+3).w
		beq.s	ShielderHand_Return
+		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------
; �������� �������
; ---------------------------------------------------------------------------

ShielderHand_WaitPlayerExplosive:
		bsr.w	ShielderHead_CreateFire2
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge

+		jsr	(Refresh_ChildPosition).w
		jsr	(Child_Draw_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	ShielderHand_Return
		move.l	#Obj_Shielder_Explosion,address(a0)
		movea.w	parent3(a0),a1
		move.w	#$4F,$2E(a1)
		move.l	#ShielderBody_Main2,address(a1)
		eori.b	#$80,collision_flags(a1)
		lea	ShielderBody_HP(pc),a2
		move.w	(Difficulty_Flag).w,d0
		move.b	(a2,d0.w),collision_property(a1)

ShielderHand_Return:
		rts
; ---------------------------------------------------------------------------
; ������ �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShielderHead:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	ShielderHead_Index(pc,d0.w),d0
		jsr	ShielderHead_Index(pc,d0.w)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		movea.w	parent3(a1),a1
		tst.w	obShaft_Timer(a1)
		beq.s	+

		tst.w	Seizure_flag.w			; check if we are in photosensitivity
		bne.s	+				; branch if yes
		btst	#0,(V_int_run_count+3).w
		beq.s	ShielderHand_Return
+		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

ShielderHead_Index: offsetTable
		offsetTableEntry.w ShielderHead_Init	; 0
		offsetTableEntry.w ShielderHead_Setup	; 2
		offsetTableEntry.w ShielderHead_Setup2	; 4
		offsetTableEntry.w ShielderHead_Setup3	; 6
; ---------------------------------------------------------------------------

ShielderHead_Init:
		move.w	x_pos(a0),d0
		move.w	#272,d1
		sub.w	d1,d0
		move.w	d1,$38(a0)
		move.w	d0,x_pos(a0)
		lea	ObjDat3_BossShielderHead(pc),a1
		jsr	(SetUp_ObjAttributes).w
		lea	ShielderBody_HP(pc),a1
		move.w	(Difficulty_Flag).w,d0
		move.b	(a1,d0.w),collision_property(a0)
		move.l	#ShielderHead_Intro,$34(a0)
		move.b	#48,objoff_3A(a0)
		rts
; ---------------------------------------------------------------------------

ShielderHead_Setup2:
		jsr	(Refresh_ChildPosition).w

ShielderHead_Setup:
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

ShielderHead_Setup3:
		jsr	(Obj_Wait).w
		bsr.w	ShielderHead_CheckTouch

ShielderHead_Setup3_2:
		moveq	#0,d0
		movea.w	parent3(a0),a1
		move.b	objoff_3C(a0),d0
		lsr.b	#5,d0
		andi.b	#3,d0
		move.b	d0,mapping_frame(a0)
		move.b	d0,mapping_frame(a1)
		add.b	d0,d0
		move.w	ShielderHead_Pos(pc,d0.w),child_dx(a0)
		move.w	ShielderHead_Pos2(pc,d0.w),child_dx(a1)
		jsr	(MoveSprite_Circular).w
		move.l	a0,-(sp)
		movea.w	parent3(a0),a0
		movea.w	parent3(a1),a1
		jsr	(Refresh_ChildPosition).w
		movea.l	(sp)+,a0
		rts
; ---------------------------------------------------------------------------

ShielderHead_Pos:
		dc.b -48, 8		; ���
		dc.b -64, -16		; ��������
		dc.b -108, -12		; ����
		dc.b -108, -12		; ����
ShielderHead_Pos2:
		dc.b -48, 8		; ���
		dc.b -48, -8		; ��������
		dc.b -48, -8		; ����
		dc.b -48, -8		; ����
; ---------------------------------------------------------------------------

ShielderHead_Intro:
		move.w	#$10,d0
		add.w	d0,x_pos(a0)
		sub.w	d0,$38(a0)
		bne.s	ShielderHead_Return
		move.b	#_Setup2,routine(a0)
		move.w	#$4F,$2E(a0)
		move.l	#ShielderHead_Intro2,$34(a0)
		sfx	sfx_Attachment
		clr.b	child_dy(a0)

ShielderHead_Return:
		rts
; ---------------------------------------------------------------------------

ShielderHead_Intro2:
		sfx	sfx_BreakBridge
		bsr.w	ShielderHead_CreateFire
		move.w	#7,$2E(a0)
		moveq	#0,d0
		move.b	objoff_39(a0),d0
		addq.b	#2,objoff_39(a0)
		cmpi.b	#6,d0
		bne.s	+
		move.b	#_Setup3,routine(a0)
		move.b	#32,objoff_3C(a0)
		move.b	#$F,collision_flags(a0)
		move.w	#$2F,$2E(a0)
		move.l	#ShielderHead_Position,$34(a0)
		clr.b	objoff_39(a0)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a2
		movea.w	parent3(a2),a2
		move.b	#_Setup1,routine(a2)
		move.w	#$2F,$2E(a2)
		move.l	#BossShielder_Move,$34(a2)
		clr.w	obShaft_Timer(a2)
		sf	(Screen_shaking_flag).w
		move.w	ShielderHead_Pos2+2(pc),child_dx(a1)
+		move.w	ShielderHead_Pos3(pc,d0.w),child_dx(a0)
		rts
; ---------------------------------------------------------------------------

ShielderHead_Pos3:
		dc.b -24, 0
		dc.b -35, -26
		dc.b -46, 0
		dc.b -48, 16
ShielderHead_SetPos:
		dc.b 32, 0, 32, 64, 32, 0, 32, 64
; ---------------------------------------------------------------------------

ShielderHead_Position:
		moveq	#0,d0
		move.b	objoff_39(a0),d0
		addq.b	#1,objoff_39(a0)
		cmpi.b	#7,d0
		bne.s	+
		clr.b	objoff_39(a0)
+		move.b	ShielderHead_SetPos(pc,d0.w),objoff_3C(a0)
		move.w	#$2F,$2E(a0)
		move.l	#ShielderHead_Attack,$34(a0)
		rts
; ---------------------------------------------------------------------------

ShielderHead_Attack:
		move.w	#$1F,$2E(a0)
		move.l	#ShielderHead_Position,$34(a0)
		sfx	sfx_FireShot
		lea	ChildObjDat_ShielderHeadFireBall(pc),a2
		jmp	(CreateChild1_Normal).w
; ---------------------------------------------------------------------------
; �������� �����
; ---------------------------------------------------------------------------

ShielderHead_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	ShielderHead_CheckTouch_Return
		tst.b	collision_property(a0)
		beq.s	ShielderHead_CheckTouch_WaitExplosive
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$40,$1C(a0)
		sfx	sfx_HurtFire
		bset	#6,status(a0)
		lea	(Player_1).w,a1
		move.w	#-$300,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
+		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	+
		addq.w	#3*2,d0
+		bsr.w	ShielderHead_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	ShielderHead_CheckTouch_Return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

ShielderHead_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

ShielderHead_CheckTouch_WaitExplosive:
		move.l	#ShielderHead_CheckTouch_WaitPlayerExplosive,address(a0)
		bset	#6,status(a0)
		bset	#7,status(a0)
		move.w	#$3F,$2E(a0)
		lea	(Player_1).w,a1
		move.w	#-$300,d0
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
		rts
; ---------------------------------------------------------------------------

ShielderHead_CheckTouch_WaitPlayerExplosive:
		bsr.w	ShielderHead_CreateFire2
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge

+		bsr.w	ShielderHead_Setup3_2
		jsr	(Child_DrawTouch_Sprite).w
		subq.w	#1,$2E(a0)
		bne.s	+
		move.l	#Obj_Shielder_Explosion,address(a0)
		movea.w	parent3(a0),a1
		move.w	#$1F,$2E(a1)
		move.l	#ShielderHand_WaitPlayerExplosive,address(a1)
+		rts

; =============== S U B R O U T I N E =======================================

ShielderHead_CreateFire:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.create				; if not, spawn every frame
		moveq	#3,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	+

.create
		lea	ChildObjDat_BossCerberus_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#24/2,$3A(a1)
		move.b	#24/2,$3B(a1)
		move.w	#$80,$3C(a1)
+		rts

; =============== S U B R O U T I N E =======================================

ShielderHead_CreateFire2:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.create				; if not, spawn every frame
		moveq	#3,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	+

.create
		lea	ChildObjDat_BossCerberus_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$80,$3C(a1)
+		rts

; =============== S U B R O U T I N E =======================================

ShielderBody_CreateFire:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.create				; if not, spawn every frame
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		cmp.b	#4,d0
		bne.s	+

.create
		lea	ChildObjDat_ShielderBody_Fire(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.b	#24/2,$3A(a1)
		move.b	#24/2,$3B(a1)
		move.w	#$300,$3C(a1)
+		rts

; =============== S U B R O U T I N E =======================================

BossShielder_CreateFire:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.create				; if not, spawn every frame
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	+

.create
		lea	ChildObjDat_ShielderBody_Fire2(pc),a2
		jsr	(CreateChild1_Normal).w
		bne.s	+
		move.b	#24/2,$3A(a1)
		move.b	#24/2,$3B(a1)
		move.w	#$300,$3C(a1)
+		rts
; ---------------------------------------------------------------------------
; �������� ��� �� ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShielderHeadFireBall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	ShielderHeadFireBall_Index(pc,d0.w),d0
		jsr	ShielderHeadFireBall_Index(pc,d0.w)
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

ShielderHeadFireBall_Index: offsetTable
		offsetTableEntry.w ShielderHeadFireBall_Init		; 0
		offsetTableEntry.w ShielderHeadFireBall_Setup	; 2
		offsetTableEntry.w ShielderHeadFireBall_Setup2	; 4
; ---------------------------------------------------------------------------

ShielderHeadFireBall_Init:
		lea	ObjDat3_BossShielderHeadFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#4,shield_reaction(a0)
		move.b	#24/2,y_radius(a0)
		move.w	#7,$2E(a0)
		move.l	#ShielderHeadFireBall_Frame,$34(a0)
		move.l	#AniRaw_Shielder_FireBall,$30(a0)
		move.w	#-$580,x_vel(a0)
		moveq	#0,d0
		movea.w	parent3(a0),a1
		move.b	objoff_3C(a1),d0
		beq.s	+
		lsr.w	#4,d0
		move.w	ShielderHeadFireBall_DataYPos-2(pc,d0.w),y_vel(a0)
		rts
+		subq.b	#1,mapping_frame(a0)
		rts
; ---------------------------------------------------------------------------

ShielderHeadFireBall_DataYPos:
		dc.w $280		; ��������
		dc.w $480		; ����
; ---------------------------------------------------------------------------

ShielderHeadFireBall_Setup2:
		jsr	(Animate_Raw).w

ShielderHeadFireBall_Setup:
		jsr	(MoveSprite2).w
		jmp	(Obj_Wait).w
; ---------------------------------------------------------------------------

ShielderHeadFireBall_Frame:
		move.b	#_Setup2,routine(a0)
		move.l	#ShielderHeadFireBall_CheckFloor,$34(a0)

ShielderHeadFireBall_CheckFloor:
		tst.w	y_vel(a0)
		beq.s	+
		bmi.s	ShielderHeadFireBall_Return
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	ShielderHeadFireBall_Return
		add.w	d1,y_pos(a0)
+		move.l	#ShielderHeadFireBall_Return,$34(a0)
		clr.w	y_vel(a0)

ShielderHeadFireBall_Return:
		rts
; ---------------------------------------------------------------------------
; �������� ��� �� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShielderBodyFireBall:
		lea	ObjDat3_BossShielderBodyFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#4,shield_reaction(a0)
		ori.b	#$80,art_tile(a0)
		jsr	(Random_Number).w
		move.w	#$300,d1
		and.w	d1,d0
		add.w	d1,d0
		neg.w	d0
		move.w	d0,x_vel(a0)
		move.w	#-$600,y_vel(a0)
		move.l	#ShielderBodyFireBall_Main,address(a0)
		move.l	#AniRaw_Shielder_FireBall,$30(a0)

ShielderBodyFireBall_Main:
		jsr	(Animate_Raw).w
		jsr	(MoveSprite).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------
; �������� ��� �� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossShielderFireBall:
		lea	ObjDat3_BossShielderBodyFireBall(pc),a1
		jsr	(SetUp_ObjAttributes).w
		bset	#4,shield_reaction(a0)
		ori.b	#$80,art_tile(a0)
		move.b	#16/2,y_radius(a0)
		move.l	#BossShielderFireBall_Main,address(a0)
		move.l	#AniRaw_Shielder_FireBall,$30(a0)
		lea	(Player_1).w,a1
		move.w	x_pos(a1),d1
		move.w	y_pos(a1),d2
		sub.w	x_pos(a0),d1
		sub.w	y_pos(a0),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#$800,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

		lea	ChildObjDat_BossShielderFireBall_2(pc),a2
		jsr	(CreateChild6_Simple).w

BossShielderFireBall_Main:
		jsr	(Animate_Raw).w
		bsr.s	BossShielderFireBall_Bounced
		jsr	(MoveSprite2).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

BossShielderFireBall_Bounced:
		tst.w	y_vel(a0)
		bmi.s	BossShielderFireBall_Return
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.s	BossShielderFireBall_Return
		add.w	d1,y_pos(a0)
		neg.w	y_vel(a0)

BossShielderFireBall_Return:
		rts
; ---------------------------------------------------------------------------
; �������������� �������� ���� �� �����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossShielderFireBall_2:
		moveq	#0,d0
		move.b	subtype(a0),d0
		addq.b	#2,d0
		move.w	d0,$2E(a0)
		lea	ObjDat3_BossShielderBodyFireBall2(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		jsr	(Child_GetPriority).w
		bset	#4,shield_reaction(a0)
		move.b	#16/2,y_radius(a0)
		move.l	x_vel(a1),x_vel(a0)
		move.l	#BossShielderFireBall2_Wait,address(a0)
		move.l	#AniRaw_Shielder_FireBall,$30(a0)

BossShielderFireBall2_Wait:
		subq.w	#1,$2E(a0)
		bne.s	+
		move.l	#BossShielderFireBall_Main,address(a0)
+		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------
; ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Shielder_Explosion:
		moveq	#0,d2
		moveq	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_Shielder_Explosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)

		move.w	#$859C,d3
		cmpi.w	#$201,(Current_zone_and_act).w
		bne.s	+
		move.w	#$8310,d3
+		move.w	d3,art_tile(a1)

		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#3,anim_frame_timer(a1)
		move.b	#4,objoff_3A(a1)
		move.b	#16,objoff_3C(a1)
		move.b	d2,angle(a1)
		move.b	#8,$40(a1)
		addi.w	#$20,d2
		dbf	d1,-
+		bra.s	Shielder_Explosion_Delete
; ---------------------------------------------------------------------------

Obj_Shielder_Explosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#5,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	Shielder_Explosion_Delete
		cmpi.b	#6,mapping_frame(a0)
		bne.s	+
		move.b	#$F,anim_frame_timer(a0)
+		move.b	$40(a0),d0
		sub.b	d0,angle(a0)
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		muls.w	objoff_3A(a0),d0
		swap	d0
		add.w	d0,x_pos(a0)
		muls.w	objoff_3C(a0),d1
		swap	d1
		add.w	d1,y_pos(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Shielder_Explosion_Delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

ShielderHead_PalFlash:
		lea	LoadShielderHead_PalRAM(pc),a1
		lea	LoadShielderHead_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_3).w
; ---------------------------------------------------------------------------

LoadShielderHead_PalRAM:
		dc.w Normal_palette_line_2+4
		dc.w Normal_palette_line_2+6
		dc.w Normal_palette_line_2+8
LoadShielderHead_PalCycle:
		dc.w $EA, $A6, $64
		dc.w $E80, $C60, $820

; =============== S U B R O U T I N E =======================================

ShielderBody_PalFlash:
		lea	LoadShielderBody_PalRAM(pc),a1
		lea	LoadShielderBody_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_6).w
; ---------------------------------------------------------------------------

LoadShielderBody_PalRAM:
		dc.w Normal_palette_line_2+2
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1A
		dc.w Normal_palette_line_2+$1C
		dc.w Normal_palette_line_2+$1E
LoadShielderBody_PalCycle:
		dc.w $EEE, $CCE, $8AC, $668, $424, $202
		dc.w $EA0, $E80, $C60, $A40, $820, $600

; =============== S U B R O U T I N E =======================================

ObjDat3_BossShielder:
		dc.l Map_ShielderBody
		dc.w $2000|Shielder_VRAM
		dc.w $200
		dc.b 168/2
		dc.b 80/2
		dc.b 0
		dc.b $16|$80
ObjDat3_BossShielderBody:
		dc.w $180
		dc.b 168/2
		dc.b 80/2
		dc.b 2
		dc.b $39|$80
ObjDat3_BossShielderHand:
		dc.l Map_ShielderHand
		dc.w $2000|Shielder_VRAM
		dc.w $280
		dc.b 168/2
		dc.b 80/2
		dc.b 2
		dc.b 0
ObjDat3_BossShielderHead:
		dc.l Map_ShielderHead
		dc.w $2000|Shielder_VRAM
		dc.w $100
		dc.b 64/2
		dc.b 64/2
		dc.b 0
		dc.b 0
ObjDat3_BossShielderHeadFireBall:
		dc.l Map_ShielderFireBall
		dc.w Shielder_VRAM
		dc.w $80
		dc.b 32/2
		dc.b 24/2
		dc.b 3
		dc.b $B|$80
ObjDat3_BossShielderBodyFireBall:
		dc.l Map_ShielderFireBall
		dc.w Shielder_VRAM
ObjDat3_BossShielderBodyFireBall2:
		dc.w $80
		dc.b 32/2
		dc.b 24/2
		dc.b 0
		dc.b $B|$80
AniRaw_Shielder_FireBall:
		dc.b 3, 0, 1, $FC
ChildObjDat_ShielderBody:
		dc.w 1-1
		dc.l Obj_ShielderBody
		dc.b 0, 80
ChildObjDat_ShielderHand:
		dc.w 1-1
		dc.l Obj_ShielderHand
		dc.b 8, 0
ChildObjDat_ShielderHead:
		dc.w 1-1
		dc.l Obj_ShielderHead
		dc.b -24, -8
ChildObjDat_ShielderHeadFireBall:
		dc.w 1-1
		dc.l Obj_ShielderHeadFireBall
		dc.b -16, 16
ChildObjDat_ShielderBodyFireBall:
		dc.w 1-1
		dc.l Obj_ShielderBodyFireBall
		dc.b -16, 0
ChildObjDat_BossShielderFireBall:
		dc.w 1-1
		dc.l Obj_BossShielderFireBall
		dc.b -16, 0
ChildObjDat_BossShielderFireBall_2:
		dc.w 4-1
		dc.l Obj_BossShielderFireBall_2
ChildObjDat_Shielder_Explosion:
		dc.w 1-1
		dc.l Obj_Shielder_Explosion
ChildObjDat_ShielderBody_Fire:
		dc.w 1-1
		dc.l Obj_BossCerberus_Fire
		dc.b -24, 16
ChildObjDat_ShielderBody_Fire2:
		dc.w 1-1
		dc.l Obj_BossCerberus_Fire
		dc.b -16, -8
PLC_BossShielder: plrlistheader
		plreq Shielder_VRAM, ArtKosM_BossShielder
PLC_BossShielder_End
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Shielder/Object data/Anim - Shielder.asm"
		include "Objects/Bosses/Shielder/Object data/Map - Body.asm"
		include "Objects/Bosses/Shielder/Object data/Map - Hand.asm"
		include "Objects/Bosses/Shielder/Object data/Map - Head.asm"
		include "Objects/Bosses/Shielder/Object data/Map - Fire Ball.asm"
