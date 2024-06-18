; ---------------------------------------------------------------------------
; Dynamic level events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SCZ3_Resize:
		moveq   #0,d0
		move.b  (Dynamic_resize_routine).w,d0
		move.w  SCZ3Death_Load_Routines(pc,d0.w),d0
		jmp     SCZ3Death_Load_Routines(pc,d0.w)

SCZ3Death_Load_Routines:
                dc.w  LoadIntroDeath-SCZ3Death_Load_Routines
		dc.w  Check_1stPhase-SCZ3Death_Load_Routines
		dc.w  Load_1stPhase-SCZ3Death_Load_Routines
		dc.w  loc_Armsey-SCZ3Death_Load_Routines
		dc.w  loc_Armsey-SCZ3Death_Load_Routines
		dc.w  CreateBoat-SCZ3Death_Load_Routines

LoadIntroDeath:
                cmpi.w  #$2F0,(Camera_x_pos).w
		blt.w   loc_Armsey
		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($59C),d2
		jsr	(Queue_Kos_Module).w	;
                cmpi.w  #1,(DialogueAlreadyShown).w
                beq.s   +
		lea     (ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	Queue_Kos_Module
+		lea	(Pal_DeathIntro).l,a1
		jsr	(PalLoad_Line1).w
		addq.b	#2,(Dynamic_resize_routine).w
		jsr	(SingleObjLoad).w
		bne.w	loc_Armsey
		move.l	#Obj_Death,(a1)	; load SCZ megaboss
		move.w  #$2F0,d0
		add.w	#$E8,d0
		move.w	d0,obX(a1)	; X-positionï
		move.w (Camera_max_Y_pos).w,d0
                add.w   #$60,d0
		move.w	d0,obY(a1)	; Y-position

Check_1stPhase:
		move.w	#$2F0,(Camera_min_X_pos).w
		move.w	#$2F0,(Camera_max_X_pos).w

		move.b	#1,(Boss_flag).w
		st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
                fadeout
		addq.b	#2,(Dynamic_resize_routine).w

Load_1stPhase:
		lea	(Player_1).w,a1
		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
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
		music	mus_SCZ3Boss					; play boss theme
		move.w	#mus_SCZ3Boss,(Level_music).w	; save boss theme

		command	cmd_FadeReset
		addq.b	#2,(Dynamic_resize_routine).w

loc_Armsey:
		rts

CreateBoat:
                cmpi.w  #$800,(Camera_X_pos).w
		blt.s		SCZ3_Resize_Return

		; create boat
		jsr	(Create_New_Sprite).w
		bne.s	SCZ3_Resize_Return
		move.l	#Obj_BossGrimReaper_Boat,address(a1)
		move.w	#$9C0,x_pos(a1)
		move.w	#$448,y_pos(a1)
		move.w	#$930,(Camera_max_X_pos).w
		lea	(ArtKosM_Bubbles).l,a1
		move.w	#tiles_to_bytes($3E0),d2
		jsr	(Queue_Kos_Module).w
		move.l	#SCZ3_Resize_Return,(Level_data_addr_RAM.Resize).w

SCZ3_Resize_Return:
		rts
; ---------------------------------------------------------------------------

SCZ3_Resize_AfterBoss:
		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_min_X_pos).w
		cmp.w	#$F80,d0
		blt.s		.return
		move.w	#$450,(Camera_min_Y_pos).w
		move.w	#$450,(Camera_target_max_Y_pos).w
		move.l	#.checkpos,(Level_data_addr_RAM.Resize).w

.checkpos
		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_min_X_pos).w
		cmp.w	#$1100,d0
		blt.s		.return
		move.l	#.check,(Level_data_addr_RAM.Resize).w

		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_EndSignControl,address(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$A0,d2
		move.w	d2,x_pos(a1)
		st	(Level_end_flag).w
		st	(LastAct_end_flag).w

.return
		rts
; ---------------------------------------------------------------------------

.check
		tst.b	(LevResults_end_flag).w
		beq.s	SCZ3_Resize_AfterBoss.return
                move.w	#$1340,(Camera_max_X_pos).w
		st	(Ctrl_1_locked).w
		move.w	#btnR<<8,(Ctrl_1_logical).w
		move.l	#.run,(Level_data_addr_RAM.Resize).w

.run
		cmpi.w  #$1460,(Player_1+x_pos).w
		blt.s		SCZ3_Resize_AfterBoss.return
		move.w	#$200,d0
		jmp	(StartNewLevel).w
