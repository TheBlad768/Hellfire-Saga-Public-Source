Obj_DPShaft:
		moveq	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_DPShaft_Index(pc,d0.w),d1
		jsr    	Obj_DPShaft_Index(pc,d1.w)
		jsr  	(Obj_DPShaft_Process).l
		lea    	Ani_DPShaft(pc),a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_DPShaft(pc),a2
		jsr	(Perform_DPLC).w
		jmp    	(Obj_DPShaft_Display).l
; ==================================================================
Obj_DPShaft_Index:
		dc.w Obj_DPShaft_Main-Obj_DPShaft_Index;0
		dc.w Obj_DPShaft_Intro1-Obj_DPShaft_Index;2
		dc.w Obj_DPShaft_Intro2-Obj_DPShaft_Index;4
		dc.w Obj_DPShaft_ChkSonic-Obj_DPShaft_Index;6
		dc.w Obj_DPShaft_Launch-Obj_DPShaft_Index;8
		dc.w Obj_DPShaft_Fall-Obj_DPShaft_Index;A
		dc.w Obj_DPShaft_MoveUp-Obj_DPShaft_Index;C
		dc.w Obj_DPShaft_FlyOppDir-Obj_DPShaft_Index;E
		dc.w Obj_DPShaft_Cast-Obj_DPShaft_Index;10
		dc.w Obj_DPShaft_Retreat-Obj_DPShaft_Index;12

                dc.w Obj_DPShaft_PreCutscene-Obj_DPShaft_Index
                dc.w Obj_DPShaft_CutsceneStart-Obj_DPShaft_Index
                dc.w Obj_DPShaft_CutsceneDialog-Obj_DPShaft_Index
                dc.w Obj_DPShaft_Death-Obj_DPShaft_Index
                dc.w Obj_DPShaft_PreCutsceneFall-Obj_DPShaft_Index
; ==================================================================
Obj_DPShaft_Display:
		cmpi.b	#$14,obRoutine(a0)
		beq.s	Obj_DPShaft_Draw2
		cmpi.b	#$16,obRoutine(a0)
		bcc.s	Obj_DPShaft_Draw
		cmpi.b	#6,obRoutine(a0)
		blt.s	Obj_DPShaft_AnimateIntro

		move.b	$1C(a0),d0
		beq.s	Obj_DPShaft_Animate
		lsr.b	#3,d0
		bcc.w	Obj_DPShaft_Return

Obj_DPShaft_Animate:
		jmp	(Draw_And_Touch_Sprite).w

Obj_DPShaft_Draw2:
                move.w	obTimer(a0),d0
		beq.s	Obj_DPShaft_Draw
                lsr.b	#3,d0
                bcc.w	Obj_DPShaft_Return

Obj_DPShaft_Draw:
		jmp	(Draw_Sprite).w

Obj_DPShaft_AnimateIntro:
		cmpi.b	#2,obRoutine(a0)
		bne.w	+
		cmpi.w	#120,obTimer(a0)
		bcc.w	Obj_DPShaft_Return
+		jmp	(Draw_Sprite).w
; ==================================================================
Obj_DPShaft_Process:
        	st	MGZEmbers_Spawn.w
                cmpi.b  #$14,obRoutine(a0)
                bcc.w   .lacricium
		cmpi.b	#6,obRoutine(a0)
		blt.w	.lacricium
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $1C(a0)
		bne.s   .whatizit
		move.b  #$78,$1C(a0)
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)
		cmpi.b 	#6,obRoutine(a0)
		beq.w	.switch
		cmpi.b 	#$12,obRoutine(a0)
		beq.w	.switch
		bra.s	.whatizit

.switch:
		move.b	#$C,obAnim(a0)
		move.w	#45,obTimer(a0)
		move.b 	#8,obRoutine(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$1C(a0)
		bne.w    .lacricium
		bclr     #6,$2A(a0)
		move.b   $25(a0),$28(a0)
		bra.w	.lacricium


.gone:
                st	(NoPause_flag).w
                clr.b   obAnim(a0)
		move.w	parent2(a0),a1
		move.b	#$A,obRoutine(a1)

		move.w	parent3(a0),a1
		move.b	#$A,obRoutine(a1)
		lea 	ChildObjDat_DialogueFirebrandRadiusExplosion3(pc),a2
		jsr 	(CreateChild6_Simple).w
		bne.s	.lacricium
		st	$40(a1)
                move.w  (Camera_x_pos).w,(Camera_min_x_pos).w
                move.w  (Camera_x_pos).w,(Camera_max_x_pos).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
                move.w  #$3C,obTimer(a0)
                clr.w   obVelX(a0)
                move.b  #$1C,obRoutine(a0)

.lacricium:
		rts
; ==================================================================

Obj_DPShaft_Produce_DI:
		sub.b 	#1,objoff_34(a0)
		bpl.w	++
		move.b	#8,objoff_34(a0)
		cmpi.b	#1,obAnim(a0)
		beq.s	+
		cmpi.b	#3,obAnim(a0)
		beq.s	+
		rts
+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Shaft_DI,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent(a1)
		move.b	obAnim(a0),obAnim(a1)
		move.w	obStatus(a0),obStatus(a1)
+		rts
; ==================================================================

Obj_DPShaft_HP:
		dc.b 8/2	; Easy
		dc.b 8		; Normal
		dc.b 8+4	; Hard
		dc.b 8+4	; Maniac

Obj_DPShaft_Main:
		lea	ObjDat4_DPShaft(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid
		sfx	sfx_Bounce
		lea	ChildObjDat_Shaft_Clone_Contraction(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_DPShaft_HP(pc,d0.w),$29(a0)
		move.b	#$10,obAnim(a0)
		move.w	#180,obTimer(a0)
                move.w  #59,objoff_3E(a0)
		move.b	#0,objoff_33(a0)
		move.b	#4,objoff_34(a0)

		move.b	#0,objoff_35(a0)
		move.b	#0,objoff_37(a0)
		move.b	#1,objoff_3B(a0)

Obj_DPShaft_Intro1:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaft_Return
		move.b	#2,obAnim(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_DPShaft_Return
		move.l	#Obj_Shaft_Sphere,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent2(a1)
		move.w	a1,parent3(a0)
		move.w	obY(a0),objoff_16(a1)
		sub.w	#$3D,objoff_16(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_DPShaft_Return
		move.l	#Obj_Shaft_Sphere,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#1,obSubtype(a1)
		move.w	a0,parent2(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	a1,parent2(a0)
		move.w	obY(a0),objoff_16(a1)
		sub.w	#$3D,objoff_16(a1)

                lea	(Player_1).w,a1
                clr.b	object_control(a1)
                sf	(Ctrl_1_locked).w
		move.w	#59,obTimer(a0)
		addq.b	#2,(Dynamic_resize_routine).w
		addq.b 	#2,obRoutine(a0)

Obj_DPShaft_Intro2:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaft_Return
		clr.b	obAnim(a0)

		addq.b 	#2,obRoutine(a0)

Obj_DPShaft_ChkSonic:
		cmpi.b	#$D,obAnim(a0)
		beq.w	Obj_DPShaft_Return
                sub.w   #1,objoff_3E(a0)
                bpl.s   +
                move.w  #360,objoff_3E(a0)
		move.b	#7,obAnim(a0)
		move.w	#60,obTimer(a0)
		move.b	#$10,obRoutine(a0)
                rts
+		jsr	(Find_Sonic).w
		cmpi.w	#$60,d2
		bcc.w	Obj_DPShaft_Return

		move.w	(Camera_min_X_pos).w,d0
		add.w	#$28,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	++

		move.w	(Camera_max_X_pos).w,d0
		add.w	#$110,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.s	++

		move.b	#$F,obAnim(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		move.w	#-$100,x_vel(a0)
		clr.w	y_vel(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	x_vel(a0)
+		move.b 	#$12,obRoutine(a0)
		rts

+		jsr	(Obj_Eggman_LookOnSonic).l
		move.b	#$C,obAnim(a0)
		move.w	#45,obTimer(a0)
		addq.b 	#2,obRoutine(a0)
		rts

Obj_DPShaft_Launch:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaft_Return ;
		sfx	sfx_Bounce
		cmpi.b	#2,objoff_33(a0)
		bne.w	+

		move.b	#0,objoff_33(a0)
		move.b	#3,obAnim(a0)
		move.w	#-$500,obVelY(a0)
		move.w	#0,obVelX(a0)
		move.w	#24,obTimer(a0)
                move.b	#$C,obRoutine(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_DPShaft_Return
		move.l	#Obj_Shaft_SphereShield,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		sub.b	#$3C,$3C(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_DPShaft_Return
		move.l	#Obj_Shaft_SphereShield,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		add.b	#$3C,$3C(a1)
		rts

+		add.b	#1,objoff_33(a0)
		move.b	#1,obAnim(a0)
		move.w	#-$500,obVelY(a0)

		move.w	(Camera_min_x_pos).w,d0
		add.w	#$A0,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
                bclr    #0,obStatus(a0)

		move.w	obX(a0),d0
		sub.w   (Camera_min_x_pos).w,d0
		cmpi.w	#$C4,d0
		bcc.s	+

		move.w	(Camera_max_x_pos).w,d0
		add.w	#$128,d0
		sub.w	#$88,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
                bset    #0,obStatus(a0)
+		addq.b 	#2,obRoutine(a0)

Obj_DPShaft_Fall:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		move.w	(Camera_min_Y_pos).w,d0
		add.w	#$B4,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_DPShaft_Return
		move.w	d0,obY(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		clr.w	obVelY(a0)
		clr.w	obVelX(a0)

		cmpi.b	#0,objoff_35(a0)
		bne.s	+
                move.w  #360,objoff_3E(a0)
		move.b	#7,obAnim(a0)
		move.w	#60,obTimer(a0)
		move.b	#$10,obRoutine(a0)
		rts

+		move.b	#2,obAnim(a0)
                move.b	#6,obRoutine(a0)
		rts

Obj_DPShaft_MoveUp:
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaft_Return
		bset	#0,obStatus(a0)
		move.w	obX(a0),d0
		sub.w   (Camera_min_x_pos).w,d0
		cmpi.w	#$C4,d0
		bcc.s	+
		bclr	#0,obStatus(a0)
+		move.w	#0,obVelY(a0)
		move.w	#-$300,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		addq.b 	#2,obRoutine(a0)

Obj_DPShaft_FlyOppDir:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(SpeedToPos).w
		btst	#0,obStatus(a0)
		beq.s	+
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$28,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	++
		rts

+		move.w	(Camera_max_X_pos).w,d0
		add.w	#$110,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.s	+
		rts

+		move.w	#0,obVelX(a0)
		move.b 	#$A,obRoutine(a0)
		rts

Obj_DPShaft_Cast:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaft_Return
		move.b	#$D,obAnim(a0)
		cmpi.b	#3,objoff_37(a0)
		bne.s	+
		move.b	#0,objoff_37(a0)

+		move.b	#1,objoff_35(a0)
		add.b	#1,objoff_37(a0)
		cmpi.b	#1,objoff_37(a0)
		beq.s	.fireattack
		cmpi.b	#2,objoff_37(a0)
		beq.s	.thunderattack
		cmpi.b	#3,objoff_37(a0)
		beq.w	.rushattack

.fireattack:
		samp	sfx_ShaftAttack

		move.w	parent2(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#1,objoff_35(a1)
		clr.w	x_vel(a1)

		move.w	parent3(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		clr.b	obColType(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#1,objoff_35(a1)
		clr.w	x_vel(a1)
		bra.w	.finishcasting

.thunderattack:
		samp	sfx_ShaftAttack2

		move.w	parent2(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#2,objoff_35(a1)
		clr.w	x_vel(a1)

		move.w	parent3(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#2,objoff_35(a1)
		clr.w	x_vel(a1)

		bra.w	.finishcasting

.rushattack:
		samp	sfx_ShaftAttack3

		move.w	parent2(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#3,objoff_35(a1)
		clr.w	x_vel(a1)

		move.w	parent3(a0),a1
		move.w	#59,obTimer(a1)
		move.b	#2,obRoutine(a1)
		move.b	#0,obAnim(a1)
		move.w 	#$23D0,obGfx(a1)
		move.b	#3,objoff_35(a1)
		clr.w	x_vel(a1)

.finishcasting:
                move.b	#6,obRoutine(a0)
		rts

Obj_DPShaft_Retreat:
		jsr	(SpeedToPos).w
		cmpi.b	#0,obAnim(a0)
		bne.s	Obj_DPShaft_Return
		clr.w	x_vel(a0)
                move.b	#6,obRoutine(a0)

Obj_DPShaft_Return:
		rts

; ===========================================================================
Obj_DPShaft_PreCutsceneFall:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		move.w	(Camera_min_Y_pos).w,d0
		add.w	#$B4,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_DPShaft_Return
		move.w	d0,obY(a0)
                clr.w   obVelY(a0)
                move.b  #$14,obRoutine(a0)

Obj_DPShaft_PreCutscene:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DPShaft_Cutscene_Return
                move.b  #$20,(Dynamic_resize_routine).w
                move.b  #1,obAnim(a0)
		move.w	#-$500,obVelY(a0)
                bclr    #0,obStatus(a0)
		move.w	obX(a0),d0
		sub.w   (Camera_min_x_pos).w,d0
		cmpi.w	#$98,d0
		bcc.s	+
                bset    #0,obStatus(a0)
+               addq.b   #2,obRoutine(a0)

Obj_DPShaft_CutsceneStart:
                move.w  (Camera_min_x_pos).w,d2
                add.w   #$96,d2
                sub.w   obX(a0),d2
                asl.w   #3,d2
                move.w  d2,obVelX(a0)
		jsr	(Obj_Produce_AfterImage).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		move.w	(Camera_min_Y_pos).w,d0
		add.w	#$B4,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_DPShaft_Return
		move.w	d0,obY(a0)
                move.b  #$12,obAnim(a0)
                bclr    #0,obStatus(a0)
                addq.b   #2,obRoutine(a0)

Obj_DPShaft_CutsceneDialog:
                cmpi.b  #$22,(Dynamic_resize_routine).w
                bne.w   Obj_DPShaft_Cutscene_Return
                addq.b   #2,obRoutine(a0)
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Load_BlackStretch).l

		; load dialog
		jsr	(Create_New_Sprite).w
		bne.w	Obj_DPShaft_Cutscene_Return
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_GMZ3,routine(a1)

		; load main dialog
		move.l	#DialogMGZ3Shaft_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ3Shaft_Process_Index_End-DialogMGZ3Shaft_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	Obj_DPShaft_Death

		; load alt dialog
		move.l	#DialogMGZ3Shaft_EX_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ3Shaft_EX_Process_Index_End-DialogMGZ3Shaft_EX_Process_Index)/8,$39(a1)


Obj_DPShaft_Death:
                cmpi.b  #$24,(Dynamic_resize_routine).w
                bne.w   Obj_DPShaft_Cutscene_Return
                clr.w   (AstarothCompleted).w
        	samp	sfx_ShaftDeath

		jsr	(Obj_KillBloodCreate).l


		move.l	#Resize_GMZ3_AfterLastBoss,(Level_data_addr_RAM.Resize).w


		lea 	ChildObjDat_DialogueFirebrandRadiusExplosion3(pc),a2
		jsr 	(CreateChild6_Simple).w
		bne.w    Obj_DPShaft_Cutscene_Return
		st	$40(a1)
		fadeout
		move.l	#Go_Delete_Sprite,(a0)

Obj_DPShaft_Cutscene_Return:
		rts

ChildObjDat_DialogueFirebrandRadiusExplosion3:
		dc.w 1-1
		dc.l Obj_DialogueFirebrandRadiusExplosion
; ---------------------------------------------------------------------------

Obj_Shaft_DI:
		move.l 	#Map_ShaftUnc,obMap(a0)
		move.w 	#$24C0,obGfx(a0)
		move.b 	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.w	#16,objoff_46(a0)
		move.l	#Obj_Shaft_DI_Del,(a0)

Obj_Shaft_DI_Del:
		move.w	parent(a0),a1
		cmpi.b	#7,obAnim(a1)
		beq.s	+
		lea	(Ani_DPShaft).l,a1
		jsr	(Animate_Sprite).w
		sub.w	#1,objoff_46(a0)
		bpl.s	++
+		move.l #Delete_Current_Sprite,(a0)
+		jmp    	(Obj_Shaft_DI_Display).l

Obj_Shaft_DI_Display:
		add.w   #1,obTimer(a0)
		cmpi.w	#3,obTimer(a0)
		bne.s	Obj_Shaft_DI_Return
		clr.w	obTimer(a0)
		jmp	(Draw_Sprite).w

Obj_Shaft_DI_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Shaft_SphereShield:
		moveq   #0,d0
		move.b	obRoutine(a0),d0
		move.w  Obj_Shaft_SphereShield_Index(pc,d0.w),d1
		jsr     Obj_Shaft_SphereShield_Index(pc,d1.w)
		lea     (Ani_Sphere).l,a1
		jsr     (AnimateSprite).w
		lea	DPLCPtr_DPShaft_Sphere(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_Shaft_SphereShield_Index:
	dc.w  Obj_Shaft_SphereShield_Main-Obj_Shaft_SphereShield_Index
	dc.w  Obj_Shaft_SphereShield_SetRadius-Obj_Shaft_SphereShield_Index
	dc.w  Obj_Shaft_SphereShield_TransshipmentPoint-Obj_Shaft_SphereShield_Index
	dc.w  Obj_Shaft_SphereShield_RotateNAttack-Obj_Shaft_SphereShield_Index

Obj_Shaft_SphereShield_Main:
		lea	ObjDat4_DPShaft_Sphere_Shield(pc),a1
		jsr	SetUp_ObjAttributes
		move.b	#1,obAnim(a0)
		move.b	#0,objoff_36(a0)
		rts

Obj_Shaft_SphereShield_SetRadius:
		addq.b	#1,objoff_48(a0)
		addi.b	#1,$3C(a0)
		jsr	(MoveSprite_Circular_Shaft).l	; ��������.
		cmpi.b	#40,objoff_48(a0)
		bcc.s	+
		rts
+		addq.b 	#2,obRoutine(a0)

Obj_Shaft_SphereShield_TransshipmentPoint:
		move.w	parent3(a0),a1
		cmpi.b	#$E,obRoutine(a1)
		beq.s	+
		rts
+		move.w	#10,obTimer(a0)
		addq.b 	#2,obRoutine(a0)

Obj_Shaft_SphereShield_RotateNAttack:
		move.w	parent3(a0),a1
		cmpi.b	#$E,obRoutine(a1)
		bne.s	Obj_Shaft_SphereShield_Delete
		subi.b	#$A,$3C(a0)
		jmp	(MoveSprite_Circular_Shaft).l	; ��������.

Obj_Shaft_SphereShield_Delete:
		move.w	#99,objoff_46(a0)
		move.l #Delete_Current_Sprite,(a0)

Obj_Shaft_SphereShield_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Shaft_Sphere:
		moveq   #0,d0
		move.b	obRoutine(a0),d0
		move.w  Obj_Shaft_Sphere_Index(pc,d0.w),d1
		jsr     Obj_Shaft_Sphere_Index(pc,d1.w)
		lea     (Ani_Sphere).l,a1
		jsr     (AnimateSprite).w
		lea	DPLCPtr_DPShaft_Sphere(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Shaft_Sphere_AnimScan).l

Obj_Shaft_Sphere_Index:
	dc.w  Obj_Shaft_Sphere_Main-Obj_Shaft_Sphere_Index
	dc.w  Obj_Shaft_Sphere_STDAction-Obj_Shaft_Sphere_Index
	dc.w  Obj_Shaft_Sphere_FireAtk-Obj_Shaft_Sphere_Index
	dc.w  Obj_Shaft_Sphere_ThAtk-Obj_Shaft_Sphere_Index
	dc.w  Obj_Shaft_Sphere_RushAtk-Obj_Shaft_Sphere_Index
	dc.w  Obj_Shaft_Sphere_ShaftDead-Obj_Shaft_Sphere_Index
	
Obj_Shaft_Sphere_AnimScan:
                btst   	#6,$2A(a0)
	        bne.s  	+
	        moveq	#0,d0
	        move.b 	obAnim(a0),d0
        	move.b 	Obj_Shaft_Sphere_Collision(pc,d0.w),d1
	        move.b 	d1,obColType(a0)
+               jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------
Obj_Shaft_Sphere_Collision:
		dc.b  0
		dc.b  $9A
		dc.b  $9A
		dc.b  $86
		dc.b  0
		dc.b  0

Obj_Shaft_Sphere_Main:	
		lea	ObjDat4_DPShaft_Sphere(pc),a1
		jsr	SetUp_ObjAttributes
		move.b	#4,obAnim(a0)

Obj_Shaft_Sphere_STDAction:
		cmpi.w	#1,obSubtype(a0)
		beq.s	.1subtype
		jsr	(Obj_Shaft_Sphere_YHome).l
		move.w	parent2(a0),a1
		move.w	obX(a1),d0
		add.w	#$10,d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)
		bra.w	.setspeed

.1subtype:
		jsr	(Obj_Shaft_Sphere_YHome).l
		move.w	parent2(a0),a1
		move.w	obX(a1),d0
		sub.w	#$10,d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)

.setspeed:
		jsr	(SpeedToPos).w
		cmpi.b	#0,objoff_35(a0)
		beq.w	.return
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Shaft_Sphere_Return
		cmpi.b	#1,objoff_35(a0)
		beq.w	.fire
		cmpi.b	#2,objoff_35(a0)
		beq.w	.light
		cmpi.b	#3,objoff_35(a0)
		beq.w	.rush
		bra.w	.return

.fire:
		move.w	#90,obTimer(a0)
		move.b	#4,obRoutine(a0)
		move.b	#2,obAnim(a0)
		move.w 	#$23D0,obGfx(a0)
		clr.w	x_vel(a0)
		cmpi.w	#1,obSubtype(a0)
		bne.w	.return
		move.w	#128,obTimer(a0)
		bra.w	.return

.light:
		sfx	sfx_LightShield
		move.b	#3,obAnim(a0)
		move.w	#90,obTimer(a0)
		move.b	#6,obRoutine(a0)
		move.w 	#$23D0,obGfx(a0)
		clr.w	x_vel(a0)

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.b	#$02,subtype(a1)		; Jump|Art ID nibble
		move.w	#$00,$42(a1)			; Xpos
		move.w	#$60,$44(a1)			; Ypos
		move.w	#$50,$2E(a1)			; Timer
		move.w	#$84E0,art_tile(a1)			; VRAM
		bra.s	.return

.rush:
		sfx	sfx_Boom
		move.w	#360,obTimer(a0)
		move.b	#8,obRoutine(a0)
		move.b	#1,obAnim(a0)
		move.w	#$200,obVelY(a0)
		move.w 	#$23D0,obGfx(a0)
		clr.w	x_vel(a0)

.return:
		rts

Obj_Shaft_Sphere_FireAtk:
		cmpi.w	#1,obSubtype(a0)
		beq.s	.1subtype
		jsr	(Obj_Shaft_Sphere_YHome).l
		move.w	parent2(a0),a1
		move.w	obX(a1),d0
		add.w	#$10,d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)
		bra.w	.setspeed

.1subtype:
		jsr	(Obj_Shaft_Sphere_YHome).l
		move.w	parent2(a0),a1
		move.w	obX(a1),d0
		sub.w	#$10,d0
		sub.w	obX(a0),d0
		asl.w	#4,d0
		move.w	d0,obVelX(a0)

.setspeed:
		jsr	(SpeedToPos).w
		move.w	parent2(a0),a1
		cmpi.b 	#6,obRoutine(a1)
		beq.s	.attack
		cmpi.b 	#8,obRoutine(a1)
		beq.s	.attack
		cmpi.b 	#$12,obRoutine(a1)
		beq.s	.attack
		rts

.attack:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Shaft_Sphere_Return
		add.b	#1,objoff_36(a0)
		cmpi.b	#2,objoff_36(a0)
		bcc.w	+
		move.w	#180,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Shaft_Sphere_Return
		move.l	#Obj_Sphere_BigFireball,(a1)
                move.w  a0,parent3(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                add.w   #$1F,obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		rts

+		clr.b	objoff_36(a0)
		move.w	parent2(a0),a1
		move.b	#0,objoff_35(a1)
		rts

Obj_Shaft_Sphere_ThAtk:
		cmpi.w	#1,obSubtype(a0)
		beq.s	.1subtypeT
		jsr	(Obj_Shaft_Sphere_THAttackYPos).l
		jsr	(Find_SonicObject).l
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w
		bra.w	.ticktockT

.1subtypeT:
		jsr	(Obj_Shaft_Sphere_THAttackYPos).l
		move.w	parent3(a0),a1
		jsr	(Find_OtherObject).w
		move.w	#$100,d0
		moveq	#$10,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w

.ticktockT:
		cmpi.b  #2,objoff_36(a0)
		beq.w	+
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Shaft_Sphere_Return
		move.w	#180,obTimer(a0)
		add.b	#1,objoff_36(a0)
		samp	sfx_ThunderClamp
		move.w #$14,(Screen_Shaking_Flag).w
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Shaft_Sphere_Return
		move.l	#Obj_Sphere_Thunder,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$F,obY(a1)
		move.w	#15,objoff_46(a1)
		move.w	a0,parent(a1)
		move.w	a0,parent2(a1)
		rts
+		clr.b	objoff_36(a0)
		move.w	parent2(a0),a1
		move.b	#0,objoff_35(a1)
		clr.w	objoff_12(a0)
		rts

Obj_Shaft_Sphere_RushAtk:
		cmpi.w	#1,obSubtype(a0)
		beq.s	.1subtypeR

		jsr	(Find_SonicObject).l
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w
		jsr	(Sphere_CheckFloor).l
		jsr	(Sphere_CheckCeiling).l
		bra.w	.ticktockR

.1subtypeR:
		move.w	parent3(a0),a1
		jsr	(Find_OtherObject).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w
		jsr	(Sphere_CheckFloor).l
		jsr	(Sphere_CheckCeiling).l

.ticktockR:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Shaft_Sphere_Return
		move.w	parent2(a0),a1
		move.b	#0,objoff_35(a1)
		rts

Obj_Shaft_Sphere_ShaftDead:
		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_DEZExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
                add.w   #$F,y_pos(a1)
		move.w	#-$100,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		move.l #Delete_Current_Sprite,(a0)
+               rts

Obj_Shaft_Sphere_YHome:
		move.w	parent2(a0),a1
		move.w	obY(a1),d0
		sub.w	#$3D,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a0)
		rts

Obj_Shaft_Sphere_THAttackYPos:
		move.w	(Camera_y_pos).w,d0
		add.w	#$16,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a0)
		rts

Sphere_CheckFloor:
		move.w	(Camera_y_pos).w,d0
		add.w	#$AA,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.s	+
		neg.w	obVelY(a0)
+		rts

Sphere_CheckCeiling:
		move.w	(Camera_y_pos).w,d0
		add.w	#$10,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bcc.s	+
		neg.w	obVelY(a0)
+		rts

Obj_Shaft_Sphere_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Sphere_Thunder:
		move.l 	#Map_Thunder,obMap(a0)
		move.w 	#$23E0,obGfx(a0)
		move.b 	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$20,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$20,y_radius(a0)
		move.b	#1,obAnim(a0)
		move.b	#$84,obColType(a0)
		cmpi.w	#$300,obY(a0)
		bcc.s	+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Sphere_Thunder,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	parent(a0),parent(a1)
		move.w	a0,parent2(a1)
		move.w	objoff_46(a0),objoff_46(a1)
		add.w	#$10,obY(a1)
+		move.l	#Obj_Sphere_Thunder_TimeThunder,(a0)

Obj_Sphere_Thunder_TimeThunder:
		lea	(Ani_Sphere).l,a1
		jsr	(Animate_Sprite).w
		jsr	(Shaft_CheckActiveThSpell).l
		move.w	parent(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	parent2(a0),a1
		move.w	obY(a1),obY(a0)
		add.w	#$10,obY(a0)
		sub.w	#1,objoff_46(a0)
		bpl.s	+
		move.w	#30,objoff_46(a0)
		move.b	#2,obAnim(a0)
		move.b	#$86,obColType(a0)
		move.l	#Obj_Sphere_Thunder_Del,(a0)
+		jmp	(Draw_And_Touch_Sprite).w

Obj_Sphere_Thunder_Del:
		lea	(Ani_Thunder).l,a1
		jsr	(Animate_Sprite).w
		jsr	(Shaft_CheckActiveThSpell).l
		move.w	parent(a0),a1
		move.w	obX(a1),obX(a0)
		move.w	parent2(a0),a1
		move.w	obY(a1),obY(a0)
		add.w	#$10,obY(a0)
		sub.w	#1,objoff_46(a0)
		bpl.s	+
		move.l #Delete_Current_Sprite,(a0)
+		jmp	(Draw_And_Touch_Sprite).w

Shaft_CheckActiveThSpell:
		move.w	parent(a0),a1
		cmpi.b	#6,obRoutine(a1)
		beq.s	+
		move.l	#Go_Delete_Sprite,(a0)
+		rts
; ==================================================================

Obj_Sphere_BigFireball:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Sphere_BigFireball_Index(pc,d0.w),d1
		jsr	Obj_Sphere_BigFireball_Index(pc,d1.w)
		lea	(Ani_BigFireball).l,a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).w

Obj_Sphere_BigFireball_Index:
		dc.w Obj_Sphere_BigFireball_Main-Obj_Sphere_BigFireball_Index
		dc.w Obj_Sphere_BigFireball_ComingDown-Obj_Sphere_BigFireball_Index
		dc.w Obj_Sphere_BigFireball_Fly-Obj_Sphere_BigFireball_Index

Obj_Sphere_BigFireball_Main:
		addq.b	#2,routine(a0)
		sfx	sfx_FireShield
		jsr	(Obj_Eggman_LookOnSonic).l
		move.l	#Map_BigFireball,obMap(a0)
		move.w	#$2F0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$9A,obColType(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$F,y_radius(a0)
		move.b	#$1F,x_radius(a0)
		move.w	#$400,obVelY(a0)
		move.w	#$400,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		rts

Obj_Sphere_BigFireball_ComingDown:
		jsr	(SpeedToPos).w
		move.w	(Camera_target_max_Y_pos).w,d0
		add.w	#$B8,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.s	.return
		clr.w	obVelY(a0)
		move.b	#$88,obColType(a0)
		move.b	#1,obAnim(a0)
		addq.b	#2,routine(a0)

.return:
		rts

Obj_Sphere_BigFireball_Fly:
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		sub.w	#$40,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	.delete
		move.w	(Camera_max_x_pos).w,d0
		add.w	#$168,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	.delete
		rts

.delete:
		move.l	#Delete_Current_Sprite,(a0)
		rts

; ---------------------------------------------------------------------------

ObjDat4_DPShaft:
		dc.l Map_ShaftUnc		; Mapping
		dc.w $24A0			; VRAM
		dc.w $200			; Priority
		dc.b 40/2			; Width	(64/2)
		dc.b 32/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $1A			; Collision


DPLCPtr_DPShaft:	dc.l ArtUnc_DPShaft>>1, DPLC_DPShaft

; ---------------------------------------------------------------------------

ObjDat4_DPShaft_Sphere:
		dc.l Map_Sphere		; Mapping
		dc.w $23D0			; VRAM
		dc.w $200			; Priority
		dc.b 24/2			; Width	(64/2)
		dc.b 24/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b 0			; Collision

ObjDat4_DPShaft_Sphere_Shield:
		dc.l Map_Sphere		; Mapping
		dc.w $2440			; VRAM
		dc.w $200			; Priority
		dc.b 24/2			; Width	(64/2)
		dc.b 24/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $87			; Collision


DPLCPtr_DPShaft_Sphere:
	dc.l ArtUnc_DPShaft_Sphere>>1, DPLC_ShSphere

; ---------------------------------------------------------------------------

PLC_BossShaft: plrlistheader
		plreq $2F0, ArtKosM_Shaft_BigFireball
		plreq $3E0, ArtKosM_Thunder
		plreq $3AD, ArtKosM_Spark
PLC_BossShaft_End

		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Spark.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Big Fireball.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Shaft.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Sphere.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Thunder.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - ShaftUnc.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/DPLC - Shaft.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/DPLC - Sphere.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Ani - Shaft.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Ani - Sphere.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Ani - Thunder.asm"
		include	"Objects/Bosses/Dark Priest Shaft/Object data/Ani - Big Fireball.asm"
