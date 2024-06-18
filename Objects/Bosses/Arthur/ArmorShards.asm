; ===========================================================================
; Shards of Arthur's armor
; ===========================================================================

Obj_ArmorShard:
		move.l	#Obj_Arthur_Mapp,obMap(a0)
		move.w	#$3A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.l	#Obj_ArmorShard_Move,(a0)

Obj_ArmorShard_Move:
		lea	(Ani_Arthur).l,a1
		jsr	(AnimateSprite).w
		jsr	(ObjectFall).w
		jmp	(Sprite_CheckDeleteTouchXY).w
; ===========================================================================