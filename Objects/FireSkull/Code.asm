; ---------------------------------------------------------------------------
; Fire Skull
; ---------------------------------------------------------------------------

Obj_FireSkull:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_FireSkull_Index(pc,d0.w),d1
		jsr	Obj_FireSkull_Index(pc,d1.w)
		lea	Ani_FireSkull(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_FireSkull_Index:
		dc.w Obj_FireSkull_Main-Obj_FireSkull_Index
		dc.w Obj_FireSkull_Test-Obj_FireSkull_Index
; ===========================================================================


Obj_FireSkull_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_MUU9q,obMap(a0)
		move.w	#$3D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$9A,obColType(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b  #0,obAnim(a0)
		move.b	#20,obTimer(a0)					; NOV: Fixed a naming issue
		move.w	#0,obVelX(a0)
		move.w 	#0,obVelY(a0)
; ===========================================================================

Obj_FireSkull_Test:
		jsr	(SpeedToPos).w
		move.b  #0,obAnim(a0)
		jsr	(Find_Sonic).w
		cmpi.w	#$80,d2
		bcc.w	Obj_FireSkull_Return
		move.b	#1,obAnim(a0)
		jsr	(Obj_FireSkull_Attack).l


Obj_FireSkull_Return:
		rts
; ============================================================================

		include "Objects/FireSkull/Object data/Ani - FireSkull.asm"
		include "Objects/FireSkull/Object data/Map - FireSkull.asm"

; ============================================================================

Obj_FireSkull_Attack:
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		subq.b	#1,obTimer(a0)					; NOV: Fixed a naming issue
		bpl.s	loc_FireSkullCool
		move.b	#90,obTimer(a0)					; NOV: Fixed a naming issue
		jsr	(SingleObjLoad2).w
		bne.s	loc_FireSkullCool
		move.l	#Obj_Fire_Missile2,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w   #-$300,obVelX(a1);
                move.w (Player_1+$10).w,d0
                sub.w   $10(a0),d0
                cmpi.w  #0,d0
                blt.s   +
                neg.w   obVelX(a1)
+               move.w (Player_1+obY).w,d0
                sub.w   obY(a0),d0
                asl.w   #2,d0
                move.w 	d0,obVelY(a1);
		sfx	sfx_FireAttack

loc_FireSkullCool:
		rts

