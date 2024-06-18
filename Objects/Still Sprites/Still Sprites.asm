
; =============== S U B R O U T I N E =======================================

Obj_StillSprite:
		move.l	#Map_StillSprites,mappings(a0)
		ori.b	#4,render_flags(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	StillSprite_Index(pc,d0.w),a1
		move.w	(a1)+,art_tile(a0)
		move.w	(a1)+,priority(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,height_pixels(a0)
		move.l	#+,address(a0)
+		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

StillSprite_Index:
		dc.w $4000		; 0
		dc.w $80
		dc.b $8
		dc.b $10
		dc.w $4000		; 1
		dc.w $80
		dc.b $10
		dc.b $10
		dc.w $4000		; 2
		dc.w $80
		dc.b $20
		dc.b $10
		dc.w $4000		; 3
		dc.w $80
		dc.b $40
		dc.b $10
		dc.w $4000		; 4
		dc.w $80
		dc.b $60
		dc.b $18
		dc.w $4000		; 5
		dc.w $100
		dc.b 128/2
		dc.b 80/2
		dc.w $4000		; 6
		dc.w $80
		dc.b $20
		dc.b $10
		dc.w $4000		; 7
		dc.w $80
		dc.b $40
		dc.b $10
		dc.w $4000		; 8
		dc.w $280
		dc.b $8
		dc.b $10
		dc.w $4000		; 9
		dc.w $280
		dc.b $8
		dc.b $10
; ---------------------------------------------------------------------------

		include "Objects/Still Sprites/Object data/Map - Still Sprites.asm"