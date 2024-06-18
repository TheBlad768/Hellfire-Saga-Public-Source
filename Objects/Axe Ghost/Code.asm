; ---------------------------------------------------------------------------
; Axe Ghost
; ---------------------------------------------------------------------------

Obj_AxeGhost:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_AxeGhost_Index(pc,d0.w),d1
		jsr	Obj_AxeGhost_Index(pc,d1.w)
		bsr.w	Obj_AxeGhost_process
		lea	Ani_AxeGhost(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_AxeGhost_Index:
		dc.w Obj_AxeGhost_Main-Obj_AxeGhost_Index
		dc.w Obj_AxeGhost_Move-Obj_AxeGhost_Index
; ===========================================================================
Obj_AxeGhost_Main:
		move.w	#0,obVelY(a0)
		move.w	#$C0,obVelX(a0)
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		move.b	#2,routine(a0)
		move.l	#SME_p5CM1,obMap(a0)
		move.w	#$8337,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$C,obColType(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#48/2,obHeight(a0)
		move.b	#48/2,obWidth(a0)
		move.b	#48/2,x_radius(a0)
		move.b	#48/2,y_radius(a0)
		move.b  #0,obAnim(a0)
		move.b  #1,$29(a0)
		jmp     (Swing_Setup_AxeGhost).w
; ===========================================================================

Obj_AxeGhost_process:
		tst.b   $29(a0)
		bne.s   Obj_AxeGhost_Return

Obj_AxeGhost_gone:
		samp	sfx_AxeGhostDeath
		jsr	(SingleObjLoad2).w
		bne.w	Obj_AxeGhost_Return
		move.l	#Obj_Explosion,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Go_Delete_Sprite,(a0)

; ===========================================================================

Obj_AxeGhost_Move:
		jsr	(SpeedToPos).w
		jmp	(Swing_UpAndDown).w

Obj_AxeGhost_Return:
		rts
; ============================================================================
		include "Objects/Axe Ghost/Object data/Ani - Axe Ghost.asm"
		include "Objects/Axe Ghost/Object data/Map - Axe Ghost.asm"

