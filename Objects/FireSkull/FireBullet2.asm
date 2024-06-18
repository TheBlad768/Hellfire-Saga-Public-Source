; ---------------------------------------------------------------------------
; ...
; ---------------------------------------------------------------------------

Obj_Fire_Missile2:				; XREF: Obj1F_Index
		move.l	#SME_MUU9q,obMap(a0)
		move.w	#$3D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #$4F,obTimer(a0)
		move.b	#2,obAnim(a0)
		move.l	#Obj_Fire_Missile2_Move,(a0)

Obj_Fire_Missile2_Move:				; XREF: Obj1F_Index
		lea	(Ani_FireSkull).l,a1
		jsr	(AnimateSprite).w
		jsr     (SpeedToPos).w
		jsr 	(ChkObjOnScreen).w
		beq.w 	+
                move.l  #Go_Delete_Sprite,(a0)
+		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================