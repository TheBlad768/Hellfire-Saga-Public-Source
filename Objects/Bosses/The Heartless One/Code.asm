; ---------------------------------------------------------------------------
; Love bullet� used by heartless creature
; ---------------------------------------------------------------------------

Obj_Heartless_Love_Bullet:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$80,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.l	#Obj_Heartless_Love_Bullet_Move,(a0)

Obj_Heartless_Love_Bullet_Move:
		lea	(Ani_HellGirl).l,a1
		jsr	(Animate_Sprite).w
		jsr	(Find_Sonic).w
		move.w	#$200,d0
    		moveq	#$20,d1
        	jsr	(Chase_ObjectYOnly).l
                jsr	(MoveSprite2).w
                jsr     (ChkObjOnScreen).l
                beq.s   +
                move.w  #$3C,obTimer(a0)
                move.l	#Obj_Heartless_Love_Bullet_Delete,(a0)
                rts
+               jsr     (Obj_Produce_AfterImage).l
                jmp	(Draw_And_Touch_Sprite).w

Obj_Heartless_Love_Bullet_Delete:
		lea	(Ani_HellGirl).l,a1
		jsr	(Animate_Sprite).w
                jsr	(MoveSprite2).w
                sub.w   #1,obTimer(a0)
                bpl.s   +
                move.l	#Go_Delete_Sprite,(a0)
+               jmp	(Draw_And_Touch_Sprite).w
; ================================================================================
Obj_Heartless_Love_Bullet_Simple:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$80,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.b	#4,obAnim(a0)
                move.w  #$26,obTimer(a0)
		move.l	#Obj_Heartless_Love_Bullet_Simple_Move,(a0)

Obj_Heartless_Love_Bullet_Simple_Move:
		lea	(Ani_HellGirl).l,a1
		jsr	(Animate_Sprite).w
                jsr	(MoveSprite2).w
           	jsr	ObjHitFloor
                tst.w	d1				; is object above the ground?
                bpl.s   +               		; if yes, branch
                add.w	d1,obY(a0)
                move.l	#Obj_Explosion,(a0)
                rts
+               sub.w   #1,obTimer(a0)
                bmi.s   +
                jsr     (Obj_Produce_AfterImage).l
+               jmp	(Draw_And_Touch_Sprite).w

; ---------------------------------------------------------------------------
; Unnamed and heartless creature encountered in SCZ3
; ---------------------------------------------------------------------------

Obj_Heartless:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Heartless_Index(pc,d0.w),d1
		jsr	Obj_Heartless_Index(pc,d1.w)
		bsr.w	Obj_Heartless_Process
		lea	Ani_Heartless(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Heartless_Display).l
; ===========================================================================
Obj_Heartless_Index:
		dc.w Obj_Heartless_Main-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
                dc.w Timer_StandNormal-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle-Obj_Heartless_Index
                dc.w Timer_NonFire-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
                dc.w Timer_Short-Obj_Heartless_Index
		dc.w Obj_Heartless_TurnOtherSide-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle-Obj_Heartless_Index
                dc.w Timer_Fire-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
		dc.w Obj_Heartless_TurnOtherSide-Obj_Heartless_Index
                dc.w Timer_Short-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle-Obj_Heartless_Index
                dc.w Timer_NonFire-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
                dc.w Obj_Heartless_TurnToSonic-Obj_Heartless_Index
                dc.w Timer_Short-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle-Obj_Heartless_Index
                dc.w Timer_Fire-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
                dc.w Timer_Short-Obj_Heartless_Index
		dc.w Obj_Heartless_TurnOtherSide-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle-Obj_Heartless_Index
                dc.w Timer_NonFire-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
		dc.w Obj_Heartless_TurnOtherSide-Obj_Heartless_Index
                dc.w Timer_StandNormal-Obj_Heartless_Index
                dc.w Obj_Heartless_TurnToSonic-Obj_Heartless_Index
                dc.w Timer_StandNormal-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle2-Obj_Heartless_Index
                dc.w Obj_Heartless_DoubleJump-Obj_Heartless_Index
                dc.w Obj_Heartless_DoubleJump2-Obj_Heartless_Index
                dc.w Obj_Heartless_PrepareToJumpDown-Obj_Heartless_Index
                dc.w Obj_Heartless_JumpDown-Obj_Heartless_Index
                dc.w Obj_Heartless_JumpDown_RipHeart-Obj_Heartless_Index
		dc.w Obj_Heartless_FallDown-Obj_Heartless_Index
                dc.w Timer_StandNormal-Obj_Heartless_Index
		dc.w Obj_Heartless_WaitIdle3-Obj_Heartless_Index
                dc.w Obj_Heartless_SlowFloatUp-Obj_Heartless_Index
                dc.w Obj_Heartless_PrepareToJumpDash-Obj_Heartless_Index
                dc.w Obj_Heartless_JumpDash-Obj_Heartless_Index
; ===========================================================================

Obj_Heartless_Process:
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $33(a0)
		bne.s   .whatizit
		move.b  #$3C,$33(a0)
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$33(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$33(a0)
		bne.s   .lacricium
		bclr    #6,$2A(a0)
		move.b  $25(a0),$28(a0)
                bsr.w   Obj_Heartless_ReturnPal
		bra.s	.lacricium

.gone:
	      	lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		jsr	(Obj_HurtBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)
		addq.b	#2,(Dynamic_resize_routine).w

.lacricium:
		rts

; ===========================================================================

Obj_Heartless_Display:
		move.b	$33(a0),d0
		beq.s	Obj_Heartless_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Heartless_Return

Obj_Heartless_Animate:
		btst   	#6,$2A(a0)
		bne.s  	.animate
                tst.b   $1C(a0)
                beq.s   .setcol
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .palcycle
		addq.w	#8,d0

.palcycle:
                jsr	(BossCerberus_PalFlash).l
                subq.b  #1,$1C(a0)

.setcol:
		moveq	#0,d0
		move.b 	obAnim(a0),d0
		move.b 	Obj_Heartless_Data_Collision(pc,d0.w),d1
		move.b 	d1,obColType(a0)

.animate:
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_Heartless_Data_Collision:
                dc.b    4
                dc.b    4
                dc.b  $88
		dc.b  $86
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b    4
                dc.b  $88
                dc.b  $86
                dc.b    4
                dc.b    4

Obj_Heartless_HP:
		dc.b 8/2	; Easy
		dc.b 8	; Normal
		dc.b 8+2	; Hard
		dc.b 8+2	; Maniac

; ===========================================================================

Obj_Heartless_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Heartless,obMap(a0)
		move.w	#$23D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.b	#4,obColType(a0)
                move.b  #6,obAnim(a0)
                move.w  #$FF,obTimer(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Heartless_HP(pc,d0.w),$29(a0)
		rts

Timer_StandNormal:
                move.w  #$3C,obTimer(a0)
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
		move.w	#$1E,$3A(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
+		addq.b	#2,routine(a0)
                rts

Timer_Short:
                move.w  #8,obTimer(a0)
		addq.b	#2,routine(a0)
                rts

Timer_Fire:
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
                sfx	sfx_Switch,0
+               move.w  #$1E,obTimer(a0)
                move.b  #$1A,$1C(a0)
		addq.b	#2,routine(a0)
                rts

Timer_NonFire:
                move.w  #$FF,obTimer(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_TurnToSonic:
                jsr     (Obj_Eggman_LookOnSonic).l
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_FallDown:
                jsr     (Obj_Heartless_Jump_RipHeart).l
           	jsr	(ObjectFall).w
           	jsr	ObjHitFloor
                tst.w	d1				; is object above the ground?
                bpl.w	Obj_Heartless_Return		; if yes, branch
                add.w	d1,obY(a0)
                move.b #5,obAnim(a0)
                clr.w   obVelX(a0)

                bsr.w   Obj_Heartless_ReturnPal
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_WaitIdle:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                move.b #4,obAnim(a0)
                move.w  #$180,obVelX(a0)
                btst    #0,obStatus(a0)
                bne.s   .setYSpd
                neg.w   obVelX(a0)

.setYSpd:
                move.w  #-$700,obVelY(a0)
                sfx     sfx_Jump
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Heartless_JumpBackward:
        	neg.w  obVelX(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_TurnOtherSide:
        	bchg   #0,obStatus(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_WaitIdle2:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                sfx	sfx_Jump
                move.w  #-$600,obVelY(a0)
                move.b  #4,obAnim(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_DoubleJump:
                jsr     (Obj_Produce_AfterImage).l
        	jsr	(ObjectFall).w
                cmpi.w  #-$80,obVelY(a0)
                blt.w   Obj_Heartless_Return
                move.b  #1,obAnim(a0)
                sfx	sfx_SpikeMove
                move.w  #-$600,obVelY(a0)
		addq.b	#2,routine(a0)

Obj_Heartless_DoubleJump2:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).w
                jsr 	(ChkObjOnScreen).w
                beq.w   Obj_Heartless_Return
                clr.w   obVelX(a0)
                clr.w   obVelY(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Heartless_Return
		move.l	#Obj_Explosion,(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                sub.w   #$10,obY(a0)
                move.w  #$3C,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_Heartless_PrepareToJumpDown:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                move.w  (Camera_x_pos).w,d0
                add.w   #28,d0
                bset    #0,obStatus(a0)
                move.w  (Player_1+obX).w,d1
                sub.w   (Camera_x_pos).w,d1
                cmpi.w  #92,d1
                bgt.s   .advance
                add.w   #$108,d0
                bclr    #0,obStatus(a0)

.advance:
                move.w  d0,obX(a0)
                move.b  #3,obAnim(a0)
                sfx     sfx_Roll
                move.w  #$700,obVelY(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_JumpDown:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).w
                sub.w   #$28,obVelY(a0)
                cmpi.w  #$30,obVelY(a0)
                bgt.w   Obj_Heartless_Return
                move.w  #$1E,obTimer(a0)
                move.b  #$5A,$1C(a0)
                sfx     sfx_Roll
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
+               clr.w   obVelY(a0)
                clr.w   obVelX(a0)
                addq.b  #2,routine(a0)
		jmp     (Swing_Setup1).w

Obj_Heartless_JumpDown_RipHeart:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (Swing_UpAndDown).w
		jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.s   .return
                move.w  #$1E,obTimer(a0)
                cmpi.b  #3,objoff_49(a0)
                beq.s   .finish
                sfx     sfx_HitSpikes
                jsr	(Obj_HurtBloodCreate).l
                jsr	(SingleObjLoad2).w
		bne.w	Obj_Heartless_Return
		move.l	#Obj_Heartless_Love_Bullet,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w  #$480,obVelX(a1)
                btst    #0,obStatus(a0)
                bne.s   .cont
                neg.w   obVelX(a1)

.cont:
                add.b   #1,objoff_49(a0)
                move.b  #9,obAnim(a0)
                rts

.finish:
                clr.b   objoff_49(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Heartless_WaitIdle3:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                move.w  #-$100,obVelY(a0)
                move.w  #$1E,obTimer(a0)
                move.b  #7,obAnim(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_SlowFloatUp:
                jsr     (SpeedToPos).l
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                move.b  #$B,obAnim(a0)
                sfx     sfx_SpinDash
                clr.w   obVelY(a0)
                move.w  #$1E,obTimer(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Heartless_PrepareToJumpDash:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                sfx     sfx_Teleport
                move.w  #$E40,obVelX(a0)
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w obVelX(a0)
+               addq.b	#2,routine(a0)
                rts

Obj_Heartless_JumpDash:
                jsr     (Obj_Produce_AfterImage).l
                jsr	(Obj_Firebrand_ProduceExplosions).l
           	jsr	(ObjectFall).w
           	jsr	ObjHitFloor
                tst.w	d1				; is object above the ground?
                bpl.w	Obj_Heartless_Return		; if yes, branch
                add.w	d1,obY(a0)
                move.b  #5,obAnim(a0)
                bchg    #0,obStatus(a0)
                clr.w   obVelX(a0)
                move.b	#4,routine(a0)

Obj_Heartless_Return:
                rts
; ===========================================================================
Obj_Heartless_Jump_RipHeart:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Heartless_Return
                move.w  #$FF,obTimer(a0)
                sfx     sfx_HitSpikes
                jsr	(Obj_HurtBloodCreate).l
                move.b  #6,obAnim(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Heartless_Return
		move.l	#Obj_Heartless_Love_Bullet_Simple,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
 		asl.w	#2,d0
   		move.w	d0,obVelX(a1)
                move.w 	#$300,obVelY(a1);
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Heartless_Return
		move.l	#Obj_Heartless_Love_Bullet_Simple,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
 		asl.w	#2,d0
   		move.w	d0,obVelX(a1)
                add.w   #$200,obVelX(a1)
                move.w 	#$300,obVelY(a1);
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Heartless_Return
		move.l	#Obj_Heartless_Love_Bullet_Simple,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
 		asl.w	#2,d0
   		move.w	d0,obVelX(a1)
                sub.w   #$200,obVelX(a1)
                move.w 	#$300,obVelY(a1);
                bsr.s   Obj_Heartless_ReturnPal
                rts

Obj_Heartless_ReturnPal:
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_Heartless,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
		move.w	#16-1,$38(a1)

.return:
                rts

; ===========================================================================

		include "Objects/Bosses/The Heartless One/Object data/Ani - Heartless.asm"
		include "Objects/Bosses/The Heartless One/Object data/Map - Heartless.asm"
