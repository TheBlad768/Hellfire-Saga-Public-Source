; ---------------------------------------------------------------------------
; Demon form of Mecha Sonic
; ---------------------------------------------------------------------------

Obj_Mecha_Demon:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Mecha_Demon_Index(pc,d0.w),d1
		jsr	Obj_Mecha_Demon_Index(pc,d1.w)
		lea	Ani_MechaSonic(pc),a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_MechaSonic(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Mecha_Demon_Display).l
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Index:
		dc.w Obj_Mecha_Demon_Main-Obj_Mecha_Demon_Index
		dc.w Obj_Mecha_Demon_Transformation-Obj_Mecha_Demon_Index ; 0
		dc.w Obj_Mecha_Demon_Dialogue-Obj_Mecha_Demon_Index	      ; 2
		dc.w Obj_Mecha_Demon_FlyUp-Obj_Mecha_Demon_Index		; 4

                dc.w Obj_Mecha_Demon_FlySideways-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_PrepareToDropAttack-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_DropAttack_RaisePowers-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_DropAttack_Action-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_Unfold-Obj_Mecha_Demon_Index

                dc.w Obj_Mecha_Demon_FlySideways-Obj_Mecha_Demon_Index

		dc.w Obj_Mecha_Demon_DropDown-Obj_Mecha_Demon_Index	; 14
		dc.w Obj_Mecha_Demon_SpinCharge-Obj_Mecha_Demon_Index ; 16
		dc.w Obj_Mecha_Demon_SpinRelease-Obj_Mecha_Demon_Index		; 18
		dc.w Obj_Mecha_Demon_PrepareToCast-Obj_Mecha_Demon_Index	;1A
		dc.w Obj_Mecha_Demon_Cast-Obj_Mecha_Demon_Index	;1C

                dc.w Obj_Mecha_Demon_Arc_Attack_Prepare-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_Arc_Attack_JumpOut-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_Arc_Attack_Prepare2-Obj_Mecha_Demon_Index
                dc.w Obj_Mecha_Demon_Arc_Attack_Action-Obj_Mecha_Demon_Index
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Process:
		tst.b   collision_flags(a0)
		bne.w   Obj_Mecha_Demon_Lacricium
		tst.b	collision_property(a0)
		beq.w	Obj_Mecha_Demon_Process_Gone
		tst.b	$1C(a0)
		bne.s	+
		move.b	#$40,$1C(a0)
		sfx	sfx_HitBoss
		bset	#6,status(a0)
+		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	Obj_Mecha_Demon_Flash
		addi.w	#5*2,d0

Obj_Mecha_Demon_Flash:
                bsr.w Obj_MechaSonicDemon_PalFlash
		subq.b	#1,$1C(a0)
		bne.s	Obj_Mecha_Demon_Lacricium
		bclr     #6,status(a0)
		move.b	 collision_restore_flags(a0),collision_flags(a0)

Obj_Mecha_Demon_Lacricium:
        	st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		rts

Obj_Mecha_Demon_Process_Gone:
                clr.w   obVelX(a0)
		move.w	#$3F,$2E(a0)
		bset    #6,status(a0)
		move.l	#Obj_Mecha_Demon_Dead_Fire,address(a0)
                rts
; ---------------------------------------------------------------------------

MechaSonicDemon_PalRAM:
		dc.w Normal_palette_line_2+8
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16
		dc.w Normal_palette_line_2+$18
		dc.w Normal_palette_line_2+$1C
MechaSonicDemon_PalCycle:
		dc.w 8, $42A, $426, $224, $20
		dc.w $888, $666, $888, $AAA, $EEE

Obj_MechaSonicDemon_PalFlash:
		lea	MechaSonicDemon_PalRAM(pc),a1
		lea	MechaSonicDemon_PalCycle(pc,d0.w),a2
		jmp	(CopyWordData_5).w
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Display:
                bsr.w   Obj_Mecha_Demon_Process
		btst   #6,$2A(a0)
		bne.s  +
		moveq  #0,d0
		move.b obAnim(a0),d0
		move.b Obj_Mecha_Demon_Data_Collision(pc,d0.w),d1
		move.b d1,obColType(a0)
+	        jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Data_Collision:
		dc.b  $12 ;0
		dc.b  $B  ;1
		dc.b  $12 ;2
		dc.b  $8C ;3
		dc.b  $B  ;4
		dc.b  $12 ;5
		dc.b  $12 ;6
		dc.b  $12 ;7
		dc.b  $12 ;8
		dc.b  0   ;9
		dc.b  0   ;A
		dc.b  0   ;B
		dc.b  $12 ;C
		dc.b  $86 ;D
		dc.b  $86 ;E
		dc.b  0   ;B
; ---------------------------------------------------------------------------

Obj_MechaDemon_HP:
		dc.b 6/2	; Easy
		dc.b 6	; Normal
		dc.b 6+2	; Hard
		dc.b 6+2	; Maniac


Obj_Mecha_Demon_Main:
		lea	ObjDat4_MechaSonic(pc),a1
		jsr	SetUp_ObjAttributes
		move.w	#180,obTimer(a0)
		move.b	#8,obAnim(a0)
                move.w	#4,objoff_46(a0)
		st  (Screen_Shaking_Flag).w
		move.w	(Difficulty_Flag).w,d0

		lea	(Player_1).w,a1
                move.b	#$81,object_control(a1)
                move.w  obX(a0),d0
                sub.w   x_pos(a1),d0
                bcc.s   .other
                bset    #0,status(a1)
                bra.s   .anim

.other:
                bclr    #0,status(a1)

.anim:
		move.w	#id_LookUp<<8,anim(a1)
                moveq   #0,d0
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_MechaDemon_HP(pc,d0.w),$29(a0)
                move.b  art_tile(a0),objoff_49(a0)
                rts


Obj_Mecha_Demon_Transformation:
                btst #0,(Level_frame_counter+1).w
		beq.s +
		eori.b #$20,art_tile(a0)
+		jsr	(Obj_Mecha_Demon_Transformation_Process).l
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Demon_Return

                move.b  objoff_49(a0),art_tile(a0)
                clr.b   objoff_49(a0)
                lea	(Player_1).w,a1
                clr.b	object_control(a1)
                sf	(Ctrl_1_locked).w

		sf  (Screen_Shaking_Flag).w
		move.b #$4,(Hyper_Sonic_flash_timer).w
                move.b  #$3C,objoff_47(a0)
		samp	sfx_ThunderClamp
                move.b  #$C,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_Dialogue:
;		btst #0,(Level_frame_counter+1).w
;		beq.s +
;		eori.b #$40,art_tile(a0)
;+		jsr	(Obj_Mecha_Demon_Transformation_Process).l
;		subq.w	#1,obTimer(a0)
;		bpl.w	Obj_Mecha_Demon_Dialogue_RTS
;		sf  (Screen_Shaking_Flag).w
;		move.w	#$23D0,obGfx(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_Dialogue_RTS:
		rts

Obj_Mecha_Demon_FlyUp:
		samp	sfx_ThunderClamp
		move.w	(Camera_x_pos).w,d0
		add.w	#$A0,d0
		move.w	d0,obX(a0)
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$40,d0
		move.w	d0,obY(a0)
		move.w	#30,objoff_46(a0)
                move.w  #$3C,obTimer(a0)
		move.b	#$C,obAnim(a0)

		lea	ChildObjDat_MechaSonic_Spark(pc),a2
		jsr	(CreateChild1_Normal).w

		move.w #$14,(Screen_Shaking_Flag).w
		move.b #$4,(Hyper_Sonic_flash_timer).w
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_PrepareToDropAttack:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Demon_Return
                move.b  #$D,obAnim(a0)
                sfx     sfx_SpinDash
                move.w  #$1E,obTimer(a0)

		addq.b	#2,routine(a0)

Obj_Mecha_Demon_DropAttack_RaisePowers:
		jsr	(Obj_Eggman_LookOnSonic).l
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Demon_Return
                sfx     sfx_Teleport

     		move.w	(Camera_target_max_y_pos).w,d0
                add.w   #$D8,d0
       		sub.w	obY(a0),d0
          	asl.w	#3,d0
		move.w	d0,obVelY(a0)

     		move.w	(Player_1+obX).w,d0
       		sub.w	obX(a0),d0
          	asl.w	#2,d0
		move.w	d0,obVelX(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_DropAttack_Action:
                jsr     (ObjectFall).l
                cmpi.w  #-$200,obVelY(a0)
                blt.s   .return
		cmpi.w	#4,objoff_48(a0)
		beq.s	.nextphase

                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Clone_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)

		lea	ChildObjDat_MechaSonic_Spark(pc),a2
		jsr	(CreateChild1_Normal).w

		sfx	sfx_Pump
		add.w	#1,objoff_48(a0)

		jsr	(Obj_Eggman_LookOnSonic).l
                move.w  (Player_1+obX).w,d0
                sub.w   obX(a0),d0
                asl.w   #2,d0
                move.w  d0,obVelX(a0)
                move.w  #-$700,obVelY(a0)

.return:
                rts

.nextphase:
                move.b  #$E,obAnim(a0)
                clr.w   obVelY(a0)
                move.w  #$5A,obTimer(a0)
		clr.w	objoff_48(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_Unfold:
                jsr     (SpeedToPos).l
                cmpi.b  #$C,obAnim(a0)
                bne.w   Obj_Mecha_Demon_Return
                move.b  #$2A,objoff_47(a0)
                samp    sfx_Fire_Shield
		addq.b	#2,routine(a0)


Obj_Mecha_Demon_FlySideways:
                jsr     (Obj_Mecha_Demon_FlySound).l
                sub.w   #1,obTimer(a0)
                bmi.s   .gonext
                btst	#0,obStatus(a0)		; is boss facing left?
                bne.w   Obj_Mecha_Demon_MoveRight
                bsr.w   Obj_Mecha_Demon_MoveLeft
                bra.s   .return

.gonext;
		move.b	#$D,obAnim(a0)
                clr.w   obVelX(a0)
		addq.b	#2,routine(a0)

.return:
                rts

Obj_Mecha_Demon_MoveLeft:
                jsr     (SpeedToPos).w
                cmpi.w  #-$200,obVelX(a0)
                bgt.s   +
                move.b  #6,obAnim(a0)
+		cmpi.w	#-$400,obVelX(a0)
		blt.s	+
		sub.w	#$40,obVelX(a0)
+               move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$18,d0
		bcc.w	Obj_Mecha_Demon_Return
		bchg	#0,obStatus(a0)
                move.b  #$C,obAnim(a0)
                move.w  #-$200,obVelX(a0)
                rts

Obj_Mecha_Demon_MoveRight:
                jsr     (SpeedToPos).w
                cmpi.w  #$200,obVelX(a0)
                blt.s   +
                move.b  #6,obAnim(a0)
+		cmpi.w	#$400,obVelX(a0)
		bgt.s	+
		add.w	#$40,obVelX(a0)
+               move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$120,d0
		blt.w	Obj_Mecha_Demon_Return
		bchg	#0,obStatus(a0)
                move.b  #$C,obAnim(a0)
                move.w  #$200,obVelX(a0)
                rts

Obj_Mecha_Demon_DropDown:
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Clone_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		clr.w	obVelY(a0)

		jsr	(Obj_Eggman_LookOnSonic).l
		lea	ChildObjDat_MechaSonic_Spark(pc),a2
		jsr	(CreateChild1_Normal).w

		move.w #$14,(Screen_Shaking_Flag).w
		sfx	sfx_Pump
		move.w	#75,obTimer(a0)
		clr.w	objoff_48(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_SpinCharge:
		btst	#1,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_MechaSonic_Spark2(pc),a2
		jsr	(CreateChild1_Normal).w
+
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Demon_Return
		sfx	sfx_Boom
		move.w	#$A00,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		addq.b	#2,routine(a0)

Obj_Mecha_Demon_SpinRelease:
		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
                btst    #0,obStatus(a0)
                bne.s   .right
		cmpi.w	#$22,d0
		blt.s	.charge
                bra.s   .return

.right:
		cmpi.w	#$118,d0
		bcc.s	.charge

.return:
		rts


.charge:
		add.w	#1,objoff_48(a0)
		cmpi.w	#3,objoff_48(a0)
		beq.s	+
		bchg	#0,obStatus(a0)
		move.w	#45,obTimer(a0)
		sfx	sfx_SpinDash
		subq.b	#2,routine(a0)
		rts
+
		bchg	#0,obStatus(a0)
		move.b	#7,obAnim(a0)
		move.w	#35,obTimer(a0)

		clr.w	obVelX(a0)
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_PrepareToCast:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Demon_Return
		move.w	#340,obTimer(a0)
		sfx	sfx_FireShield
		lea	ChildObjDat_MechaSonicCastExplosion_Create(pc),a2
		jsr	(CreateChild1_Normal).w
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Mecha_BurningSkull,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		subi.w	#$2B,obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	a0,parent(a1)
+		addq.b	#2,routine(a0)

Obj_Mecha_Demon_Cast:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Demon_Return
		clr.w	objoff_48(a0)
		move.b	#1,obAnim(a0)
                sfx     sfx_SpinDash
		addq.b	#2,routine(a0)

Obj_Mecha_Demon_Arc_Attack_Prepare:
		cmpi.b	#3,obAnim(a0)
                bne.w   Obj_Mecha_Demon_Return	
                bchg    #0,obStatus(a0)
                move.w  #-$600,obVelY(a0)
        	move.w	#$400,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+		addq.b	#2,routine(a0)
                rts

Obj_Mecha_Demon_Arc_Attack_JumpOut:
                jsr     (ObjectFall).l
                cmpi.w  #-$80,obVelY(a0)
                blt.w   Obj_Mecha_Demon_Return
                clr.w   obVelY(a0)

                clr.w   obVelX(a0)
                bchg    #0,obStatus(a0)
                sfx     sfx_SpinDash
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$70,d0
		move.w	d0,obY(a0)
                move.w  #$3C,obTimer(a0)
                jsr     (Obj_Mecha_CreateArrowAim).l
		addq.b	#2,routine(a0)
                rts

Obj_Mecha_Demon_Arc_Attack_Prepare2:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Demon_Return
		sfx	sfx_Teleport
                move.w  #$400,obVelY(a0)
        	move.w	#$800,obVelX(a0)
     		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+		        ; if not, branch
		neg.w   obVelX(a0)
+               addq.b	#2,routine(a0)
                rts

Obj_Mecha_Demon_Arc_Attack_Action:
                jsr     (SpeedToPos).l
                sub.w   #$20,obVelY(a0)
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$60,d0
		move.w	obY(a0),d1
                cmp.w   d0,d1
                bcc.w   Obj_Mecha_Demon_Return
                clr.w   obVelY(a0)
                clr.w   obVelX(a0)
		move.w	(Camera_x_pos).w,d0
                sub.w   #$10,d0
     		btst	#0,obStatus(a0)		; is boss facing left?
		beq.w	+		        ; if not, branch
                add.w   #$158,d0
+		move.w	d0,obX(a0)
                bchg    #0,obStatus(a0)
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$40,d0
		move.w	d0,obY(a0)
                move.w  #$78,obTimer(a0)
                move.b  #$2A,objoff_47(a0)
                samp    sfx_Fire_Shield
                move.b	#8,routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Dead_Fire:
		bsr.w	MechaDemon_CreateFire
		subq.w	#1,$2E(a0)
		bpl.w	Obj_Mecha_Demon_Dead_Draw
                move.b  #9,obAnim(a0)
		move.l	#Obj_Mecha_Demon_Dead_Fall,address(a0)

Obj_Mecha_Demon_Dead_Fall:
		bsr.w	MechaDemon_CreateFire
		jsr	(MoveSprite).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Demon_Dead_Dislay
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
		sfx	sfx_Pump
		move.w	#$3F,$2E(a0)
		st	(Screen_Shaking_Flag).w
		move.l	#Obj_Mecha_Demon_Dead_Defeated_Fire,address(a0)

Obj_Mecha_Demon_Dead_Defeated_Fire:
		bsr.w	MechaDemon_CreateFire
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Mecha_Demon_Dead_Dislay
		lea	ChildObjDat_MechaDemon_FlickerMove(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	#$2A,$2E(a0)
		move.l	#Obj_Mecha_Demon_Dead_Defeated_Prepare_For_Shaft,address(a0)

Obj_Mecha_Demon_Dead_Defeated_Prepare_For_Shaft:
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Mecha_Demon_Return
		move.l	#Delete_Current_Sprite,address(a0)
		sf	(Screen_Shaking_Flag).w
		addq.b	#2,(Dynamic_resize_routine).w
                rts

Obj_Mecha_Demon_Dead_Dislay:
		lea	Ani_MechaSonic(pc),a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_MechaSonic(pc),a2
		jsr	(Perform_DPLC).w

Obj_Mecha_Demon_Dead_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_ExploseRush:
		subq.w	#1,objoff_46(a0)
		bpl.s	Obj_Mecha_Demon_ExploseRushRTS
		jsr	(RandomNumber).w
		andi.w	#30,d0
		move.w	#60,d1 ; Copy camera Xpos into d0
		add.w	d1,d0
		move.w	d0,objoff_46(a0) ; Set Xpos

Obj_Mecha_Demon_Return:
Obj_Mecha_Demon_ExploseRushRTS:
		rts
; ---------------------------------------------------------------------------

Obj_Mecha_CheckBorders:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		bchg	#0,obStatus(a0)
		clr.w	x_vel(a0)
+		addi.w	#$F8,d0
		cmp.w	x_pos(a0),d0
		bgt.s	+
		bchg	#0,obStatus(a0)
		clr.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_Mecha_CheckBorders_NegatiateSpeed:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$20,d0
		cmp.w	x_pos(a0),d0
		blt.s		+
		bchg	#0,obStatus(a0)
		neg.w	x_vel(a0)
+		addi.w	#$F8,d0
		cmp.w	x_pos(a0),d0
		bgt.s	+
		bchg	#0,obStatus(a0)
		neg.w	x_vel(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_Mecha_Demon_Transformation_Process:
		subq.w	#1,objoff_46(a0)
		bpl.s	Obj_Mecha_Demon_TrPrRTS
		move.w	#4,objoff_46(a0)
		sfx	sfx_Electro
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Mecha_Demon_TrPrRTS
		move.l	#Obj4B_Spark,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

Obj_Mecha_Demon_TrPrRTS:
		rts

; =============== S U B R O U T I N E =======================================

MechaDemon_CreateFire:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge
+		btst	#1,(Level_frame_counter+1).w
		beq.s	+
		lea	(ChildObjDat_BossCerberus_Fire).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		rts
; ---------------------------------------------------------------------------
; Pieces
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MechaDemon_FlickerMove:
		move.b	#32,child_dx(a0)
		move.b	#8,child_dy(a0)
		lea	ObjDat3_MechaDemon_FlickerMove(pc),a1
		jsr	(SetUp_ObjAttributes).w
		jsr	(Refresh_ChildPositionAdjusted).l
		move.l	#Obj_FlickerMove,address(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		lea	MechaDemon_FlickerMove_Data(pc,d0.w),a1
		move.b	(a1)+,d1
		ext.w	d1
		movea.w	parent3(a0),a2
		btst	#0,render_flags(a2)
		beq.s	MechaDemon_FlickerMove_Set
		neg.w	d1
		bset	#0,render_flags(a0)

MechaDemon_FlickerMove_Set:
		add.w	d1,x_pos(a0)
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,y_pos(a0)
		asl.w	#5,d1
		move.w	d1,x_vel(a0)
		asl.w	#4,d2
		move.w	d2,y_vel(a0)
		lsr.w	#1,d0
		move.b	d0,mapping_frame(a0)
		rts
; ---------------------------------------------------------------------------

MechaDemon_FlickerMove_Data:
		dc.b $F0, $F5
		dc.b $F0, 5
		dc.b $F8, $F5
		dc.b $F8, 5
		dc.b 0, $F5
		dc.b 0, 5
		dc.b 8, $F5
		dc.b 8, 5
		dc.b $F0, $15
		dc.b $F8, $15
		dc.b 0, $15
		dc.b 8, $15
		dc.b $10, 5
		dc.b $10, $15
		dc.b $10, $FD
		dc.b $E8, $1D
; ---------------------------------------------------------------------------

ObjDat3_MechaDemon_FlickerMove:
		dc.l Map_MechaSonicPieces
		dc.w $A350
		dc.w 0
		dc.b 64/2
		dc.b 16/2
		dc.b 0
		dc.b 0
ChildObjDat_MechaDemon_FlickerMove:
		dc.w 16-1
		dc.l Obj_MechaDemon_FlickerMove
; ---------------------------------------------------------------------------
; Sparks
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_MechaSonic_Spark2:
		lea	ObjDat3_MechaSonic_Spark(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$300,priority(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		addq.w	#7,d0
		move.w	d0,$2E(a0)
		movea.w	parent3(a0),a1
		move.w	#$400,d0
		btst	#0,status(a1)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#MechaSonic_Spark_Draw,address(a0)
		bra.s	MechaSonic_Spark_Draw

; =============== S U B R O U T I N E =======================================

Obj_MechaSonic_Spark:
		lea	ObjDat3_MechaSonic_Spark(pc),a1
		jsr	(SetUp_ObjAttributes).w
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,d1
		addq.w	#7,d0
		move.w	d0,$2E(a0)
		movea.w	parent3(a0),a1
		move.w	x_vel(a1),d0
		asl.w	#2,d0
		asl.w	#6,d1
		add.w	d1,d0
		neg.w	d0
		move.w	d0,x_vel(a0)
		jsr	(Random_Number).w
		andi.w	#$3FF,d0
		addi.w	#$100,d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.l	#Go_Delete_Sprite,$34(a0)
		move.l	#MechaSonic_Spark_Draw,address(a0)

MechaSonic_Spark_Draw:
		jsr	(MoveSprite2).w
		jsr	(Obj_Wait).w
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

ObjDat3_MechaSonic_Spark:
		dc.l Map_Spark2
		dc.w $84FC
		dc.w $80
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b 0
ChildObjDat_MechaSonic_Spark:
		dc.w 4-1
		dc.l Obj_MechaSonic_Spark
		dc.b 0, 40
		dc.l Obj_MechaSonic_Spark
		dc.b 0, 40
		dc.l Obj_MechaSonic_Spark
		dc.b 0, 40
		dc.l Obj_MechaSonic_Spark
		dc.b 0, 40
ChildObjDat_MechaSonic_Spark2:
		dc.w 1-1
		dc.l Obj_MechaSonic_Spark2
		dc.b 0, 40

; =============== S U B R O U T I N E =======================================

Obj_MechaSonicCastExplosion_Create:
		move.l	#Map_Offscreen,mappings(a0)
		move.b	#4,render_flags(a0)
		move.l	#Obj_MechaSonicCastExplosion_Create_Main,address(a0)

Obj_MechaSonicCastExplosion_Create_Main:
		move.w	parent3(a0),a1
		tst.w	objoff_48(a1)
		beq.w	MechaSonicCastExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.s	Obj_MechaSonicCastExplosion_Create_Return
		move.w	#7,$2E(a0)
		lea	ChildObjDat_MechaSonicCastExplosion(pc),a2
		jsr	(CreateChild6_Simple).w

Obj_MechaSonicCastExplosion_Create_Return:
		jmp	(Child_CheckParent).w

; =============== S U B R O U T I N E =======================================

Obj_MechaSonicCastExplosion:
		moveq	#0,d2
		move.w	#3-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_MechaSonicCastExplosion_SetMove,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$59C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$380,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	#7,anim_frame_timer(a1)
		dbf	d1,-
+		bra.w	MechaSonicCastExplosion_Delete
; ---------------------------------------------------------------------------

SetMove_Data:
		dc.b 8
		dc.b -8
		dc.b 4
		dc.b -4
SetMove_Data2:
		dc.w -$200
		dc.w -$280
		dc.w -$400
		dc.w -$480
SetMove_Data3:
		dc.b 0
		dc.b 1
		dc.b 2
		dc.b 3
; ---------------------------------------------------------------------------

Obj_MechaSonicCastExplosion_SetMove:
		jsr	(Random_Number).w
		andi.w	#4-1,d0
		move.b	SetMove_Data(pc,d0.w),$40(a0)
		jsr	(Random_Number).w
		andi.w	#4-1,d0
		move.b	SetMove_Data3(pc,d0.w),$41(a0)
		jsr	(Random_Number).w
		andi.w	#7-1,d0
		move.w	SetMove_Data2(pc,d0.w),y_vel(a0)
		move.l	#Obj_MechaSonicCastExplosion_Anim,address(a0)

Obj_MechaSonicCastExplosion_Anim:
		moveq	#0,d0
		move.b	angle(a0),d0
		add.b	$40(a0),d0
		move.b	d0,angle(a0)
		jsr	(GetSineCosine).w
		moveq	#0,d1
		move.b	$41(a0),d1
		asr.w	d1,d0
		move.w	d0,x_vel(a0)
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	MechaSonicCastExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

MechaSonicCastExplosion_Delete:
		move.l	#Delete_Current_Sprite,address(a0)
		rts
; ---------------------------------------------------------------------------
Obj_Mecha_Produce_Debris:
                sub.w   #1,$42(a0)
                bpl.s   .return
                move.w  #$2A,$42(a0)
                jsr     (SingleObjLoad2).w
                bne.s    .return
                move.l  #Obj_Mecha_Debris,(a1)
                move.w  a0,parent3(a1)
                move.w  (Camera_x_pos).w,obX(a1)
                jsr     (RandomNumber).w
                andi.w   #$F8,d0
                addi.w   #$20,d0
                addi.w   d0,obX(a1)
                move.w  (Camera_target_max_y_pos).w,obY(a1)
                sub.w   #$1E,obY(a1)
.return:
                rts

; ===========================================================================

Obj_Mecha_Debris:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Mecha_Debris_Index(pc,d0.w),d1
		jsr	Obj_Mecha_Debris_Index(pc,d1.w)
		jmp	(Obj_Mecha_Debris_Display).l

Obj_Mecha_Debris_Index:
		dc.w Obj_Mecha_Debris_Main-Obj_Mecha_Debris_Index
		dc.w Obj_Mecha_Debris_Wait-Obj_Mecha_Debris_Index
		dc.w Obj_Mecha_Debris_Fall-Obj_Mecha_Debris_Index
		dc.w Obj_Mecha_Debris_Fall2-Obj_Mecha_Debris_Index

Obj_Mecha_Debris_Display:
                cmpi.b  #6,routine(a0)
                bne.s   .display
		move.w	v_framecount.w,d0
  		lsr.w	#3,d0
		bcc.w	Obj_Mecha_Debris_Return

.display:
		jmp	(Child_DrawTouch_Sprite).w

Obj_Mecha_Debris_Main:
		move.w	#$370,obGfx(a0)
		move.l	#Map_Debris,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#8,y_radius(a0)

                moveq   #0,d0
                jsr     (RandomNumber).w
                andi.b  #3,d0
                cmpi.b  #0,d0
                bne.s   +
                add.b   #1,d0
+               move.b  d0,mapping_frame(a0)
                move.b  #$84,obColType(a0)
                move.w  #$3C,obTimer(a0)

                lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w   Obj_Mecha_Return
		move.b	#$02,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#$30,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
		addq.b	#2,routine(a0)

Obj_Mecha_Debris_Wait:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Mecha_Debris_Return
		addq.b #2,routine(a0)

Obj_Mecha_Debris_Fall:
                jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A7,d0
                blt.w   Obj_Mecha_Clone_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A7,d0
                move.w` d0,obY(a0)
                sfx     sfx_Pump
                clr.b   obColType(a0)
                move.w  #-$200,obVelY(a0)
		addq.b #2,routine(a0)

Obj_Mecha_Debris_Fall2:
                jsr	(ObjectFall).w
                jsr     (ChkObjOnScreen).w
                beq.s   Obj_Mecha_Debris_Return
		move.l	#Go_Delete_Sprite,(a0)

Obj_Mecha_Debris_Return:
                rts

Obj_Mecha_Demon_FlySound:
                sub.b   #1,objoff_47(a0)
                bpl.s   .return
                move.b  #$2A,objoff_47(a0)
                samp	sfx_MechaDemon

.return:
                rts

Obj_Mecha_Debris_Collisions:
                dc.b 0
                dc.b $84
                dc.b $8B
                dc.b $33|$80

ChildObjDat_MechaSonicCastExplosion_Create:
		dc.w 1-1
		dc.l Obj_MechaSonicCastExplosion_Create
		dc.b 0, -24
ChildObjDat_MechaSonicCastExplosion:
		dc.w 1-1
		dc.l Obj_MechaSonicCastExplosion
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Mecha Sonic/Object data/Map - Mecha Demon.asm"
                include "Objects/Bosses/Mecha Sonic/Object data/Ani - Mecha Demon.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/Map - Spark2.asm"
		include "Objects/Bosses/Mecha Sonic/Object data/Map - Mecha Sonic Pieces.asm"
