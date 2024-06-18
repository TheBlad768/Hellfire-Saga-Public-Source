; ---------------------------------------------------------------------------
; Hell girl 2 (badnik)
; ---------------------------------------------------------------------------

Obj_Hellgirl2:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Hellgirl2_Index(pc,d0.w),d1
		jsr	Obj_Hellgirl2_Index(pc,d1.w)
		lea	(Ani_Hellgirl).l,a1
		jsr	(AnimateSprite).w
		jsr	(Obj_Hellgirl_process).l
		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================
Obj_Hellgirl2_Index:
		dc.w Obj_Hellgirl2_Main-Obj_Hellgirl2_Index
		dc.w Obj_Hellgirl2_Test-Obj_Hellgirl2_Index
		dc.w Obj_Hellgirl2_Kiss-Obj_Hellgirl2_Index
		dc.w Obj_Hellgirl2_RunAway-Obj_Hellgirl2_Index
; ===========================================================================

Obj_Hellgirl2_CheckLustDead:
		cmpi.b  #1,(Lust_Dead).w
		bne.w	Obj_Hellgirl2_Return
		move.b	#8,obRoutine(a0)
		rts

Obj_Hellgirl2_Main:
		move.b  #2,obAnim(a0)
		move.w  #0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$8375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$34,obColType(a0)
		move.b  #1,$29(a0)
		jmp     (Swing_Setup_Hellgirl).w
; ===========================================================================

Obj_Hellgirl2_Test:
		jsr	(SpeedToPos).w
		jsr	(Obj_Hellgirl2_CheckLustDead).l
		jsr 	(Swing_UpAndDown).w
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(Find_Sonic).w
		move.w	#$200,d0
		moveq	#$20,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(Find_Sonic).w
		cmpi.w	#$20,d2
		bcc.w	Obj_Hellgirl2_Return
		addq.b	#2,obRoutine(a0)
		move.b	#3,obAnim(a0)
		rts

Obj_Hellgirl2_Kiss:
		move.b	#$29,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Hellgirl2_Return
		move.l	#Obj_Love_Bullet2,(a1)
                move.w  a0,parent3(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#-$100,obVelX(a1);
                move.w 	#-$300,obVelY(a1);
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Hellgirl2_Return
		move.l	#Obj_Love_Bullet2,(a1)
                move.w  a0,parent3(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
                move.w 	#$100,obVelX(a1);
                move.w 	#-$300,obVelY(a1);
		addq.b  #2,obRoutine(a0);

; ===========================================================================

Obj_Hellgirl2_RunAway:
		cmpi.w	#-$400,obVelY(a0)
		blt.s	+
		sub.w	#$10,obVelY(a0)
+		jsr	(Obj_Hellgirl2_CheckLustDead).l
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.w	Obj_Hellgirl2_Return
		move.l	#Delete_Current_Sprite,(a0)

Obj_Hellgirl2_Return:
		rts
