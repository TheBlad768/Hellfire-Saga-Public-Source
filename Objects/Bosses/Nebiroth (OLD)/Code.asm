Obj_Nebiroth:
		moveq 	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_Nebiroth_Index(pc,d0.w),d1
		jsr	Obj_Nebiroth_Index(pc,d1.w)
		bsr.w	Obj_Nebiroth_Process
		lea	Ani_Nebiroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ==================================================================
Obj_Nebiroth_Index:
		dc.w Obj_Nebiroth_Main-Obj_Nebiroth_Index	; 0
		dc.w Obj_Nebiroth_Arrive-Obj_Nebiroth_Index
		dc.w Obj_Nebiroth_Stand-Obj_Nebiroth_Index	; 4
		dc.w Obj_Nebiroth_Move-Obj_Nebiroth_Index	; 6
		dc.w Obj_Nebiroth_Attack-Obj_Nebiroth_Index	; 8
		dc.w Obj_Nebiroth_Jump-Obj_Nebiroth_Index	; A
		dc.w Obj_Nebiroth_Land-Obj_Nebiroth_Index	; C
; ==================================================================
Obj_Nebiroth_Process:
		move.b	#60,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $1C(a0)
		bne.s   .whatizit
		move.b  #$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		move.w	parent(a0),a1
		move.b	#0,obColType(a1)
		bset    #6,$2A(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		jsr	(BossFlash_Pal2).l
		subq.b	#1,$1C(a0)
		bne.w	.lacricium
		move.w	parent(a0),a1
		move.b	#$8A,obColType(a1)
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		rts
; ==================================================================

.gone:
		move.w	#1,(AstarothCompleted).w
		move.b	#1,objoff_49(a0)
		clr.b	(MidBoss_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	.skip1
		move.l	#Obj_Song_Fade_ToLevelMusic,(a1)
.skip1

		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Camera_min_X_pos).w
		move.w	#$A00,(Camera_target_max_Y_pos).w


		lea	(Pal_GMZ).l,a1
		jsr	(PalLoad_Line1).w
		cmpi.w  #70,(v_rings).w;
		bcc.s   .contdying
		move.w	#70,(v_rings).w
		move.b	#$80,(Update_HUD_ring_count).w

.contdying:
		jsr	(Obj_KillBloodCreate).l
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.skip
		move.b	#8,$2C(a1)
.skip		move.l	#Delete_Current_Sprite,(a0)
		lea	(PLC2_GMZ2_Enemy).l,a5
		jsr	(LoadPLC_Raw_KosM).w

.lacricium:
		rts
; ==================================================================
Obj_Nebiroth_NebWave_Attack:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_NebWave,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#$800,obVelX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_NebWave,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.w	#$C,obY(a1)
		move.w	#$800,obVelX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_NebWave,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.w	#$18,obY(a1)
		move.w	#$800,obVelX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)

+		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_NebWave,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$C,obY(a1)
		move.w	#$800,obVelX(a1)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a1)

+		sfx	sfx_Teleport
		rts
; ==================================================================

Obj_Nebiroth_HP:
		dc.b 6/2	; Easy
		dc.b 6		; Normal
		dc.b 6+2	; Hard
		dc.b 6+2	; Maniac
; ==================================================================

Obj_Nebiroth_Main:
		move.w	#$400,obVelX(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Nebiroth,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$C,obColType(a0)
		move.b	#$1F,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$1F,x_radius(a0)
		move.b	#$1F,y_radius(a0)
		move.b	#0,objoff_32(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_Nebiroth_Legs,(a1)
		move.w	a0,parent3(a1)
		move.b	#$8A,obColType(a1)
		move.w	a1,parent(a0)
		move.b	#0,objoff_49(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Nebiroth_HP(pc,d0.w),$29(a0)

Obj_Nebiroth_Arrive:
		jsr	(SpeedToPos).w
		cmpi.w	#$332,obX(a0)
		blt.w	Obj_Nebiroth_Return
		move.w	#90,obTimer(a0)
		addq.b	#2,obRoutine(a0)
		clr.w	obVelX(a0)

Obj_Nebiroth_Stand:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Nebiroth_Return
		jsr	(RandomNumber).w
		andi.w	#1,d0
		beq.s	Obj_Nebiroth_setjump

Obj_Nebiroth_setrun:
		move.w	#100,obTimer(a0)
		addq.b	#2,obRoutine(a0)
		rts


Obj_Nebiroth_setjump:
		move.b	#1,obAnim(a0)
		move.w	#-$500,obVelY(a0)
		move.w	#$11A,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		addq.b	#6,obRoutine(a0)
		rts

Obj_Nebiroth_Move:
		move.w	#$335,obVelX(a0)
		cmpi.w	#70,obTimer(a0)
		bgt.s	+
		cmpi.w	#30,obTimer(a0)
		blt.s	+
		move.w	#$550,obVelX(a0)
+		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Nebiroth_Return
		move.w	#30,obTimer(a0)
		bchg	#0,obStatus(a0)
		move.w	#0,obVelX(a0)
		addq.b	#2,obRoutine(a0)
		rts

Obj_Nebiroth_Attack:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Nebiroth_Return
		move.b	#8,obAnim(a0)
		bsr.w	Obj_Nebiroth_NebWave_Attack
		move.w	#60,obTimer(a0)
		subq.b	#4,obRoutine(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		rts

Obj_Nebiroth_Jump:
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		cmpi.w	#$1D5,obY(a0)
		blt.w	Obj_Nebiroth_Return
		move.w	#$1D9,obY(a0)
		sfx	sfx_Pump
		add.b	#1,objoff_32(a0)
		move.w	#15,obTimer(a0)
		move.b	#0,obAnim(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		addq.b	#2,obRoutine(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_WarningStone,(a1)
		move.w	a0,parent(a1)
		move.w	#$1D9,obY(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		jsr	(RandomNumber).w
		andi.w	#$191,d0
		addi.w	d0,obX(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Nebiroth_Return
		move.l	#Obj_WarningStone,(a1)
		move.w	a0,parent(a1)
		move.w	#$1D9,obY(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		jsr	(RandomNumber).w
		andi.w	#$191,d0
		addi.w	d0,obX(a1)

Obj_Nebiroth_Land:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Nebiroth_Return
		move.b	#1,obAnim(a0)
		cmpi.b	#4,objoff_32(a0)
		beq.s	+
		move.w	#-$500,obVelY(a0)
		subq.b	#2,obRoutine(a0)
		rts

+		move.b	#0,objoff_32(a0)
		move.w	#30,obTimer(a0)
		bchg	#0,obStatus(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		subq.b	#4,obRoutine(a0)
		move.b	#0,obAnim(a0)

Obj_Nebiroth_Return:
		rts

; ==================================================================
Obj_Nebiroth_Legs:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Nebiroth_Legs_Index(pc,d0.w),d1
		jsr	Obj_Nebiroth_Legs_Index(pc,d1.w)
		lea	Ani_Nebiroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).w
; ==================================================================
Obj_Nebiroth_Legs_Index:
		dc.w Obj_Nebiroth_Legs_Main-Obj_Nebiroth_Legs_Index
		dc.w Obj_Nebiroth_Legs_Action-Obj_Nebiroth_Legs_Index
; ==================================================================
Obj_Nebiroth_KeepLegs:
		move.w	parent(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		add.w	#$18,obY(a0)
		rts
; ==================================================================
Obj_Nebiroth_Legs_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Nebiroth,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$88,obColType(a0)
		move.b	#$1F,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$1F,x_radius(a0)
		move.b	#$1F,y_radius(a0)

Obj_Nebiroth_Legs_Action:
		move.w	parent3(a0),a1
		move.w	obStatus(a1),obStatus(a0)
		move.w	obX(a1),obX(a0)
		move.w	obY(a1),obY(a0)
		add.w	#$18,obY(a0)
		move.b	obRoutine(a1),d0
                move.b Obj_Nebiroth_Legs_Anim(pc,d0.w),d1
		move.b	d1,obAnim(a0)
		rts

Obj_Nebiroth_Legs_Anim:
		dc.b	3
		dc.b	3
		dc.b	2
		dc.b	2
		dc.b	2
		dc.b	2
		dc.b	3
		dc.b	3
		dc.b	2
		dc.b	2
		dc.b	4
		dc.b	4
		dc.b	2
		dc.b	2

Obj_Nebiroth_Legs_Return:
		rts

; ==================================================================
Obj_WarningStone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_WarningStone_Index(pc,d0.w),d1
		jsr	Obj_WarningStone_Index(pc,d1.w)
		lea	Ani_Nebiroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_WarningStone_Index:
		dc.w Obj_WarningStone_Main-Obj_WarningStone_Index
		dc.w Obj_SumStone-Obj_WarningStone_Index
		dc.w Obj_WarningStone_Delete-Obj_WarningStone_Index
; ---------------------------------------------------------------------------

Obj_WarningStone_Main:
		move.l	#Map_Nebiroth,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#6,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #100,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_SumStone:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_49(a1)
		beq.w	+
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_WarningStone_Return
		jsr	(SingleObjLoad2).w
		bne.s	Obj_WarningStone_Return
		move.l	#Obj_NebStone,(a1)
		move.w	parent(a0),parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.w	#$B6,obY(a1)
+		addq.b	#2,routine(a0)

Obj_WarningStone_Delete:
		move.l #Delete_Current_Sprite,(a0)

Obj_WarningStone_Return:
		rts
; ==================================================================
Obj_NebStone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_NebStone_Index(pc,d0.w),d1
		jsr	Obj_NebStone_Index(pc,d1.w)
		lea	Ani_Nebiroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_NebStone_Index:
		dc.w Obj_NebStone_Main-Obj_NebStone_Index
		dc.w Obj_NebStone_FallNDel-Obj_NebStone_Index
		dc.w Obj_NebStone_Delete-Obj_NebStone_Index
; ---------------------------------------------------------------------------

Obj_NebStone_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Nebiroth,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$8B,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#5,obAnim(a0)

Obj_NebStone_FallNDel:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_49(a1)
		beq.w	+
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	Obj_NebStone_Return
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#2,obSubtype(a0)
		rts

+		addq.b	#2,routine(a0)

Obj_NebStone_Delete:
		move.l #Delete_Current_Sprite,(a0)

Obj_NebStone_Return:
		rts
; ---------------------------------------------------------------------------

Obj_NebWave:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_NebWave_Index(pc,d0.w),d1
		jsr	Obj_NebWave_Index(pc,d1.w)
		lea	Ani_Nebiroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

Obj_NebWave_Index:
		dc.w Obj_NebWave_Main-Obj_NebWave_Index
		dc.w Obj_NebWave_Move-Obj_NebWave_Index

; ---------------------------------------------------------------------------
Obj_NebWave_Main:
		move.l	#Map_Nebiroth,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#7,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#$A,obWidth(a0)
		move.b	#$A,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#$8A,obColType(a0)
		addq.b	#2,routine(a0)

Obj_NebWave_Move:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_49(a1)
		beq.w	+
		jmp	(SpeedToPos).w

+		move.l	#Delete_Current_Sprite,(a0)
		rts

		include "Objects/Bosses/Nebiroth/Object data/Ani - Nebiroth.asm"
		include "Objects/Bosses/Nebiroth/Object data/Map - Nebiroth.asm"
