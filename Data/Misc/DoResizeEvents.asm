; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Do_ResizeEvents:
	if (Debug_LevelId < 0) | (Debug_Resize >= 0)
		movea.l	(Level_data_addr_RAM.Resize).w,a0
		jsr	(a0)
	else
		clr.w	Camera_min_X_pos.w
		clr.w	Camera_min_Y_pos.w

		move.w	#$F20,Camera_max_Y_pos.w
		move.w	#$F20,Camera_target_max_Y_pos.w
		move.w	#$7EC0,Camera_max_X_pos.w
	endif
		moveq	#2,d1
		move.w	(Camera_target_max_Y_pos).w,d0
		sub.w	(Camera_max_Y_pos).w,d0
		beq.s	++
		bcc.s	+++
		neg.w	d1
		move.w	(Camera_Y_pos).w,d0
		cmp.w	(Camera_target_max_Y_pos).w,d0
		bls.s		+
		move.w	d0,(Camera_max_Y_pos).w
		andi.w	#-2,(Camera_max_Y_pos).w
+		add.w	d1,(Camera_max_Y_pos).w
		move.b	#1,(Camera_max_Y_pos_changing).w
+		rts
; ---------------------------------------------------------------------------
+		move.w	(Camera_Y_pos).w,d0
		addq.w	#8,d0
		cmp.w	(Camera_max_Y_pos).w,d0
		blo.s		+
		btst	#1,(Player_1+status).w
		beq.s	+
		add.w	d1,d1
		add.w	d1,d1
+		add.w	d1,(Camera_max_Y_pos).w
		move.b	#1,(Camera_max_Y_pos_changing).w

No_Resize:
		rts
; End of function Do_ResizeEvents
; ---------------------------------------------------------------------------

Resize_FDZ1:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0			; I need to remove this and use a long jump. For example: move.l	#Load_GFX4,(Level_data_addr_RAM.Resize).w
		move.w  Arthur_Load_Routines(pc,d0.w),d0		; But there is a lot of code here. This will take a very long time :/ \:
		jmp     Arthur_Load_Routines(pc,d0.w)
; ---------------------------------------------------------------------------

Arthur_Load_Routines:
		dc.w  Check_End4-Arthur_Load_Routines					; $00
		dc.w  Load_GFX4-Arthur_Load_Routines						; $02
		dc.w  CameraMoveUp4-Arthur_Load_Routines				; $04
		dc.w  Load_Boss_Arthur-Arthur_Load_Routines				; $06
		dc.w  loc_kumancey-Arthur_Load_Routines					; $08
		dc.w  StartFDZ1Cutscene_SetWaitFlag-Arthur_Load_Routines	; $0A
		dc.w  FDZ1Cutscene_Wait-Arthur_Load_Routines				; $0C
		dc.w  StartFDZ1Cutscene_SetFlag-Arthur_Load_Routines		; $0E
		dc.w  StartFDZ1Cutscene-Arthur_Load_Routines				; $10
		dc.w  FDZ1Cutscene_Wait-Arthur_Load_Routines				; $12
		dc.w  FDZ1Cutscene_LookLR-Arthur_Load_Routines			; $14
		dc.w  FDZ1Cutscene_Wait-Arthur_Load_Routines				; $16
		dc.w  FDZ1Cutscene_LookUp-Arthur_Load_Routines			; $18
		dc.w  loc_kumancey4-Arthur_Load_Routines					; $1A
		dc.w  FDZ1Cutscene_Wait-Arthur_Load_Routines				; $1C
		dc.w  FDZ1Cutscene_LookBack-Arthur_Load_Routines			; $1E
		dc.w  FDZ1Cutscene_Wait-Arthur_Load_Routines				; $20
		dc.w  FDZ1Cutscene_RestoreControl-Arthur_Load_Routines		; $22
		dc.w  FDZ1Cutscene_SetPos-Arthur_Load_Routines			; $24
		dc.w  loc_kumancey4-Arthur_Load_Routines					; $26
		dc.w  FDZ1LoadSignFade-Arthur_Load_Routines				; $28
		dc.w  FDZ1LoadSign-Arthur_Load_Routines					; $2A
		dc.w  loc_kumancey4-Arthur_Load_Routines					; $2C

; extended
		dc.w  FDZ1Extended_Start-Arthur_Load_Routines				; $2E
		dc.w  FDZ1Extended_Wait-Arthur_Load_Routines				; $30
; ---------------------------------------------------------------------------

Check_End4:
		cmpi.w  #$2600,(Camera_x_pos).w
		blt.w   loc_kumancey
		move.w	#$2600,(Camera_min_X_pos).w
		move.w	#$2BC,(Camera_target_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w

Load_GFX4:
		cmpi.w  #$2800,(Camera_x_pos).w
		bne.w   loc_kumancey
		move.w	#$2800,(Camera_min_X_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		lea	(PLC_BossArthur).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_Arthur).l,a1
		jsr	(PalLoad_Line1).w

CameraMoveUp4:
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$2BC,(Camera_min_Y_pos).w
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	loc_kumancey			; If so, branch
		fadeout					; fade out music

loc_kumancey:
		rts

Load_Boss_Arthur:
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		tst.w	dxFadeOff.w
		bne.w	loc_kumancey
		music	mus_Microboss, 0
		command	cmd_FadeReset
+		addq.b	#2,(Dynamic_resize_routine).w
		move.b	#1,(Boss_flag).w
		jsr	(SingleObjLoad).w
		bne.s	loc_kumancey
		move.l	#Obj_Arthur,(a1)	; load FDZ miniboss
		move.w	#$2949,obX(a1)		; X-position +149
		move.w	#$318,obY(a1)		; Y-position
		move.w	(Player_1+obX).w,d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$94,d0
		blt.s	+
		move.b	#1,objoff_48(a1)
		bchg	#0,obStatus(a1)
		move.w	#$27DF,obX(a1)		; X-position +149
+		rts
; ---------------------------------------------------------------------------

Arthur_Rings:
		dc.b 5*5	; Easy
		dc.b 4*5	; Normal
		dc.b 2*5	; Hard
		dc.b 0*5	; Maniac
; ---------------------------------------------------------------------------

StartFDZ1Cutscene_SetWaitFlag:
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#4*60,(Demo_timer).w
		st	(NoPause_flag).w
		st	(Level_end_flag).w
		rts
; ---------------------------------------------------------------------------

StartFDZ1Cutscene_SetFlag:
		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		lea	(Pal_Gloamglozer).l,a1
		jsr	(PalLoad_Line1).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

StartFDZ1Cutscene:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Load_BlackStretch).l
		move.w	#2*60,(Demo_timer).w

FDZ1Cutscene_Wait:
		tst.w	(Demo_timer).w
		bne.s	+
		addq.b	#2,(Dynamic_resize_routine).w
+		rts
; ---------------------------------------------------------------------------

FDZ1Cutscene_LookLR:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Player_1).w,a1
		move.w	#id_LookLR<<8,anim(a1)
		move.w	#3*60,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

FDZ1Cutscene_LookUp:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Player_1).w,a1
		move.w	#id_LookUp<<8,anim(a1)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Dialog_Process,(a1)
		move.b	#_FDZ1Start,routine(a1)
		move.l	#DialogFDZ1Start_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ1Start_Process_Index_End-DialogFDZ1Start_Process_Index)/8,$39(a1)
+		rts
; ---------------------------------------------------------------------------

FDZ1Cutscene_LookBack:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Player_1).w,a1
		move.w	#id_LookL<<8,anim(a1)
		move.w	#2*60,(Demo_timer).w
		rts
; ---------------------------------------------------------------------------

FDZ1Cutscene_RestoreControl:
		addq.b	#2,(Dynamic_resize_routine).w
		jsr	(Restore_PlayerControl).w

FDZ1Cutscene_SetPos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$E0,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s	+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------

+		btst	#Status_InAir,status(a1)
		bne.s	-
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		jsr	(Stop_Object).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_FDZ1_Process,address(a1)
+		rts
; ---------------------------------------------------------------------------

FDZ1LoadSignFade:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts
;=================================================================================

FDZ1LoadSign:
		tst.w	dxFadeOff.w
		bne.s	loc_kumancey4
		command	cmd_FadeReset
		command	cmd_StopMus
		addq.b	#2,(Dynamic_resize_routine).w
		sf	(Black_Stretch_flag).w
		sf	(NoPause_flag).w
		sf	(Ctrl_1_locked).w

		lea	(PLC_Main7).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w

		st	(BackgroundEvent_flag).w		; load FDZ2

;		jsr	(Create_New_Sprite).w
;		bne.s	loc_kumancey4
;		move.l	#Obj_EndSignControl,(a1)
;		move.w	(Camera_X_pos).w,d2
;		addi.w	#$A0,d2
;		move.w	d2,x_pos(a1)


		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w

loc_kumancey4:
		rts
;=================================================================================

FDZ1Extended_Start:
		addq.b	#2,(Dynamic_resize_routine).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

FDZ1Extended_Wait:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		move.b	#$28,(Dynamic_resize_routine).w
		rts
;=================================================================================

Resize_FDZ2:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Headliss_Load_Routines(pc,d0.w),d0
		jmp     Headliss_Load_Routines(pc,d0.w)
;=================================================================================

Headliss_Load_Routines:
		dc.w  Check_Mid5-Headliss_Load_Routines ; 0
		dc.w  FDZ2_Fade-Headliss_Load_Routines ; 2
		dc.w  FDZ2_LoadGluttony-Headliss_Load_Routines ; 4
		dc.w  loc_DasIstSoil2-Headliss_Load_Routines ; 6
		dc.w  FDZ2_Fade1-Headliss_Load_Routines ; 8
		dc.w  Check_End5-Headliss_Load_Routines ; A
		dc.w  Load_GFX5-Headliss_Load_Routines ; C
		dc.w  Load_Boss_Headliss-Headliss_Load_Routines ; E
		dc.w  FDZ2_MoveCamera-Headliss_Load_Routines
		dc.w  Load_Boss_Headliss2-Headliss_Load_Routines ; 10
		dc.w  FDZ2_MoveCamera-Headliss_Load_Routines ; 12 (VERY IMPORTANT!!!!!!!!!!!!!!!!!!)
		dc.w  FDZ2_StopCamera-Headliss_Load_Routines
		dc.w  FDZ2_Return-Headliss_Load_Routines
		dc.w  FDZ2_StartCutscene-Headliss_Load_Routines
		dc.w  FDZ2_Cutscene-Headliss_Load_Routines
		dc.w  FDZ2_Return-Headliss_Load_Routines
		dc.w  FDZ2_Fade2-Headliss_Load_Routines
		dc.w  FDZ2_CheckEnd-Headliss_Load_Routines
		dc.w  FDZ2_LoadHeadlissScene-Headliss_Load_Routines
		dc.w  FDZ2_Return-Headliss_Load_Routines
		dc.w  FDZ2_DistExplosionStart-Headliss_Load_Routines
		dc.w  FDZ2_DistExplosion-Headliss_Load_Routines
		dc.w  FDZ2_BreakDist-Headliss_Load_Routines
		dc.w  FDZ2_LoadZone-Headliss_Load_Routines
		dc.w  FDZ2_Return-Headliss_Load_Routines
;=================================================================================


Check_Mid5:
		cmpi.w  #$1209,(Camera_x_pos).w
		blt.s	++
		cmpi.w	#1,(AstarothCompleted).w
		beq.w	+++
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		fadeout					; fade out music

+		move.w	#$1209,(Camera_min_X_pos).w
		move.w	#$1209,(Camera_max_X_pos).w
        move.w  #$246,d0
		move.w	d0,(Camera_target_max_Y_pos ).w
		lea	(Pal_Gluttony).l,a1
		jsr	(PalLoad_Line1).w
		lea	(ArtKosM_Gluttony).l,a1
		move.w	#tiles_to_bytes($3A0),d2
		jsr	(Queue_Kos_Module).w
		addq.b	#2,(Dynamic_resize_routine).w
+		rts

+		move.b	#$A,(Dynamic_resize_routine).w
		rts

FDZ2_Fade:
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		tst.w	dxFadeOff.w
		bne.w	loc_DasIstSoil
+		move.w	(Camera_y_pos).w,d0
		cmpi.w	#$246,d0
		bne.w	FDZ2_Return
		addq.b	#2,(Dynamic_resize_routine).w
		samp	sfx_GluttonySpew
		move.b  #$00,(Check_GluttonyDead).w

FDZ2_LoadGluttony:
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		music	mus_Microboss, 0
		command	cmd_FadeReset

+		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		move.b	#1,(MidBoss_flag).w
        move.w  #$246,d0
		move.w	d0,(Camera_min_Y_pos).w
		jsr	(SingleObjLoad).w
		bne.w	loc_DasIstSoil
		move.l	#Obj_Gluttony,(a1)	;
		move.w	#$1500,obX(a1)	; X-position
		move.w	#$2E9,obY(a1)	; Y-position
		addq.b	#2,(Dynamic_resize_routine).w

loc_DasIstSoil2:
		cmpi.b	#$01,(Check_GluttonyDead).w
		bne.w	loc_DasIstSoil
		clr.b	(MidBoss_flag).w
		move.b	#$00,(Check_GluttonyDead).w
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

FDZ2_Fade1:
		tst.w	dxFadeOff.w
		bne.w	loc_DasIstSoil
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   loc_DasIstSoil
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$5C4,(Camera_target_max_Y_pos).w
		move.w	#$1DF0,(Camera_max_X_pos).w
		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset

Check_End5:
		cmpi.w	#$1C60,(Camera_x_pos).w
		blt.w	loc_DasIstSoil
		move.w	#$1C60,(Camera_min_X_pos).w
		move.w	#$1C60,(Camera_max_X_pos).w
                move.w  #$130,d0
                move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w

Load_GFX5:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$98,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s	+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------

+		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		sf	(Ctrl_1_locked).w
		lea	(Pal_Headliss).l,a1
		jsr	(PalLoad_Line1).w
		move.b	#1,(Lust_Cutscene).w
		lea	(ArtKosM_Headliss).l,a1
		move.w	#tiles_to_bytes($3A0),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_Feal).l,a1
		move.w	#tiles_to_bytes($420),d2
		jsr	(Queue_Kos_Module).w
		fadeout					; fade out music

Load_Boss_Headliss:
		cmpi.w	#$130,(Camera_y_pos).w
		bne.w	loc_DasIstSoil
		addq.b	#2,(Dynamic_resize_routine).w
		addq.b	#2,(BackgroundEvent_routine).w
		move.w	#$130,(Camera_min_Y_pos).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#4,subtype(a1)
		move.l	#Pal_FDZ_Red+$40,$30(a1)
		move.w	#Normal_palette_line_4,$34(a1)
		move.w	#16-1,$38(a1)
+		rts
;=================================================================================

Load_Boss_Headliss2:
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#60,(CutsceneTimer).w
		move.b	#1,(Boss_flag).w
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		jsr	(SingleObjLoad).w
		bne.s	FDZ2_MoveCamera
		move.l	#Obj_Headliss,(a1)				; load FDZ megaboss
		move.w	#$1D29,obX(a1)					; X-position
		move.w	#$12F,obY(a1)					; Y-position

FDZ2_MoveCamera:
		rts
;=================================================================================

FDZ2_StopCamera:
		move.w	(Camera_x_pos).w,d0
		move.w	d0,(Camera_min_x_pos).w
		move.w	d0,(Camera_max_x_pos).w
		fadeout					; fade out music
		move.b	#$00,(Check_dead).w
		clr.w	(AstarothCompleted).w
		addq.b	#2,(Dynamic_resize_routine).w

FDZ2_Return:
		rts
;=================================================================================

FDZ2_StartCutscene:
		addq.b	#6,(Dynamic_resize_routine).w
		st	(Level_end_flag).w
		rts

;		st	(Ctrl_1_locked).w
;		clr.w	(Ctrl_1_logical).w
;		st	(NoPause_flag).w
;		st	(Level_end_flag).w

FDZ2_Cutscene:
;		lea	(Player_1).w,a1
;		btst	#Status_InAir,status(a1)
;		bne.s	FDZ2_Return
;		addq.b	#4,(Dynamic_resize_routine).w
		rts




;		clr.w	(Ctrl_1_logical).w
;		move.b	#$81,object_control(a1)
;		move.w	#id_LookUp<<8,anim(a1)
;		bclr	#Status_Facing,status(a1)
;		jsr	(Stop_Object).w
;		lea	(ArtKosM_BlackStretch).l,a1
;		move.w	#tiles_to_bytes($520),d2
;		jsr	(Queue_Kos_Module).w
;		jsr	(Load_BlackStretch).l
;		jsr	(Create_New_Sprite).w
;		bne.s	+
;		move.l	#Obj_Dialog_Process,(a1)
;		move.b	#_FDZ2,routine(a1)
;		move.l	#DialogFDZ2_Process_Index-4,$34(a1)
;		move.b	#(DialogFDZ2_Process_Index_End-DialogFDZ2_Process_Index)/8,$39(a1)
;+		rts
;=================================================================================

FDZ2_Fade2:
		tst.w	dxFadeOff.w
		bne.w	loc_DasIstSoil
		command	cmd_FadeReset
		command	cmd_StopMus

		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		st	$40(a1)
		st	$41(a1)
+		st	(Level_end_flag).w
		st	NoBackgroundEvent_flag.w		; NAT: This is controlled by this routine instead.
		st	LastAct_end_flag.w			; also set this flag so that the title cards are not loaded immediately.
		addq.b	#2,(Dynamic_resize_routine).w

		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_FDZ+$40,$30(a1)
		move.w	#Normal_palette_line_4,$34(a1)
		move.w	#16-1,$38(a1)
+

loc_DasIstSoil:
		rts
;=================================================================================

FDZ2_CheckEnd:
		tst.b	(Level_end_flag).w
		bne.s	loc_DasIstSoil
		addq.b	#2,(Dynamic_resize_routine).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
		st	(NoPause_flag).w
		lea	(Pal_Headliss).l,a1
		jsr	(PalLoad_Line1).w
		lea	(ArtKosM_Headliss).l,a1
		move.w	#tiles_to_bytes($3A0),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_Feal).l,a1
		move.w	#tiles_to_bytes($420),d2
		jmp	(Queue_Kos_Module).w
;=================================================================================

FDZ2_LoadHeadlissScene:
		addq.b	#2,(Dynamic_resize_routine).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_HeadlissCutScene,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$E0,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$00,d2
		move.w	d2,y_pos(a1)
+		rts
;=================================================================================

PLC_Explosion: plrlistheader
		plreq $500, ArtKosM_Explosion
PLC_Explosion_End

PLC_ExplosionFDZ2: plrlistheader
		plreq $578, ArtKosM_Explosion
PLC_ExplosionFDZ2_End
;=================================================================================

FDZ2_DistExplosionStart:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(PLC_ExplosionFDZ2).l,a5
		jsr	(LoadPLC_Raw_KosM).w
+		move.w	#2*60,(Demo_timer).w
-		rts
;=================================================================================

FDZ2_DistExplosion:
		btst	#0,(Level_frame_counter+1).w
		beq.s	+
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_DialogueFirebrand_Fire,(a1)
		move.w	#$578,$30(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$E0,d2
		move.w	d2,y_pos(a1)
		move.b	#224/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)

+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge,0

+		cmp.w	#8,Demo_timer.w				; NAT: open the floor a little earlier
		bne.s	+
		clr.w	Camera_min_x_pos.w			; set camera boundaries.
		move.w	#$180,Camera_max_x_pos.w		; Camera can only move downwards, nowhere else
		clr.w	Camera_min_y_pos.w
		move.w	#$600,Camera_max_y_pos.w

		clr.w	Player_1+x_vel.w
		clr.w	Player_1+ground_vel.w
		clr.b	Player_1+$3D.w				; delete that spindash!
		move.w	#2,Transition_Zone.w			; update transition zone to act 3
		addq.b	#1,ScreenEvent_flag.w			; reload foreground only
		st	Sonic_NoKill.w
		clr.b	(Ctrl_1_locked).w

		move.l	#Null_Sprites,d0			; disable object loading for the cutscene
		move.l	d0,Object_load_addr_front.w
		move.l	d0,Object_load_addr_back.w
		move.l	#Null_Rings,d0			; disable rings loading for the cutscene
		move.l	d0,Ring_start_addr_ROM.w		; also disable ring loading
		move.l	d0,Ring_end_addr_ROM.w

		lea	(Layout_FDZ2_CutScene).l,a0
		bsr.w	Load_Level2
		moveq	#palid_FDZ,d0
		jsr	LoadPalette_Immediate			; reload palette (FDZ2 end boss changes it)

		lea	(PLC1_FDZ3_Misc).l,a5			; reload graphics (Rain)
		jsr	(LoadPLC_Raw_KosM).w


;		move.w	Player_1+x_pos.w,d0			; get player x-pos to d0
;		and.w	#$FF80,d0					; keep in range of $100 pixels (we want slight variability of x-pos to make transition nicer)
;		sub.w	#$80+$80,d0				; center around the 3 chunks we laid out... This is our x-offset now!


		move.w	(Camera_X_pos).w,d0			; x-offset
		andi.w	#$FF80,d0
		move.w	#$100,d1					; y-offset
		jsr	Reset_ObjectsPosition2			; move objects backwards, so they line up with act 3

+		tst.w	(Demo_timer).w
		bne.s	+
		addq.b	#2,(Dynamic_resize_routine).w
+		move.w	#30,(Grounder_Alive).w

FDZ2_DistExplosion_rts:
		rts
;=================================================================================

FDZ2_BreakDist:
		move.b	#id_Hurt,Player_1+anim.w		; put Sonic in the hurting animatiom for the cutscene
		subq.w	#1,(Grounder_Alive).w
		bne.s	FDZ2_DistExplosion_rts

		jsr	Create_New_Sprite			; create new object
		bne.s	FDZ2_DistExplosion_rts			; if we can't load it... Umm, well shit
		move.l	#Obj_TitleCard,address(a1)		; we want to delay the title card object a bit
		st	$3E(a1)					; set it as transition title card
		st	$40(a1)					; load graphics

		clr.b	(NoPause_flag).w
		clr.w	Screen_shaking_flag.w			; stop screen shaking effect
		addq.b	#2,(Dynamic_resize_routine).w
		rts
;=================================================================================

FDZ2_LoadZone:
		lea	Player_1+x_pos.w,a1			; we want to limit Sonic's x-position so he does not land on floors
		cmp.w	#$94,(a1)				; check for left side
		bhs.s	.nominx					; if more than specified, do not move Sonic
		move.w	#$94,(a1)				; limit player's position
		clr.w	Player_1+x_vel.w			; clear horizontal velocity

.nominx		cmp.w	#$1F4,(a1)				; check for right side
		bls.s	.nomaxx					; if less than specified, do not move Sonic
		move.w	#$1F4,(a1)				; limit player's position
		clr.w	Player_1+x_vel.w			; clear horizontal velocity

.nomaxx
		move.b	#id_Hurt,Player_1+anim.w		; put Sonic in the hurting animatiom for the cutscene
		cmp.w	#$E00,Player_1+y_vel.w			; check if Sonic is moving too fast down
		ble.s	.nocap					; if not, do not cap
		move.w	#$E00,Player_1+y_vel.w			; cap Sonic's vertical velocity

.nocap
		tst.b	BackgroundEvent_flag.w			; check if we have yet to transition
		beq.s	.chk					; if not, branch
		cmp.w	#$300,Camera_y_pos.w			; check if we are low enough to wrap back up
		blt.s	.rts					; if not, skip

		moveq	#0,d0					; x-offset
		move.w	#$100,d1				; y-offset
		jmp	Reset_ObjectsPosition2			; move objects upwards, so that we can never run out of the corridor! Very important.

.chk		cmp.w	#$200,Camera_y_pos.w			; check if we are low enough to finally load act 3
		sge	BackgroundEvent_flag.w			; if yes, set transition flag

.rts		rts
	;	tst.b	(Player_1+render_flags).w
	;	bmi.s	FDZ2_BreakDist_Return
	;	addq.b	#2,(Dynamic_resize_routine).w
	;	moveq	#2,d0
	;	jmp	(StartNewLevel).l
;=================================================================================

Resize_FDZ3:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Mecha_Load_Routines(pc,d0.w),d0
		jmp     Mecha_Load_Routines(pc,d0.w)
;=================================================================================

Mecha_Load_Routines:
		dc.w  FDZ3_Init-Mecha_Load_Routines
		dc.w  FDZ3_InitialFall-Mecha_Load_Routines
		dc.w  FDZ3_SmoothPalette-Mecha_Load_Routines
		dc.w  Check_Mid6-Mecha_Load_Routines
		dc.w  FDZ3_Fade-Mecha_Load_Routines
		dc.w  FDZ3_LoadAstaroth-Mecha_Load_Routines
		dc.w  Astaroth_Death-Mecha_Load_Routines
		dc.w  Astaroth_Death2-Mecha_Load_Routines
		dc.w  Check_End6-Mecha_Load_Routines
		dc.w  Load_GFX6-Mecha_Load_Routines
		dc.w  Load_GFX6_additional-Mecha_Load_Routines
		dc.w  CameraMoveUp6-Mecha_Load_Routines
		dc.w  Load_Boss_EvilEye-Mecha_Load_Routines
		dc.w  FDZ3_WaitFor-Mecha_Load_Routines
		dc.w  FDZ3_Fade2-Mecha_Load_Routines
		dc.w  StartFDZ3Cutscene_SetWaitFlag-Mecha_Load_Routines
		dc.w  StartFDZ3Cutscene_SetFlag-Mecha_Load_Routines
		dc.w  StartFDZ3Cutscene-Mecha_Load_Routines
		dc.w  FDZ3Cutscene_LoadProcess-Mecha_Load_Routines
		dc.w  loc_Uk-Mecha_Load_Routines
		dc.w  FDZ3_SetFade2-Mecha_Load_Routines
		dc.w  FDZ3_Fade2-Mecha_Load_Routines
		dc.w  FDZ3_Fade3-Mecha_Load_Routines
		dc.w  loc_Uk-Mecha_Load_Routines
;=================================================================================

FDZ3_Init:
		addq.b	#2,(Dynamic_resize_routine).w
		addq.w	#1,Player_1+y_vel.w			; make sure the check below works correctly

FDZ3_InitialFall:
		cmp.w	#$E00,Player_1+y_vel.w			; check if Sonic is moving too fast down
		ble.s	.nocap					; if not, do not cap
		move.w	#$E00,Player_1+y_vel.w			; cap Sonic's vertical velocity

.nocap
		move.b	#id_Hurt,Player_1+anim.w		; set player to the hurting animation
		tst.w	Player_1+y_vel.w			; check if player landed on floor
		bne.s	.noset					; if not, delay still
		addq.b	#2,(Dynamic_resize_routine).w
.noset		rts
;=================================================================================

FDZ3_SmoothPalette:
		cmpi.w  #$200,(Camera_x_pos).w
		blt.w	FDZ3_Fade_Return
		addq.b	#2,(Dynamic_resize_routine).w
		samp	sfx_ThunderLightning
		move.b	#4,(Hyper_Sonic_flash_timer).w
		st	FDZ3Rain_Spawn.w

FDZ3_LoadRainPalette:
		lea	(Pal_FDZ3).l,a1
		jsr	(PalLoad_Line1).w

FDZ3_LoadRainPalette2:
		lea	(Pal_FDZ3_Rain).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_SonicFDZRain).l,a1
		jmp	(PalLoad_Line0).w
;=================================================================================

Check_Mid6:
		cmpi.w  #$1A1F,(Camera_x_pos).w
		blt.w   loc_kumancey
		sf	(FDZ3Rain_Process).w
		sf	FDZ3Rain_Spawn.w

		lea	(Pal_FDZ+$20).l,a1
		jsr	(PalLoad_Line2).w
		lea	(Pal_SonicFDZ).l,a1		; AF: Load normal sonic palette
		jsr	(PalLoad_Line0).w

		cmpi.w	#1,(AstarothCompleted).w
		beq.w	+
		lea	(Pal_Astaroth).l,a1
		jsr	(PalLoad_Line1).w
		move.w	#$1A1F,(Camera_min_X_pos).w
		move.w	#$1A1F,(Camera_max_X_pos).w
                move.w  #$138,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		lea	(ArtKosM_Astaroth).l,a1
		move.w	#tiles_to_bytes($340),d2
		jsr	(Queue_Kos_Module).w
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w

FDZ3_Fade_Return:
		rts

+		move.b	#$10,(Dynamic_resize_routine).w
		rts

FDZ3_Fade:
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		tst.w	dxFadeOff.w
		bne.s	FDZ3_Fade_Return
+		addq.b	#2,(Dynamic_resize_routine).w
		rts

FDZ3_LoadAstaroth:
		move.b  #0,(Check_GluttonyDead).w
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		music	mus_Microboss, 0
		command	cmd_FadeReset

+		jsr	(SingleObjLoad).w
		bne.w	loc_kumancey
		move.l	#Obj_Astaroth,(a1)
		move.w	#$1C00,obX(a1)	; X-position
		move.w	#$1F2,obY(a1)	; Y-position
		move.b	#1,(MidBoss_flag).w
		addq.b	#2,(Dynamic_resize_routine).w

Astaroth_Death:
		cmpi.b  #1,(Check_GluttonyDead).w
		bne.s	Astaroth_Death2_return
		move.b  #0,(Check_GluttonyDead).w
		fadeout					; fade out music
		clr.b	(MidBoss_flag).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts

Astaroth_Death2:
		tst.w	dxFadeOff.w
		bne.s	Astaroth_Death2_return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.s   Astaroth_Death2_return
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Camera_min_Y_pos).w
		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w
		move.w	#$338,(Camera_target_max_Y_pos ).w
		move.w	#$2000,(Camera_max_X_pos).w
		command	cmd_FadeReset
		jmp	(Obj_PlayLevelMusic).w

Astaroth_Death2_return:
		rts

Check_End6:
		cmpi.w  #$2000,(Camera_x_pos).w
		blt.w   loc_kumancey
		move.w	#$2000,(Camera_min_X_pos).w
		move.w	#$2000,(Camera_max_X_pos).w
                move.w  #$B0,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos ).w
		move.b  #1,(Firebrand_InterlPassed).w
		addq.b	#2,(Dynamic_resize_routine).w
		lea	Arthur_Rings(pc),a1
		jmp	(Set_LostRings).w

Load_GFX6:
		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

Load_GFX6_additional:
		tst.w	dxFadeOff.w
		bne.s	Load_GFX6_additional_Return
		addq.b	#2,(Dynamic_resize_routine).w
		tst.b	(FDZ3Rain_Process).w
		beq.s	Load_GFX6_additional_Return
		sf	(FDZ3Rain_Process).w
		sf	FDZ3Rain_Spawn.w
		lea	(Pal_FDZ+$20).l,a1
		jmp	(PalLoad_Line2).w

Load_GFX6_additional_Return:
		rts

CameraMoveUp6:
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#80,(CutsceneTimer).w
		move.w	#0,(Check_dead).w
		music	mus_Boss1
		command	cmd_FadeReset

Load_Boss_EvilEye:
		subq.w	#1,(CutsceneTimer).w
		bpl.w	loc_Uk
		addq.b	#2,(Dynamic_resize_routine).w
		move.b   #1,(Boss_flag).w
		lea	(ArtKosM_EvilEye).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	Queue_Kos_Module
		jsr	(Create_New_Sprite).w			;
		move.l	#Obj_EvilEye,(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		add.w	#$19E,obX(a1)
		move.w	(Camera_target_max_Y_pos).w,obY(a1)
		add.w	#$60,obY(a1)
		lea	(Pal_EvilEye).l,a1
		jsr	(PalLoad_Line1).w

FDZ3_WaitFor:
		cmpi.w	#1,(Check_dead).w
		bne.s	+
		move.w	#0,(Check_dead).w
		fadeout					; fade out music
		clr.w	(AstarothCompleted).w
		addq.b	#2,(Dynamic_resize_routine).w
+		rts

FDZ3_Fade2:
		tst.w	dxFadeOff.w
		bne.s	+
		addq.b	#2,(Dynamic_resize_routine).w
+		rts
; =======================================================================================

StartFDZ3Cutscene_SetWaitFlag:
		addi.b	#$A,(Dynamic_resize_routine).w
		st	(Level_end_flag).w
		rts

		st	(NoPause_flag).w
		lea	(Pal_Gloamglozer).l,a1
		jsr	(PalLoad_Line1).w
		lea	(ArtKosM_Gloamglozer).l,a1
		move.w  #tiles_to_bytes($3A0),d2
		jmp     (Queue_Kos_Module).w
; ---------------------------------------------------------------------------

StartFDZ3Cutscene_SetFlag:
		addq.b	#2,(Dynamic_resize_routine).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
		rts
; =======================================================================================

StartFDZ3Cutscene:
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		jmp	(Load_BlackStretch).l
; =======================================================================================

FDZ3Cutscene_LoadProcess:
		addq.b	#2,(Dynamic_resize_routine).w
		move.b	#0,(Grounder_Alive).w
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_FDZ3_Process,(a1)
+		rts
; =======================================================================================

FDZ3_SetFade2:
		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		rts
; =======================================================================================

FDZ3_Fade3:
		tst.w	dxFadeOff.w
		bne.s	loc_Uk
		command	cmd_FadeReset
		command	cmd_StopMus

		addq.b	#2,(Dynamic_resize_routine).w
		sf	(Black_Stretch_flag).w
		sf	(NoPause_flag).w
		sf	(Ctrl_1_locked).w
		jsr	(Create_New_Sprite).w
		bne.s	loc_Uk
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)

loc_Uk:
		rts
; =======================================================================================

Resize_FDZ4:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Gloamglozer_Load_Routines(pc,d0.w),d0
		jmp     Gloamglozer_Load_Routines(pc,d0.w)

Gloamglozer_Load_Routines:
		dc.w  Check_End_Of_Forest0-Gloamglozer_Load_Routines
		dc.w  Check_End_Of_Forest-Gloamglozer_Load_Routines
		dc.w  Check_End_Of_Forest01-Gloamglozer_Load_Routines
		dc.w  Check_End_Of_Forest001-Gloamglozer_Load_Routines
		dc.w  Check_End_Of_Forest1-Gloamglozer_Load_Routines
		dc.w  Resize_FDZ4_SpringKeep-Gloamglozer_Load_Routines
		dc.w  Resize_FDZ4_CreateThisFuckinSignFade-Gloamglozer_Load_Routines
		dc.w  Resize_FDZ4_CreateThisFuckinSign-Gloamglozer_Load_Routines
		dc.w  Resize_FDZ4_Return2-Gloamglozer_Load_Routines

Check_End_Of_Forest0:
		cmpi.w  #$150,(Camera_x_pos).w
		blt.w   Resize_FDZ4_Return
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(ArtKosM_Chesire).l,a1
		move.w	#tiles_to_bytes($380),d2
		jsr	(Queue_Kos_Module).w
		lea	(Pal_Chesire).l,a1
		jsr	(PalLoad_Line1).w
		jsr	(SingleObjLoad).w
		bne.w	Resize_FDZ4_Return
		move.l	#Obj_ChesireLock,(a1)
		move.w	#$360,obX(a1)
		move.w	#$113,obY(a1)

Check_End_Of_Forest:
		cmpi.w  #$2C0,(Camera_x_pos).w
		blt.w   Resize_FDZ4_Return
		move.w	#$2C0,(Camera_min_X_pos).w
		move.w	#$2C0,(Camera_max_X_pos).w
                move.w  #$B0,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		move.w	#0,(Grounder_Alive).w
		addq.b	#2,(Dynamic_resize_routine).w

Check_End_Of_Forest01:
		cmpi.w	#1,(Grounder_Alive).w
		bne.w	Resize_FDZ4_SpringKeep
		tst.w	dxFadeOff.w
		bne.w	Resize_FDZ4_SpringKeep
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#0,(Grounder_Alive).w

		music	mus_Gloam2
		command	cmd_FadeReset
		rts
; ---------------------------------------------------------------------------

Check_End_Of_Forest001:
		cmpi.w	#1,(DialogueAlreadyShown).w
		beq.w   +++
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$6F,d0
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
		clr.w	(Ctrl_1_logical).w
+		addq.b	#2,(Dynamic_resize_routine).w

Resize_FDZ4_Return:
		rts
; ---------------------------------------------------------------------------

Check_End_Of_Forest1:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Pal_Gloamglozer).l,a1
		jsr	(PalLoad_Line1).w

		cmpi.w	#1,(DialogueAlreadyShown).w
		beq.w	+
		move.b	#1,(Lust_Cutscene).w

		st	(NoPause_flag).w
		st	(Level_end_flag).w
		lea (ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	Queue_Kos_Module
		jsr	(Load_BlackStretch).l

+		jsr	(SingleObjLoad).w
		bne.s	Resize_FDZ4_SpringKeep
		move.l	#Obj_Gloamglozer,(a1)	; load FDZ megaboss
		move.w	#$3D8,obX(a1)
		move.w	#$113,obY(a1)

Resize_FDZ4_SpringKeep:
		rts
; ===========================================================

Resize_FDZ4_CreateThisFuckinSignFade:
		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		rts
; ===========================================================

Resize_FDZ4_CreateThisFuckinSign:
		tst.w	dxFadeOff.w
		bne.w	Resize_FDZ4_Return2
		command	cmd_FadeReset
		command	cmd_StopMus

		st	(NoBackgroundEvent_flag).w
		move.w	#4,(Transition_Zone).w

		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
+		addq.b	#2,(Dynamic_resize_routine).w

Resize_FDZ4_Return2:
		rts
; ===========================================================

Resize_SCZ1:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Honey_Load_Routines(pc,d0.w),d0
		jmp     Honey_Load_Routines(pc,d0.w)

Honey_Load_Routines:
		dc.w  SCZ1_CheckMid-Honey_Load_Routines						; 00
		dc.w  SCZ1_LoadBlueSkeleton-Honey_Load_Routines				; 02
		dc.w  loc_bartney-Honey_Load_Routines						; 04
		dc.w  SCZ1_FadeOut-Honey_Load_Routines						; 06
		dc.w  SCZ1_FadeIn_AfterBlueSkeleton-Honey_Load_Routines		; 08
		dc.w  SCZ1_FadeIn_AfterBlueSkeleton2-Honey_Load_Routines	; 0A
		dc.w  SCZ1_Load_Death-Honey_Load_Routines					; 0C
		dc.w  SCZ1_Check_End-Honey_Load_Routines					; 0E
		dc.w  SCZ1_Sonic_Position-Honey_Load_Routines				; 10
		dc.w  loc_bartney-Honey_Load_Routines						; 12
		dc.w  SCZ1_Honey_Load_GFX-Honey_Load_Routines				; 14
		dc.w  SCZ1_Load_Boss_Honey-Honey_Load_Routines				; 16
		dc.w  SCZ1_MoreDialog-Honey_Load_Routines					; 18
		dc.w  loc_bartney-Honey_Load_Routines						; 1A
		dc.w  loc_bartney-Honey_Load_Routines						; 1C
		dc.w  SCZ1_FadeOut-Honey_Load_Routines						; 1E
		dc.w  SCZ1_FadeIn-Honey_Load_Routines						; 20
		dc.w  loc_bartney-Honey_Load_Routines						; 22
;--------------------------------------------------------------------------------------------------
AccordingToAllKnownPhysicsLawsWhenYouTeleportFromVoidToZoneWithoutFloorUnderYourLegsYouShouldFall:
		addq.b	#2,(Dynamic_resize_routine).w
                rts

RoughLanding:
		lea (Player_1).w,a1
		cmpi.w	#$2F0,obY(a1)
		blt.w	loc_bartney
		move.b	#0,(SCZ1_Cutscene).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts
;--------------------------------------------------------------------------------------------------

SCZ1_CheckMid:
		tst.w	(AstarothCompleted).w
		bne.s	.jmp
		move.w	#$2228,d0
		cmp.w	(Camera_X_pos).w,d0
		bhi.w	loc_bartney
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		move.w	#$200,d0
		move.w	d0,(Camera_target_max_Y_pos).w
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
		move.w	d0,(Camera_min_Y_pos).w

		; load boss art
		lea	(PLC_BossTwoFaces).l,a5
		jsr	(LoadPLC_Raw_KosM).w

		; return rings
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w

		fadeout	; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts
;--------------------------------------------------------------------------------------------------

.jmp
		move.b	#$0A,(Dynamic_resize_routine).w

.return
                rts
;--------------------------------------------------------------------------------------------------

SCZ1_LoadBlueSkeleton:
		tst.w	dxFadeOff.w
		bne.w	loc_bartney
		music	mus_Microboss
		command	cmd_FadeReset

		; load boss TwoFaces
		jsr	(SingleObjLoad).w
		bne.w	loc_cjompy
		move.l	#Obj_BossTwoFaces,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a1)

		addq.b	#2,(Dynamic_resize_routine).w
		rts
;--------------------------------------------------------------------------------------------------

SCZ1_FadeIn_AfterBlueSkeleton:
		tst.w	dxFadeOff.w
		bne.w	loc_bartney

                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   loc_bartney

		; restore art
		lea	(PLC1_SCZ1_Misc).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC2_SCZ1_Enemy).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_Main7).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_MainSCZ).l,a5
		jsr	(LoadPLC_Raw_KosM).w

		move.w	#$5600,(Camera_max_X_pos).w
		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w
		rts

SCZ1_FadeIn_AfterBlueSkeleton2:
		cmpi.w  #$253F,(Camera_X_pos).w
		blt.s		SCZ1_FadeIn_AfterBlueSkeleton2_Return
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$800,(Camera_target_max_Y_pos).w

SCZ1_FadeIn_AfterBlueSkeleton2_Return:
		rts

SCZ1_Load_Death:
		move.w	#$5400,d0
		cmp.w	(Camera_X_pos).w,d0
		bgt.s	SCZ1_FadeIn_AfterBlueSkeleton2_Return
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$488,(Camera_target_max_Y_pos).w
		cmpi.w	#2,(AstarothCompleted).w
                beq.w   +

; load cutscene
		lea	(Pal_Death).l,a1
		jsr	(PalLoad_Line1).w
		jsr	(SingleObjLoad).w
		bne.s	SCZ1_FadeIn_AfterBlueSkeleton2_Return
		move.l	#Obj_SCZ1Death,address(a1)
		move.w	(Camera_max_X_pos).w,d0
		addi.w	#$100,d0
		move.w	d0,obX(a1)
		move.w	(Camera_target_max_Y_pos).w,d0
		addi.w	#$88,d0
		move.w	d0,obY(a1)
                bchg    #0,obStatus(a1)
+		addq.b	#2,(Dynamic_resize_routine).w

SCZ1_Check_End:
		move.w	#$5600,d0
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		cmp.w	(Camera_X_pos).w,d0
		bne.s	SCZ1_FadeIn_AfterBlueSkeleton2_Return
		move.w	d0,(Camera_min_X_pos).w
		move.w	#$488,(Camera_min_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		st	(NoPause_flag).w
		st	(Level_end_flag).w
		st	(Boss_flag).w
		st	(Ctrl_1_locked).w

SCZ1_Sonic_Position:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$80,d0
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
		clr.w	(Ctrl_1_logical).w
		fadeout					; fade out music
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		cmpi.w	#2,(AstarothCompleted).w
                beq.w   .skip
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		jsr	(Load_BlackStretch).l
                addq.b	#2,(Dynamic_resize_routine).w

		; load dialog
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_SCZ1start1,routine(a1)

		; load main dialog
		move.l	#DialogSCZ1start1_Process_Index-4,$34(a1)
		move.b	#(DialogSCZ1start1_Process_Index_End-DialogSCZ1start1_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	.return

		; load alt dialog
		move.l	#DialogSCZ1start1_EX_Process_Index-4,$34(a1)
		move.b	#(DialogSCZ1start1_EX_Process_Index_End-DialogSCZ1start1_EX_Process_Index)/8,$39(a1)


.return
		rts
; ---------------------------------------------------------------------------

.skip
                addq.b	#4,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

SCZ1_Honey_Load_GFX:
		lea	(Pal_Honey).l,a1
		jsr	(PalLoad_Line1).w
		lea	(ArtKosM_Honey).l,a1
		move.w	#tiles_to_bytes($308),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($59C),d2
		jsr	(Queue_Kos_Module).w
		addq.b	#2,(Dynamic_resize_routine).w

SCz1_Load_Boss_Honey:
		tst.w	dxFadeOff.w
		bne.w	loc_bartney
		jsr	(SingleObjLoad).w
		bne.w	loc_bartney
		move.l	#Obj_Honey,(a1)	; Load SCZ1 boss
		move.w	(Camera_x_pos).w,d0
	;	addi.w	#$100,d0
		move.w	d0,obX(a1)
		move.w	(Camera_min_Y_pos).w,d0
		subi.w	#$10,d0
		move.w	d0,obY(a1)
		cmpi.w	#2,(AstarothCompleted).w
                beq.w   +
                addq.b	#2,(Dynamic_resize_routine).w
                rts
+               move.b	#$1C,(Dynamic_resize_routine).w
                rts
; ---------------------------------------------------------------------------

SCZ1_MoreDialog:
		move.w	#2,(AstarothCompleted).w
		addq.b	#2,(Dynamic_resize_routine).w
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_SCZ1start2,routine(a1)

		; load main dialog
		move.l	#DialogSCZ1start2_Process_Index-4,$34(a1)
		move.b	#(DialogSCZ1start2_Process_Index_End-DialogSCZ1start2_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	.return

		; load alt dialog
		move.l	#DialogSCZ1start2_EX_Process_Index-4,$34(a1)
		move.b	#(DialogSCZ1start2_EX_Process_Index_End-DialogSCZ1start2_EX_Process_Index)/8,$39(a1)

.return
		rts
; ---------------------------------------------------------------------------

SCZ1_FadeIn:
		tst.w	dxFadeOff.w
		bne.s	loc_bartney
		command	cmd_FadeReset
		command	cmd_StopMus

		lea	(PLC_MainSCZ).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
		jsr	(Create_New_Sprite).w
		bne.s	loc_bartney
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		clr.w	(AstarothCompleted).w
		addq.b	#2,(Dynamic_resize_routine).w

loc_bartney:
		rts

SCZ1_FadeOut:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

; =======================================================================================
Resize_SCZ2:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Firehead_Load_Routines(pc,d0.w),d0
		jmp     Firehead_Load_Routines(pc,d0.w)
; =======================================================================================

Firehead_Load_Routines:
		dc.w  SCZ2_CheckMid-Firehead_Load_Routines
		dc.w  SCZ2_Load_Firebrand-Firehead_Load_Routines
		dc.w  loc_cjompy-Firehead_Load_Routines
		dc.w  SCZ2_FadeOut-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterFirebrand-Firehead_Load_Routines
		dc.w  SCZ2_CheckEnd-Firehead_Load_Routines
		dc.w  SCZ2_CheckEnd2-Firehead_Load_Routines
		dc.w  SCZ2_LoadFireHead-Firehead_Load_Routines
		dc.w  loc_cjompy-Firehead_Load_Routines
		dc.w  SCZ2_FadeOut-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterFireHead-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterSign-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterSign_CheckPos-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterSign_CheckPos2-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterSign_CheckPos_NextLevel-Firehead_Load_Routines
		dc.w  SCZ2_Fade_AfterSign_CheckPos_Return-Firehead_Load_Routines
; =======================================================================================

SCZ2_CheckMid:
		cmpi.w  #$2120,(Camera_x_pos).w
		blt.w   loc_cjompy
		move.w	#$2120,(Camera_max_X_pos).w
		move.w	#$2120,(Camera_min_X_pos).w
                move.w  #$30,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		fadeout					; fade out music

		lea	(Pal_Firebrand).l,a1
		jsr	(PalLoad_Line1).w

		lea	(ArtKosM_FirebrandFlames).l,a1
		move.w	#tiles_to_bytes($3C0),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($410),d2
		jsr	(Queue_Kos_Module).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts

SCZ2_Load_Firebrand:
		tst.w	dxFadeOff.w
		bne.w	loc_cjompy

		music	mus_Microboss
		command	cmd_FadeReset

		jsr	(SingleObjLoad).w
		bne.w	loc_cjompy
		move.l	#Obj_Firebrand,(a1)	; load SCZ megaboss
		move.w (Camera_X_pos).w,d0
		add.w	#$188,d0
		move.w	d0,obX(a1)	; X-position?
		move.w (Camera_target_max_Y_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obY(a1)	; Y-position

		addq.b	#2,(Dynamic_resize_routine).w
		lea	Arthur_Rings(pc),a1
		jmp	(Set_LostRings).w

SCZ2_FadeOut:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

SCZ2_Fade_AfterFirebrand:
		tst.w	dxFadeOff.w
		bne.w	loc_cjompy
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   loc_cjompy
		lea	(Pal_SCZ2).l,a1
		jsr	(PalLoad_Line1).w
		lea	(PLC_MainSCZ).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
                move.w	#$2FA0,(Camera_max_X_pos).w
                clr.w	(Camera_min_Y_pos).w
                move.w	#$500,(Camera_target_max_Y_pos).w

		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w

SCZ2_CheckEnd:
		cmpi.w  #$2E80,(Camera_X_pos).w
		blt.s	SCZ2_CheckEnd2
                move.w	#$200,(Camera_target_max_Y_pos ).w
		addq.b	#2,(Dynamic_resize_routine).w

SCZ2_CheckEnd2:
		cmpi.w  #$2FA0,(Camera_X_pos).w
		bne.w   loc_cjompy
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		moveq	#$38,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w

		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

SCZ2_LoadFireHead:
		tst.w	dxFadeOff.w
		bne.w	loc_cjompy
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Boss1
		command	cmd_FadeReset

		; clear tiles for boss art
		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		locVRAM	tiles_to_bytes($320),VDP_control_port-VDP_control_port(a5)
		moveq	#0,d0
		moveq	#$20-1,d1

.clear
	rept 8
		move.l	d0,VDP_data_port-VDP_data_port(a6)
	endr
		dbf	d1,.clear
		enableIntsSave

		; load boss
		bsr.w	Create_New_Sprite
		bne.s	loc_cjompy
		move.l	#Obj_BossFireHead,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$108,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$108,d2
		move.w	d2,y_pos(a1)
		rts

SCZ2_Fade_AfterFireHead:
		tst.w	dxFadeOff.w
		bne.s	loc_cjompy
		command	cmd_FadeReset
		command	cmd_StopMus

		lea	(PLC_MainSCZ).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
		jsr	(Create_New_Sprite).w
		bne.s	loc_cjompy
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		st	$40(a1)
		st	$41(a1)
		st	(Level_end_flag).w
		st	NoBackgroundEvent_flag.w		; NAT: This is controlled by this routine instead.
		st	LastAct_end_flag.w			; also set this flag so that the title cards are not loaded immediately.
		addq.b	#2,(Dynamic_resize_routine).w

loc_cjompy:
		rts
; ----------------------------------------------------------------------------------

SCZ2_Fade_AfterSign:
		tst.b	(Level_end_flag).w
		bne.s	SCZ2_Fade_AfterSign_Return

		move.b	#2,Current_Act.w					; change to act 3
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		jsr	Create_New_Sprite					; create new object
		bne.s	.notfree							; if we can't load it... Umm, well shit
		move.l	#Obj_TitleCard,address(a1)			; we want to delay the title card object a bit
		st	$3E(a1)								; set it as transition title card
		st	$40(a1)								; load graphics

.notfree

		addq.b	#2,(Dynamic_resize_routine).w
                move.w	#$3680,(Camera_max_X_pos).w
		move.w	#$78,(Camera_target_max_Y_pos).w
		st	(Ctrl_1_locked).w
		move.w	#btnR<<8,(Ctrl_1_logical).w

SCZ2_Fade_AfterSign_Return:
		rts
; ----------------------------------------------------------------------------------

SCZ2_Fade_AfterSign_CheckPos:
		lea	(Player_1).w,a1
		move.w	x_pos(a1),d3
		addi.w	#16,d3
		jsr	SonicOnObjHitFloor2
		cmpi.w	#16,d1
		blt.s		SCZ2_Fade_AfterSign_CheckPos_Return
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#((btnC+btnR)<<8)|(btnC+btnR),(Ctrl_1_logical).w

SCZ2_Fade_AfterSign_CheckPos_Return:
		rts
; ----------------------------------------------------------------------------------

SCZ2_Fade_AfterSign_CheckPos2:
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#(btnC+btnR)<<8,(Ctrl_1_logical).w

SCZ2_Fade_AfterSign_CheckPos_NextLevel:
		cmpi.w  #$3500,(Camera_X_pos).w
		blo.s		SCZ2_Fade_AfterSign_CheckPos_Return

		addq.b	#2,(Dynamic_resize_routine).w
		st	(BackgroundEvent_flag).w		; load SCZ3

;		sf	(NoPause_flag).w
;		sf	(Ctrl_1_locked).w
;		clr.w	(Ctrl_1_logical).w

		rts
; =======================================================================================

Resize_SCZ3:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  Cerberus_Load_Routines(pc,d0.w),d0
		jmp     Cerberus_Load_Routines(pc,d0.w)
; =======================================================================================

Cerberus_Load_Routines:
		dc.w  Check_Mid3-Cerberus_Load_Routines
                dc.w  SCZ3_FadeOut-Cerberus_Load_Routines
		dc.w  Check_Mid3_Prepares-Cerberus_Load_Routines
		dc.w  Check_Mid3_LoadSoulless-Cerberus_Load_Routines
		dc.w  loc_IkHo-Cerberus_Load_Routines
                dc.w  Check_Mid3_LoadHeartlessGFX-Cerberus_Load_Routines
		dc.w  Check_Mid3_LoadHeartless-Cerberus_Load_Routines
	;	dc.w  Load_Fade-Cerberus_Load_Routines
	;	dc.w  Load_GFX3-Cerberus_Load_Routines
	;	dc.w  Load_Boss_Cerberus-Cerberus_Load_Routines
	;	dc.w  loc_IkHo-Cerberus_Load_Routines
	;	dc.w  Load_Fade-Cerberus_Load_Routines
	;	dc.w  Cerberus_createEndSign-Cerberus_Load_Routines
		dc.w  loc_IkHo-Cerberus_Load_Routines
                dc.w  SCZ3_FadeOut-Cerberus_Load_Routines
                dc.w  SCZ3_Fade_AfterSoulless-Cerberus_Load_Routines
		dc.w  loc_IkHo-Cerberus_Load_Routines
; =======================================================================================

Check_Mid3:
		cmpi.w  #$C00,(Camera_x_pos).w
		blt.w	loc_IkHo
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$C00,(Camera_min_X_pos).w
		move.w	#$C00,(Camera_max_X_pos).w
                move.w  #$1C0,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos ).w

		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($1D0),d2
		jsr	(Queue_Kos_Module).w
		lea	(ArtKosM_Soulless).l,a1
		move.w	#tiles_to_bytes($3D0),d2
		jsr	(Queue_Kos_Module).w
		lea	(Pal_Soulless).l,a1
		jsr	(PalLoad_Line1).w
                rts

Check_Mid3_Prepares:
		tst.w	dxFadeOff.w
		bne.w	loc_IkHo
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
                sfx     sfx_Spindash
		addq.b	#2,(Dynamic_resize_routine).w

Check_Mid3_LoadSoulless:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$98,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s	+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------

+		jsr	(Stop_Object).w
                bclr    #0,status(a1)
                clr.w	(Ctrl_1_logical).w
		sf	(Ctrl_1_locked).w
                jsr	(SingleObjLoad).w
		bne.s	+
		move.l	#Obj_Soulless,(a1)	; load SYZ miniboss
		move.w	#$D18,obX(a1)	; X-position
		move.w	#$180,obY(a1)	; Y-position
                sfx     sfx_Teleport
+               music	mus_Microboss
		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w
                rts

Check_Mid3_LoadHeartlessGFX:
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
                sfx     sfx_Spindash
		lea	(ArtKosM_Heartless).l,a1
		move.w	#tiles_to_bytes($3D0),d2
		jsr	(Queue_Kos_Module).w
		lea	(Pal_Heartless).l,a1
		jsr	(PalLoad_Line1).w
		addq.b	#2,(Dynamic_resize_routine).w
                rts

Check_Mid3_LoadHeartless:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$98,d0
		move.w	#btnL<<8,d1
		sub.w	x_pos(a1),d0
		beq.s	++
		blo.s	+
		move.w	#btnR<<8,d1
+		move.w	d1,(Ctrl_1_logical).w
-		rts
; ---------------------------------------------------------------------------
+		jsr	(Stop_Object).w
                bset    #0,status(a1)
                clr.w	(Ctrl_1_logical).w
		sf	(Ctrl_1_locked).w
                jsr	(SingleObjLoad).w
		bne.s	+
		move.l	#Obj_Heartless,(a1)	; load SYZ miniboss
                move.w  (Camera_x_pos).w,d0
                add.w   #$28,d0
		move.w	d0,obX(a1)	; X-position
		move.w	#$180,obY(a1)	; Y-position
                bchg    #0,obStatus(a1)
                sfx     sfx_Teleport
+		addq.b	#2,(Dynamic_resize_routine).w
                rts

SCZ3_FadeOut:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

SCZ3_Fade_AfterSoulless:
		tst.w	dxFadeOff.w
		bne.w	loc_IkHo
		lea	(Pal_SCZ).l,a1
		jsr	(PalLoad_Line1).w
		lea	(PLC_MainSCZ).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
                move.w	#$1FE2,(Camera_max_X_pos).w
                clr.w	(Camera_min_Y_pos).w
                move.w	#$500,(Camera_target_max_Y_pos).w

		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w
                rts

Check_End3:
		cmpi.w  #$1FE2,(Camera_x_pos).w
		blo.s	loc_IkHo
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		move.w	#$F8,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		move.b	#25,(v_rings).w	; This battle gotta be hard, NOV: maximize HP
		move.b	#$80,(Update_HUD_ring_count).w
		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		rts
; ============================================================================

Load_Fade:
		tst.w	dxFadeOff.w
		bne.s	loc_IkHo
		addq.b	#2,(Dynamic_resize_routine).w

loc_IkHo:
		rts
; ============================================================================

Load_GFX3:
		addq.b	#2,(Dynamic_resize_routine).w

;		lea	(ArtKosM_DEZExplosion).l,a1
;		move.w	#tiles_to_bytes($1D0),d2
;		jsr	(Queue_Kos_Module).w
;		lea	(ArtKosM_XanBie).l,a1
;		move.w	#tiles_to_bytes($3D0),d2
;		jsr	(Queue_Kos_Module).w
;		lea	(Pal_XanBie).l,a1
;		jsr	(PalLoad_Line1).w

Load_Boss_Cerberus:
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Boss1
		command	cmd_FadeReset

		bsr.w	Create_New_Sprite
		bne.s	loc_IkHo2
		move.l	#Obj_BossFireHead,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$108,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$100,d2
		move.w	d2,y_pos(a1)

;		move.w	#$B28,x_pos(a1)
;		move.w	#$460,y_pos(a1)

loc_IkHo2:
		rts
; ============================================================================

Cerberus_createEndSign:
		command	cmd_FadeReset
		command	cmd_StopMus

		lea	(Pal_SCZ).l,a1
		jsr	(PalLoad_Line1).w
		move.b	#$00,(Check_dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		bsr.w	Create_New_Sprite
		bne.s	+
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
+		rts
; ============================================================================

Resize_SCZ4:
		rts
; =======================================================================================

Resize_GMZ1:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  GMZ1_Load_Routines(pc,d0.w),d0
		jmp     GMZ1_Load_Routines(pc,d0.w)
; =======================================================================================

GMZ1_Load_Routines:
		dc.w GMZ1_AutorunSection-GMZ1_Load_Routines			; 0
		dc.w Load_Scientist-GMZ1_Load_Routines				; 2
		dc.w Load_Scientist2-GMZ1_Load_Routines				; 4
		dc.w GMZ1_Fade1-GMZ1_Load_Routines					; 6
		dc.w GMZ1_Fade2-GMZ1_Load_Routines					; 8

		dc.w Load_Werewolf-GMZ1_Load_Routines				; A
		dc.w Load_Werewolf2-GMZ1_Load_Routines				; C
		dc.w GMZ1_Fade11-GMZ1_Load_Routines				; E
		dc.w GMZ1_Fade22-GMZ1_Load_Routines				; 10

		dc.w GMZ1_StartLava-GMZ1_Load_Routines				; 12
		dc.w GMZ1_CheckLava-GMZ1_Load_Routines				; 14

		dc.w ShielderShaft_checkintropos-GMZ1_Load_Routines		; 16
		dc.w ShielderShaft_setintropos-GMZ1_Load_Routines		; 18
		dc.w ShielderShaft_checkfade-GMZ1_Load_Routines			; 1A
		dc.w ShielderShaft_createboss-GMZ1_Load_Routines		; 1C
		dc.w ShielderShaft_wait-GMZ1_Load_Routines				; 1E
		dc.w ShielderShaft_wait-GMZ1_Load_Routines				; 20
		dc.w ShielderShaft_move-GMZ1_Load_Routines				; 22
		dc.w ShielderShaft_wait-GMZ1_Load_Routines				; 24
		dc.w GMZ1_Fade3333333333333333333333333-GMZ1_Load_Routines	;26
		dc.w ShielderShaft_checkfade-GMZ1_Load_Routines			; 28
		dc.w ShielderShaft_createEndSign-GMZ1_Load_Routines		; 2A
		dc.w ShielderShaft_wait-GMZ1_Load_Routines				; 2C
		dc.w Resize_GMZ1_RTS-GMZ1_Load_Routines					; 2E
; =======================================================================================

GMZ1_AutorunSection:
		st	(Ctrl_1_locked).w
		move.b	#1<<3,(Ctrl_1_logical).w

		cmpi.w	#$900,(Camera_x_pos).w
		blt.w	loc_bartney
		clr.w	(Ctrl_1_logical).w
		sf	(Ctrl_1_locked).w
		addq.b	#2,(Dynamic_resize_routine).w

Load_Scientist:
		cmpi.w	#$1520,(Camera_x_pos).w
		blt.w	Resize_GMZ1_RTS
		tst.w	(AstarothCompleted).w
		bne.w	+
		move.b	#0,(Check_Dead).w
;		st	(Ctrl_1_locked).w
	;	clr.w	(Ctrl_1_logical).w
		;lea	(Player_1).w,a1
		;bsr.w	Stop_Object
		st	(Boss_flag).w
		lea	(Pal_BossScientist).l,a1
		jsr	(PalLoad_Line1).w
		lea	(ArtKosM_Scientist).l,a1
		move.w	#tiles_to_bytes($403),d2
		jsr	(Queue_Kos_Module).w
		move.w	#$1520,(Camera_min_X_pos).w
		move.w	#$1520,(Camera_max_X_pos).w
                move.w  #$238,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts

+		move.b	#$A,(Dynamic_resize_routine).w
		move.w	#$3600,(Camera_max_X_pos).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$708,(Camera_target_max_Y_pos).w
		rts

Load_Scientist2:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ1_RTS
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		music	mus_Microboss
		command	cmd_FadeReset

		jsr	(SingleObjLoad).w
		bne.w	Resize_GMZ1_RTS
		move.l	#Obj_Scientist,(a1)
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$118,d0
		move.w	d0,obX(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$94,d0
		blt.s	+
		move.w	(Camera_x_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obX(a1)
		bchg	#0,obStatus(a1)
+		move.w	(Camera_target_max_Y_pos).w,d0
		add.w	#$A8,d0
		move.w	d0,obY(a1)
		addq.b	#2,(Dynamic_resize_routine).w
		rts

GMZ1_Fade1:
		cmpi.b	#1,(Check_Dead).w
		bne.w	Resize_GMZ1_RTS
		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts

GMZ1_Fade2:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ1_RTS
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   Resize_GMZ1_RTS
                clr.w   (Camera_min_Y_pos).w
		move.w	#$500,(Camera_target_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Pal_GMZ).l,a1
		jsr	(PalLoad_Line1).w
		move.w	#$3600,(Camera_max_X_pos).w
		move.w	#$708,(Camera_target_max_Y_pos).w
		sf	(Boss_flag).w
		lea	(PLC2_GMZ1_Enemy).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset

Load_Werewolf:
		cmpi.w	#$255B,(Camera_x_pos).w
		blt.w	Resize_GMZ1_RTS
		cmpi.w	#2,(AstarothCompleted).w
		beq.w	+
		move.b	#0,(Check_Dead).w

		samp	sfx_WolfAwoo
		fadeout					; fade out music
		st	(Boss_flag).w
		lea	(Pal_Werewolf).l,a1
		jsr	(PalLoad_Line1).w
		lea	(PLC_BossWerewolf).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		move.w	#$255B,(Camera_min_X_pos).w
		move.w	#$255B,(Camera_max_X_pos).w
                move.w  #$4AC,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts

+		move.b	#$12,(Dynamic_resize_routine).w
		move.w	#$4000,(Camera_max_X_pos).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$770,(Camera_target_max_Y_pos).w
		jsr	SingleObjLoad				; NAT: Load the object to handle the lava.
		bne.s	+				; this object was made to simplify lava processing
		move.l	#Obj_GMZ1Lava,(a1)			; and make it more consistent
+		rts

Load_Werewolf2:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ1_RTS
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		music	mus_Microboss
		command	cmd_FadeReset

		jsr	(SingleObjLoad).w
		bne.w	Resize_GMZ1_RTS
		move.l	#Obj_Werewolf,(a1)
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$7F,d0
		move.w	d0,obX(a1)
		move.w	(Camera_max_Y_pos).w,d0
		sub.w	#$F,d0
		move.w	d0,obY(a1)
		addq.b	#2,(Dynamic_resize_routine).w
		rts

GMZ1_Fade11:
		cmpi.b	#1,(Check_Dead).w
		bne.w	Resize_GMZ1_RTS
		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts

GMZ1_Fade22:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ1_RTS
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   Resize_GMZ1_RTS
                clr.w	(Camera_min_Y_pos).w
                move.w	#$600,(Camera_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		sf	(Boss_flag).w
		lea	(Pal_GMZ).l,a1
		jsr	(PalLoad_Line1).w
		move.w	#$4000,(Camera_max_X_pos).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$770,(Camera_target_max_Y_pos).w
		jsr	(Obj_PlayLevelMusic).w			; Play music
		command	cmd_FadeReset
		command	cmd_StopMus

		jsr	SingleObjLoad				; NAT: Load the object to handle the lava.
		bne.s	GMZ1_StartLava				; this object was made to simplify lava processing
		move.l	#Obj_GMZ1Lava,(a1)			; and make it more consistent
; ---------------------------------------------------------------------------

GMZ1_StartLava:
		cmpi.w	#$2920,(Camera_x_pos).w
		blt.s	GMZ1_StartLava_Return

		lea	(Pal_DPShaft_Ghost).l,a1
		jsr	(PalLoad_Line1).w

		lea	(ArtKosM_ShaftGhost).l,a1
		move.w	#tiles_to_bytes($475),d2
		jsr	(Queue_Kos_Module).w
		st	(Screen_Shaking_Flag).w


		jsr	(SingleObjLoad).w
		bne.s	+
		move.l	#Obj_DPShaftGhost,(a1)
		move.w	(Camera_X_pos).w,obX(a1)
+		move.b	#$2C,(Dynamic_resize_routine).w

GMZ1_StartLava_Return:
		rts
; ---------------------------------------------------------------------------

GMZ1_CheckLava:
		addq.b	#2,(Dynamic_resize_routine).w
		move.b	#$7F,Lava_Event.w			; make lava move upwards

		move.b	#4,(Hyper_Sonic_flash_timer).w
		lea	(PLC2_GMZ1_Enemy).l,a5
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

PlayFireEffect:
		cmpi.w	#1,(Sonic_Dead).w
		bne.s	+
		rts

+		sub.w	#1,(Grounder_Alive).w
		bpl.w	Resize_GMZ1_RTS
		move.w	#24,(Grounder_Alive).w
		sfx	sfx_Shake, 1
; ---------------------------------------------------------------------------

ShielderShaft_checkintropos:
		move.w	#$800,d0
		cmpi.w	#$3100,(Camera_X_pos).w
		blo.s	.gotheight
		cmpi.w	#$280,(Camera_Y_pos).w		; if the camera is too low down, do not change max y-pos
		bhs.s	.gotheight
		move.w	#$260,d0
		cmpi.w	#$3C00,(Camera_X_pos).w		; if we are very near the boss, pan up
		blo.s	.gotheight			; this makes sure the tiles load correctly in the boss
		move.w	#$240,d0

.gotheight
		move.w	d0,(Camera_target_max_Y_pos).w

		cmpi.w	#$3E00,(Camera_X_pos).w
		blo.w	ShielderShaft_wait3
		move.w	d0,(Camera_min_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w

		fadeout					; fade out music
		jsr	(Create_New_Sprite).w
  		bne.s	+
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#7,subtype(a1)
		move.w	#$F,$2E(a1)
		move.l	#Pal_SonicMGZ2,$30(a1)
		move.w	#Normal_palette_line_1,$34(a1)
        	move.w	#16-1,$38(a1)
+		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		lea	(Pal_BossShaft).l,a1
		jsr	(PalLoad_Line1).w
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		st	(Ctrl_1_locked).w
		st	(Boss_flag).w
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   +
		st	(Level_end_flag).w
+		lea	(PLC_Shaft).l,a5
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

ShielderShaft_setintropos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
	;	fadeout					; fade out music
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
                rts
; ---------------------------------------------------------------------------

ShielderShaft_createboss:
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Boss1
		command	cmd_FadeReset

		bsr.w	Create_New_Sprite
		bne.s	ShielderShaft_wait3
		move.l	#Obj_Shaft,(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$118,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$A8,d0
		move.w	d0,y_pos(a1)
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   ShielderShaft_createboss_skip
		jsr	(Create_New_Sprite).w
		bne.s	ShielderShaft_wait3
		move.l	#Obj_Dialog_Process,(a1)
		move.b	#_GMZ1,routine(a1)

		; load main dialog
		move.l	#DialogMGZ1Shaft_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ1Shaft_Process_Index_End-DialogMGZ1Shaft_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	ShielderShaft_wait3

		; load alt dialog
		move.l	#DialogMGZ1Shaft_EX_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ1Shaft_EX_Process_Index_End-DialogMGZ1Shaft_EX_Process_Index)/8,$39(a1)

ShielderShaft_wait3:
		rts
; ---------------------------------------------------------------------------

ShielderShaft_createboss_skip:
		move.b	#$20,(Dynamic_resize_routine).w
                rts
; ---------------------------------------------------------------------------

GMZ1_Fade3333333333333333333333333:		; Am I really doing this?
		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

ShielderShaft_checkfade:
		tst.w	dxFadeOff.w
		bne.s	ShielderShaft_wait
		addq.b	#2,(Dynamic_resize_routine).w

ShielderShaft_wait:
		rts
; ---------------------------------------------------------------------------

ShielderShaft_move:
		move.w	(Camera_X_pos).w,d3
;		cmpi.b	#6,(Player_1+routine).w
;		bhs.s	+
		subq.w	#2,d3
		cmpi.w	#$3E00,d3
		bhs.s	+
		move.w	#-$200,d0
		sub.w	d0,d3
		sub.w	d0,(Player_1+x_pos).w
		moveq	#0,d1
		jsr	(Offset_ObjectsDuringTransition).l

+		move.w	d3,(Camera_X_pos).w
		move.w	d3,(Camera_X_pos_copy).w
		move.w	d3,(Camera_min_X_pos).w
		move.w	d3,(Camera_max_X_pos).w

		lea	(Player_1).w,a0
		cmpi.b	#5,anim(a0)
		bne.s	+
		clr.b	anim(a0)

+		addi.w	#$18,d3
		cmp.w	x_pos(a0),d3
		bls.s	+
		move.w	d3,x_pos(a0)
		move.w	#-$200,ground_vel(a0)

+		addi.w	#$108,d3
		cmp.w	x_pos(a0),d3
		bhi.s	+
		move.w	d3,x_pos(a0)
+		rts
; ---------------------------------------------------------------------------

ShielderShaft_createEndSign:
		command	cmd_FadeReset
		command	cmd_StopMus

		clr.b	(Boss_flag).w
                clr.w  (AstarothCompleted).w
		lea	(Pal_GMZ).l,a1
		jsr	(PalLoad_Line1).w
		addq.b	#2,(Dynamic_resize_routine).w
		bsr.w	Create_New_Sprite
		bne.s	+
		move.l	#Obj_EndSignControl,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
+		rts
; ---------------------------------------------------------------------------

Resize_GMZ1_RTS:
		rts
; ---------------------------------------------------------------------------


Resize_GMZ2:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  GMZ2_Load_Routines(pc,d0.w),d0
		jmp     GMZ2_Load_Routines(pc,d0.w)
; ---------------------------------------------------------------------------

GMZ2_Load_Routines:
		dc.w Load_Centipede-GMZ2_Load_Routines
		dc.w GMZ2_Fade-GMZ2_Load_Routines
		dc.w GMZ2_LoadCentipede-GMZ2_Load_Routines
		dc.w Resize_GMZ2_RTS-GMZ2_Load_Routines

		dc.w GMZ2_PostMiniBoss-GMZ2_Load_Routines
		dc.w Load_ArmorFade-GMZ2_Load_Routines
		dc.w Load_Armor-GMZ2_Load_Routines

		dc.w Resize_GMZ2_RTS-GMZ2_Load_Routines
		dc.w Load_Armor2-GMZ2_Load_Routines
		dc.w Resize_GMZ2_RTS-GMZ2_Load_Routines
		dc.w GMZ2_Fade11-GMZ2_Load_Routines
		dc.w GMZ2_Fade22-GMZ2_Load_Routines

		dc.w CerberusShaft_checkintropos-GMZ2_Load_Routines
		dc.w CerberusShaft_setintropos-GMZ2_Load_Routines
		dc.w CerberusShaft_checkfade-GMZ2_Load_Routines
		dc.w CerberusShaft_createboss-GMZ2_Load_Routines
		dc.w CerberusShaft_wait3-GMZ2_Load_Routines
		dc.w CerberusShaft_checkfade-GMZ2_Load_Routines
		dc.w GMZ2_Fade111-GMZ2_Load_Routines
		dc.w GMZ2_Fade222-GMZ2_Load_Routines
		dc.w Resize_GMZ2_RTS4-GMZ2_Load_Routines
; ---------------------------------------------------------------------------

Load_Centipede:
	; figure out the target y-position for current position
		move.w	#$440,d0			; initial max
		cmp.w	#$5C0,Camera_X_Pos.w		; check if we are behind start area
		bhs.s	.ahead				; branch if not
		move.w	#$130,d0			; max for boss

.ahead
		move.w	d0,Camera_target_max_Y_pos.w	; set camera max-pos

	; figure out the minimum camera x-position
		move.w	#$780,d0			; minimum x-position for initial arena
		cmp.w	#$2D0,Camera_Y_Pos.w		; check if we are above start area
		bhs.s	.below				; branch if not
		move.w	#$360,d0			; minimum x-position for boss arena
		cmp.w	Camera_X_Pos.w,d0		; check if we are at the boss arena
		beq.s	.loadboss			; branch if not

.below
		move.w	d0,Camera_min_X_pos.w		; set as minimum camera x-pos
		rts

.loadboss
		tst.w	(AstarothCompleted).w
		bne.s	++
		move.w	d0,Camera_min_X_pos.w
		move.w	d0,Camera_max_X_pos.w

		move.w	#$130,d0
		cmp.w	(Camera_Y_pos).w,d0
		bne.s	.return
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	+				; If so, branch
		fadeout					; fade out music
+
		move.b	#0,(Check_Dead).w
		lea	(ArtKosM_Centipede).l,a1
		move.w	#tiles_to_bytes($403),d2
		jsr	(Queue_Kos_Module).w

		clr.b	GravityAngle.w			; toggle reverse gravity

		move.w	#3*60,(Demo_timer).w
		move.w	#$3F,(Palette_fade_info).w
		st	(Screen_shaking_flag).w
		move.b	#4*60,MGZEmbers_Spawn.w			; disable ember spawning
		lea	Arthur_Rings(pc),a1
		jmp	(Set_LostRings).w
; ---------------------------------------------------------------------------
+
		move.b	#8,(Dynamic_resize_routine).w
		clr.w	(Camera_min_X_pos).w
		move.w	#$A00,(Camera_target_max_Y_pos).w

.return
		rts
; ---------------------------------------------------------------------------

GMZ2_Fade:
		sfx	sfx_Shake
		move.w	(Demo_timer).w,d0
		tst.w	d0
		bne.w	GMZ2_ToBlack
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#60,(Demo_timer).w
		move.w	#$8C89,(VDP_control_port).l
		move.w	(v_player+obX).w,d0
		move.w	#$380+$A,d1
		cmp.w	d1,d0
		bhi.w	.adjustsonic
		move.w	d1,d0
		bra.s	.adjustsonic2

	.adjustsonic:
		move.w	#$480-$A,d1
		cmp.w	d1,d0
		blo.w	.adjustsonic2
		move.w	d1,d0

	.adjustsonic2:
		move.w	d0,(v_player+obX).w
		lea	(Layout_GMZ2_Alt).l,a0
		jsr	(Load_Level2).l
		jmp	FGInit_Generic

; ---------------------------------------------------------------------------
GMZ2_LoadCentipede:
		sfx	sfx_SpecialRumble
		tst.w	(Demo_timer).w
		bne.s	GMZ2_Fade1_Return
		addq.b	#2,(Dynamic_resize_routine).w

		jsr	(SingleObjLoad).w
		bne.s	GMZ2_Fade1_Return
		move.l	#Obj_Centipede,(a1)
		move.w	#$370,obX(a1)
		move.w	#$170,obY(a1)
		bchg	#0,obStatus(a1)
		move.b	#1,(MidBoss_flag).w
		music	mus_Microboss
		command	cmd_FadeReset

		lea	(Pal_Centipede).l,a1
		jsr	(PalLoad_Line0).w
		jsr	(PalLoad_Line1).w
		jmp	(PalLoad_Line2).w

GMZ2_Fade1_Return:
		rts

GMZ2_ToBlack:
		andi.w	#7,d0
		bne.s	GMZ2_Fade1_Return
		jmp	Pal_ToBlack
; ---------------------------------------------------------------------------

GMZ2_PostMiniBoss:
;		cmp.w	#$2C0,Camera_X_Pos.w		; check if we are behind mini-boss area
;		bhs.s	GMZ2_Fade1_Return				; branch if not

		move.w	#$8C81,(VDP_control_port).l
		moveq	#palid_SonicMGZ2,d0			; AF: load MGZ2 sonic palette
		jsr	LoadPalette_Immediate
		moveq	#palid_GMZ2,d0
		jsr	LoadPalette_Immediate

		move.l	d7,-(sp)
		lea	(Layout_GMZ2).l,a2
		tst.b	(Extended_mode).w
		beq.s	.notex
		lea	(Layout_GMZ2ex).l,a2

.notex
		move.l	a2,(Level_layout_addr_ROM).w
		addq.l	#8,a2
		move.l	a2,(Level_layout2_addr_ROM).w
		move.l	a0,-(sp)
		jsr	FGInit_Generic
		move.l	(sp)+,a0
		move.l	(sp)+,d7

		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$A00,(Camera_target_max_Y_pos).w

Load_ArmorFade:
		cmp.w	#$300,Camera_Y_Pos.w		; check if we are low enough
		blo.s	.nope				; branch if not
		move.w	#$C60,Camera_max_X_pos.w	; set max camera x-pos to the boss arena

.nope
		cmpi.w	#$C60,(Camera_x_pos).w
		blt.s	GMZ2_Fade1_Return
		cmpi.w	#2,(AstarothCompleted).w
		beq.w	+
		move.w	#$C60,(Camera_min_X_pos).w
		move.w	#$C60,(Camera_max_X_pos).w
		move.w	#$688,(Camera_min_Y_pos).w
		move.w	#$6C0,(Camera_target_max_Y_pos).w

		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		clr.b	GravityAngle.w			; toggle reverse gravity
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		lea	(PLC_GreatAxeLord).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_BossGreatAxeLord).l,a1
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
+
		move.b	#$18,(Dynamic_resize_routine).w
		move.w	#$2860,(Camera_max_X_pos).w
		move.w	#$720,(Camera_target_max_Y_pos).w
		rts
; ---------------------------------------------------------------------------

Load_Armor:
		tst.w	dxFadeOff.w
		bne.s	Resize_GMZ2_RTS
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Microboss
		command	cmd_FadeReset

		jsr	(SingleObjLoad).w
		bne.s	Resize_GMZ2_RTS
		move.l	#Obj_GreatAxeLord,(a1)
		move.w	(Camera_min_X_pos).w,d0
		addi.w	#$17F,d0
		move.w	d0,obX(a1)
		move.w	(Camera_target_max_Y_pos).w,d0
		addi.w	#$88,d0
		move.w	d0,obY(a1)

Resize_GMZ2_RTS:
		rts
; ---------------------------------------------------------------------------

Load_Armor2:
		jsr	(SingleObjLoad).w
		bne.w	Resize_GMZ2_RTS2
		move.l	#Obj_GreatBlueLord,(a1)
		move.w	(Camera_min_X_pos).w,d0
		subi.w	#$58,d0
		move.w	d0,obX(a1)
		move.w	(Camera_target_max_Y_pos).w,d0
		addi.w	#$88,d0
		move.w	d0,obY(a1)
		addq.b	#2,(Dynamic_resize_routine).w

Resize_GMZ2_RTS2:
		rts
; ---------------------------------------------------------------------------

GMZ2_Fade11:
		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

GMZ2_Fade22:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ2_RTS4
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$8F,d0
                cmp.w   (Player_1+obY).w,d0
                bcc.w   Resize_GMZ2_RTS4
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$2860,(Camera_max_X_pos).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$7A0,(Camera_target_max_Y_pos).w

		command	cmd_FadeReset
		jsr	(Obj_PlayLevelMusic).w			; Play music
		lea	(PLC_Main7).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	PLC_Main2.l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC1_GMZ2_Misc).l,a5			; reload graphics
		jsr	(LoadPLC_Raw_KosM).w
		move.b	#$80,(Update_HUD_ring_count).w
		lea	(PLC2_GMZ2_Enemy).l,a5			; reload enemy graphics
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

CerberusShaft_checkintropos:
		cmpi.w	#$2700,(Camera_X_pos).w
		blo.w	CerberusShaft_wait3
		move.w	#$2700,(Camera_X_pos).w
		addq.b	#2,(Dynamic_resize_routine).w
		fadeout					; fade out music
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		lea	(Pal_BossShaft).l,a1
		jsr	(PalLoad_Line1).w
		move.w	#$440,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		clr.b	GravityAngle.w			; toggle reverse gravity
		st	(Ctrl_1_locked).w
		st	(Boss_flag).w
		lea	(PLC_Shaft).l,a5
		jmp	(LoadPLC_Raw_KosM).w
; ---------------------------------------------------------------------------

CerberusShaft_setintropos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$30,d0
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
	;	fadeout					; fade out music
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

CerberusShaft_createboss:
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Boss1
		command	cmd_FadeReset

		bsr.w	Create_New_Sprite
		bne.s	CerberusShaft_wait3
		move.l	#Obj_Shaft2,(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A8,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$A8,d0
		move.w	d0,y_pos(a1)

CerberusShaft_wait3:
		rts
; ---------------------------------------------------------------------------

CerberusShaft_checkfade:
		tst.w	dxFadeOff.w
		bne.s	CerberusShaft_wait
		addq.b	#2,(Dynamic_resize_routine).w

CerberusShaft_wait:
		rts
; ---------------------------------------------------------------------------

GMZ2_Fade111:
;		cmpi.b	#9,(Check_Dead).w
;		bne.w	Resize_GMZ2_RTS4

		fadeout					; fade out music
		move.b	#0,(Check_Dead).w
		addq.b	#2,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

GMZ2_Fade222:
;		tst.w	dxFadeOff.w
;		bne.s	Resize_GMZ2_RTS4

		lea	(PLC_Main7).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w

		addq.b	#2,(Dynamic_resize_routine).w
		command	cmd_FadeReset
		command	cmd_StopMus

		;move.w	#1,(ThatsAllFolks).w
		jsr	(Create_New_Sprite).w
		bne.s	Resize_GMZ2_RTS4
		move.l	#Obj_EndSignControl,(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$9B,d2
		move.w	d2,x_pos(a1)

Resize_GMZ2_RTS4:
		rts
; ---------------------------------------------------------------------------

Resize_GMZ3:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  GMZ3_Load_Routines(pc,d0.w),d0
		jmp     GMZ3_Load_Routines(pc,d0.w)
; ---------------------------------------------------------------------------

GMZ3_Load_Routines:
		dc.w LoadMecha0-GMZ3_Load_Routines                    ;0
		dc.w MechaShaft_setintropos-GMZ3_Load_Routines        ;2
		dc.w MechaShaft_createboss-GMZ3_Load_Routines         ;4
		dc.w LoadMecha0_RTS-GMZ3_Load_Routines                ;6
		dc.w LoadMecha0_RTS-GMZ3_Load_Routines                ;8
		dc.w GMZ3_FadeOutMusic-GMZ3_Load_Routines             ;A
		dc.w LoadMecha0_RTS-GMZ3_Load_Routines                ;C
                dc.w GMZ3_LoadMechaDemon-GMZ3_Load_Routines           ;E
		dc.w LoadMecha0_RTS-GMZ3_Load_Routines                ;10
		dc.w Load_DPShaft-GMZ3_Load_Routines                  ;12
		dc.w MechaShaft_setintropos-GMZ3_Load_Routines        ;14
		dc.w Load_DPShaft0-GMZ3_Load_Routines                 ;16
		dc.w Resize_GMZ3_RTS-GMZ3_Load_Routines               ;18
		dc.w Load_DPShaft2-GMZ3_Load_Routines                 ;1A
		dc.w Load_DPShaft3-GMZ3_Load_Routines                 ;1C
		dc.w Resize_GMZ3_RTS-GMZ3_Load_Routines               ;1E
		dc.w ShaftDead_setpos-GMZ3_Load_Routines              ;20
		dc.w Resize_GMZ3_RTS-GMZ3_Load_Routines               ;22
		dc.w Resize_GMZ3_RTS-GMZ3_Load_Routines               ;24
; ---------------------------------------------------------------------------
LoadMecha0:
		cmpi.w	#$660,(Camera_x_pos).w
		blt.w	Resize_GMZ3_RTS
		lea 	(v_FDZ3_Rain).w,a1
		jsr 	(Delete_Referenced_Sprite).w
		lea	(Pal_BossShaft).l,a1
		jsr	(PalLoad_Line1).w
		st	(Ctrl_1_locked).w
		st	(Boss_flag).w
		lea	(PLC_Shaft).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		move.w	#$660,(Camera_min_X_pos).w
		move.w	#$660,(Camera_max_X_pos).w
                move.w  #$238,d0
		move.w	d0,(Camera_min_Y_pos).w
		move.w	d0,(Camera_target_max_Y_pos).w
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w

LoadMecha0_RTS:
		rts

GMZ3_FadeOutMusic:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		rts


GMZ3_LoadMechaDemon:
		move.b #$4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp
		jsr	(SingleObjLoad).w
		bne.s   +
 	   	move.l 	#Obj_Mecha_Demon,(a1) ; load phase 2

		move.w	(Camera_x_pos).w,d0
		add.w	#$98,d0
		move.w	d0,obX(a1)
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$40,d0
		move.w	d0,obY(a1)
		lea	(Pal_MechaDemon).l,a1
		jsr	(PalLoad_Line1).w
		addq.b	#2,(Dynamic_resize_routine).w
+               rts

GMZ3_FadeInLevel1:
		tst.w	dxFadeOff.w
		bne.w	loc_DasIstSoil
		addq.b	#2,(Dynamic_resize_routine).w
		move.w	#$1DF0,(Camera_max_X_pos).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC2_KosM).w

		command	cmd_FadeReset
		jsr	(Obj_PlayLevelMusic).w			; Play music
; ---------------------------------------------------------------------------

MechaShaft_setintropos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$30,d0
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
		addq.b	#2,(Dynamic_resize_routine).w
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jmp	(Stop_Object).w
; ---------------------------------------------------------------------------

MechaShaft_createboss:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ3_RTS
		addq.b	#2,(Dynamic_resize_routine).w

		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		jsr	(Create_New_Sprite).w
		bne.s	.cutscene
		move.l	#Obj_Shaft3,(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$128,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$B0,d0
		move.w	d0,y_pos(a1)

.cutscene:
		move.b  #1,(Grounder_Alive).w
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   .skip
		st	(Level_end_flag).w
		fadeout

		; load dialog
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_GMZ3Start,routine(a1)

		; load main dialog
		move.l	#DialogMGZ3ShaftStart_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ3ShaftStart_Process_Index_End-DialogMGZ3ShaftStart_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	.return

		; load alt dialog
		move.l	#DialogMGZ3ShaftStart_EX_Process_Index-4,$34(a1)
		move.b	#(DialogMGZ3ShaftStart_EX_Process_Index_End-DialogMGZ3ShaftStart_EX_Process_Index)/8,$39(a1)

.return
		rts
; ---------------------------------------------------------------------------

.skip
                music	mus_Boss1
                command cmd_FadeReset
                move.b  #8,(Dynamic_resize_routine).w
		rts
; ---------------------------------------------------------------------------

Load_DPShaft:
		fadeout					; fade out music
		addq.b	#2,(Dynamic_resize_routine).w
		lea	Arthur_Rings(pc),a1
		jsr	(Set_LostRings).w
		lea	(PLC_BossShaft).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		st	(Ctrl_1_locked).w
		st	(Boss_flag).w
                rts
; ---------------------------------------------------------------------------

Load_DPShaft0:
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Pal_DPShaft).l,a1
		jsr	(PalLoad_Line1).w
		jsr	(SingleObjLoad).w
		bne.w	Resize_GMZ3_RTS
		move.l	#Obj_DPShaft,(a1)
		move.w	(Camera_max_X_pos).w,d0
		add.w	#$118,d0
		move.w	d0,obX(a1)
		move.w	(Camera_min_Y_pos).w,d0
		add.w	#$B5,d0
		move.w	d0,obY(a1)
		move.b	#0,obAnim(a1)
		rts

Load_DPShaft2:
		tst.w	dxFadeOff.w
		bne.w	Resize_GMZ3_RTS
		addq.b	#2,(Dynamic_resize_routine).w
		music	mus_Gloam2
		command	cmd_FadeReset

Load_DPShaft3:
		sub.w	#1,(Camera_min_X_pos).w
		cmpi.w	#$600,(Camera_min_X_pos).w
		bcc.w	Resize_GMZ3_RTS
		addq.b	#2,(Dynamic_resize_routine).w
                rts

ShaftDead_setpos:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$30,d0
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
		st	(Level_end_flag).w
		clr.w	(Ctrl_1_logical).w
		move.b	#$81,object_control(a1)
                move.w (Camera_y_pos).w,d0
                add.w   #$B4,d0
                move.w  obY(a1),d1
                cmp.w   d0,d1
                beq.s   +
                move.w  d0,obY(a1)
+		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		addq.b	#2,(Dynamic_resize_routine).w

Resize_GMZ3_RTS:
		rts
; ---------------------------------------------------------------------------

Resize_GMZ3_AfterLastBoss:
		move.l	#.aftersign,(Level_data_addr_RAM.Resize).w

		sf	(Black_Stretch_flag).w
		st	(Level_end_flag).w
		st	NoBackgroundEvent_flag.w		; NAT: This is controlled by this routine instead.
		st	LastAct_end_flag.w			; also set this flag so that the title cards are not loaded immediately.

		jsr	(Create_New_Sprite).w
		bne.s	.aftersign
		move.l	#Obj_EndSignControl,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		st	$40(a1)
		st	$41(a1)

.aftersign
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive


		tst.b	(Level_end_flag).w
		bne.w	.return

		move.w	#2*60,(Demo_timer).w
		move.l	#.wait,(Level_data_addr_RAM.Resize).w
		st	(Level_end_flag).w

.wait
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive


		tst.w	(Demo_timer).w
		bne.s	.return
		sfx	sfx_Magic
		move.l	#.deform,(Level_data_addr_RAM.Resize).w
		move.l	#Resize_GMZ3_DeformProcess,(Level_data_addr_RAM.BackgroundEvent).w

		jsr	(Create_New_Sprite).w
		bne.s	.deform
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#$1F,subtype(a1)						; wait time
		move.w	#$3F,$2E(a1)							; wait time
		move.w	#Normal_palette_line_1,objoff_34(a1)	; palette ram
		move.l	#Pal_BossTwoFacesBlack,objoff_30(a1)	; palette pointer
		move.w	#64-1,objoff_38(a1)					; palette size

.deform
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive


		moveq	#3,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	.return
		addq.w	#4,(PalCycle_Timer3).w
		cmpi.w	#$100,(PalCycle_Timer3).w
		bhs.s	.start
		
.return
		rts
; ---------------------------------------------------------------------------

.start
		addq.w	#8,sp		; ???

		tst.b	(Extended_mode).w
		bne.s	.results

		move.w	#$300,d0
		jmp	(StartNewLevel).w
; ---------------------------------------------------------------------------

.results
		move.b	#id_Results,(Game_mode).w		; set Game Mode
		rts
; ---------------------------------------------------------------------------

Resize_GMZ4:
		rts

; =======================================================================================
; ---------------------------------------------------------------------------------------
; Intro
; ---------------------------------------------------------------------------------------

Resize_IZ:
		rts

; =======================================================================================
; ---------------------------------------------------------------------------------------
; DDZ
; ---------------------------------------------------------------------------------------

Resize_DDZ:
		rts

; =======================================================================================
; ---------------------------------------------------------------------------------------
; Credits
; ---------------------------------------------------------------------------------------

Resize_CRE:
		rts

; =======================================================================================









