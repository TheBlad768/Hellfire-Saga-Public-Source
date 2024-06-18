Obj_Werewolf:
		moveq	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_Werewolf_Index(pc,d0.w),d1
		jsr    	Obj_Werewolf_Index(pc,d1.w)
		bsr.w  	Obj_Werewolf_Process
		lea    	Ani_Werewolf(pc),a1
		jsr   	(AnimateSprite).w
		jmp    	(Obj_Werewolf_Display).l
; ==================================================================
Obj_Werewolf_Index:
		dc.w Obj_Werewolf_Main-Obj_Werewolf_Index
		dc.w Obj_Werewolf_Appear-Obj_Werewolf_Index
		dc.w Obj_Werewolf_Stand-Obj_Werewolf_Index
		dc.w Obj_Werewolf_Walk-Obj_Werewolf_Index
		dc.w Obj_Werewolf_InAir-Obj_Werewolf_Index
		dc.w Obj_Werewolf_LeftRightSide-Obj_Werewolf_Index
		dc.w Obj_Werewolf_CutDown-Obj_Werewolf_Index
; ==================================================================
Obj_Werewolf_Process:
		move.b	#80,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		jsr	(Obj_SmallBloodCreate).l
		move.b	#$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.s	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		rts

.gone:
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.w	#2,(AstarothCompleted).w
		move.b	#1,(Check_Dead).w
		jsr	(Obj_KillBloodCreate).l
		move.l	#Delete_Current_Sprite,(a0)

.lacricium:
		rts
; ==================================================================
Obj_Werewolf_Display:
                btst   #6,$2A(a0)
                bne.s  +
                move.b #0,d0
                move.b obAnim(a0),d0
                move.b Obj_Werewolf_Data_Collision(pc,d0.w),d1
                move.b d1,obColType(a0)
+               move.b	$1C(a0),d0
		beq.s	+
		lsr.b	#3,d0
		bcc.w	++
+		jmp	(Draw_And_Touch_Sprite).w
+		rts

Obj_Werewolf_Data_Collision:
		dc.b	$30
		dc.b	$30
		dc.b	$86
		dc.b	6
		dc.b	6
		dc.b	6
		dc.b	$8C
		dc.b	$30
Obj_Werewolf_HP:
		dc.b 10/2	; Easy
		dc.b 10		; Normal
		dc.b 10+6	; Hard
		dc.b 10+2	; Maniac
; ==================================================================
Obj_Werewolf_Main:
		addq.b 	#2,obRoutine(a0)
		move.l 	#Map_Werewolf,obMap(a0)
		move.w 	#$23E8,obGfx(a0)
		move.b	#$30,obColType(a0)
		move.b 	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Werewolf_HP(pc,d0.w),$29(a0)

		move.b	#7,obAnim(a0)
		move.w	#10,obTimer(a0)
		move.b	#0,objoff_33(a0)

Obj_Werewolf_Appear:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Werewolf_Return
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		cmpi.w	#$570,obY(a0)
		blt.w	Obj_Werewolf_Return
		move.b	#0,obAnim(a0)
		move.w	#0,obVelY(a0)
		move.w	#30,obTimer(a0)
		move.w	#$570,obY(a0)
		addq.b 	#2,obRoutine(a0)

Obj_Werewolf_Stand:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Werewolf_Return
		move.w	#60,obTimer(a0)
		move.b	#1,obAnim(a0)
		addq.b 	#2,obRoutine(a0)

Obj_Werewolf_Walk:
		jsr	(Obj_Werewolf_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$100,d0
		move.w	#$20,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w

		cmpi.w	#30,obTimer(a0)
		bne.s	+
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$30,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
;		move.w	#$1E,$3A(a1)			; Timer before appearance
		move.w	#$84E0,art_tile(a1)			; VRAM
+
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Werewolf_Return
		cmpi.w	#$51A,obY(a0)
		blt.w	Wsetjump
		cmpi.b	#2,objoff_33(a0)
		beq.w	Wsetjump
		jsr	(RandomNumber).w
		andi.w	#1,d0
		beq.w	Wsetjump

Wsetcut:
		add.b	#1,objoff_33(a0)
		move.b	#6,obAnim(a0)
		move.w	#30,obTimer(a0)
		move.w	#$400,obVelX(a0)
		btst	#0,obStatus(a0)
		beq.s	+
		neg.w	obVelX(a0)
+		move.b	#$C,obRoutine(a0)
		sfx	sfx_CutDown
		rts

Wsetjump:
		move.b	#0,objoff_33(a0)
		move.b	#2,obAnim(a0)
		addq.b 	#2,obRoutine(a0)
		samp	sfx_WolfJump
		jsr	(RandomNumber).w
		andi.w	#2,d0
		mulu.w	#2,d0
		lea	(Obj_Werewolf_XVel).l,a1
                move.w (a1,d0.w),obVelX(a0)
		move.w #-$400,obVelY(a0)
		cmpi.w	#$51A,obY(a0)
		bcc.s	+
		add.w	#8,obY(a0)
		move.w  #$600,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
+		btst	#0,obStatus(a0)
		beq.s	+
		neg.w	obVelX(a0)
+  		rts

Obj_Werewolf_InAir:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(Obj_Werewolf_CheckLeftWall).l
		jsr	(Obj_Werewolf_CheckRightWall).l
		jsr	(Obj_Werewolf_CheckCeiling).l
		jsr	(Obj_Werewolf_CheckFloor).l
		jsr	(SpeedToPos).w
		bra.w	Obj_Werewolf_Return

Obj_Werewolf_CheckLeftWall:
		move.w  (Camera_x_pos).w,d0
		add.w   #$B,d0
		move.w  obX(a0),d1
		cmp.w   d0,d1
		bcc.w	Obj_Werewolf_Return
		bset	#0,obStatus(a0)
		jsr	(Obj_Werewolf_Climb).l
		bra.w	Obj_Werewolf_Return

Obj_Werewolf_CheckRightWall:
		move.w  (Camera_x_pos).w,d0
		add.w   #$12B,d0
		move.w  obX(a0),d1
		cmp.w   d0,d1
		blt.w	Obj_Werewolf_Return
		bclr	#0,obStatus(a0)
		jsr	(Obj_Werewolf_Climb).l
		bra.w	Obj_Werewolf_Return

Obj_Werewolf_CheckCeiling:
		move.w 	(Camera_target_max_Y_pos).w,d0
		add.w 	#$1D,d0
		move.w  obY(a0),d1
		cmp.w   d0,d1
		bcc.w	Obj_Werewolf_Return
		move.w	#0,obVelY(a0)
		move.w	#0,obVelX(a0)
		move.b	#4,obAnim(a0)
		move.w	#40,obTimer(a0)
		move.b	#6,obRoutine(a0)
		bra.w	Obj_Werewolf_Return

Obj_Werewolf_CheckFloor:
		cmpi.w	#0,obVelY(a0)
		blt.w	Obj_Werewolf_Return
		move.w 	(Camera_target_max_Y_pos).w,d0
		add.w 	#$C4,d0
		move.w  obY(a0),d1
		cmp.w   d0,d1
		blt.w	Obj_Werewolf_Return
		move.w	d0,obY(a0)
		move.b	#0,obAnim(a0)
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.w	#30,obTimer(a0)
		move.b	#4,obRoutine(a0)
		bra.w	Obj_Werewolf_Return

Obj_Werewolf_LeftRightSide:
		jsr	(SpeedToPos).w
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Werewolf_Return
		move.w  (Camera_x_pos).w,d0
		add.w   #$16,d0
		move.w  obX(a0),d1
		cmp.w   d0,d1
		bcc.w	.subx
		add.w	#8,obX(a0)
		bra.s	.setspeeds

.subx:
		sub.w	#8,obX(a0)

.setspeeds:
		move.w #-$400,obVelY(a0)
		jsr	(RandomNumber).w
		andi.w	#2,d0
		mulu.w	#2,d0
		lea	(Obj_Werewolf_XVel).l,a1
                move.w (a1,d0.w),obVelX(a0)
		neg.w	obVelX(a0)
		btst	#0,obStatus(a0)
		beq.s	+
		neg.w	obVelX(a0)
+		jsr	(RandomNumber).w
		andi.w	#1,d0
		beq.s	+
		neg.w	obVelY(a0)
+		move.b	#8,obRoutine(a0)
		move.b	#2,obAnim(a0)
		samp	sfx_WolfJump
  		rts

Obj_Werewolf_CutDown:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(Obj_Werewolf_CutLeftWall).l
		jsr	(Obj_Werewolf_CutRightWall).l
		jsr	(SpeedToPos).w
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Werewolf_Return
		move.b	#1,obAnim(a0)
		move.w	#0,obVelX(a0)
		move.w	#60,obTimer(a0)
		move.b	#6,obRoutine(a0)
		rts

Obj_Werewolf_Climb:
		move.w	#20,obTimer(a0)
		move.b	#5,obAnim(a0)
		move.w	#0,obVelX(a0)
		move.w	#$A0,obVelY(a0)
		move.w 	(Camera_target_max_Y_pos).w,d0
		add.w 	#$6E,d0
		move.w  obY(a0),d1
		cmp.w   d0,d1
		blt.s	+
		neg.w	obVelY(a0)
		move.b	#3,obAnim(a0)
+		move.b	#$A,obRoutine(a0)
		rts

Obj_Werewolf_CutLeftWall:
		move.w  (Camera_x_pos).w,d0
		add.w   #$B,d0
		move.w  obX(a0),d1
		cmp.w   d0,d1
		bcc.s	+
		add.w	#8,obX(a0)
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
+		rts

Obj_Werewolf_CutRightWall:
		move.w  (Camera_x_pos).w,d0
		add.w   #$12B,d0
		move.w  obX(a0),d1
		cmp.w   d0,d1
		blt.s	+
		sub.w	#8,obX(a0)
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
+		rts


Obj_Werewolf_XVel:
		dc.w	$800
		dc.w	$700
		dc.w	$400
		dc.w	$300
		dc.w	$A00


; ==================================================================

Obj_Werewolf_LookOnSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.s	Obj_Werewolf_Return
		bclr	#0,obStatus(a0)
		tst.w	d0
		bne.s	Obj_Werewolf_Return
		bset	#0,obStatus(a0)

Obj_Werewolf_Return:
		rts

PLC_BossWerewolf: plrlistheader
		plreq $3E8, ArtKosM_Werewolf
PLC_BossWerewolf_End

		include	"Objects/Bosses/Werewolf/Object data/Map - Werewolf.asm"
		include	"Objects/Bosses/Werewolf/Object data/Ani - Werewolf.asm"
		
		include	"Objects/Bosses/Werewolf/Object data/Map - Exclamation.asm"
