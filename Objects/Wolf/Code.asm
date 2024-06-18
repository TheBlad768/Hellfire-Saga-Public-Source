; ===========================================================================
; Wolf (badnik)
; ===========================================================================

Obj_Wolf:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Wolf_Index(pc,d0.w),d1
		jsr	Obj_Wolf_Index(pc,d1.w)
		bsr.w	Obj_Wolf_process
		lea	Ani_Wolf(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

Obj_Wolf_Index:
		dc.w Obj_Wolf_Main-Obj_Wolf_Index	; 0
		dc.w Obj_Wolf_Fall-Obj_Wolf_Index	; 2
		dc.w Obj_Wolf_Wait-Obj_Wolf_Index	; 4
		dc.w Obj_Wolf_Jump-Obj_Wolf_Index	; 6
		dc.w Obj_Wolf_Jump2-Obj_Wolf_Index	; 8
		dc.w Obj_Wolf_Dead-Obj_Wolf_Index	; A
Wolf_Vram:
		dc.w $39B	; Act 1
		dc.w $39B	; Act 2
		dc.w $2EA	; Act 3
		dc.w $39B	; Act 4
; ---------------------------------------------------------------------------

Obj_Wolf_Main:
		moveq	#0,d0
		addq.b	#2,routine(a0)
		move.b	(Current_act).w,d0
		add.w	d0,d0
		move.w	Wolf_Vram(pc,d0.w),obGfx(a0)
		move.l	#SME_LoOy9,obMap(a0)
		move.b	#4,obRender(a0)
		move.b	#9,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$20,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$0A,x_radius(a0)
		move.b	#$0A,y_radius(a0)
		move.w	#$A,obTimer(a0)
		move.b  #1,$29(a0)
		rts

Obj_Wolf_process:
		cmpi.b	#$A,routine(a0)
		bcc.w	.lacricium
		tst.b   $29(a0)
		bne.s	.lacricium

.gone:
		move.b	#$A,routine(a0)

.lacricium:
		rts

Obj_Wolf_Fall:
		jsr	(ObjectFall).w
		jsr	ObjHitFloor
		tst.w	d1				; is object above the ground?
		bpl.w	Obj_Wolf_Return			; if yes, branch

		add.w	d1,obY(a0)			; match	object's position with the floor
		addq.b	#2,routine(a0)

Obj_Wolf_Wait:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Wolf_Return
		addq.b	#2,routine(a0)

Obj_Wolf_Jump:
		jsr	(Find_Sonic).w
		cmpi.w	#$80,d2
		bcc.w	Obj_Wolf_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		addq.b	#2,routine(a0)
		move.b	#1,obAnim(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		move.w	#-$600,obVelY(a0)

Obj_Wolf_Jump2:
		jsr	(Obj_Feal_CheckWalls).l
		jsr	(ObjectFall).w
		tst.w	y_vel(a0)			; check if wolf is going upwards
		ble.w	Obj_Wolf_Return			; branch if is

		move.b	x_radius(a0),d3			; NAT: Get radius to d3
		ext.w	d3				; extend to word
		add.w	x_pos(a0),d3			; add x-pos to it
		jsr	ObjHitFloor2			; check right side of object first
		tst.w	d1				; touched the floor?
		bmi.s	.touch				; if yes, branch

		move.b	x_radius(a0),d3			; NAT: Get radius to d3
		ext.w	d3				; extend to word
		neg.w	d3				; negate it
		add.w	x_pos(a0),d3			; add x-pos to it
		jsr	ObjHitFloor2			; check left side of object
		tst.w	d1				; is object above the ground?
		bpl.s	Obj_Wolf_Return			; if yes, branch

.touch		add.w	d1,obY(a0)
		subq.b	#4,routine(a0)
		move.w	#$3C,obTimer(a0)
		move.b	#0,obAnim(a0)
		clr.l	obVelX(a0)
		rts

Obj_Wolf_Dead:
		clr.w	respawn_addr(a0)		; Mark object as destroyed
                sfx     sfx_KnucklesKick
                samp	sfx_WolfDeath
		jsr	(Obj_KillBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)

Obj_Wolf_Return:
		rts
; ---------------------------------------------------------------------------

		include "Objects/Wolf/Object data/Ani - Wolf.asm"
		include "Objects/Wolf/Object data/Map - Wolf.asm"
