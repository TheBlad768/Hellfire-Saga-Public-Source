; ===========================================================================
; Brick
; ===========================================================================

Obj_Brick:
		move.l	#Map_Grounder,obMap(a0)
		move.w	#$4000,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#1,obAnim(a0)
		move.l	#Obj_Brick_Move,(a0)

Obj_Brick_Move:
		lea	(Ani_Grounder).l,a1
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jsr 	(ChkObjOnScreen).w
		beq.w 	+
                jmp	(DeleteObject).w
+		jmp	(Draw_Sprite).w
; ===========================================================================
