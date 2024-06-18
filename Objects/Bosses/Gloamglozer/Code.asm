; ---------------------------------------------------------------------------
; Gloamglozer, FDZ mega-boss
; ---------------------------------------------------------------------------

Obj_Gloamglozer:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Gloamglozer_Index(pc,d0.w),d1
		jsr	Obj_Gloamglozer_Index(pc,d1.w)
		bsr.w	Obj_Gloamglozer_ShipProcess
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		lea	(Ani_Gloamglozer).l,a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_Gloamglozer(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Gloamglozer_Display).l
; ===========================================================================

Obj_Gloamglozer_Index:
		dc.w Obj_Gloamglozer_Main-Obj_Gloamglozer_Index			; 0
		dc.w Obj_Gloamglozer_Dialogue-Obj_Gloamglozer_Index 	        ; 2
		dc.w Obj_Gloamglozer_Dialogue_Return-Obj_Gloamglozer_Index 	; 4
		dc.w Obj_Gloamglozer_HideBeforeTransform-Obj_Gloamglozer_Index  ; 6
		dc.w Obj_Gloamglozer_TransformSimple-Obj_Gloamglozer_Index      ; 8
		dc.w Obj_Gloamglozer_WaitForSignal-Obj_Gloamglozer_Index 	; A
		dc.w Obj_Gloamglozer_FlyUp-Obj_Gloamglozer_Index 		; C
		dc.w Obj_Gloamglozer_TransformStrong-Obj_Gloamglozer_Index      ; E
		dc.w Obj_Gloamglozer_WaitForSignal2-Obj_Gloamglozer_Index       ; 10
		dc.w Obj_Gloamglozer_AfterIt-Obj_Gloamglozer_Index 		; 12
		dc.w Obj_Gloamglozer_CutsceneStart-Obj_Gloamglozer_Index	; 14
		dc.w Obj_Gloamglozer_CutsceneWait-Obj_Gloamglozer_Index

		dc.w Obj_Gloamglozer_CutsceneSetWait-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneWait-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneDialogLoad-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneDialogWait-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneSonicHandUp_Return-Obj_Gloamglozer_Index

		dc.w Obj_Gloamglozer_CutsceneSetMoveRight-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneMoveRight-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneSonicMoveRight-Obj_Gloamglozer_Index
		dc.w Obj_Gloamglozer_CutsceneSonicWait-Obj_Gloamglozer_Index

Obj_Gloamglozer_HP:
		dc.b 8/2	; Easy
		dc.b 8	        ; Normal
		dc.b 8+2	; Hard
		dc.b 8+2	; Maniac
; ===========================================================================

Obj_Gloamglozer_Main:
		lea	ObjDat4_Gloamglozer(pc),a1
		jsr	SetUp_ObjAttributes
	    	move.w  #360,obTimer(a0)
		move.w	#0,obSubtype(a0)

		move.w	#$C0,d0				; Down
		move.w	d0,$3E(a0)
		move.w	d0,$1A(a0)
		move.w	#$10,$40(a0)		; Time
		bclr	#0,$38(a0)
		st	$3A(a0)					; set current frame as invalid

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Gloamglozer_HP(pc,d0.w),$29(a0)

		move.w	obY(a0),objoff_16(a0)
		move.b	#8,objoff_49(a0)
		move.b	#0,objoff_47(a0)
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		cmpi.w	#1,(DialogueAlreadyShown).w
		beq.s	.skip

		bra.s   Obj_Gloamglozer_LoadDialog
		rts

.skip:
		move.b	#6,routine(a0)

.return:
		rts
; ===========================================================================

Obj_Gloamglozer_LoadDialog:
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.w	a1,parent3(a0)
		move.b	#_FDZ4,routine(a1)

		; load main dialog
		move.l	#DialogFDZ4_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4_Process_Index_End-DialogFDZ4_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	.return

		; load alt dialog
		move.l	#DialogFDZ4_EX_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4_EX_Process_Index_End-DialogFDZ4_EX_Process_Index)/8,$39(a1)


.return
		rts
; ===========================================================================
Obj_Gloamglozer_ShipProcess:
		cmpi.b	#$14,routine(a0)
		bcc.w	.lacricium
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$3C,$1C(a0)
		jsr	(Obj_SmallBloodCreate).l
		samp	sfx_FireHurt
		sfx	sfx_KnucklesKick
		move.b	#1,obAnim(a0)

.skipshout:
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.w	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		rts
; ===========================================================================

.gone:
		tst.b	(Extended_mode).w
		bne.s	.altdelete

		lea	(ArtKosM_DialogueGloam).l,a1
		move.w	#tiles_to_bytes($400),d2
		jsr	(Queue_Kos_Module).w
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
		bclr	#0,obStatus(a0)
		move.w	#$3D8,obX(a0)
		move.w	#$120,obY(a0)
		clr.w	(DialogueAlreadyShown).w
		move.b	#2,obAnim(a0)
		move.b	#$14,routine(a0)

.lacricium:
		rts

; ===========================================================================

.altdelete
		move.b	#$C,(Dynamic_resize_routine).w
		clr.w	(DialogueAlreadyShown).w
		move.l	#Delete_Current_Sprite,address(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		move.b	#4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ===========================================================================

Obj_Gloamglozer_Display:
                cmpi.b  #1,objoff_3E(a0)
                beq.s   Obj_Gloamglozer_Display_Invulnerable
		move.b	$1C(a0),d0
		beq.s	Obj_Gloamglozer_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Gloamglozer_Cutscene_Return

Obj_Gloamglozer_Animate:
		jmp	(Draw_And_Touch_Sprite).w

Obj_Gloamglozer_Display_Invulnerable:
		tst.w	Seizure_flag.w			; check if photosensitivity
		bne.s	.draw				; if so, no flicker
		move.w  v_framecount.w,d0
		lsr.b	#1,d0
		bcc.w	Obj_Gloamglozer_Cutscene_Return

.draw:
		cmpi.l	#Obj_Gloamglozer,(a0)
		beq.s	.drawMain
		jmp	(Child_Draw_Sprite).w

.drawMain:
		jmp	(Draw_Sprite).w
; ===========================================================================

Obj_Gloamglozer_ThunderClamp:
		move.w #$14,(Screen_Shaking_Flag).w
		move.b #$4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ===========================================================================

Obj_Gloamglozer_Dialogue:
		movea.w	parent3(a0),a1
		tst.b	obDialogWinowsText(a1)
		bne.s	Obj_Gloamglozer_Dialogue_Return
		addq.b	#2,routine(a0)
		move.w	#id_Landing<<8,(Player_1+anim).w

Obj_Gloamglozer_Dialogue_Return:
		rts
; ===========================================================================
Obj_Gloamglozer_HideBeforeTransform:
		jsr	(Obj_Gloamglozer_ThunderClamp).l
		move.w	#$4C9,obY(a0)
		addq.b	#2,routine(a0)
; ===========================================================================

Obj_Gloamglozer_TransformSimple:
		jsr	(RandomNumber).w
		andi.b	#1,d0
		beq.s	.mickey
		lea	(ArtKosM_PrinPrin).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Create_New_Sprite).w
		bne.s	.notfree
		move.l	#Obj_PrinPrinFantom,(a1)
		move.w	obX(a0),obX(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_min_y_pos).w,d0
		sub.w	#$20,d0
		move.w	d0,obY(a1)

.notfree
		bra.w	.hide
		rts

.mickey:
		lea	(ArtKosM_Mickey).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Create_New_Sprite).w
		bne.s	.hide
		move.l	#Obj_MickeyFantom,(a1)
		move.w	obX(a0),obX(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_min_y_pos).w,d0
		sub.w	#$20,d0
		move.w	d0,obY(a1)

.hide:
                move.b  #1,objoff_3E(a0)
		addq.b	#2,routine(a0)

Obj_Gloamglozer_WaitForSignal:
		cmpi.b	#1,objoff_48(a0)
		bne.w	Obj_Gloamglozer_Cutscene_Return
		clr.b	objoff_48(a0)
		jsr	(Obj_Gloamglozer_ThunderClamp).l
		addq.b	#2,routine(a0)
		move.w	#-$B00,obVelY(a0)
                jsr     (Obj_Eggman_LookOnSonic).l
                btst	#0,obStatus(a0)
		bne.w	Obj_Gloamglozer_Cutscene_Return
		neg.w	obVelX(a0)

Obj_Gloamglozer_FlyUp:
		jsr	(ChkObjOnScreen).w
		beq.w	Obj_Gloamglozer_Cutscene_Return
		addq.b	#2,routine(a0)
                clr.b   objoff_3E(a0)
		jsr	(Obj_Gloamglozer_ThunderClamp).l
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		rts

Obj_Gloamglozer_TransformStrong:
		move.w	#$4C9,obY(a0)
		cmpi.b	#2,objoff_47(a0)
		bgt.s	.chesire
		add.b	#1,objoff_47(a0)
		lea	(ArtKosM_Bloodeau).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Create_New_Sprite).w
		bne.s	.notfree
		move.l	#Obj_BloodeauFantom,(a1)
		move.w	obX(a0),obX(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_y_pos).w,d0
		sub.w	#$20,d0
		move.w	d0,obY(a1)

.notfree
		bra.s	.hide
		rts

.chesire:
		clr.b	objoff_47(a0)
		lea	(ArtKosM_DialogueGloam).l,a1
		move.w	#tiles_to_bytes($400),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_Chesire).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Create_New_Sprite).w
		bne.s	.notfree2
		move.l	#Obj_ChesireFantom,(a1)
		move.w	obX(a0),obX(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_y_pos).w,d0
		sub.w	#$20,d0
		move.w	d0,obY(a1)

.notfree2
		jsr	(Create_New_Sprite).w
		bne.s	.hide
		move.l	#Obj_DialogueGloam,(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$48,d0
		move.w	d0,obY(a1)
		move.w	(Camera_X_pos).w,d0
		add.w	#$90,d0
		move.w	d0,obX(a1)

.hide:
		addq.b	#2,routine(a0)

Obj_Gloamglozer_WaitForSignal2:
		cmpi.b	#1,objoff_48(a0)
		bne.w	Obj_Gloamglozer_Cutscene_Return
		clr.b	objoff_48(a0)
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Obj_Gloamglozer_ThunderClamp).l
		addq.b	#2,routine(a0)
                rts

Obj_Gloamglozer_AfterIt:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Gloamglozer_Cutscene_Return
		jsr	(Obj_Gloamglozer_ThunderClamp).l
		move.w	#$4C9,obY(a0)
		clr.b	objoff_3E(a0)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
		move.b	#8,routine(a0)
		rts

Obj_GloamglozerForm_CheckReturnPal:
		btst	#7,status(a0)
		beq.s	+
		lea	(Pal_Gloamglozer).l,a1
		jmp	(PalLoad_Line1).w
+		jmp	(Child_DrawTouch_Sprite).w
; ===========================================================================

Obj_Gloamglozer_CutsceneStart:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$60,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s		+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		btst	#Status_InAir,status(a1)
		bne.s	-
		addq.b	#2,routine(a0)
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Load_BlackStretch).l
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.b	#0,obAnim(a0)
		move.w	#$4F,$2E(a0)

Obj_Gloamglozer_CutsceneWait:
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Gloamglozer_Cutscene_Return
		addq.b	#2,routine(a0)

Obj_Gloamglozer_Cutscene_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSetWait:
		addq.b	#2,routine(a0)
		st	(NoPause_flag).w
		st	(Level_end_flag).w
		move.w	#$1F,$2E(a0)
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneDialogLoad:
		addq.b	#2,routine(a0)
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_FDZ4End2,routine(a1)
		move.l	#DialogFDZ4End_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4End_Process_Index_End-DialogFDZ4End_Process_Index)/8,$39(a1)
		move.w	a1,parent3(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneDialogWait:
		movea.w	parent3(a0),a1
		tst.b	obDialogWinowsText(a1)
		bne.s	Obj_Gloamglozer_CutsceneSonicHandUp_Return
		addq.b	#2,routine(a0)
		lea	(Player_1).w,a1
		move.w	#id_HandUp<<8,anim(a1)
		move.w	#$2F,$2E(a0)

Obj_Gloamglozer_CutsceneSonicHandUp_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSetMoveRight:
		addq.b	#2,routine(a0)
		move.w	#$400,x_vel(a0)

Obj_Gloamglozer_CutsceneMoveRight:
	;	jsr	(MoveSprite2).w
		tst.b	render_flags(a0)
		bmi.s	Obj_Gloamglozer_CutsceneSonicHandUp_Return
		move.l	#Obj_Gloamglozer_CutsceneSonicMoveRight,address(a0)
		move.w	#$5E0,(Camera_max_X_pos).w
		move.w	#$7F,$2E(a0)
		lea	(Player_1).w,a1
		clr.b	object_control(a1)
		move.w	#btnR<<8,(Ctrl_1_logical).w

Obj_Gloamglozer_CutsceneSonicMoveRight:
		cmpi.w	#$5E0,(Camera_X_pos).w
		bne.s	Obj_Gloamglozer_CutsceneSonicWait_Return
		move.l	#Obj_Gloamglozer_CutsceneSonicWait,address(a0)
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		jsr	(Stop_Object).w
		move.b	#$81,object_control(a1)
		move.w	#id_Hurt<<8,anim(a1)
		st	(Screen_Shaking_Flag).w
		samp	sfx_FireAtkFire
		move.b	#4,(Hyper_Sonic_flash_timer).w
		move.w	#$4F,$2E(a0)
		move.w	(Player_1+y_pos).w,$30(a0)

Obj_Gloamglozer_CutsceneSonicWait:
		bsr.s	Obj_Gloamglozer_CutsceneSonicGrab
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Gloamglozer_CutsceneSonicWait_Return
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		move.l	#Obj_Gloamglozer_CutsceneSonicSetFlipAnim,address(a0)

Obj_Gloamglozer_CutsceneSonicWait_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSonicGrab:
		moveq	#0,d0
		move.b	angle(a0),d0
		addq.b	#4,d0
		move.b	d0,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d1
		add.w	$30(a0),d1
		move.w	d1,(Player_1+y_pos).w
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSonicSetFlipAnim:
		move.w	#id_Flip<<8,(Player_1+anim).w
		move.l	#Obj_Gloamglozer_CutsceneMoveSonicUp,address(a0)

Obj_Gloamglozer_CutsceneMoveSonicUp:
		lea	(Player_1).w,a1
		subq.w	#4,y_pos(a1)
		move.w	y_pos(a1),d0
		sub.w	(Camera_Y_pos).w,d0
		cmpi.w	#$80,d0
		bhs.s	+
		move.w	#$4F,$2E(a0)
		move.l	#Obj_Gloamglozer_CutsceneSonicWait2,address(a0)
		move.w	(Player_1+y_pos).w,$30(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSonicWait2:
		bsr.s	Obj_Gloamglozer_CutsceneSonicGrab
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Gloamglozer_CutsceneSonicWait2_Return
		move.l	#Obj_Gloamglozer_CutsceneSonicGrab,address(a0)


		lea	(ArtKosM_Shaft_BigFireball).l,a1
		move.w	#tiles_to_bytes($320),d2
		jsr	(Queue_Kos_Module).w


		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_CutsceneFirebrand,address(a1)	; load FDZ megaboss
		move.w	a1,$44(a0)
		move.w	a0,parent3(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$100,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$80,d2
		move.w	d2,y_pos(a1)
+		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	Obj_Gloamglozer_CutsceneSonicWait2_Return
		move.b	#_FDZ4End,routine(a1)
		move.l	#DialogFDZ4End2_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4End2_Process_Index_End-DialogFDZ4End2_Process_Index)/8,$39(a1)

Obj_Gloamglozer_CutsceneSonicWait2_Return:
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneCreateHellGirl:
		bsr.w	Obj_Gloamglozer_CutsceneSonicGrab
		move.l	#Obj_Gloamglozer_CutsceneSonicGrab,address(a0)
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_HellgirlFDZ4,(a1)
		move.w	(Camera_X_pos).w,d2
		subi.w	#$40,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$88,d2
		move.w	d2,y_pos(a1)
		move.w	$44(a0),parent3(a1)
		move.w	a0,$44(a1)
+		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_CutsceneSonicLookUp:
		subq.w	#1,$2E(a0)
		bpl.s	Obj_Gloamglozer_CutsceneSonicWait2_Return
		lea	(Player_1).w,a1
		move.w	#id_LookUp<<8,anim(a1)
		move.l	#Obj_Gloamglozer_Cutscene_DialogWait,address(a0)
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_FDZ4End3,routine(a1)
		move.l	#DialogFDZ4End3_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4End3_Process_Index_End-DialogFDZ4End3_Process_Index)/8,$39(a1)
		move.w	a1,parent3(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_Cutscene_DialogWait:
		movea.w	parent3(a0),a1
		cmpi.b	#6,obDialogWinowsText(a1)
		bne.s	Obj_Gloamglozer_Cutscene_DialogWait2_Remove
		lea	(Player_1).w,a1
		move.w	#id_Wonder<<8,anim(a1)
		move.l	#Obj_Gloamglozer_Cutscene_DialogWait2,address(a0)

Obj_Gloamglozer_Cutscene_DialogWait2:
		movea.w	parent3(a0),a1
		cmpi.b	#4,obDialogWinowsText(a1)
		bne.s	Obj_Gloamglozer_Cutscene_DialogWait2_Remove
		lea	(Player_1).w,a1
		move.w	#id_LookUp<<8,anim(a1)
		move.l	#Obj_Gloamglozer_Cutscene_DialogWait2_Remove,address(a0)

Obj_Gloamglozer_Cutscene_DialogWait2_Remove:
		rts
; ---------------------------------------------------------------------------

Obj_Gloamglozer_Cutscene_Remove:
		movea.w	$44(a0),a1
		move.l	#CutsceneFirebrand_Remove,address(a1)
		move.l	#Delete_Current_Sprite,address(a0)
		addq.b	#2,(Dynamic_resize_routine).w
		sf	(NoPause_flag).w
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w

; =============== S U B R O U T I N E =======================================

Obj_CutsceneFirebrand:
		move.b	#3,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ObjDat4_Gloamglozer(pc),a1
		jsr	SetUp_ObjAttributes
		move.l	#CutsceneFirebrand_Draw,address(a0)
		move.w	#$C0,d0				; Down
		move.w	d0,$3E(a0)
		move.w	d0,$1A(a0)
		move.w	#$10,$40(a0)		; Time
		bclr	#0,$38(a0)
		st	$3A(a0)					; set current frame as invalid
		rts
; ---------------------------------------------------------------------------

CutsceneFirebrand_Draw:
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		lea	(Ani_Gloamglozer).l,a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_Gloamglozer(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

CutsceneFirebrand_Remove:
		samp	sfx_ThunderClamp
		move.l	#Delete_Current_Sprite,address(a0)
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

ObjDat3_CutsceneFirebrand:
		dc.l SME_gSjKD
		dc.w $22E4
		dc.w $300
		dc.b 48/2
		dc.b 64/2
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------

DPLCPtr_Gloamglozer:	dc.l ArtUnc_Gloamglozer>>1, DPLC_Gloamglozer

DPLCPtr_DeathIntro:		dc.l ArtUnc_DeathIntro>>1, DPLC_DeathIntro

ObjDat4_Gloamglozer:
		dc.l SME_gSjKD			; Mapping
		dc.w $22E4			; VRAM
		dc.w $300			; Priority
		dc.b 48/2			; Width	(64/2)
		dc.b 64/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b 6				; Collision
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Gloamglozer/Object data/Ani - Gloamglozer.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Gloamglozer.asm"
		include "Objects/Bosses/Gloamglozer/Object data/DPLC - Gloamglozer.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Ani - Prin Prin.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Prin Prin.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Ani - Bloodeau.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Bloodeau.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Ani - Mickey.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Mickey.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Ani - Dialogue.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Dialogue.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Chesire.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Ani - Chesire.asm"


		include "Objects/Bosses/Gloamglozer/Object data/Ani - Death.asm"
		include "Objects/Bosses/Gloamglozer/Object data/DPLC - Death.asm"
		include "Objects/Bosses/Gloamglozer/Object data/Map - Death.asm"
