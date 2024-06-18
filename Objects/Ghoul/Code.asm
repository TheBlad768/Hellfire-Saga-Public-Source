; ---------------------------------------------------------------------------
; Ghoul
; ---------------------------------------------------------------------------


Obj_Ghoul:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Ghoul_Index(pc,d0.w),d1
		jsr	Ghoul_Index(pc,d1.w)
		bsr.w	Obj_Ghoul_Process
		lea	Ani_Ghoul(pc),a1
		jsr	(AnimateSprite).w
		lea	DatDPLC_Ghoul(pc),a2
		jsr	Perform_DPLC
		jmp	Sprite_CheckDeleteTouchSlotted
; ---------------------------------------------------------------------------
Ghoul_Index:
		dc.w Ghoul_Main-Ghoul_Index
		dc.w Ghoul_StandOnFloor-Ghoul_Index
		dc.w Ghoul_FindFloor-Ghoul_Index
		dc.w Ghoul_Dead-Ghoul_Index

DatDPLC_Ghoul:
		dc.l ArtUnc_Ghoul>>1, DPLC_Ghoul

ObjDat_Ghoul:
	SlotDataSCZ0	$0000, SME_7TupD, 3*$80, $1C, $14, $00, $C
; ---------------------------------------------------------------------------

Ghoul_Main:
		lea	ObjDat_Ghoul(pc),a1
		jsr	SetUp_ObjAttributesSlotted
		move.b  #1,$29(a0)
		move.b	#$3C,obTimer(a0)				; NOV: Fixed a naming issue

Ghoul_StandOnFloor:
		jsr	(ObjectFall).w
		jsr	(ObjFloorDist).w
		tst.w	d1		; is object above the ground?
		bpl.s	Ghoul_NotOnFloor	; if yes, branch
		add.w	d1,obY(a0)	; match	object's position with the floor
		move.w	#0,obVelY(a0)
	        bchg	#0,obStatus(a0)
		addq.b	#2,routine(a0)

Ghoul_NotOnFloor:
		rts
; ---------------------------------------------------------------------------
Obj_Ghoul_Process:
		tst.b   $29(a0)
		bne.s   Obj_Ghoul_Lacricium
                jsr	(Obj_KillBloodCreate).l
                samp	sfx_GhoulDeath
                move.l	#Go_Delete_SpriteSlotted,address(a0)
                ;move.b	#0,obColType(a0)
                ;move.w	#0,obVelX(a0)
                ;move.b  #1,obAnim(a0)
		;move.b	#6,routine(a0)

Obj_Ghoul_Lacricium:
		rts
; ---------------------------------------------------------------------------

Ghoul_FindFloor:
		btst	#0,obStatus(a0)
		beq.s	.moveleft
		cmpi.w	#$300,obVelX(a0)
		bgt.s	.advance
		add.w	#$80,obVelX(a0)
		bra.s	.advance

.moveleft:
		cmpi.w	#-$300,obVelX(a0)
		blt.s	.advance
		sub.w	#$80,obVelX(a0)

.advance:
		jsr	(SpeedToPos).w
		move.w	x_pos(a0),d3
		subi.w	#$18,d3
		btst	#0,obStatus(a0)
		beq.s	+
		addi.w	#$30,d3
+  		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	Ghoul_Pause
		cmpi.w	#$C,d1
		bge.s	Ghoul_Pause
		add.w	d1,obY(a0)				; match object's position with the floor
		rts
; ---------------------------------------------------------------------------

Ghoul_Pause:
		move.b	#2,obAnim(a0)
		bchg	#0,obStatus(a0)
		rts

Ghoul_Dead:
                jsr 	(ChkObjOnScreen).w
                bne.s   .delete
		subq.b	#1,obTimer(a0)					; NOV: Fixed a naming issue
		bpl.s	Ghoul_Return

.delete:
		move.l	#Go_Delete_SpriteSlotted,address(a0)



Ghoul_Return:
		rts
; ---------------------------------------------------------------------------

		include "Objects/Ghoul/Object data/Anim - Ghoul.asm"
		include "Objects/Ghoul/Object data/Map - Ghoul.asm"
		include "Objects/Ghoul/Object data/DPLC - Ghoul.asm"