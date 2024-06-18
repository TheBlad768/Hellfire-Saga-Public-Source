; ---------------------------------------------------------------------------
; Hell girl (badnik)
; ---------------------------------------------------------------------------

Obj_Hellgirl:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Hellgirl_Index(pc,d0.w),d1
		jsr	Obj_Hellgirl_Index(pc,d1.w)
		lea	(Ani_Hellgirl).l,a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_Hellgirl_Index:
		dc.w Obj_Hellgirl_Main-Obj_Hellgirl_Index
		dc.w Obj_Hellgirl_Test-Obj_Hellgirl_Index
		dc.w Obj_Hellgirl_Kiss-Obj_Hellgirl_Index
		dc.w Obj_Hellgirl_FlyAway1-Obj_Hellgirl_Index
		dc.w Obj_Hellgirl_FlyAway2-Obj_Hellgirl_Index
; ===========================================================================

Obj_Hellgirl_Main:
		move.b  #0,obAnim(a0)
		move.b	#$A,obTimer(a0)
		addq.b	#2,routine(a0)
		move.l	#SME_fMWF3,obMap(a0)
		cmpi.w	#$203,(Current_zone_and_act).w
		beq.s	.gmz4gfx
		move.w	#$375,obGfx(a0)
		bra.s	.contload

.gmz4gfx:
		move.w	#$420,obGfx(a0)

.contload:
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		jmp     (Swing_Setup_Hellgirl).w
; ===========================================================================

Obj_Hellgirl_Test:
		cmpi.b  #1,(Lust_Dead).w
		beq.w	+
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		jsr	(Find_Sonic).w
		cmpi.w	#$80,d2
		bcc.w	Obj_Hellgirl_Return
		addq.b	#2,routine(a0)
		move.b	#1,obAnim(a0)
		rts
+		move.b	#6,routine(a0)
		rts

Obj_Hellgirl_Kiss:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Hellgirl_Return
		move.b	#8,obTimer(a0)
		addq.b  #2,routine(a0);
		move.b	#0,obAnim(a0)
		jsr	(SingleObjLoad).w
		bne.s	Obj_Hellgirl_Return
		move.l	#Obj_Love_Bullet,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

; ===========================================================================

Obj_Hellgirl_FlyAway1:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		subq.b  #1,obTimer(a0)
		bpl.s   Obj_Hellgirl_Return
		addq.b  #2,routine(a0)
		bclr	#0,obStatus(a0)
		move.w	#-$100,obVelX(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		bgt.s	Obj_Hellgirl_Return
		bset	#0,obStatus(a0)
		neg.w	obVelX(a0)

Obj_Hellgirl_FlyAway2:
		jsr	(SpeedToPos).w
		cmpi.w	#-$400,obVelY(a0)
		blt.s	+
		sub.w	#$10,obVelY(a0)
+		jsr	(ChkObjOnScreen).w
		beq.w	Obj_Hellgirl_Return
		move.l	#Delete_Current_Sprite,(a0)


Obj_Hellgirl_Return:
		rts


		include "Objects/Hellgirl/Object data/Ani - Hellgirl.asm"
		include "Objects/Hellgirl/Object data/Map - Hellgirl.asm"
