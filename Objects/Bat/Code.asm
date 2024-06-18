
; =============== S U B R O U T I N E =======================================

Obj_Bat:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Bat_Index(pc,d0.w),d0
		jsr	Bat_Index(pc,d0.w)
		bsr.w	Obj_Bat_Process
		lea	Ani_Bat(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------
Obj_Bat_Process:
		tst.b   $29(a0)
		bne.s	.lacricium
		samp	sfx_BatDeath
        move.l  #Obj_Explosion,(a0)
        clr.b   routine(a0)
	
.lacricium:
		rts
; ---------------------------------------------------------------------------
Bat_Index: offsetTable
		offsetTableEntry.w Bat_Init			; 0
		offsetTableEntry.w Bat_SetMove		; 2
		offsetTableEntry.w Bat_Swing		; 4
		offsetTableEntry.w Bat_Wait		; 6
Bat_Vram:
		dc.w $24CC	; Act 1
		dc.w $24AC	; Act 2
		dc.w $243E	; Act 3
		dc.w $24CC	; Act 4
; ---------------------------------------------------------------------------

Bat_Init:
		move.b  #1,$29(a0)
		lea	ObjDat3_Bat(pc),a1
		jsr	(SetUp_ObjAttributes).w
		moveq	#0,d0
		move.b	(Current_act).w,d0
		add.w	d0,d0
		move.w	Bat_Vram(pc,d0.w),obGfx(a0)
		tst.b	subtype(a0)
		beq.s	+
		addq.b	#4,routine(a0)
		move.b	#1,anim(a0)
+		rts
; ---------------------------------------------------------------------------

Bat_Wait:
		jsr	(Find_SonicTails).w
		cmpi.w	#112,d2	; X
		bhs.s	+
		cmpi.w	#72,d3	; Y
		bhs.s	+
		subq.b	#4,routine(a0)
		move.b	#0,anim(a0)
+		rts
; ---------------------------------------------------------------------------

Bat_SetMove:
		jsr	(Find_SonicTails).w
		move.w	#-$200,x_vel(a0)
		bclr	#0,status(a0)
		tst.w	d0
		beq.s	+
		bset	#0,status(a0)
		neg.w	x_vel(a0)
+		addq.b	#2,routine(a0)
		rts
; ---------------------------------------------------------------------------

Bat_Swing:
		jsr	(Swing_UpAndDown_Slow).w
		jmp	(MoveSprite2).w

; =============== S U B R O U T I N E =======================================

ObjDat3_Bat:
		dc.l Map_Bat
		dc.w $A4C0
		dc.w $180
		dc.b 32/2
		dc.b 32/2
		dc.b 0
		dc.b $B
; ---------------------------------------------------------------------------

		include "Objects/Bat/Object data/Anim - Bat.asm"
		include "Objects/Bat/Object data/Map - Bat.asm"