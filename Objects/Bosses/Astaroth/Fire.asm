; =====================================================
; The unique fire produced by Astaroth
; =====================================================

Obj_AstFire:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_AstFire_Index(pc,d0.w),d1
		jsr	Obj_AstFire_Index(pc,d1.w)
		lea	Ani_Astaroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; =====================================================

Obj_AstFire_Index:
		dc.w	Obj_AstFire_Main-Obj_AstFire_Index
		dc.w	Obj_AstFire_SetAttr-Obj_AstFire_Index
		dc.w	Obj_AstFire_TickTock-Obj_AstFire_Index

; =====================================================

Obj_AstFire_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Astaroth,obMap(a0)
		move.w	#$340,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		bset	#4,shield_reaction(a0)
		move.b	#3,obAnim(a0)

Obj_AstFire_SetAttr:
		move.w	#-$250,obVelX(a0)
                move.w (Player_1+$10).w,d0
                sub.w   $10(a0),d0
                cmpi.w  #0,d0
                blt.s   +
		neg.w	obVelX(a0)
+               move.w (Player_1+obY).w,d0
                sub.w   obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a0)
		addq.b	#2,routine(a0)


Obj_AstFire_TickTock:
		cmpi.b  #$01,(Check_GluttonyDead).w
		beq.s	Obj_AstFire_Delete
		jsr	(SpeedToPos).w
		subq.w	#1,obTimer(a0)
		bpl.s	Obj_AstFire_Return

Obj_AstFire_Delete:
		jmp	(DeleteObject).w

Obj_AstFire_Return:
		rts

