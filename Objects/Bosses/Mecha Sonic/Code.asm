; ---------------------------------------------------------------------------
; Mecha Sonic, GMZ mega-boss
; ---------------------------------------------------------------------------

Obj_Mecha_AnimDPLC:
		lea	Ani_MechaSonic(pc),a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_MechaSonic(pc),a2
		jsr	(Perform_DPLC).w
                rts

Obj_Mecha:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Mecha_Index(pc,d0.w),d1
		jsr	Obj_Mecha_Index(pc,d1.w)
                jsr     (Obj_Mecha_AnimDPLC).l
		jmp	(Obj_Mecha_AnimScan).l

; ===========================================================================

Obj_Mecha_Index:
		dc.w Obj_Mecha_Main-Obj_Mecha_Index
		dc.w Obj_Mecha_DropDown-Obj_Mecha_Index
                dc.w Obj_Mecha_Stand-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal-Obj_Mecha_Index
                dc.w Obj_Mecha_DashNormal_ChkBorders-Obj_Mecha_Index

		dc.w Obj_Mecha_Stand-Obj_Mecha_Index
                dc.w Obj_Mecha_PrepareToJump2-Obj_Mecha_Index
                dc.w Obj_Mecha_Jump2Process-Obj_Mecha_Index
                dc.w Obj_Mecha_Jump2Process2-Obj_Mecha_Index
                dc.w Obj_Mecha_Jump2DropDash-Obj_Mecha_Index
                dc.w Obj_Mecha_DashNormal_ChkBorders-Obj_Mecha_Index

		dc.w Obj_Mecha_Stand-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal_ChkOnScreen-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal_Prepare-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal_ChkTimer-Obj_Mecha_Index
		dc.w Obj_Mecha_HoppingDash-Obj_Mecha_Index
                dc.w Obj_Mecha_DashNormal_Prepare-Obj_Mecha_Index
		dc.w Obj_Mecha_DashNormal_ChkTimer-Obj_Mecha_Index
		dc.w Obj_Mecha_HoppingDash_ChkBorders-Obj_Mecha_Index
		dc.w Obj_Mecha_HoppingDash_ChkBorders_Unroll-Obj_Mecha_Index
		dc.w Obj_Mecha_Stand-Obj_Mecha_Index
                dc.w Obj_Mecha_PrepareToJump-Obj_Mecha_Index
                dc.w Obj_Mecha_JumpProcess-Obj_Mecha_Index
                dc.w Obj_Mecha_JumpDash_ChkBorders-Obj_Mecha_Index
                dc.w Obj_Mecha_JumpDash_PrepareToFall-Obj_Mecha_Index
                dc.w Obj_Mecha_JumpDash_Fall-Obj_Mecha_Index
                dc.w Obj_Mecha_Reset-Obj_Mecha_Index
; ===========================================================================

Obj_Mecha_Process:
		tst.b   collision_flags(a0)
		bne.w   Obj_Mecha_Process_Lacricium
		tst.b	collision_property(a0)
		beq.w	Obj_Mecha_Process_Gone
		tst.b   $1C(a0)
		bne.s   +
		move.b  #$40,$1C(a0)
		sfx	sfx_HitBoss
		bset    #6,status(a0)
+		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   Obj_Mecha_Flash
		addi.w	#5*2,d0

Obj_Mecha_Flash:
                bsr.w    Obj_MechaSonic_PalFlash
		subq.b   #1,$1C(a0)
		bne.s    Obj_Mecha_Process_Lacricium
		bclr     #6,status(a0)
		move.b	 collision_restore_flags(a0),collision_flags(a0)

Obj_Mecha_Process_Lacricium:
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		rts

Obj_Mecha_Process_Gone:
		bset    #6,status(a0)
                move.l  #Obj_Mecha_Dying_Fall,(a0)
		samp	sfx_ThunderClamp
                move.w  #$3C,obTimer(a0)
		lea 	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr 	(CreateChild6_Simple).w
		bne.s	+
		st	$40(a1)
                clr.w   obVelX(a0)
		addq.b	#2,(Dynamic_resize_routine).w
+               rts
; ---------------------------------------------------------------------------

MechaSonic_PalRAM:
		dc.w Normal_palette_line_2+8
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1C
MechaSonic_PalCycle:
		dc.w 8, $A24, $624, $422, $20
		dc.w $888, $666, $888, $AAA, $EEE

Obj_MechaSonic_PalFlash:
		lea	MechaSonic_PalRAM(pc),a1
		lea	MechaSonic_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_5).w
; ---------------------------------------------------------------------------

Obj_Mecha_AnimScan:
                bsr.w	Obj_Mecha_Process
		btst   	#6,$2A(a0)
		bne.s  	+
		moveq	#0,d0
		move.b 	obAnim(a0),d0
		move.b 	Obj_Mecha_Data_Collision(pc,d0.w),d1
		move.b 	d1,obColType(a0)
+	        jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------
Obj_Mecha_Data_Collision:
		dc.b  $12
		dc.b  $B
		dc.b  $12
		dc.b  $8C
		dc.b  $B
		dc.b  $12
		dc.b  $12
		dc.b  $12
		dc.b  $12
		dc.b  $B

Obj_Mecha_HP:
		dc.b 8/2	; Easy
		dc.b 8	; Normal
		dc.b 8+2	; Hard
		dc.b 8+2	; Maniac

; ===========================================================================
Obj_Mecha_Main:
		lea	ObjDat4_MechaSonic(pc),a1
		jsr	SetUp_ObjAttributes
                move.b  #4,obAnim(a0)
                moveq   #0,d0
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Mecha_HP(pc,d0.w),$29(a0)

Obj_Mecha_DropDown:
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		move.w	#120,obTimer(a0)
+		addq.b	#2,routine(a0)

Obj_Mecha_Stand:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Return
		move.w	#60,obTimer(a0)
		sfx	sfx_SpinDash
		move.b	#1,obAnim(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_DashNormal:
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Return
		sfx	sfx_Teleport
		move.w	#$800,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		; if not, branch
		neg.w   obVelX(a0)
+		clr.w	obVelY(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_DashNormal_ChkOnScreen:
		jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Return
                jsr     (ChkObjOnScreen).w
                beq.w   Obj_Mecha_Return
                move.w  #12,obTimer(a0)
                jsr     (Obj_Mecha_CreateArrowAim).l
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_DashNormal_Prepare:
		jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Return
                bchg    #0,obStatus(a0)
                neg.w   obVelX(a0)
                move.w  #30,obTimer(a0)
                jsr     (Obj_Mecha_CreateArrowAim).l
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_DashNormal_ChkTimer:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Return
                sfx     sfx_SpinDash
                move.w  #9,obTimer(a0)
                addq.b  #2,routine(a0)
                rts

Obj_Mecha_HoppingDash:
                jsr	(ObjectFall).w
                sub.w   #1,obTimer(a0)
                bpl.s   .action
                jsr     (ChkObjOnScreen).w
                bne.s   .nextphase

.action:
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
		sfx	sfx_Pump
                move.w  #-$200,obVelY(a0)
                bra.s   .return

.nextphase:
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                clr.w   obVelY(a0)
                move.w  #15,obTimer(a0)
                addq.b  #2,routine(a0)

.return:
                rts

Obj_Mecha_HoppingDash_ChkBorders:
                move.w obX(a0),d0
                sub.w (Camera_x_pos).w,d0
		btst	#0,obStatus(a0)
		bne.s	.other
                cmpi.w #$20,d0
                blt.s  .preparetounroll
                bra.s   .falling

.other:
                cmpi.w #$118,d0
                bgt.s  .preparetounroll

.falling:
                jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
		sfx	sfx_Pump
                move.w  #-$200,obVelY(a0)
                rts
                  
.preparetounroll:
                bchg    #0,obStatus(a0)
                clr.w   obVelX(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_HoppingDash_ChkBorders_Unroll:
                jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
		move.b	#4,obAnim(a0)
                move.w  #90,obTimer(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_DashNormal_ChkBorders:
		jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.w   .return
                move.w obX(a0),d0
                sub.w (Camera_x_pos).w,d0
		btst	#0,obStatus(a0)
		bne.s	.other
                cmpi.w #$20,d0
                blt.s  .preparetounroll
                rts

.other:
                cmpi.w #$118,d0
                bgt.s  .preparetounroll
                rts
                  
.preparetounroll:
                bchg    #0,obStatus(a0)
                neg.w   obVelX(a0)
		move.b	#4,obAnim(a0)
                move.w  #90,obTimer(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_PrepareToJump:
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Return
		move.w	#$100,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+		move.w  #-$600,obVelY(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_JumpProcess:
                jsr     (ObjectFall).w
                cmpi.w  #-$80,obVelY(a0)
                blt.w   Obj_Mecha_Return
		move.w	#$600,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+		clr.w   obVelY(a0)
                sfx     sfx_Teleport
		addq.b	#2,routine(a0)

Obj_Mecha_JumpDash_ChkBorders:
		jsr	(SpeedToPos).w
                move.w obX(a0),d0
                sub.w (Camera_x_pos).w,d0
		btst	#0,obStatus(a0)
		bne.s	.other
                cmpi.w #$20,d0
                blt.s  .preparetounroll
                rts

.other:
                cmpi.w #$118,d0
                bgt.s  .preparetounroll
                rts
                  
.preparetounroll:
                move.w  #18,obTimer(a0)
                bchg    #0,obStatus(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_JumpDash_PrepareToFall:
		sub.w	#1,obTimer(a0)
		bpl.s   .return
                clr.w   obVelX(a0)
                move.b  #5,obAnim(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_JumpDash_Fall:
                jsr     (ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                move.b  #4,obAnim(a0)
                move.w  #$3C,obTimer(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_Jump_PrepareToDig:
                jsr     (ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                move.w  #$200,obVelY(a0)
                st  (Screen_Shaking_Flag).w
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_Dig_Process:
                sfx	sfx_SpecialRumble
                jsr     (Obj_Mecha_Produce_Dirt).l
                jsr     (SpeedToPos).w
                move.w  obY(a0),d0
                sub.w   (Camera_min_Y_pos).w,d0
                cmpi.w  #$D8,d0
                blt.w   Obj_Mecha_Return
                clr.w   obVelX(a0)
                clr.w   obVelY(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w   Obj_Mecha_Return
                move.b	#$04,subtype(a1)			; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#-$40,$44(a1)			; Ypos
		move.w	#$1E,$3A(a1)			; Timer
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$83D7,art_tile(a1)			; VRAM
                move.w  #$5A,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Dig_FollowSonic:
                sfx	sfx_SpecialRumble
                jsr     (Obj_Mecha_Produce_Dirt).l
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Find_Sonic).w
		move.w	#$300,d0
		moveq	#$20,d1
		jsr	(Chase_ObjectXOnly).w
                jsr     (SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	.return
                move.w  #-$800,obVelY(a0)
		move.w	(Player_1+obX).w,d0
   		sub.w	obX(a0),d0
   		asl.w	#2,d0
    		move.w	d0,obVelX(a0)
                jsr     (Obj_Eggman_LookOnSonic).l
                sf  (Screen_Shaking_Flag).w
                sfx     sfx_BreakBridge
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_Dig_JumpOut: 
                jsr     (ObjectFall).w
                cmpi.w  #-$80,obVelY(a0)
                blt.s   .return
		add.w	#1,objoff_48(a0)
		cmpi.w	#2,objoff_48(a0)
		beq.s	.nextphase
		addq.b	#2,routine(a0)
                rts

.nextphase:
                clr.w   objoff_48(a0)
                move.b  #5,obAnim(a0)
                clr.w   obVelX(a0)
                clr.w   obVelY(a0)
                move.w  #$78,obTimer(a0)
		addq.b	#4,routine(a0)

.return:
                rts

Obj_Mecha_FallToDig:
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                subq.b  #8,routine(a0)
                rts

Obj_Mecha_JumpOut_Landing:
                jsr     (ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                clr.w   obVelY(a0)
                move.b  #2,obAnim(a0)
		move.w	#$600,obVelX(a0)
                move.w  #$1E,obTimer(a0) 
                move.w  obX(a0),d0
                sub.w   (Camera_x_pos).w,d0
                cmpi.w  #$94,d0
                bcc.s   .other
                bset    #0,obStatus(a0)
                bra.s   .gonext

.other:
                bclr    #0,obStatus(a0)
                
.gonext:
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_Charging:
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Return
                sfx     sfx_Roll
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+               addq.b	#2,routine(a0)
                rts

Obj_Mecha_PrepareToJump2:
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Return
		move.w	(Player_1+obX).w,d0
   		sub.w	obX(a0),d0
   		asl.w	#2,d0
    		move.w	d0,obVelX(a0)
                move.w  #-$700,obVelY(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_Jump2Process:
                jsr     (ObjectFall).w
                cmpi.w  #-$200,obVelY(a0)
                blt.w   Obj_Mecha_Return
                sfx     sfx_Roll
                addq.b	#2,routine(a0)
                rts

Obj_Mecha_Jump2Process2:
                jsr     (ObjectFall).w
                cmpi.w  #-$80,obVelY(a0)
                blt.w   Obj_Mecha_Return
                clr.w   obVelX(a0)
                move.w  #$A00,obVelY(a0)
                sfx     sfx_Teleport
                addq.b	#2,routine(a0)
                rts
                
Obj_Mecha_Jump2DropDash:
                jsr     (SpeedToPos).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
                clr.w   obVelY(a0)       
      		move.w	#$600,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+               sfx     sfx_Pump
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
                move.w	#$14,(Screen_Shaking_Flag).w
		addq.b	#2,routine(a0)
		rts


Obj_Mecha_Reset:
                move.b  #4,routine(a0)
                bra.w   Obj_Mecha_Return

Obj_Mecha_Return:
		rts

Obj_Mecha_CheckXY:	; ������ ��������� 4x4(������ ������� ?x?)
		dc.w -8
		dc.w 16
		dc.w -8
		dc.w 16

; ===========================================================================
Obj_Mecha_Clone_XSpeeds:
                dc.w    $100
                dc.w    -$100
; ===========================================================================
Obj_Mecha_Clone:
		lea	ObjDat4_MechaSonicClone(pc),a1
		jsr	SetUp_ObjAttributes
                move.b  objoff_48(a0),mapping_frame(a0)
                moveq	#0,d0
                move.w  obX(a0),d0
      		moveq	#0,d0
 		move.b	subtype(a0),d0
		move.w	Obj_Mecha_Clone_XSpeeds(pc,d0.w),x_vel(a0)

                move.b  #$B,obAnim(a0)
                move.w  #$3C,obTimer(a0)
                move.l  #Obj_Mecha_Clone_Move,address(a0)

Obj_Mecha_Clone_Move_Preparing:
                jsr     (Obj_Mecha_AnimDPLC).l
                jsr	(Draw_Sprite).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Clone_Return
                cmpi.b  #2,subtype(a0)
                bne.s   +
                st	(Ctrl_1_locked).w
                clr.w	(Ctrl_1_logical).w
                sfx	sfx_Bounce
+               move.w  #$3C,obTimer(a0)
                move.l  #Obj_Mecha_Clone_Move,address(a0)
                rts

Obj_Mecha_Clone_Move:
                sub.w   #1,obTimer(a0)
                bpl.s   ++
                cmpi.b  #2,subtype(a0)
                bne.s   +
		music	mus_MGZ3Boss
		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w
+               move.l	#Go_Delete_Sprite,(a0)
                rts
+               jsr     (SpeedToPos).l
                move.w	v_framecount.w,d0
  		lsr.w	#3,d0
                bcc.s   Obj_Mecha_Clone_Return
                jsr     (Obj_Mecha_AnimDPLC).l
                jmp	(Draw_Sprite).w

Obj_Mecha_Clone_Return:
                rts
; ---------------------------------------------------------------------------
Obj_Mecha_FallDying:
                jsr     (Obj_Mecha_AnimDPLC).l
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.s   .lacricium
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump

		addq.b	#2,(Dynamic_resize_routine).w
		move.l	#Delete_Current_Sprite,address(a0)

.lacricium:
                rts
; ===========================================================================
Obj_Mecha_CreateArrowAim:
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s   .return
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
		move.w	#$A0,$44(a1)			; Ypos
		move.w	#$1E,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM

.return:
                rts

; ===========================================================================
Obj_Mecha_Dying_Fall:
                jsr     (Obj_Mecha_AnimDPLC).l
                jsr	(Draw_Sprite).w
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Clone_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
                move.b  #9,obAnim(a0)
                move.l  #Obj_Mecha_Dying,(a0)

Obj_Mecha_Dying:
                jsr     (Obj_Mecha_AnimDPLC).l
                jsr	(Draw_Sprite).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Clone_Return

                jsr     (SingleObjLoad).w
                bne.w   Obj_Mecha_Return
                move.l  #Obj_Mecha_Clone,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.b  obStatus(a0),obStatus(a1)

                jsr     (SingleObjLoad).w
                bne.w   Obj_Mecha_Return
                move.l  #Obj_Mecha_Clone,(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.b  obStatus(a0),obStatus(a1)
                move.b  #2,subtype(a1)
                st	(Ctrl_1_locked).w
                clr.w	(Ctrl_1_logical).w

                sfx	sfx_Bounce
		move.l	#Delete_Current_Sprite,address(a0)
                rts

; ===========================================================================
Obj_Mecha_Produce_Dirt:
		move.w	v_framecount.w,d0
  		lsr.w	#4,d0
		bcc.w	.return
               	jsr	(SingleObjLoad2).w
		bne.s	.return
		move.l	#Obj_Mecha_Dirt,(a1)
                move.w  #$8370,obGfx(a1)
		move.w	obX(a0),obX(a1)
                move.w  (Camera_target_max_y_pos).w,d0
                add.w   #$B8,d0
		move.w	d0,obY(a1)
		add.w	#$24,obY(a1)
                cmpi.w  #0,obVelX(a0)
                bne.s   .setXSpdIfAny
		jsr	(RandomNumber).w
		andi.w	#$100,d0
		sub.w	d0,obVelX(a1)
		jsr	(RandomNumber).w
		andi.w	#$200,d0
		add.w	d0,obVelX(a1)
                bra.s   .setYSpd

.setXSpdIfAny:
		move.w	obVelX(a0),d1
		neg.w	d1
		move.w	d1,obVelX(a1)

.setYSpd:
                move.w  #-$100,obVelY(a1)
		jsr	(RandomNumber).w
		andi.w	#$300,d0
		sub.w	d0,obVelY(a1)

.return:
                rts

ObjDat4_MechaSonic:
		dc.l Map_MechaSonic		; Mapping
		dc.w $2350			; VRAM
		dc.w $200			; Priority
		dc.b 20/2			; Width	(64/2)
		dc.b 10/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $23			; Collision

DPLCPtr_MechaSonic:	dc.l ArtUnc_MechaSonic>>1, DPLC_MechaSonic

ObjDat4_MechaSonicClone:
		dc.l Map_MechaSonic		; Mapping
		dc.w $2350			; VRAM
		dc.w $200			; Priority
		dc.b 20/2			; Width	(64/2)
		dc.b 10/2			; Height (64/2)
		dc.b $E				; Frame
		dc.b 0        			; Collision


Obj_Mecha_Dirt:
		move.l	#Map_Debris,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.l	#Obj_Mecha_Dirt_Fly,(a0)

Obj_Mecha_Dirt_Fly:
		jsr	(Draw_Sprite).w
		jsr	(ObjectFall).w
                jsr     (ChkObjOnScreen).w
                beq.s   +
		move.l	#Go_Delete_Sprite,(a0)
+		rts
; ===========================================================================
		include "Objects/Bosses/Mecha Sonic/Object data/Ani - Mecha Sonic.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/DPLC - Mecha Sonic.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/Map - Mecha Sonic.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/Map - Spark.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/Map - Debris.asm"
