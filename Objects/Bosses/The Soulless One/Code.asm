; ---------------------------------------------------------------------------
; Unnamed and soulles creature encountered in SCZ3
; ---------------------------------------------------------------------------

Obj_Soulless:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Soulless_Index(pc,d0.w),d1
		jsr	Obj_Soulless_Index(pc,d1.w)
		bsr.w	Obj_Soulless_Process
		lea	Ani_Soulless(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Soulless_Display).l
; ===========================================================================
Obj_Soulless_Index:
		dc.w Obj_Soulless_Main-Obj_Soulless_Index                     ; 0
		dc.w Obj_Soulless_FallDown-Obj_Soulless_Index                 ; 2
		dc.w Obj_Soulless_WaitForSpinDash-Obj_Soulless_Index          ; 4
		dc.w Obj_Soulless_SpinDashSet-Obj_Soulless_Index              ; 6
		dc.w Obj_Soulless_Release-Obj_Soulless_Index                  ; 8
		dc.w Obj_Soulless_Unroll-Obj_Soulless_Index                   ; A
		dc.w Obj_Soulless_WaitForPeelout-Obj_Soulless_Index           ; C
		dc.w Obj_Soulless_PeeloutRelease-Obj_Soulless_Index           ; E
		dc.w Obj_Soulless_PeeloutPrepareToJump-Obj_Soulless_Index     ; 10
		dc.w Obj_Soulless_Fall-Obj_Soulless_Index                     ; 12
		dc.w Obj_Soulless_Fall-Obj_Soulless_Index                     ; 14
		dc.w Obj_Soulless_Fall-Obj_Soulless_Index                     ; 16
		dc.w Obj_Soulless_Fall-Obj_Soulless_Index                     ; 18
		dc.w Obj_Soulless_WaitForSpinDash-Obj_Soulless_Index          ; 1A
		dc.w Obj_Soulless_SpinDashSet-Obj_Soulless_Index              ; 1C
		dc.w Obj_Soulless_Release-Obj_Soulless_Index                  ; 1E
		dc.w Obj_Soulless_Unroll-Obj_Soulless_Index                   ; 20
                dc.w Obj_Soulless_WaitForLevitation-Obj_Soulless_Index        ; 22
                dc.w Obj_Soulless_LevitateUp-Obj_Soulless_Index               ; 24
                dc.w Obj_Soulless_PreparingWhileLevitating-Obj_Soulless_Index ; 26
                dc.w Obj_Soulless_JumpDash-Obj_Soulless_Index                 ; 28
                dc.w Obj_Soulless_JumpDash_MEGARINGO-Obj_Soulless_Index       ; 2A
                dc.w Obj_Soulless_JumpDash_Continue-Obj_Soulless_Index        ; 2C
                dc.w Obj_Soulless_JumpDashWentIntoSpin-Obj_Soulless_Index     ; 2E
                dc.w Obj_Soulless_SpinWentIntoJump-Obj_Soulless_Index         ; 30
                dc.w Obj_Soulless_Release-Obj_Soulless_Index                  ; 32
                dc.w Obj_Soulless_Unroll-Obj_Soulless_Index                   ; 34
		dc.w Obj_Soulless_Reset-Obj_Soulless_Index
; ===========================================================================

Obj_Soulless_Display:
		move.b	$33(a0),d0
		beq.s	Obj_Soulless_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Soulless_Return

Obj_Soulless_Animate:
		btst   	#6,$2A(a0)
		bne.s  	.oncol
                cmpi.b  #$2C,routine(a0)
                beq.s   .offcol
		moveq	#0,d0
		move.b 	obAnim(a0),d0
		move.b 	Obj_Soulless_Data_Collision(pc,d0.w),d1
		move.b 	d1,obColType(a0)

.oncol
		jmp	(Draw_And_Touch_Sprite).w

.offcol:
                move.w  obTimer(a0),d0
                lsr.w   #3,d0
                bcc.w   Obj_Soulless_Return
                jmp	(Draw_Sprite).w
; ===========================================================================
Obj_Soulless_Data_Collision:
                dc.b    4
                dc.b    4
                dc.b    6
                dc.b    6
		dc.b  $8A
		dc.b  $86
                dc.b    4
                dc.b    4
                dc.b    6
                dc.b    6

Obj_Soulless_HP:
		dc.b 8/2	; Easy
		dc.b 8	; Normal
		dc.b 8+2	; Hard
		dc.b 8+2	; Maniac
; ===========================================================================

Obj_Soulless_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Soulless,obMap(a0)
		move.w	#$23D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.b	#2,obColType(a0)
                move.b  #5,obAnim(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Soulless_HP(pc,d0.w),$29(a0)
		rts


; ===========================================================================

Obj_Soulless_Process:
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
Obj_Soulless_SetTimerDependingOnHits:
                cmpi.b  #8,$29(a0)
                blt.s   .dependency
                move.b  #$5A,objoff_48(a0)
                bra.s   .return

.dependency:
                move.b  $29(a0),d0
                lsl.b   #3,d0
                move.b  d0,objoff_48(a0)
                add.b   #$18,objoff_48(a0)

.return:
                rts
; ===========================================================================
Obj_Soulless_Produce_Dust:
               	jsr	(SingleObjLoad2).w
		bne.s	.return
		move.l	#Obj_Dust,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$1F,obY(a1)
		move.w	obVelX(a0),d1
		neg.w	d1
		move.w	d1,obVelX(a1)
		jsr	(RandomNumber).w
		andi.w	#2,d0
		mulu.w	#2,d0
		lea	(Obj_SCZDust_Gfxes).l,a2
                move.w  (a2,d0.w),obGfx(a1)

.return:
                rts
; ===========================================================================
Obj_Soulless_FallDown:
           	jsr	(ObjectFall).w
           	jsr	ObjHitFloor
                tst.w	d1				; is object above the ground?
                bpl.w	Obj_Soulless_Return		; if yes, branch
                add.w	d1,obY(a0)
                move.b #3,obAnim(a0)
                jsr    (Obj_Soulless_SetTimerDependingOnHits).l
		addq.b	#2,routine(a0)

Obj_Soulless_WaitForSpinDash:
                  sub.b #1,objoff_48(a0)
                  bpl.w Obj_Soulless_Return
                clr.w   obVelY(a0)
                  move.b #2,obAnim(a0)
		  sfx	sfx_SpinDash
                  move.b  #$3C,objoff_48(a0)
                  move.w  #$700,obVelX(a0)
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w obVelX(a0)
+		  addq.b #2,routine(a0)
                  rts
		  
Obj_Soulless_SpinDashSet:
                jsr (Obj_Soulless_Produce_Dust).l
                jsr (Obj_Soulless_Produce_Dust).l
                  sub.b #1,objoff_48(a0)
                  bpl.w Obj_Soulless_Return
		  sfx	sfx_Teleport
                  move.b #5,obAnim(a0)
                addq.b #2,routine(a0)
                rts

Obj_Soulless_Release:
                jsr (Obj_Soulless_Produce_Dust).l
                jsr     (Obj_Produce_AfterImage).l
                  jsr (SpeedToPos).w
                  move.w obX(a0),d0
                  sub.w (Camera_x_pos).w,d0
		  btst	#0,obStatus(a0)
		  bne.s	.other
                  cmpi.w #$18,d0
                  blt.s  .preparetounroll
                  rts

.other:
                  cmpi.w #$120,d0
                  bgt.s  .preparetounroll
                  rts
                  
.preparetounroll:
                  bchg #0,obStatus(a0)
                  addq.b #2,routine(a0)

Obj_Soulless_Unroll:
                jsr     (Obj_Produce_AfterImage).l
      		  btst	#0,obStatus(a0)		; is boss facing left?
		  bne.w	.moveleft		; if not, branch

.moveright:
		cmpi.w	#$100,obVelX(a0)
		blt.s	.clrani
		sub.w	#$100,obVelX(a0)
		bra.w	.return

.moveleft:
		cmpi.w	#-$100,obVelX(a0)
		bgt.w	.clrani
		add.w	#$100,obVelX(a0)
		bra.s	.return

.clrani:
                  move.b #3,obAnim(a0)
                  jsr    (Obj_Soulless_SetTimerDependingOnHits).l
                 addq.b #2,routine(a0)

.return:
                  rts

Obj_Soulless_WaitForPeelout:
                  sub.b #1,objoff_48(a0)
                  bpl.w Obj_Soulless_Return
		  move.b #7,obAnim(a0)
		  addq.b #2,routine(a0)
                  rts

Obj_Soulless_PeeloutRelease:
                  jsr (SpeedToPos).w
                jsr     (Obj_Produce_AfterImage).l
		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.moveright		; if not, branch

.moveleft:
		cmpi.w	#-$400,obVelX(a0)
		blt.w	.testborders
		sub.w	#$20,obVelX(a0)
		bra.w	.return

.moveright:
		cmpi.w	#$400,obVelX(a0)
		bgt.s	.testborders
		add.w	#$20,obVelX(a0)
		bra.w	.return


.testborders:       
                  move.w obX(a0),d0
                  sub.w (Camera_x_pos).w,d0
		  btst	#0,obStatus(a0)
		  bne.s	.other
                  cmpi.w #$28,d0
                  blt.s  .preparetounroll
                  rts

.other:
                  cmpi.w #$110,d0
                  bgt.s  .preparetounroll
                  rts
                  
.preparetounroll:
                  bchg #0,obStatus(a0)

                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$F,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
                sfx     sfx_Switch
+               addq.b #2,routine(a0)

.return:
                  rts

Obj_Soulless_PeeloutPrepareToJump:
                jsr     (Obj_Produce_AfterImage).l
                  jsr (SpeedToPos).w
      		  btst	#0,obStatus(a0)		; is boss facing left?
		  bne.w	.moveleft		; if not, branch

.moveright:
		cmpi.w	#$50,obVelX(a0)
		blt.s	.jump
		sub.w	#$50,obVelX(a0)
		bra.w	.return

.moveleft:
		cmpi.w	#-$50,obVelX(a0)
		bgt.w	.jump
		add.w	#$50,obVelX(a0)
		bra.s	.return

.jump:
                  move.b #8,obAnim(a0)
                sfx	sfx_Jump
                  move.w #-$600,obVelY(a0)
                  addq.b #2,routine(a0)

.return:
                  rts

Obj_Soulless_Fall:
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$380,d0
		move.w	#8,d1
		jsr	(Chase_ObjectXOnly).w
                jsr     (Obj_Produce_AfterImage).l
		jsr	(ObjectFall).w
		jsr	ObjHitFloor
		tst.w	d1				; is object above the ground?
		bpl.w	Obj_Soulless_Return
                add.w	d1,obY(a0)
                cmpi.b  #$18,routine(a0)
                beq.s   +
                move.w #-$600,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
                sfx	sfx_Jump
+               addq.b #2,routine(a0)
                rts

Obj_Soulless_WaitForWarning:
                  sub.b #1,objoff_48(a0)
                  bpl.w Obj_Soulless_Return
                sfx     sfx_Switch
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$04,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
+                 move.b #$1E,objoff_48(a0)
                  addq.b #2,routine(a0)
                rts

Obj_Soulless_WaitForLevitation:
                sub.b   #1,objoff_48(a0)
                bpl.w   Obj_Soulless_Return
                move.b  #1,obAnim(a0)
                move.w  #-$700,obVelY(a0)
                clr.w   obVelX(a0)
                sfx     sfx_Switch
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Soulless_Return
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84F0,art_tile(a1)			; VRAM
                addq.b  #2,routine(a0)

.return:
                rts

Obj_Soulless_LevitateUp:
                jsr     (Obj_Produce_AfterImage).l
		jsr	(ObjectFall).w
                cmpi.w  #-$80,obVelY(a0)
                blt.w   Obj_Soulless_Return
                clr.w   obVelY(a0)
                move.b  #8,obAnim(a0)
		sfx	sfx_Spindash
                move.w  #$1E,obTimer(a0)

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Soulless_Return
                move.b	#$12,subtype(a1)		; Jump|Art ID nibble
		move.w	#$38,$42(a1)			; Xpos
		move.w	#$A8,$44(a1)			; Ypos
		move.w	#$2E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)		; VRAM

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Soulless_Return
                move.b	#$12,subtype(a1)		; Jump|Art ID nibble
		move.w	#$98,$42(a1)			; Xpos
		move.w	#$A8,$44(a1)			; Ypos
		move.w	#$2E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)		; VRAM

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Soulless_Return
                move.b	#$12,subtype(a1)		; Jump|Art ID nibble
		move.w	#$F8,$42(a1)			; Xpos
		move.w	#$A8,$44(a1)			; Ypos
		move.w	#$2E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)		; VRAM

                addq.b  #2,routine(a0)
                rts


Obj_Soulless_PreparingWhileLevitating:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Soulless_Return
		sfx	sfx_Teleport
                move.w  #$C00,obVelX(a0)
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w   obVelX(a0)
+               move.w  #$B,obTimer(a0)
                sfx     sfx_Teleport
                addq.b  #2,routine(a0)
                rts

Obj_Soulless_JumpDash:
                jsr     (Obj_Produce_AfterImage).l
		jsr	(ObjectFall).w
                sub.w   #1,obTimer(a0)  
                bpl.w   Obj_Soulless_Return
                clr.b   objoff_49(a0)
                samp	sfx_WalkingArmorAtk
                addq.b #2,routine(a0)
                rts

Obj_Soulless_JumpDash_MEGARINGO:
                cmpi.b  #$10,objoff_49(a0)
                beq.w   .advance
                jsr     (SingleObjLoad2).w
                bne.w   Obj_Soulless_Return
                move.l  #Obj_Soulless_Ring,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.b  objoff_49(a0),objoff_49(a1)
                addq.b	#2,objoff_49(a0)
                move.w  #$1E,obTimer(a0)
                rts


.advance:
                clr.b   objoff_49(a0)
                addq.b #2,routine(a0)

Obj_Soulless_JumpDash_Continue:
                sub.w   #1,obTimer(a0)
                jsr     (Obj_Produce_AfterImage).l
		jsr	(ObjectFall).w
		jsr	ObjHitFloor
		tst.w	d1				; is object above the ground?
		bpl.w	Obj_Soulless_Return
                add.w	d1,obY(a0)
                bchg    #0,obStatus(a0)
                move.b  #5,obAnim(a0)
                clr.w   obVelY(a0)
                move.w  #$600,obVelX(a0)
                sfx     sfx_Roll
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w   obVelX(a0)
+               move.w  #$5A,obTimer(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Soulless_Return
                move.w  (Camera_x_pos).w,d0
                sub.w   obX(a0),d0
                bgt.s   .left
		move.w	#$120,$42(a1)			; Xpos
                move.b	#$13,subtype(a1)			; Jump|Art ID nibble
                bra.s   .cont

.left:
                move.w  #$18,$42(a1)			; Xpos
                move.b	#$15,subtype(a1)			; Jump|Art ID nibble

.cont:
		move.w	#$70,$44(a1)			; Ypos
		move.w	#$5A,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
                addq.b #2,routine(a0)
                rts

Obj_Soulless_JumpDashWentIntoSpin:
                sub.w   #1,obTimer(a0)
                bpl.s   +
                jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).w
                jsr 	(ChkObjOnScreen).w
                beq.s   +
                move.w  #-$600,obVelY(a0)
                sfx     sfx_Jump
                addq.b #2,routine(a0)
+               rts

Obj_Soulless_SpinWentIntoJump:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).w
                jsr     ObjHitFloor
                tst.w   d1
                bpl.w   Obj_Soulless_Return
                add.w   d1,obY(a0)
                clr.w   obVelY(a0)
                addq.b #2,routine(a0)
                rts

Obj_Soulless_WaitForSpinJump:
                  sub.b #1,objoff_48(a0)
                  bpl.w Obj_Soulless_Return
                move.w #-$600,obVelY(a0)
                move.w  #$80,objoff_42(a0)
                  move.b #8,obAnim(a0)
                  move.b  #8,objoff_48(a0)
                  move.w  #$180,obVelX(a0)
                move.w  #$12,obTimer(a0)
                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#$00,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$1E,$44(a1)			; Ypos
		move.w	#$F,$2E(a1)			; Timer
		move.w	#$F,$3A(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
+      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w obVelX(a0)
+		  addq.b #2,routine(a0)
                  rts

Obj_Soulless_FallThrowRing:
                sub.w   #1,obTimer(a0)
                bpl.w   .action
                move.w  #$12,obTimer(a0)
                cmpi.b	#$10,objoff_49(a0)
                bne.s   .throw
                clr.b   objoff_49(a0)

.throw:
                jsr     (SingleObjLoad2).w
                bne.w   .action
                move.l  #Obj_Soulless_Ring,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.b  objoff_49(a0),objoff_49(a1)
                samp	sfx_WalkingArmorAtk
                addq.b	#2,objoff_49(a0)


.action:
                jsr     (Obj_Produce_AfterImage).l
		jsr	(ObjectFall).w
		jsr	ObjHitFloor
		tst.w	d1				; is object above the ground?
		bpl.w	Obj_Soulless_Return
                add.w	d1,obY(a0)
                cmpi.b  #$2A,routine(a0)
                beq.s   .preparetoroll
                move.w #-$700,obVelY(a0)
                move.w  objoff_42(a0),d0
                add.w   d0,obVelY(a0)
                add.w   #$80,objoff_42(a0)
                sfx	sfx_Jump
                move.w  #$100,obVelX(a0)
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.gonext		; if not, branch
		neg.w obVelX(a0)
                bra.s   .gonext

.preparetoroll:
                clr.w   objoff_12(a0)
                sfx	sfx_Roll
                clr.w  obVelY(a0)
                move.w  #$200,obVelX(a0)
      		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.gonext		; if not, branch
		neg.w obVelX(a0)

.gonext:
               addq.b #2,routine(a0)
                rts

Obj_Soulless_Reset:
                 jsr    (Obj_Soulless_SetTimerDependingOnHits).l
                 move.b #3,obAnim(a0)
                 move.b #4,routine(a0)

Obj_Soulless_Return:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Souless's ring, which he throws
; ---------------------------------------------------------------------------
Obj_Soulless_Ring:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Soulless_Ring_Index(pc,d0.w),d1
		jsr	Obj_Soulless_Ring_Index(pc,d1.w)
		lea     (Ani_Soulless).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================

Obj_Soulless_Ring_Index:
		dc.w Obj_Soulless_Ring_Main-Obj_Soulless_Ring_Index
		dc.w Obj_Soulless_Ring_Fall-Obj_Soulless_Ring_Index
; ===========================================================================

Obj_Soulless_Ring_Main:
		move.l	#Map_Soulless,obMap(a0)
		move.w	#$23D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#6,obAnim(a0)
		move.b	#$87,obColType(a0)
                move.b  objoff_49(a0),d0
                lea     (Obj_Soulless_Ring_YSpeeds).l,a1
                move.w  (a1,d0.w),obVelY(a0)
                lea     (Obj_Soulless_Ring_XSpeeds).l,a1
                move.w  (a1,d0.w),obVelX(a0)
		addq.b	#2,routine(a0)

Obj_Soulless_Ring_Fall:
		jsr	(SpeedToPos).w
                jsr 	(ChkObjOnScreen).w
                beq.s  Obj_Soulless_Ring_Return
		move.l #Go_Delete_Sprite,(a0)

Obj_Soulless_Ring_Return:
		rts
; ===========================================================================
Obj_SCZDust_Gfxes:
		dc.w	$2435
		dc.w	$2436
		dc.w	$2437
		dc.w	$2438
		dc.w	$2435
; ===========================================================================
Obj_Soulless_Ring_YSpeeds:
                dc.w    -$500
                dc.w    -$300
                dc.w    0
                dc.w    $300
                dc.w    $500
                dc.w    $300
                dc.w    0
                dc.w    -$300

Obj_Soulless_Ring_XSpeeds:
                dc.w    0
                dc.w    $300
                dc.w    $600
                dc.w    $300
                dc.w    0
                dc.w    -$300
                dc.w    -$600
                dc.w    -$300
; ===========================================================================


		include "Objects/Bosses/The Soulless One/Object data/Ani - Soulless.asm"
		include "Objects/Bosses/The Soulless One/Object data/Map - Soulless.asm"
