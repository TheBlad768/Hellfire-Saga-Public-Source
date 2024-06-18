Obj_Scientist:
		moveq	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_Scientist_Index(pc,d0.w),d1
		jsr    	Obj_Scientist_Index(pc,d1.w)
		bsr.w  	Obj_Scientist_Process
		lea    	Ani_Scientist(pc),a1
		jsr    	(AnimateSprite).w
		jmp    	(Obj_Scientist_Display).l
; ==================================================================
Obj_Scientist_Index:
		dc.w Obj_Scientist_Main-Obj_Scientist_Index
		dc.w Obj_Scientist_GetReady-Obj_Scientist_Index
		dc.w Obj_Scientist_ChkNumberOfAttacks-Obj_Scientist_Index
		dc.w Obj_Scientist_Teleport-Obj_Scientist_Index
		dc.w Obj_Scientist_Return-Obj_Scientist_Index
; ==================================================================
Obj_Scientist_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Scientist_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Scientist_Return

Obj_Scientist_Animate:
		jmp	(Draw_And_Touch_Sprite).w
; ==================================================================

Obj_Scientist_Process:
		move.b	#60,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.s	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		bra.w	.lacricium

.gone:
		move.b	#1,objoff_49(a0)

      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.w	#1,(AstarothCompleted).w
		move.b	#1,(Check_Dead).w
		move.l	#Delete_Current_Sprite,(a0)

.lacricium:
		rts
; ==================================================================

Obj_Scientist_HP:
		dc.b 8/2	; Easy
		dc.b 8		; Normal
		dc.b 8+2	; Hard
		dc.b 8+2	; Maniac
; ==================================================================

Obj_Scientist_Main:
		addq.b 	#2,obRoutine(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l 	#Map_Scientist,obMap(a0)
		move.w 	#$2403,obGfx(a0)
		move.b 	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$22,obColType(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Scientist_HP(pc,d0.w),$29(a0)

		move.w	#0,obSubtype(a0)
		move.w	#30,objoff_46(a0)
		move.b	#3,objoff_3C(a0)
		move.b	#0,objoff_3D(a0)
		move.b	#0,objoff_49(a0)
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bne.s	+
		add.w	d1,obY(a0)
+		rts

Obj_Scientist_GetReady:
		sub.w	#1,objoff_46(a0)
		bpl.w	Obj_Scientist_Return
		sf (Ctrl_1_locked).w
		move.w	#60,objoff_46(a0)
		addq.b 	#2,obRoutine(a0)

Obj_Scientist_ChkNumberOfAttacks:
		sub.w	#1,objoff_46(a0)
		bpl.w	Obj_Scientist_Return
		move.w	#1,obAnim(a0)
		move.b	objoff_3D(a0),d0
		move.b	objoff_3C(a0),d1
		cmp.b	d0,d1
		bne.w	.firstbottle
		jsr	(RandomNumber).w
		andi.w	#3,d0
		addi.w	#1,d0
		move.b	d0,objoff_3C(a0)
		move.b	#0,objoff_3D(a0)


		jsr	(RandomNumber).w
		andi.b	#1,d0
		move.b	d0,objoff_3E(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Scientist_MutaBottle,(a1)
		move.w	a0,parent2(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	objoff_3E(a0),objoff_3E(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	#-$700,obVelY(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		cmpi.b	#1,objoff_3E(a0)
		bne.w	.cony
		move.w	(Camera_x_pos).w,d1
		add.w	#$118,d1
		sub.w	obX(a0),d1
		asl.w	#2,d1
		move.w	d1,obVelX(a1)

.cony:
		move.w	a0,parent2(a1)

		cmpi.b	#1,objoff_3E(a0)
		bne.w	.fin

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Scientist_MutaBottle,(a1)
		move.w	a0,parent2(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#1,objoff_3E(a1)
		move.b	#1,objoff_30(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	#-$700,obVelY(a1)
		move.w	(Camera_x_pos).w,d1
		add.w	#$25,d1
		sub.w	obX(a0),d1
		asl.w	#2,d1
		move.w	d1,obVelX(a1)
		move.w	a0,parent2(a1)

.fin:
		jsr	(SingleObjLoad2).w
		bne.s	.fin2
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$100,obY(a0)

.fin2:
		move.b	#8,obRoutine(a0)
		rts


.firstbottle:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Scientist_Bottle,(a1)
		move.w	a0,parent2(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	#-$800,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$100,d0
		add.w	d0,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$E8,d0
		add.w	#$30,d0
		add.w	(Camera_x_pos).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)


		jsr	(RandomNumber).w
		andi.w	#1,d0
		beq.w	.finish

.secondbottle:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Scientist_Bottle,(a1)
		move.w	a0,parent2(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	#-$600,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$100,d0
		add.w	d0,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$E8,d0
		add.w	#$30,d0
		add.w	(Camera_x_pos).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		add.w	#$100,obVelX(a1)

		jsr	(RandomNumber).w
		andi.w	#3,d0
		beq.w	.finish

.thirdbottle:

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Scientist_Return
		move.l	#Obj_Scientist_Bottle,(a1)
		move.w	a0,parent2(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	#-$700,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$E8,d0
		add.w	#$30,d0
		add.w	(Camera_x_pos).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		sub.w	#$100,obVelX(a1)

.finish:
		add.b	#1,objoff_3D(a0)
		move.w	#90,objoff_46(a0)
		rts

Obj_Scientist_Teleport:
		move.w	(Camera_x_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obX(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$94,d0
		blt.s	.furpos
		bra.s	.changeor

.furpos:
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$118,d0
		move.w	d0,obX(a0)

.changeor:
		jsr	(Obj_Eggman_LookOnSonic).l

		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$A8,d0
		move.w	d0,obY(a0)
		jsr	(SingleObjLoad2).w
		bne.s	.fin
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

.fin:
		sub.b	#2,obRoutine(a0)

Obj_Scientist_Return:
		rts


; ===========================================================================
Obj_Scientist_Bottle:
		move.l 	#Map_Scientist,obMap(a0)
		move.w 	#$403,obGfx(a0)
		move.b	#2,obAnim(a0)
		move.b	#$31|$80,obColType(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.l	#Obj_Scientist_Bottle_Move,(a0)
		rts

Obj_Scientist_Bottle_ChkAlive:
		move.w	parent2(a0),a1
		cmpi.b	#1,objoff_49(a1)
		bne.s	+
		move.l  #Go_Delete_Sprite,(a0)
+		rts

Obj_Scientist_Bottle_Move:
		jsr	(Obj_Scientist_Bottle_ChkAlive).l
		lea	(Ani_Scientist).l,a1
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	+
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		sfx	sfx_Bomb
+		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_Scientist_MutaBottle:
		move.l 	#Map_Scientist,obMap(a0)
		move.w 	#$2403,obGfx(a0)
		move.b	#2,obAnim(a0)
		move.b	#$31|$80,obColType(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.l	#Obj_Scientist_MutaBottle_Move,(a0)

Obj_Scientist_MutaBottle_Move:
		jsr	(Obj_Scientist_Bottle_ChkAlive).l
		lea	(Ani_Scientist).l,a1
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Scientist_RoseBud,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	objoff_3E(a0),objoff_3E(a1)
		move.b	objoff_30(a0),objoff_30(a1)
		move.w	parent2(a0),parent2(a1)
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		sfx	sfx_Bomb
+		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================
Obj_Scientist_RoseBud:
		moveq	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_Scientist_RoseBud_Index(pc,d0.w),d1
		jsr    	Obj_Scientist_RoseBud_Index(pc,d1.w)
		lea    	Ani_Scientist(pc),a1
		jsr    	(AnimateSprite).w
		jsr	(Obj_Scientist_Bottle_ChkAlive).l
		jmp    	(Draw_And_Touch_Sprite).w
; ==================================================================
Obj_Scientist_RoseBud_Index:
		dc.w Obj_Scientist_RoseBud_Main-Obj_Scientist_RoseBud_Index
		dc.w Obj_Scientist_RoseBud_FlyUp-Obj_Scientist_RoseBud_Index
		dc.w Obj_Scientist_RoseBud_Flying-Obj_Scientist_RoseBud_Index
		dc.w Obj_Scientist_RoseBud_Attack-Obj_Scientist_RoseBud_Index
		dc.w Obj_Scientist_RoseBud_StompDown-Obj_Scientist_RoseBud_Index
; ==================================================================
Obj_Scientist_RoseBud_Main:
		addq.b	#2,obRoutine(a0)
		move.l 	#Map_Scientist,obMap(a0)
		move.w 	#$2403,obGfx(a0)
		move.b	#3,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#8,y_radius(a0)
		move.w	#-$300,obVelY(a0)

Obj_Scientist_RoseBud_FlyUp:
		jsr	(SpeedToPos).w
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$30,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Scientist_RoseBud_Return
		move.w	#0,obVelY(a0)
		move.b	#$86,obColType(a0)
		move.w	#120,obTimer(a0)
		cmpi.b	#1,objoff_3E(a0)
		beq.s	+
		addq.b	#2,obRoutine(a0)
		rts
+		move.w	#20,obTimer(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		move.b	#8,obRoutine(a0)
		rts

Obj_Scientist_RoseBud_Flying:
		jsr	(Find_SonicTails).w
		move.w	#$200,d0			; Maximum speed.
		move.w	#$20,d1				; Acceleration.
		jsr	(Chase_ObjectXOnly).w		; �������� ������ �� X �������
		jsr	(MoveSprite2).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Scientist_RoseBud_Return
		addq.b	#2,obRoutine(a0)
		move.w	#$700,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)

Obj_Scientist_RoseBud_Attack:
		sub.w	#$30,obVelY(a0)
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.s	Obj_Scientist_RoseBud_Return
		move.w	parent2(a0),a1
		cmpi.b	#6,obRoutine(a1)
		beq.s	+
		move.b	#6,obRoutine(a1)
+		move.l  #Go_Delete_Sprite,(a0)

Obj_Scientist_RoseBud_StompDown:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Scientist_RoseBud_Return
		jsr	(Find_SonicTails).w
		move.w	#$300,d0			; Maximum speed.
		move.w	#$70,d1				; Acceleration.
		jsr	(Chase_ObjectXOnly).w		; �������� ������ �� X �������
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	Obj_Scientist_RoseBud_Return
		move.w	parent2(a0),a1
		cmpi.b	#6,obRoutine(a1)
		beq.s	+
		move.b	#6,obRoutine(a1)
+               move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)

Obj_Scientist_RoseBud_Return:
		rts


		include	"Objects/Bosses/Scientist/Object data/Ani - Scientist.asm"
		include	"Objects/Bosses/Scientist/Object data/Map - Scientist.asm"
