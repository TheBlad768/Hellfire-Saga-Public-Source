; -----------------------------------------
; Harpy (badnik)
; -----------------------------------------

Obj_Harpy:
		jsr	(Obj_WaitOffscreen).w
		moveq   #0,d0
		move.b	obRoutine(a0),d0
		move.w  Obj_Harpy_Index(pc,d0.w),d1
		jsr     Obj_Harpy_Index(pc,d1.w)
		bsr.w	Obj_Harpy_Process
		lea     (Ani_Harpy).l,a1
		jsr     (AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w

Obj_Harpy_Index:
		dc.w  Obj_Harpy_Main-Obj_Harpy_Index
		dc.w  Obj_Harpy_Chase-Obj_Harpy_Index
		dc.w  Obj_Harpy_Rising-Obj_Harpy_Index
		dc.w  Obj_Harpy_Impetum-Obj_Harpy_Index
		dc.w  Obj_Harpy_FreeFlight-Obj_Harpy_Index
		dc.w  Obj_Harpy_Dead-Obj_Harpy_Index


Obj_Harpy_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_bjndN,obMap(a0)
		move.w	#$2C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$C,obColType(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#10,obHeight(a0)
		move.b	#10,obWidth(a0)
		move.b	#10,x_radius(a0)
		move.b	#10,y_radius(a0)
		move.b	#0,obAnim(a0)
		move.w	#12,obTimer(a0)
		move.b  #1,$29(a0)
		rts

Obj_Harpy_Process:
		cmpi.b	#$A,obRoutine(a0)
		bcc.w	.lacricium
		tst.b   $29(a0)
		bne.s	.lacricium

.gone:
		move.b	#$A,obRoutine(a0)

.lacricium:
		rts

Obj_Harpy_LookOnSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Harpy_Return
		bclr	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bset	#0,obStatus(a0)
+		rts

Obj_Harpy_OnScreen:
		jsr 	(ChkObjOnScreen).w
		beq.w	Obj_Harpy_Return
		jmp	(DeleteObject).w

Obj_Harpy_Chase:
		jsr	(SpeedToPos).w
		jsr	(Obj_Harpy_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$120,d0
		moveq	#$10,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		jsr	(Find_Sonic).w
		cmpi.w	#$68,d2
		bcc.w	Obj_Feal_Return
		addq.b	#2,obRoutine(a0)

Obj_Harpy_Rising:
		jsr	(SpeedToPos).w
		jsr	(Obj_Harpy_LookOnSonic).l
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		asl.w	#3,d0
		cmpi.w	#0,d0
		bcc.s	+
		sub.w	#0,d0
		move.w	d0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		rts
+		add.w	#0,d0
		move.w	d0,obVelY(a0)
		addq.b	#2,obRoutine(a0)
		rts

Obj_Harpy_Impetum:
		jsr	(Obj_Harpy_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$400,d0			; Maximum speed.
		move.w	#$20,d1				; Acceleration.
		jsr	(Chase_ObjectXOnly).w		; �������� ������ �� X �������
		jsr	(MoveSprite2).w

		jsr	(Find_Sonic).w
		cmpi.w	#$18,d2
		bcc.w	Obj_Harpy_Return
		;move.w	(Player_1+obY).w,d0
		;sub.w	obY(a0),d0
		;cmpi.w	#$8,d0
		;bcc.w	Obj_Harpy_Return
		addq.b	#2,obRoutine(a0)

Obj_Harpy_FreeFlight:
		jmp	(SpeedToPos).w

Obj_Harpy_Dead:
		samp	sfx_HoneyDeath
		jsr	(Obj_HurtBloodCreate).l
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Harpy_Return
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#loc_85088,(a0)

Obj_Harpy_Return:
		rts
		include "Objects/Harpy/Object data/Ani - Harpy.asm"
		include "Objects/Harpy/Object data/Map - Harpy.asm"
