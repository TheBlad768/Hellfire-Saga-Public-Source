; ---------------------------------------------------------------------------
; Phantom
; ---------------------------------------------------------------------------

Obj_Phantom:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Phantom_Index(pc,d0.w),d1
		jsr	Phantom_Index(pc,d1.w)
		bsr.w	Obj_Phantom_Process
		lea	Ani_Phantom(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------
Phantom_Index:
		dc.w Phantom_Main-Phantom_Index
		dc.w Phantom_Test-Phantom_Index
		dc.w Phantom_Move-Phantom_Index
		dc.w Phantom_FindFloor-Phantom_Index
		dc.w Phantom_GoBackToEarth-Phantom_Index
Phantom_Vram:
		dc.w $40C	; Act 1
		dc.w $32D	; Act 2
		dc.w $462	; Act 3
		dc.w $40C	; Act 4

Obj_Phantom_Process:
		cmpi.b	#8,routine(a0)
		bcc.w	.lacricium
		tst.b   $29(a0)
		bne.s	.lacricium

.gone:
                samp	sfx_Phantom
                move.b  #3,obAnim(a0)
                bchg    #0,obStatus(a0)
		move.b	#8,routine(a0)

.lacricium:
		rts
; ---------------------------------------------------------------------------

Phantom_Main:
		moveq	#0,d0
		addq.b	#2,routine(a0)
		move.b	(Current_act).w,d0
		add.w	d0,d0
		move.w	Phantom_Vram(pc,d0.w),obGfx(a0)
		move.l	#Map_Phantom,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$1C,obHeight(a0)
		move.b	#$18,obWidth(a0)
		move.b	#$0C,x_radius(a0)
		move.b	#$10,y_radius(a0)
		jsr	(ObjectFall).w
		jsr	(ObjFloorDist).w
		tst.w	d1
		bpl.s	Phantom_NotOnFloor
		add.w	d1,obY(a0)			; match	object's position with the floor
		move.w	#0,obVelY(a0)
		bchg	#0,obStatus(a0)	; change object's orientation
		move.b  #1,$29(a0)

Phantom_NotOnFloor:
		rts
; ---------------------------------------------------------------------------

Phantom_Test;
		move.b	#0,obAnim(a0)
		jsr 	(ChkObjOnScreen).w
		bne.w 	Phantom_Return
		jsr	(Find_Sonic).w
		cmpi.w	#$9F,d2
		bcc.w	Phantom_Return
		bclr	#0,obStatus(a0)
		tst.w	d0
		bne.s	Phantom_Test2
		bset	#0,obStatus(a0)

Phantom_Test2:
		addq.b	#2,routine(a0)
		move.b	#1,obAnim(a0)

Phantom_Move:
		cmpi.b	#1,obAnim(a0)
		beq.w	Phantom_Return
		addq.b	#2,routine(a0)
		move.b	#$23,obColType(a0)
		move.w	#-$200,obVelX(a0)		; move object to the left
		bchg	#0,obStatus(a0)
		bne.w	Phantom_Return
		neg.w	obVelX(a0)			; change direction
; ---------------------------------------------------------------------------

Phantom_FindFloor:
		jsr	(SpeedToPos).w

		move.b	x_radius(a0),d3			; NAT: Get radius to d3
		ext.w	d3				; extend to word
		add.w	x_pos(a0),d3			; add x-pos to it
		jsr	ObjFloorDist2			; check left side of object

		cmpi.w	#-8,d1
		blt.s	Phantom_Pause
		cmpi.w	#$C,d1
		bge.s	Phantom_Pause

		move.b	x_radius(a0),d3			; NAT: Get radius to d3
		ext.w	d3				; extend to word
		neg.w	d3				; negate it
		add.w	x_pos(a0),d3			; add x-pos to it
		jsr	ObjFloorDist2			; check left side of object

		cmpi.w	#-8,d1
		blt.s	Phantom_Pause
		cmpi.w	#$C,d1
		bge.s	Phantom_Pause

		add.w	d1,obY(a0)				; match object's position with the floor
		rts
; ---------------------------------------------------------------------------

Phantom_Pause:
		subq.b	#2,routine(a0)

Phantom_Return:
		rts
; ---------------------------------------------------------------------------
Phantom_GoBackToEarth:
                cmpi.b  #5,obAnim(a0)
                bne.s   +
                move.l	#Go_Delete_Sprite,(a0)
+               rts

		include "Objects/Phantom/Object data/Ani - Phantom.asm"
		include "Objects/Phantom/Object data/Map - Phantom.asm"



