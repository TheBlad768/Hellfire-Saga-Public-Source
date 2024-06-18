
Obj_HAxt:
		move.l	#SME_WmmBn,obMap(a0)
		move.w	#$3A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#3,obWidth(a0)
		move.b	#3,obHeight(a0)
		move.b	#3,x_radius(a0)
		move.b	#3,y_radius(a0)
		move.b	#2,obAnim(a0)
		move.l	#Obj_HAxt_Move,(a0)

Obj_HAxt_Move:
		btst	#1,(Level_frame_counter+1).w
		bne.s	+
		eori.b	#$40,art_tile(a0)
+		jsr	(Obj_HAxt_CheckBossAlive).l
		lea	(Ani_Headliss).l,a1
		jsr	(AnimateSprite).w
		jsr	(SpeedToPos).w
		jmp	(Sprite_CheckDeleteTouchXY).w

Obj_HAxt_CheckBossAlive:
		cmpi.b	#$01,(Check_dead).w
		bne.s	+
		jmp	(DeleteObject).w
+		rts
; ===========================================================================