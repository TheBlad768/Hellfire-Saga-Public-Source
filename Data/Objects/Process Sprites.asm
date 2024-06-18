; ---------------------------------------------------------------------------
; Object code execution subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Process_Sprites:
		lea	(Object_RAM).w,a0
		moveq	#((Object_RAM_End-Object_RAM)/object_size)-1,d7

Process_Sprites_Loop:
		move.l	(a0),d0
		beq.s	+
		movea.l	d0,a1
		jsr	(a1)
+		lea	next_object(a0),a0
		dbf	d7,Process_Sprites_Loop
		rts
; End of function Process_Sprites