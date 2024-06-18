; ---------------------------------------------------------------------------
; Death SCZ4 megaboss
; ---------------------------------------------------------------------------
Obj_Death:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Death_Index(pc,d0.w),d1
		jsr	Obj_Death_Index(pc,d1.w)
                cmpi.b  #2,routine(a0)
                beq.s   .introDPLC
                cmpi.b  #$50,routine(a0)
                beq.s   .introDPLC
		lea	(Ani_Death).l,a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_Death(pc),a2
		jsr	(Perform_DPLC).w
                bra.s   .animscan

.introDPLC:
		lea	(Ani_DeathIntro).l,a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_DeathIntro2(pc),a2
		jsr	(Perform_DPLC).w

.animscan:
		jsr	Obj_Death_Process
		jmp	(Obj_Death_AnimScan).l

DPLCPtr_DeathIntro2:		dc.l ArtUnc_DeathIntro>>1, DPLC_DeathIntro
; ============================================================================
Obj_Death_Index:
		dc.w    Obj_Death_Main-Obj_Death_Index			; 0
		dc.w    Obj_Death_Dialog-Obj_Death_Index	        ; 2
		dc.w    Obj_Death_WaitStepping-Obj_Death_Index		; 4
		dc.w    Obj_Death_StepToSonic-Obj_Death_Index		; 6
		dc.w    Obj_Death_ScytheAttack-Obj_Death_Index          ; 8
                dc.w    Obj_Death_SelectAttack-Obj_Death_Index          ; A

                dc.w    Obj_Death_JumpPrepare-Obj_Death_Index           ; C
                dc.w    Obj_Death_Jump-Obj_Death_Index                  ; E
                dc.w    Obj_Death_PauseBeforeDash-Obj_Death_Index       ; 10
                dc.w    Obj_Death_Dash-Obj_Death_Index                  ; 12

                dc.w    Obj_Death_JumpPrepare2-Obj_Death_Index          ; 14
                dc.w    Obj_Death_Hide-Obj_Death_Index                  ; 16
                dc.w    Obj_Death_LoadAim-Obj_Death_Index               ; 18
                dc.w    Obj_Death_ThrowScythe-Obj_Death_Index           ; 1A
                dc.w    Obj_Death_FallBack-Obj_Death_Index              ; 1C

                dc.w    Obj_Death_JumpPrepare3-Obj_Death_Index          ; 1E
                dc.w    Obj_Death_JumpProcess-Obj_Death_Index           ; 20
                dc.w    Obj_Death_ThrowPlow-Obj_Death_Index             ; 22
                dc.w    Obj_Death_CheckPlowDeleted-Obj_Death_Index      ; 24
                dc.w    Obj_Death_PrepareToSpinDash-Obj_Death_Index     ; 26
                dc.w    Obj_Death_SpinDash-Obj_Death_Index              ; 28

                dc.w    Obj_Death_JumpPrepare4-Obj_Death_Index          ; 2A
                dc.w    Obj_Death_Jump2-Obj_Death_Index                 ; 2C
                dc.w    Obj_Death_WarningWave-Obj_Death_Index           ; 2E
                dc.w    Obj_Death_FalxThrow-Obj_Death_Index             ; 30
                dc.w    Obj_Death_FalxThrow_Throw-Obj_Death_Index       ; 32
                dc.w    Obj_Death_ThrowCommand-Obj_Death_Index          ; 34
                dc.w    Obj_Death_PauseBeforeDash-Obj_Death_Index       ; 36
                dc.w    Obj_Death_Dash-Obj_Death_Index                  ; 38

                dc.w    Obj_Death_JumpPrepare2-Obj_Death_Index          ; 3A
                dc.w    Obj_Death_Hide-Obj_Death_Index                  ; 3C
                dc.w    Obj_Death_LoadAims-Obj_Death_Index              ; 3E
                dc.w    Obj_Death_ThrowDoubleScythes-Obj_Death_Index    ; 40
                dc.w    Obj_Death_WaitForCommand-Obj_Death_Index        ; 42
                dc.w    Obj_Death_FallBack-Obj_Death_Index              ; 44

                dc.w    Obj_Death_CutsceneStart-Obj_Death_Index         ; 46
                dc.w    Obj_Death_CutsceneBlood-Obj_Death_Index         ; 48
                dc.w    Obj_Death_CutsceneTrembling-Obj_Death_Index     ; 4A
                dc.w    Obj_Death_CutsceneJump-Obj_Death_Index          ; 4C
                dc.w    Obj_Death_CutsceneDash-Obj_Death_Index          ; 4E

		dc.w    Obj_Death_Dialog2-Obj_Death_Index	        ; 50
                dc.w    Obj_Death_IntroComingDown-Obj_Death_Index       ; 52
		dc.w    Obj_Death_Dialog3-Obj_Death_Index	        ; 54
; ===========================================================================

Obj_Death_Process:
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$4B,$1C(a0)
		move.b	#0,obColType(a0)
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
		bra.w	.lacricium


.gone:
                samp    sfx_DeathWounded
                clr.w   obVelX(a0)
                move.w  #$F,obTimer(a0)
                st	(Ctrl_1_locked).w
		clr.w	(Ctrl_1_logical).w
                move.b  #$46,routine(a0)
                move.b  #2,obAnim(a0)

.lacricium:
		rts
; ===========================================================================

Obj_Death_AnimScan:
		btst   	#6,$2A(a0)
		bne.s  	+
		moveq	#0,d0
		move.b 	obAnim(a0),d0
		move.b 	Obj_Death_Data_Collision(pc,d0.w),d1
		move.b 	d1,obColType(a0)
+	        move.b	$1C(a0),d0
		beq.s	+
		lsr.b	#3,d0
		bcc.w	Obj_Death_Return
+               cmpi.b  #2,routine(a0)
                beq.s   .nullcol
                cmpi.b  #$46,routine(a0)
                bcc.s   .nullcol
                jmp	(Draw_And_Touch_Sprite).w

.nullcol:
                jmp     (Draw_Sprite).w
; ---------------------------------------------------------------------------
Obj_Death_Data_Collision:
		dc.b  $30
		dc.b  $30
		dc.b  $30
		dc.b  $30
		dc.b  $14|$80
		dc.b  $30
		dc.b  $25|$80
		dc.b  $30
		dc.b  $30
		dc.b  $38|$80

; ===========================================================================
Obj_Death_HP:
		dc.b 10/2	; Easy
		dc.b 10		; Normal
		dc.b 10+6	; Hard
		dc.b 10+2	; Maniac

Obj_Death_ChkSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$40,d2
   		bcc.w	Obj_Death_Return
                clr.w   obVelX(a0)
                move.b  #3,obAnim(a0)
                move.b  #8,routine(a0)
                rts

Obj_Death_Main:
		st	objoff_3A(a0)									; reset DPLC frame
		lea	ObjDat4_DeathIntro(pc),a1
		jsr	SetUp_ObjAttributes
                bchg    #0,obStatus(a0)
  		move.b	#0,obSubtype(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_Death_HP(pc,d0.w),$29(a0)
                clr.b   objoff_34(a0)

                samp	sfx_ThunderClamp
		move.b	#3,(Hyper_Sonic_flash_timer).w
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion333(pc),a2
		jsr	(CreateChild6_Simple).w
                bne.w   Obj_Death_Return
                st	$40(a1)
                move.w  #$2A,obTimer(a0)

Obj_Death_Dialog:
                cmpi.w  #0,obTimer(a0)
                beq.s   ++
                sub.w   #1,obTimer(a0)
                btst	#2,(Level_frame_counter+1).w
		beq.w   +
		lea	ChildObjDat_DialogueFirebrand_Fire669(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.w   Obj_Death_Return
                move.w	#$59C,$30(a1)
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.w	Obj_Death_Return
		samp	sfx_ThunderClamp
		move.b	#1,(Hyper_Sonic_flash_timer).w
                rts
+               cmpi.b  #6,(Dynamic_resize_routine).w
		bne.w	Obj_Death_Return

		lea	(ArtKosM_DeathScythe).l,a1
		move.w	#tiles_to_bytes($330),d2
		jsr	(Queue_Kos_Module).w

		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($59C),d2
		jsr	(Queue_Kos_Module).w

                cmpi.w  #1,(DialogueAlreadyShown).w
                beq.s   .skip
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_LookUp<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		st	(NoPause_flag).w
		st	(Level_end_flag).w
		jsr	(Load_BlackStretch).l
                jsr	(Create_New_Sprite).w
		bne.s	.return
                move.w  a1,parent(a0)
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_SCZ3,routine(a1)

		; load main dialog
		move.l	#DialogDeathSCZ3_Process_Index-4,$34(a1)
		move.b	#(DialogDeathSCZ3_Process_Index_End-DialogDeathSCZ3_Process_Index)/8,$39(a1)

		tst.b	(Extended_mode).w
		beq.s	.skip

		; load alt dialog
		move.l	#DialogDeathSCZ3_EX_Process_Index-4,$34(a1)
		move.b	#(DialogDeathSCZ3_EX_Process_Index_End-DialogDeathSCZ3_EX_Process_Index)/8,$39(a1)

.skip
		move.b	#$50,routine(a0)

.return
                rts

Obj_Death_Dialog2:
                cmpi.w  #1,(DialogueAlreadyShown).w
                beq.s   .skip
		move.w	parent(a0),a1
        	cmpi.b	#1,obDialogWinowsText(a1)
		bcc.w	Obj_Death_Return

.skip:
		lea	(Pal_Death).l,a1
		jsr	(PalLoad_Line1).w
		st	objoff_3A(a0) ; reset DPLC frame
		lea	ObjDat4_Death(pc),a1
		jsr	SetUp_ObjAttributes
                bchg    #0,obStatus(a0)
		lea	(Player_1).w,a1
		move.w	#id_Wait2<<8,anim(a1)
                move.b  #8,obAnim(a0)
                move.w  #$500,obVelY(a0)
                rts

Obj_Death_IntroComingDown:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A0,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                move.w  #$F0,obTimer(a0)
                move.w  #$3C,objoff_3E(a0)
                clr.w    obVelY(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		sfx	sfx_Pump
                move.b  #0,obAnim(a0)
		addq.b	#2,routine(a0)
                rts

Obj_Death_Dialog3:

                cmpi.w  #1,(DialogueAlreadyShown).w
                beq.s   .skip
                cmpi.b  #8,(Dynamic_resize_routine).w
		bne.w	Obj_Death_Return
                move.w  #1,(DialogueAlreadyShown).w

.skip:
                move.b  #8,(Dynamic_resize_routine).w
                move.b  #4,routine(a0)

Obj_Death_WaitStepping:
                jsr     (Obj_Death_SelectAttack).l
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
		jsr	(Obj_Eggman_LookOnSonic).l
                move.b  #1,obAnim(a0)
                move.w  #$100,obVelX(a0)
                btst    #0,obStatus(a0)
                bne.s   +
                neg.w   obVelX(a0)
+		addq.b	#2,routine(a0)

Obj_Death_StepToSonic:
                jsr     (Obj_Death_SelectAttack).l
                jsr     (Obj_Death_ChkSonic).l
                jsr     (SpeedToPos).l
                cmpi.b  #0,obAnim(a0)
                bne.w   Obj_Death_Return
                clr.w   obVelX(a0)
                move.w  #$3C,objoff_3E(a0)
                subq.b	#2,routine(a0)
                rts

Obj_Death_ScytheAttack:
                cmpi.b  #4,obAnim(a0)
                beq.w   Obj_Death_PlayScytheSound
                cmpi.b  #6,obAnim(a0)
                beq.w   Obj_Death_PlayScytheSound
                cmpi.b  #0,obAnim(a0)
                bne.w   Obj_Death_Return
                addq.b	#2,routine(a0)
                cmpi.w  #$3C,obTimer(a0)
                blt.s   +
                move.w  #$3C,obTimer(a0)
+               rts
; ===========================================================================
Obj_Death_JumpPrepare:
                move.w  #-$700,obVelY(a0)
                move.b  #8,obAnim(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
                addq.b	#2,routine(a0)

Obj_Death_Jump:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obVelY(a0),d0
                cmpi.w  #-$80,d0
                blt.w   Obj_Death_Return
                move.b  #9,obAnim(a0)
                move.w  #$2A,objoff_3E(a0)
                sfx     sfx_Spindash
                addq.b	#2,routine(a0)
                rts

Obj_Death_PauseBeforeDash:
		jsr	(Obj_Eggman_LookOnSonic).l
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
                sfx     sfx_Teleport
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#3,d0
		move.w	d0,obVelX(a0)
                addq.b	#2,routine(a0)
                rts

Obj_Death_Dash:
               btst #0,obStatus(a0)
               beq.s .left
               move.w     (Camera_max_x_pos).w,d0
               add.w      #$118,d0
               move.w     obX(a0),d1
               cmp.w     d0,d1
               blt.s .cont
               neg.w obVelX(a0)
               bra.s .cont

.left:
               move.w     (Camera_min_x_pos).w,d0
               add.w      #$10,d0
               move.w     obX(a0),d1
               cmp.w     d0,d1
               bcc.s .cont
               neg.w obVelX(a0)

.cont:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A0,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                move.b  #0,obAnim(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		sfx	sfx_Pump
		jsr	(Obj_Eggman_LookOnSonic).l
                clr.w   obVelY(a0)
                clr.w   obVelX(a0)

                move.w  #$3C,objoff_3E(a0)
                move.b  #4,routine(a0)
                rts
; ===========================================================================
Obj_Death_JumpPrepare2:
                clr.b   objoff_48(a0)
                move.w  (Player_1+obX).w,d0
                sub.w   (Camera_min_x_pos).w,d0
                cmpi.w  #$97,d0
                blt.s   +
                move.b  #1,objoff_48(a0)
+               move.w  #-$300,obVelY(a0)
                move.b  #8,obAnim(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
                addq.b	#2,routine(a0)

Obj_Death_Hide:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$128,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_min_x_pos).w,d0
                add.w   #$2E,d0
                move.w  d0,objoff_12(a0)
                addq.b	#2,routine(a0)
                rts

Obj_Death_LoadAim:
                cmpi.b  #1,objoff_48(a0)
                bne.s   +
                move.w  (Camera_max_x_pos).w,d0
                add.w   #$124,d0
                move.w  d0,objoff_12(a0)
+               move.w  #$3C,objoff_3E(a0)
                clr.b   objoff_34(a0)
                
                jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheAim,(a1)
		move.w  a0,parent3(a1)
		move.w	objoff_12(a0),obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$B8,d0
		move.w	d0,obY(a1)
                move.w  #$3C,obTimer(a1)
                addq.b	#2,routine(a0)

Obj_Death_ThrowScythe:
                cmpi.b  #5,objoff_34(a0)
                beq.w   +++
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return

		samp	sfx_WalkingArmorAtk
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheSpin,(a1)
		move.w  a0,parent3(a1)
		move.w	objoff_12(a0),obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$10F,d0
		move.w	d0,obY(a1)

                add.w   #$3C,objoff_12(a0)
                cmpi.b  #1,objoff_48(a0)
                bne.s   +
                sub.w   #$78,objoff_12(a0)

+               cmpi.b  #4,objoff_34(a0)
                beq.w   +
                jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheAim,(a1)
		move.w  a0,parent3(a1)
		move.w	objoff_12(a0),obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$B8,d0
		move.w	d0,obY(a1)
                move.w  #$2A,obTimer(a1)


+                add.b   #1,objoff_34(a0)
                move.w  #$2A,objoff_3E(a0)
                rts

+               clr.b   objoff_34(a0)
                clr.w   obVelX(a0)
                move.b  #9,obAnim(a0)
                move.w  #$3C,objoff_3E(a0)

                move.w  (Camera_target_max_y_pos).w,obY(a0)
                sub.w   #$3C,obY(a0)

                sfx     sfx_Switch
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$02,subtype(a1)		; Jump|Art ID nibble
		move.w	#$96,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

                addq.b	#2,routine(a0)

Obj_Death_FallBack:
                   cmpi.w             #0,objoff_3E(a0)
                   beq.s              +
                move.w  (Player_1+obX).w,obX(a0)
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return


+               jsr     (ObjectFall).l
                jsr     (Obj_Produce_AfterImage).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A0,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                move.b  #0,obAnim(a0)
                clr.w   obVelY(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		move.w	#$14,(Screen_Shaking_Flag).w
		sfx	sfx_Pump
                move.w  #$3C,objoff_3E(a0)
                move.b  #4,routine(a0)
                rts
; ===========================================================================
Obj_Death_JumpPrepare3:
		jsr	(Obj_Eggman_LookOnSonic).l
                move.w  #$600,obVelX(a0)
                btst    #0,obStatus(a0)
                bne.s   +
                neg.w   obVelX(a0)
+               move.w  #-$500,obVelY(a0)
                move.b  #8,obAnim(a0)
                clr.w   objoff_48(a0)
                addq.b	#2,routine(a0)

Obj_Death_JumpProcess:
                jsr     (Obj_Produce_AfterImage).l
               jsr     (ObjectFall).l
               btst #0,obStatus(a0)
               beq.s .left
               move.w     (Camera_x_pos).w,d0
               add.w      #$158,d0
               move.w     obX(a0),d1
                cmp.w  d0,d1
                blt.w  Obj_Death_Return
                bra.s   .cont

.left:
               move.w     (Camera_x_pos).w,d0
                sub.w   #$18,d0
               move.w     obX(a0),d1
               cmp.w     d0,d1
                bcc.w  Obj_Death_Return

.cont:

                bchg    #0,obStatus(a0)
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                move.w  #$3C,objoff_3E(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$15,subtype(a1)		; Jump|Art ID nibble
                move.w	#$20,$42(a1)			; Xpos
                btst #0,obStatus(a0)
                bne.s +
                move.b	#$13,subtype(a1)
                move.w	#$118,$42(a1)			; Xpos
+	        move.w  #$A0,$44(a1)
        	move.w	#$F,$3A(a1)			; Before Timer
                move.w	#$2D,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

                sfx     sfx_Switch

                addq.b	#2,routine(a0)

Obj_Death_ThrowPlow:
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
                samp	sfx_WalkingArmorAtk
                jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScythePlow,(a1)
		move.w  a0,parent3(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.w  #-$300,obVelY(a1)
                move.w  #-$900,obVelX(a1)
                btst    #0,obStatus(a0)
                bne.s   .branch
                bchg    #0,obStatus(a1)
.branch
                addq.b	#2,routine(a0)

Obj_Death_CheckPlowDeleted:
                cmpi.w  #4,objoff_48(a0)
                bne.w   Obj_Death_Return
                move.w  #$3C,objoff_3E(a0)
                sfx     sfx_Spindash

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$15,subtype(a1)		; Jump|Art ID nibble
                move.w	#$18,$42(a1)			; Xpos
                btst #0,obStatus(a0)
                bne.s +
                move.b	#$13,subtype(a1)
                move.w	#$108,$42(a1)			; Xpos
+		move.w	#$3C,$2E(a1)			; Timer
                move.w	#$B0,$44(a1)			; Ypos
		move.w	#$84A0,art_tile(a1)		; VRAM
                addq.b	#2,routine(a0)

Obj_Death_PrepareToSpinDash:
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
                sfx     sfx_Teleport
                move.b  #9,obAnim(a0)
                move.w  #$900,obVelX(a0)
                btst    #0,obStatus(a0)
                bne.s   +
                neg.w   obVelX(a0)
+               clr.w   obVelY(a0)
                addq.b	#2,routine(a0)
                rts

Obj_Death_SpinDash:
               jsr     (Obj_Produce_AfterImage).l
               jsr     (SpeedToPos).l
               btst #0,obStatus(a0)
               beq.s .left
               move.w     (Camera_x_pos).w,d0
               add.w      #$114,d0
               move.w     obX(a0),d1
                cmp.w  d0,d1
                blt.w  Obj_Death_Return
                bra.s   .cont

.left:
               move.w     (Camera_x_pos).w,d0
              add.w      #$28,d0
               move.w     obX(a0),d1
               cmp.w     d0,d1
                bcc.w  Obj_Death_Return

.cont:
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                move.b  #0,obAnim(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		sfx	sfx_Pump
		jsr	(Obj_Eggman_LookOnSonic).l
                clr.w   obVelY(a0)
                clr.w   obVelX(a0)

                move.w  #$3C,objoff_3E(a0)
                move.b  #4,routine(a0)
                rts
; ===========================================================================
Obj_Death_JumpPrepare4:
		jsr	(Obj_Eggman_LookOnSonic).l
                move.w  #-$800,obVelY(a0)
                move.b  #9,obAnim(a0)
                move.w  (Camera_x_pos).w,d0
                add.w   #$94,d0
                sub.w   obX(a0),d0
                asl.w   #3,d0
                move.w  d0,obVelX(a0)
                addq.b	#2,routine(a0)
                rts

Obj_Death_Jump2:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obVelY(a0),d0
                cmpi.w  #-$20,d0
                blt.w   Obj_Death_Return
                move.b  #9,obAnim(a0)
                move.w  #$3C,objoff_3E(a0)
                sfx     sfx_Spindash
                clr.w   obVelY(a0)
                clr.w   objoff_16(a0)
                clr.b   objoff_48(a0)
                clr.b   objoff_49(a0)
                addq.b	#2,routine(a0)

Obj_Death_WarningWave:
                cmpi.b  #$C,objoff_48(a0)
                bcc.s   .gonext
                lea	(ChildObjDat6_BossAim).l,a2
 		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$10,subtype(a1)		; Jump|Art ID nibble
                move.b  objoff_48(a0),d0
                lea     (Obj_Death_FalxLevel2_XPoses).l,a2
                move.w  (a2,d0.w),$42(a1)		; Xpos
                move.w	#$BC,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM
                addq.b  #2,objoff_48(a0)
                rts

.gonext:
                clr.b   objoff_48(a0)
                addq.b	#2,routine(a0)

Obj_Death_FalxThrow:
                jsr     (Swing_UpAndDown).w
                move.w  (Camera_x_pos).w,d0
                add.w   #$94,d0
                sub.w   obX(a0),d0
                asl.w   #2,d0
                move.w  d0,obVelX(a0)
                jsr     (SpeedToPos).l
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
                move.w  #$3C,objoff_3E(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
                sfx     sfx_Basaran
                clr.b   objoff_48(a0)
                addq.b	#2,routine(a0)
                rts

Obj_Death_FalxThrow_Throw:
                cmpi.b  #4,objoff_49(a0)
                bcc.w   .gonext
                cmpi.b  #$C,objoff_48(a0)
                bcc.s   .goback

                jsr     (SingleObjLoad).l
                bne.w   Obj_Death_Return
                move.l  #Obj_Death_FalxLevel2,(a1)
                move.w  a0,parent3(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                move.b  objoff_48(a0),objoff_48(a1)
                move.b  objoff_49(a0),objoff_49(a1)
                move.b  objoff_3D(a0),objoff_3D(a1)
                addq.b  #2,objoff_48(a0)
                rts

.goback:        move.w  #$5A,objoff_3E(a0)
                move.b  #$A,obAnim(a0)
                add.b   #1,objoff_49(a0)
                clr.b   objoff_48(a0)
                eor.b   #$01,objoff_3D(a0)
                subq.b	#2,routine(a0)
                rts

.gonext:
                clr.b   objoff_49(a0)

                sfx     sfx_Switch
                sfx     sfx_Roll

                addq.b	#2,routine(a0)
                rts

Obj_Death_ThrowCommand:
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return

                addq.b	#2,routine(a0)
                rts
; ===========================================================================
Obj_Death_LoadAims:
                move.w  #$3C,objoff_3E(a0)

                clr.b   objoff_48(a0)

          ;      jsr	(SingleObjLoad).w
	;	bne.w	Obj_Death_Return
	;	move.l	#Obj_DeathScytheAim,(a1)
	;	move.w  a0,parent3(a1)
               ; move.w  (Camera_x_pos).w,d0
               ; add.w   #$18,d0
	;	move.w	d0,obX(a1)
	;	move.w	(Camera_max_y_pos).w,d0
	;	add.w	#$B8,d0
	;	move.w	d0,obY(a1)
               ; bchg    #0,obStatus(a1)
               ; move.w  #$3C,obTimer(a1)
                sfx     sfx_Switch

                lea	(ChildObjDat6_BossAim).l,a2
 		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$12,subtype(a1)		; Jump|Art ID nibble
                move.w  #$20,$42(a1)		; Xpos
                move.w	#$A8,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

                lea	(ChildObjDat6_BossAim).l,a2
 		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$12,subtype(a1)		; Jump|Art ID nibble
                move.w  #$118,$42(a1)		; Xpos
                move.w	#$A8,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

                addq.b	#2,routine(a0)

Obj_Death_ThrowDoubleScythes:
                sub.w   #1,objoff_3E(a0)
                bpl.w   Obj_Death_Return
		samp	sfx_WalkingArmorAtk
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheDouble,(a1)
		move.w  a0,parent3(a1)
                move.w  (Camera_x_pos).w,d0
                add.w   #$18,d0
		move.w	d0,obX(a1)
                bchg    #0,obStatus(a1)
		move.w	(Camera_max_y_pos).w,d0
		sub.w	#$F,d0
		move.w	d0,obY(a1)
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheDouble,(a1)
		move.w  a0,parent3(a1)
                move.w  (Camera_x_pos).w,d0
                add.w   #$124,d0
		move.w	d0,obX(a1)
                move.b  #1,obSubtype(a1)
		move.w	(Camera_max_y_pos).w,d0
		sub.w	#$F,d0
		move.w	d0,obY(a1)
                addq.b	#2,routine(a0)

Obj_Death_WaitForCommand:
                cmpi.b  #1,objoff_48(a0)
                bne.w   Obj_Death_Return
                clr.b   objoff_48(a0)
                move.b  #9,obAnim(a0)
                move.w  #$3C,objoff_3E(a0)

                move.w  (Camera_target_max_y_pos).w,obY(a0)
                sub.w   #$3C,obY(a0)

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$02,subtype(a1)		; Jump|Art ID nibble
		move.w	#$96,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM
                sfx     sfx_Switch
                sfx     sfx_Roll
                addq.b	#2,routine(a0)
; ===========================================================================
Obj_Death_SelectAttack:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Death_Return

Obj_Death_SelectAttack_Select:
                move.w  #$F0,obTimer(a0)
 		jsr	(RandomNumber).w
		andi.w	#3,d0
		move.b	Obj_Death_SelectAttack_AttackData(pc,d0.w),d1
                move.b  objoff_47(a0),d2
                cmp.b   d1,d2
                beq.s   .chkrepeat
                bra.s   .setatk

.chkrepeat:
                add.w   #1,d0
		move.b	Obj_Death_SelectAttack_AttackData(pc,d0.w),d1

.setatk:
                move.b  d1,routine(a0)
                move.b  d1,objoff_47(a0)
                rts

Obj_Death_SelectAttack_AttackData:
                dc.b    $C
                dc.b    $1E
                dc.b    $2A
                dc.b    $3A
                dc.b    $C
                dc.b    $3A

Obj_Death_PlayScytheSound:
		samp	sfx_WalkingArmorAtk

Obj_Death_Return:
                rts

; ===========================================================================
Obj_Death_CutsceneStart:
                jsr     (ObjectFall).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A0,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A0,d0
                move.w` d0,obY(a0)
                clr.b   objoff_48(a0)
                addq.b	#2,routine(a0)

Obj_Death_CutsceneBlood:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Death_Cutscene_Return
                move.w  #$3C,obTimer(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#$F,subtype(a1)
		move.l	#Pal_DeathDefeat,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
                move.w	#16-1,$38(a1)
+               jsr	(Obj_HurtBloodCreate).l
		move.b	#$48,obHeight(a0)
		move.b	#$48,obWidth(a0)
		move.b	#$48,x_radius(a0)
		move.b	#$48,y_radius(a0)
                addq.b	#2,routine(a0)

Obj_Death_CutsceneTrembling:
		move.w  v_framecount.w,d0
		lsr.b	#1,d0
		bcc.w	.addX
                sub.w   #2,obX(a0)
                bra.s   .cont

.addX:
                add.w   #2,obX(a0)

.cont:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Death_Cutscene_Return
                move.b  #8,obAnim(a0)
                move.w  #-$600,obVelY(a0)
                clr.w   obVelX(a0)
                bset    #0,obStatus(a0)
                addq.b	#2,routine(a0)

Obj_Death_CutsceneJump:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obVelY(a0),d0
                cmpi.w  #-$20,d0
                blt.w   Obj_Death_Return
                move.b  #9,obAnim(a0)
                move.w  #$B00,obVelX(a0)
                clr.w   obVelY(a0)
                sfx     sfx_Teleport
                addq.b	#2,routine(a0)

Obj_Death_CutsceneDash:
                bsr.s   Obj_Death_RestoreGFX
                jsr     (SpeedToPos).l
                move.w  obX(a0),d0
                sub.w   (Camera_min_x_pos).w,d0
                cmpi.w  #$300,d0
                blt.s   Obj_Death_Cutscene_Return
                move.l  #Go_Delete_Sprite,(a0)
		move.w	#$1F00,(Camera_max_X_pos).w
		clr.w	(Camera_min_Y_pos).w
		move.w	#$480,(Camera_target_max_Y_pos).w
;		move.w	#$540,(Target_water_level).w
		clr.w	(Ctrl_1_logical).w
                sf	(Ctrl_1_locked).w
		lea	(Pal_SCZ).l,a1
		jsr	(PalLoad_Line1).w
		lea	(PLC_Main7).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		addq.b	#2,(Dynamic_resize_routine).w

Obj_Death_RestoreGFX:
                cmpi.b  #1,objoff_48(a0)
                beq.s   Obj_Death_Cutscene_Return
                jsr     (ChkObjOnScreen).w
                beq.s   Obj_Death_Cutscene_Return
                move.b  #1,objoff_48(a0)
		lea	(PLC2_SCZ3_Enemy).l,a5
		jsr	(LoadPLC_Raw_KosM).w


Obj_Death_Cutscene_Return:
                rts
; ---------------------------------------------------------------------------
; Thrown Death Scythe
; ---------------------------------------------------------------------------
Obj_DeathScytheSpin:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheSpin_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheSpin_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DeathScytheSpin_Index:
		dc.w Obj_DeathScytheSpin_Main-Obj_DeathScytheSpin_Index
		dc.w Obj_DeathScytheSpin_PopUp-Obj_DeathScytheSpin_Index
		dc.w Obj_DeathScytheSpin_FallDown-Obj_DeathScytheSpin_Index

Obj_DeathScytheSpin_Main:
		move.w	#-$900,obVelY(a0)
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$2E|$80,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)

Obj_DeathScytheSpin_PopUp:
		jsr	(ObjectFall).w
		move.w	obVelY(a0),d0
		cmpi.w	#-$100,d0
		blt.w	Obj_DeathScytheSpin_Return
		addq.b	#2,routine(a0)
		rts

Obj_DeathScytheSpin_FallDown:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_DeathScytheSpin_Return
		add.w	#$1A,obY(a0)
		clr.b	obColType(a0)
		move.l	#Go_Delete_Sprite,address(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		lea	ChildObjDat_DeathRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w


Obj_DeathScytheSpin_Return:
		rts
; ---------------------------------------------------------------------------
; Double Death Scythe
; ---------------------------------------------------------------------------
Obj_DeathScytheDouble:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheDouble_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheDouble_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DeathScytheDouble_Index:
		dc.w Obj_DeathScytheDouble_Main-Obj_DeathScytheDouble_Index
		dc.w Obj_DeathScytheDouble_FallDown-Obj_DeathScytheDouble_Index
		dc.w Obj_DeathScytheDouble_Plow-Obj_DeathScytheDouble_Index
		dc.w Obj_DeathScytheDouble_FlyUp-Obj_DeathScytheDouble_Index
		dc.w Obj_DeathScytheDouble_FlyDown-Obj_DeathScytheDouble_Index

Obj_DeathScytheDouble_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$2E|$80,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)

Obj_DeathScytheDouble_FallDown:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_DeathScytheDouble_Return
		add.w	#$1A,obY(a0)
		clr.b	obColType(a0)
		move.b	#$8D,obColType(a0)
		move.b	#4,obAnim(a0)
                move.w  #$4F,obTimer(a0)

		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$04,subtype(a1)		; Jump|Art ID nibble
		move.w	#-$3C,$44(a1)			; Ypos
		move.w	#$4F,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

                clr.w   obVelY(a0)
                cmpi.b  #1,obSubtype(a0)
                beq.s   +
		move.w	#$14,(Screen_Shaking_Flag).w
                sfx     sfx_Pump
                st	(Screen_Shaking_Flag).w
+		addq.b	#2,routine(a0)

Obj_DeathScytheDouble_Plow:
                cmpi.b  #1,obSubtype(a0)
                beq.s   +
                jsr     (WaterBlock_Push_Sound).l
+               jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).l
                btst    #0,obStatus(a0)
                beq.s   .left
                cmpi.w  #$600,obVelX(a0)
                bcc.s   .cont
                add.w   #$A,obVelX(a0)
                bra.s   .cont

.left:
                cmpi.w  #-$600,obVelX(a0)
                blt.s   .cont
                sub.w   #$A,obVelX(a0)

.cont:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DeathScytheDouble_Return
                move.w  (Camera_x_pos).w,d0
                add.w   #$94,d0
                move.w  d0,obX(a0)
                cmpi.b  #1,obSubtype(a0)
                bne.s   .makedouble
		move.l	#Go_Delete_Sprite,address(a0)
                sf	(Screen_Shaking_Flag).w
		lea	ChildObjDat_DeathRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w

.makedouble:
                move.w  #-$800,obVelY(a0)
		move.b	#$16|$80,obColType(a0)
                move.b  #5,obAnim(a0)
                clr.b   objoff_48(a0)
                clr.w   obVelX(a0)
                clr.w   obVelY(a0)
                move.w  #3,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_DeathScytheDouble_FlyUp:
                bsr.w   Obj_DeathScytheDouble_MakeTrail
                cmpi.b  #4,objoff_48(a0)
                bcc.s   .delete
                cmpi.b  #2,objoff_48(a0)
                blt.s   .yspd
		jsr	(Find_SonicObject).l
		move.w	#$300,d0
		moveq	#$30,d1
		jsr	(Chase_ObjectXOnly).w

.yspd:
		jsr	(ObjectFall).w
                move.w  obVelY(a0),d0
                cmpi.w  #-$80,d0
                blt.w   Obj_Death_Return
	        addq.b	#2,routine(a0)
                rts

.delete:
                jsr     (SpeedToPos).l
                move.w  (camera_max_y_pos).w,d0
                sub.w   obY(a0),d0
                cmpi.w  #$20,d0
                blt.s   +
		move.w	#$14,(Screen_Shaking_Flag).w
		lea	ChildObjDat_DeathRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
                move.l  #Go_Delete_Sprite,(a0)
                move.w  parent3(a0),a1
                move.b  #1,objoff_48(a1)
+               rts

Obj_DeathScytheDouble_FlyDown:
                bsr.w   Obj_DeathScytheDouble_MakeTrail
		jsr	(Find_SonicObject).l
		move.w	#$300,d0
		moveq	#$18,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$A8,d0
                blt.w   Obj_Death_Return
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$A8,d0
                move.w` d0,obY(a0)
                add.b   #1,objoff_48(a0)
                move.w  #-$800,obVelY(a0)
                sfx     sfx_Pump
		move.w	#$14,(Screen_Shaking_Flag).w
		subq.b	#2,routine(a0)
                rts

Obj_DeathScytheDouble_MakeTrail:
                sub.w   #1,obTimer(a0)
                bpl.s   Obj_DeathScytheDouble_Return
                move.w  #1,obTimer(a0)
                jsr     (SingleObjLoad).l
                bne.w   Obj_DeathScythePlow_Return
                move.l  #Obj_DoubleScythe_Trail,(a1)
                move.w  a0,parent(a1)
                move.w  obX(a0),obX(a1)
                move.w  obY(a0),obY(a1)

Obj_DeathScytheDouble_Return:
		rts
; ---------------------------------------------------------------------------
; Plow Death Scythe
; ---------------------------------------------------------------------------
Obj_DeathScythePlow:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScythePlow_Index(pc,d0.w),d1
		jsr	Obj_DeathScythePlow_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DeathScythePlow_Index:
		dc.w Obj_DeathScythePlow_Main-Obj_DeathScythePlow_Index
		dc.w Obj_DeathScythePlow_Fall-Obj_DeathScythePlow_Index
		dc.w Obj_DeathScythePlow_Pause-Obj_DeathScythePlow_Index
		dc.w Obj_DeathScythePlow_Plow-Obj_DeathScythePlow_Index

Obj_DeathScythePlow_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$8D,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)
		move.b	#3,obAnim(a0)
                btst    #0,obStatus(a0)
                bne.w   Obj_DeathScythePlow_Return
                neg.w   obVelX(a0)

Obj_DeathScythePlow_Fall:
                jsr     (Obj_Produce_AfterImage).l
                jsr     (ObjectFall).l
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$C0,d0
                blt.w   Obj_Death_Return
		move.w	#$14,(Screen_Shaking_Flag).w
                sfx     sfx_Pump
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$C0,d0
                move.w` d0,obY(a0)
                clr.w   obVelY(a0)
                clr.w   obVelX(a0)
                move.w  #$3C,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_DeathScythePlow_Pause:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DeathScythePlow_Return
                st	(Screen_Shaking_Flag).w
		move.b	#4,obAnim(a0)
                move.w  #$2C,obTimer(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$04,subtype(a1)		; Jump|Art ID nibble
		move.w	#-$3C,$44(a1)			; Ypos
		move.w	#$F,$2E(a1)			; Timer
		move.w	#$1A,$3A(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM
		addq.b	#2,routine(a0)

Obj_DeathScythePlow_Plow:
                jsr     (WaterBlock_Push_Sound).l
                jsr     (Obj_DeathScythePlow_CreateFalx).l
                jsr     (Obj_Produce_AfterImage).l
                jsr     (SpeedToPos).l
                btst #0,obStatus(a0)
               beq.s .left
                cmpi.w  #$600,obVelX(a0)
                bcc.s   .checkright
                add.w   #$A,obVelX(a0)

.checkright:
               move.w     (Camera_x_pos).w,d0
               add.w      #$158,d0
               move.w     obX(a0),d1
                cmp.w  d0,d1
                blt.w  Obj_Death_Return
                bra.s   .cont

.left:
                cmpi.w  #-$600,obVelX(a0)
                blt.s   .checkleft
                sub.w   #$A,obVelX(a0)

.checkleft:
               move.w     (Camera_x_pos).w,d0
                sub.w   #$18,d0
               move.w     obX(a0),d1
               cmp.w     d0,d1
                bcc.w  Obj_Death_Return

.cont:
                sf	(Screen_Shaking_Flag).w
		move.l	#Go_Delete_Sprite,address(a0)
                bra.w   Obj_DeathScythePlow_Return

Obj_DeathScythePlow_CreateFalx:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DeathScythePlow_Return
                jsr     (SingleObjLoad).l
                bne.w   Obj_DeathScythePlow_Return
                move.l  #Obj_DeathScytheFalx,(a1)
                move.w  parent3(a0),parent3(a1)
                move.w  obX(a0),obX(a1)

                btst    #0,obStatus(a0)
                beq.s   .left
                sub.w   #$16,obX(a1)
                bra.s   .cont

.left:
                add.w   #$16,obX(a1)

.cont:
                move.w  obX(a1),objoff_12(a0)
                move.w  obY(a0),obY(a1)
                move.w  #-$400,obVelY(a1)
                sfx	sfx_Basaran
                move.w  #$1A,obTimer(a0)

                jsr     (SingleObjLoad).l
                bne.s   Obj_DeathScythePlow_Return
                move.l  #Obj_DeathFalx_Explosion,(a1)
                move.w  objoff_12(a0),obX(a1)
                move.w  obY(a0),obY(a1)
                sfx     sfx_Explosion
                clr.w   objoff_12(a0)
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
                move.b	#$04,subtype(a1)		; Jump|Art ID nibble
		move.w	#-$3C,$44(a1)			; Ypos
		move.w	#$F,$2E(a1)			; Timer
		move.w	#$F,$3A(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

Obj_DeathScythePlow_Return:
                rts

; ---------------------------------------------------------------------------
; Death Scythe Falx
; ---------------------------------------------------------------------------
Obj_DeathScytheFalx:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheFalx_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheFalx_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DeathScytheFalx_Index:
		dc.w Obj_DeathScytheFalx_Main-Obj_DeathScytheFalx_Index
		dc.w Obj_DeathScytheFalx_FlyUp-Obj_DeathScytheFalx_Index
		dc.w Obj_DeathScytheFalx_Pause-Obj_DeathScytheFalx_Index
		dc.w Obj_DeathScytheFalx_Fall-Obj_DeathScytheFalx_Index

Obj_DeathScytheFalx_Main:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$8B,obColType(a0)
                move.w  #$2C,obTimer(a0)
		move.b	#2,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_DeathScytheFalx_FlyUp:
  		jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DeathScytheFalx_Return
                move.w  #$5A,obTimer(a0)
                clr.w   obVelY(a0)
                addq.b	#2,routine(a0)
                jmp	(Swing_Setup1).w

Obj_DeathScytheFalx_Pause:
                jsr 	(Swing_UpAndDown).w
                jsr	(SpeedToPos).w
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_DeathScytheFalx_Return
                sfx	sfx_Basaran
                move.w  (Player_1+obX).w,d0
                sub.w   obX(a0),d0
                asl.w   #2,d0
                move.w  d0,obVelX(a0)
		addq.b	#2,routine(a0)

Obj_DeathScytheFalx_Fall:
  		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$B8,d0
                blt.w   Obj_Death_Return
		move.w	#$14,(Screen_Shaking_Flag).w
		move.l	#Go_Delete_Sprite,address(a0)
                move.w  parent3(a0),a1
                add.w   #1,objoff_48(a1)
                sfx     sfx_Explosion
		lea	ChildObjDat_DEZExplosion23(pc),a2
		jmp	(CreateChild6_Simple).w

Obj_DeathScytheFalx_Return:
                rts
; ---------------------------------------------------------------------------
; Death Falx
; ---------------------------------------------------------------------------
Obj_DeathFalx:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathFalx_Index(pc,d0.w),d1
		jsr	Obj_DeathFalx_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DeathFalx_Index:
		dc.w Obj_DeathFalx_Main-Obj_DeathFalx_Index
		dc.w Obj_DeathFalx_FlyOffScreen-Obj_DeathFalx_Index
		dc.w Obj_DeathFalx_WaitForCommand-Obj_DeathFalx_Index
		dc.w Obj_DeathFalx_FlyToOtherSide-Obj_DeathFalx_Index

Obj_DeathFalx_Main:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$8B,obColType(a0)
                move.w  #$1A,obTimer(a0)
		move.b	#2,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_DeathFalx_FlyOffScreen:
                cmpi.w  #0,obVelY(a0)
                blt.s   +
                sub.w   #8,obVelY(a0)
+               jsr     (SpeedToPos).w
                btst #0,obStatus(a0)
                beq.s .left
                move.w     (Camera_x_pos).w,d0
                add.w      #$158,d0
                move.w     obX(a0),d1
                cmp.w  d0,d1
                blt.w  Obj_Death_Return
                bra.s   .cont

.left:
                move.w     (Camera_x_pos).w,d0
                sub.w   #$18,d0
                move.w     obX(a0),d1
                cmp.w     d0,d1
                bcc.w  Obj_Death_Return

.cont:
                bchg    #0,obStatus(a0)
                neg.w   obVelX(a0)
                clr.w   obVelY(a0)
                cmpi.b  #0,objoff_49(a0)
                bgt.s   .randomY
                move.w  (Camera_max_y_pos).w,d0
                add.w   #$B8,d0
                move.w` d0,obY(a0)
                bra.s   .setWarn

.randomY:
 		jsr	(RandomNumber).w
		andi.w	#2,d0
                cmpi.w  #0,d0
                beq.s   +
                cmpi.w  #1,d0
                beq.s   ++
                cmpi.w  #2,d0
                beq.s   +++
+               move.w  #$90,obY(a0)
                bra.s   .setY
+               move.w  #$40,obY(a0)
                bra.s   .setY
+               move.w  #$68,obY(a0)

.setY:
                move.w  (Camera_max_y_pos).w,d0
                add.w   d0,obY(a0)

.setWarn:
                move.b  objoff_49(a0),d0
                asl.b   #3,d0
                move.b  d0,objoff_49(a0)

		lea	(ChildObjDat6_BossAim).l,a2
 		jsr	(CreateChild6_Simple).w
		bne.w	Obj_DeathFalx_Return
                move.b	#$10,subtype(a1)		; Jump|Art ID nibble
		move.w	#$118,$42(a1)			; Xpos
                btst    #0,obStatus(a0)
                beq.s   +
                move.w	#$18,$42(a1)			; Xpos
+		move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                move.w	d0,$44(a1)			; Ypos
                moveq   #0,d0
                move.b  objoff_49(a0),d0
		move.w	d0,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM
                addq.b	#2,routine(a0)

Obj_DeathFalx_WaitForCommand:
                move.w  parent3(a0),a1
                cmpi.b  #1,objoff_48(a1)
                bne.s   Obj_DeathFalx_Return
                addq.b	#2,routine(a0)

Obj_DeathFalx_FlyToOtherSide:
                cmpi.b  #0,objoff_49(a0)
                beq.s   +
                sub.b   #1,objoff_49(a0)
                rts
+               jsr     (SpeedToPos).w
                btst #0,obStatus(a0)
                beq.s .left
                move.w     (Camera_x_pos).w,d0
                add.w      #$158,d0
                move.w     obX(a0),d1
                cmp.w  d0,d1
                blt.w  Obj_Death_Return
                bra.s   .cont

.left:
                move.w     (Camera_x_pos).w,d0
                sub.w   #$18,d0
                move.w     obX(a0),d1
                cmp.w     d0,d1
                bcc.w  Obj_Death_Return

.cont:
		move.l	#Go_Delete_Sprite,address(a0)

Obj_DeathFalx_Return:
                rts
; ---------------------------------------------------------------------------
; Double Scythe Falx
; ---------------------------------------------------------------------------
Obj_DoubleScytheFalx:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DoubleScytheFalx_Index(pc,d0.w),d1
		jsr	Obj_DoubleScytheFalx_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_DoubleScytheFalx_Index:
		dc.w Obj_DoubleScytheFalx_Main-Obj_DoubleScytheFalx_Index
		dc.w Obj_DoubleScytheFalx_Fall-Obj_DoubleScytheFalx_Index

Obj_DoubleScytheFalx_Main:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$8B,obColType(a0)
                move.w  #$1A,obTimer(a0)
		move.b	#2,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_DoubleScytheFalx_Fall:
  		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$B8,d0
                blt.w   Obj_Death_Return
		move.l	#Go_Delete_Sprite,address(a0)
                cmpi.b  #1,obSubtype(a0)
                beq.s   +
                move.w  parent3(a0),a1
                move.b  #1,objoff_48(a1)

+		lea	ChildObjDat_DEZExplosion23(pc),a2
		jmp	(CreateChild6_Simple).w

; ---------------------------------------------------------------------------
; Death Falx level 2 (Gradius PS1 reference)
; ---------------------------------------------------------------------------
Obj_Death_FalxLevel2:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Death_FalxLevel2_Index(pc,d0.w),d1
		jsr	Obj_Death_FalxLevel2_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).l

Obj_Death_FalxLevel2_Index:
		dc.w Obj_Death_FalxLevel2_Main-Obj_Death_FalxLevel2_Index
		dc.w Obj_Death_FalxLevel2_Fall-Obj_Death_FalxLevel2_Index

Obj_Death_FalxLevel2_Main:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$8B,obColType(a0)
                move.w  #$1A,obTimer(a0)
		move.b	#2,obAnim(a0)

                addq.b	#2,routine(a0)
                moveq   #0,d0
                move.b  objoff_48(a0),d0
                lea     (Obj_Death_FalxLevel2_XSpeeds).l,a1
                move.w  (a1,d0.w),obVelX(a0)
                cmpi.b  #1,objoff_3D(a0)
                beq.s   Obj_Death_FalxLevel2_Fall
                add.w   #$D8,obVelX(a0)
		rts

Obj_Death_FalxLevel2_Fall:
  		jsr	(ObjectFall).w
                move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                cmpi.w  #$B8,d0
                blt.w   Obj_Death_Return
                
                cmpi.b  #3,objoff_49(a0)
                bcc.s   +
                lea	(ChildObjDat6_BossAim).l,a2
 		jsr	(CreateChild6_Simple).w
		bne.w	Obj_DeathFalx_Return
                move.b	#$10,subtype(a1)		; Jump|Art ID nibble
                move.w  obX(a0),d0
                add.w   #$20,d0
                sub.w   (Camera_x_pos).w,d0
		move.w	d0,$42(a1)			; Xpos
		move.w  obY(a0),d0
                sub.w   (Camera_max_y_pos).w,d0
                move.w	d0,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$84A0,art_tile(a1)		; VRAM

+               cmpi.b  #1,objoff_48(a0)
                beq.s   +
		move.w	#$14,(Screen_Shaking_Flag).w
                sfx     sfx_Explosion
+               move.l  #Obj_DeathFalx_Explosion,(a0)
                rts


Obj_Death_FalxLevel2_XSpeeds:
                dc.w    -$4B0
                dc.w    -$360
                dc.w    -$1B0
                dc.w    0
                dc.w    $1B0
                dc.w    $360
                dc.w    $4B0

Obj_Death_FalxLevel2_XPoses:
                dc.w    $28
                dc.w    $6F
                dc.w    $B6
                dc.w    $FA
                dc.w    $13A
                dc.w    $00
                dc.w    $1AE

Obj_Death_FalxLevel2_Return:
                rts

; ---------------------------------------------------------------------------
; Double Falx Explosion
; ---------------------------------------------------------------------------
Obj_DeathFalx_Explosion:
		move.l	#Map_Explosion,mappings(a0)
		move.w	#$859C,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$100,priority(a0)
		move.b	#0,collision_flags(a0)
		move.b	#$C,width_pixels(a0)
		move.b	#$C,height_pixels(a0)
		move.b	#3,anim_frame_timer(a0)
		move.b	#0,mapping_frame(a0)
		move.l	#Obj_DeathFalx_Explosion_Draw,(a0)

Obj_DeathFalx_Explosion_Draw:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.w	Obj_DeathFalx_Explosion_Delete
+		jmp	(Draw_Sprite).w

Obj_DeathFalx_Explosion_Delete:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------
; Double Scythe Trail
; ---------------------------------------------------------------------------
Obj_DoubleScythe_Trail:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)
		move.w	#$F,objoff_46(a0)
		move.w	#4,objoff_3E(a0)
		move.l	#Obj_DoubleScythe_Trail_Del,(a0)

Obj_DoubleScythe_Trail_Del:
                sub.w   #1,objoff_46(a0)
                bpl.s   .draw
                move.l	#Go_Delete_Sprite,address(a0)
                rts

.draw:
		move.w  parent(a0),a1
                move.b	obFrame(a1),obFrame(a0)
                move.b	obStatus(a1),obStatus(a0)
                sub.w   #1,objoff_3E(a0)
		bpl.s	Obj_DoubleScythe_Trail_Return
		move.w	#4,objoff_3E(a0)
		jmp	(Draw_Sprite).w

Obj_DoubleScythe_Trail_Return:
		rts
; ---------------------------------------------------------------------------
; Death Scythe Aim
; ---------------------------------------------------------------------------
Obj_DeathScytheAim:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheAim_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheAim_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
  		jmp	(Obj_DeathScytheAim_Display).l

Obj_DeathScytheAim_Index:
		dc.w Obj_DeathScytheAim_Main-Obj_DeathScytheAim_Index
		dc.w Obj_DeathScytheAim_Disappear-Obj_DeathScytheAim_Index

Obj_DeathScytheAim_Display:
		move.w	obTimer(a0),d0
		lsr.w	#3,d0
		bcc.s	Obj_DeathScytheAim_Return
  		jmp	(Child_Draw_Sprite).w

Obj_DeathScytheAim_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8330,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)
		move.b	#1,obAnim(a0)
                sfx     sfx_Switch

Obj_DeathScytheAim_Disappear:
                sub.w   #1,obTimer(a0)
                bpl.s   Obj_DeathScytheAim_Return
		move.l	#Go_Delete_Sprite,address(a0)

Obj_DeathScytheAim_Return:
		rts

; ---------------------------------------------------------------------------
; Death Radius Explosion
; ---------------------------------------------------------------------------

Obj_DeathRadiusExplosion:
		moveq	#0,d2
		move.w	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_DeathRadiusExplosion_GetVelocity,address(a1)
		move.l	#Map_Explosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
		tst.b	$40(a0)
		beq.s	+
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
+		move.b	#4,render_flags(a1)
		move.w	#$80,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	#$8B,obColType(a0)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d2,angle(a1)
		move.b	#3,anim_frame_timer(a1)
		addi.w	#$20,d2
		dbf	d1,-
+		bra.s	DeathExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DeathRadiusExplosion_GetVelocity:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$200,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		move.l	#Obj_DeathRadiusExplosion_Anim,address(a0)

Obj_DeathRadiusExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.s	DeathExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DeathExplosion_Delete:
		move.l	#Delete_Current_Sprite,address(a0)
		rts


ChildObjDat_DEZExplosion22:
		dc.w 1-1
		dc.l Obj_DEZExplosion

ChildObjDat_DEZExplosion23:
		dc.w 1-1
		dc.l Obj_DEZExplosion

DPLCPtr_Death:	dc.l ArtUnc_Death>>1, DPLC_Death

ObjDat4_Death:
		dc.l Map_Death			; Mapping
		dc.w $2290			; VRAM
		dc.w $300			; Priority
		dc.b 38/2			; Width	(64/2)
		dc.b 38/2			; Height(64/2)
		dc.b 0				; Frame
		dc.b $C				; Collision

ObjDat4_DeathIntro:
		dc.l Map_DeathIntro		; Mapping
		dc.w $2270			; VRAM
		dc.w $300			; Priority
		dc.b 72/2			; Width	(64/2)
		dc.b 72/2			; Height(64/2)
		dc.b 0				; Frame
		dc.b $C				; Collision

ChildObjDat_DeathRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DeathRadiusExplosion

ChildObjDat_DialogueFirebrandRadiusExplosion333:
	dc.w 1-1
	dc.l Obj_DialogueFirebrandRadiusExplosion

ChildObjDat_DialogueFirebrand_Fire669:
		dc.w 1-1
		dc.l Obj_DialogueFirebrand_Fire

		include "Objects/Bosses/Death X/Object data/Ani - Death.asm"
		include "Objects/Bosses/Death X/Object data/Map - Death.asm"
		include "Objects/Bosses/Death X/Object data/DPLC - Death.asm"
		include "Objects/Bosses/Death X/Object data/Ani - Scythe.asm"
		include "Objects/Bosses/Death X/Object data/Map - Scythe.asm"