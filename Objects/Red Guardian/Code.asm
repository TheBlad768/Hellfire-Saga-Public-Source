; ---------------------------------------------------------------------------
; Red Guardian
; ---------------------------------------------------------------------------

Obj_RedGuardian:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_RedGuardian_Index(pc,d0.w),d1
		jsr	Obj_RedGuardian_Index(pc,d1.w)
		lea	(Ani_RedGuardian).l,a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_RedGuardian_Index:
		dc.w Obj_RedGuardian_Main-Obj_RedGuardian_Index
		dc.w Obj_RedGuardian_Move-Obj_RedGuardian_Index
; ===========================================================================
Obj_RedGuardian_Main:
        move.b	#2,routine(a0)
		move.l	#Map_RedGuard,obMap(a0)
		move.w	#$2B0,obGfx(a0)
		move.b	#4,obRender(a0)
	    move.b	#$45,collision_flags(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#40/2,obHeight(a0)
		move.b	#40/2,obWidth(a0)
		move.b	#40/2,x_radius(a0)
		move.b	#40/2,y_radius(a0)
		jmp     (Swing_Setup1).w
; ===========================================================================
Obj_RedGuardian_SetAnim:
		move.b  #0,obAnim(a0)
		tst.w	y_vel(a0)
		ble.s   .return
		move.b  #1,obAnim(a0)

.return:
		rts

Obj_RedGuardian_Move:
		cmpi.b  #0,$33(a0)
		bne.s   .fly
		bsr.s   Obj_RedGuardian_SetAnim

.fly:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(SpeedToPos).w
		jsr	(Swing_UpAndDown).w
		cmpi.b  #0,$33(a0)
		beq.s   Obj_RedGuardian_Return
		subq.b  #1,$33(a0)
		bne.s   Obj_RedGuardian_Return
		bclr    #6,$2A(a0)

Obj_RedGuardian_Return:
		rts
; ============================================================================
		include "Objects/Red Guardian/Object data/Map - Red Guardian.asm"
		include "Objects/Red Guardian/Object data/Ani - Red Guardian.asm"