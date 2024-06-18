; ---------------------------------------------------------------------------
; Killer Fish
; ---------------------------------------------------------------------------

Obj_KillerFish:
  		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_KillerFish_Index(pc,d0.w),d1
		jsr	Obj_KillerFish_Index(pc,d1.w)
		lea	(Ani_KillerFish).l,a1
		jsr	(AnimateSprite).w

                cmpi.b  #1,subtype(a0)
                beq.s   +
		move.w	(Water_level).w,d0
                add.w   #$18,d0
		cmp.w	y_pos(a0),d0			; is Killer Fish above the water?
		blt.s	+		             ; if no, branch
                move.w  d0,y_pos(a0)
+		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_KillerFish_Index:
		dc.w Obj_KillerFish_Main-Obj_KillerFish_Index
		dc.w Obj_KillerFish_Wait-Obj_KillerFish_Index
		dc.w Obj_KillerFish_Swim-Obj_KillerFish_Index
		dc.w Obj_KillerFish_Chase-Obj_KillerFish_Index
		dc.w Obj_KillerFish_MoveUnder-Obj_KillerFish_Index
		dc.w Obj_KillerFish_Rise-Obj_KillerFish_Index
		dc.w Obj_KillerFish_ChaseFurious-Obj_KillerFish_Index
; ===========================================================================
Obj_KillerFish_Main:
		move.l	#SME_gMVhP,obMap(a0)
		move.w	#$2FD,obGfx(a0)
		move.b	#4,obRender(a0)
	        move.b	#$A,collision_flags(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#32/2,obHeight(a0)
		move.b	#40/2,obWidth(a0)
		move.b	#40/2,x_radius(a0)
		move.b	#32/2,y_radius(a0)
                move.w  #0,objoff_48(a0)
                move.b	#2,routine(a0)
                cmpi.b  #1,subtype(a0)
                bne.s   .return
                move.b  #2,obAnim(a0)
                move.b	#8,routine(a0)

.return:
                rts

Obj_KillerFish_Wait:
                sub.w   #1,obTimer(a0)
                bpl.s   .return
		btst	#0,obStatus(a0)
		beq.s	.setleft
                move.w  #$80,obVelX(a0)
                bra.s   .finished

.setleft:
                move.w  #-$80,obVelX(a0)

.finished:
                move.b  #1,obAnim(a0)
                add.w   #1,objoff_48(a0)
                addq.b	#2,routine(a0)

.return:
                rts

Obj_KillerFish_Swim:
                bsr.w   Obj_KillerFish_ChkChase
                jsr     (SpeedToPos).l
		btst	#0,obStatus(a0)
		beq.s	.addspeed
                sub.w   #1,obVelX(a0)
                bra.s   .testitsall

.addspeed:
                add.w   #1,obVelX(a0)

.testitsall:
                cmpi.w  #0,obVelX(a0)
                bne.s   .return
                cmpi.w  #3,objoff_48(a0)
                bne.s   .sleep
                clr.w   objoff_48(a0)
                bchg    #0,obStatus(a0)

.sleep:
                move.w  #$1E,obTimer(a0)
                subq.b	#2,routine(a0)

.return:
                rts

Obj_KillerFish_Chase:
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Find_SonicTails).w
		cmpi.w	#$60,d2
		bcc.w	.cool
		move.w	#$100,d0
		moveq	#$8,d1
		jsr	(Chase_Object).w
		jmp	(MoveSprite2).w

.cool:
                clr.w   obVelX(a0)
                clr.w   obVelY(a0)
                move.b  #0,obAnim(a0)
                clr.w   objoff_48(a0)
                move.w  #$1E,obTimer(a0)
                move.b	#2,routine(a0)
                rts

Obj_KillerFish_MoveUnder:
                move.w  (Camera_y_pos).w,d0
                add.w   #$DF,d0
                move.w  d0,obY(a0)
                move.w  #-$200,obVelY(a0)
                move.w  #$3C,obTimer(a0)
                addq.b	#2,routine(a0)

.return:
                rts

Obj_KillerFish_Rise:
                jsr     (SpeedToPos).l
                sub.w   #1,obTimer(a0)
                bpl.s   .return
                addq.b	#2,routine(a0)

.return:
                rts

Obj_KillerFish_ChaseFurious:
                jsr     (Obj_Eggman_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$200,d0
		moveq	#$10,d1
		jsr	(Chase_Object).w
		jmp	(MoveSprite2).w
; ============================================================================
Obj_KillerFish_ChkChase:
                jsr	(Find_Sonic).w
		cmpi.w	#$60,d2
		bcc.w	.return
                move.b  #2,obAnim(a0)
                move.b	#6,routine(a0)

.return:
                rts
; ============================================================================
		include "Objects/Killer Fish/Object data/Map - Killer Fish.asm"
		include "Objects/Killer Fish/Object data/Ani - Killer Fish.asm"