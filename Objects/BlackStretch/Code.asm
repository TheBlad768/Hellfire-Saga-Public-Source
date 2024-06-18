; ---------------------------------------------------------------------------
; Letterboxing (LBX)
; Version 3.1
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Letterboxing:
		move.l	#Map_Letterboxing,mappings(a0)
		move.w	#$8580,art_tile(a0)
		bset	#6,render_flags(a0)				; set multi-draw flag
		moveq	#1,d0
		move.w	d0,mainspr_childsprites(a0)
		move.b	d0,mapping_frame(a0)		; WHAT? If = 0 ignore mapping data??? (loc_1AEE4)
		move.w	#$100,x_pos(a0)
		move.w	#$80,y_pos(a0)
		move.w	#16,objoff_2E(a0)				; move frames
		move.l	#.show,address(a0)
		lea	sub2_x_pos(a0),a1
		move.w	x_pos(a0),(a1)+				; xpos
		move.w	#$0188+1,(a1)+				; ypos
;		move.b	mapping_frame(a0),1(a1)		; frame+1

.show
		addq.w	#1,y_pos(a0)
		subq.w	#1,sub2_y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		move.l	#.wait,address(a0)

.wait
		tst.b	(Black_Stretch_flag).w
		bne.s	.draw
		move.w	#16,objoff_2E(a0)				; move frames
		move.l	#.hide,address(a0)

.hide
		subq.w	#1,y_pos(a0)
		addq.w	#1,sub2_y_pos(a0)
		subq.w	#1,objoff_2E(a0)
		bpl.s	.draw
		cmpi.w	#$0400,(Current_Zone).w				; MJ: is this the credits?
		beq.s	.NoPLC						; MJ: if so, skip the flesh (don't need it)
                lea	(ArtKosM_Flesh).l,a1
		move.w	#tiles_to_bytes($558),d2
		jsr	(Queue_Kos_Module).w

	.NoPLC:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.draw
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Load_BlackStretch:
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Letterboxing,address(a1)
		st	(Black_Stretch_flag).w
+		rts
; ---------------------------------------------------------------------------

		include "Objects/BlackStretch/Object data/Map - Letterboxing.asm"