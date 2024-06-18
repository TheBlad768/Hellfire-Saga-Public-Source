; ---------------------------------------------------------------------------
; Display 8x8 text on the plan
; Inputs:
; d1 = plane address
; d3 = vram shift
; a1 = source address
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Load_PlaneText:
		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5
		move.l	#$800000,d2

Load_PlaneText_SetPos:
		move.l	d1,VDP_control_port-VDP_control_port(a5)

Load_PlaneText_Loop:
		moveq	#0,d0						; VRAM
		move.b	(a1)+,d0
		bmi.s	Load_PlaneText_Options
		add.w	d3,d0						; VRAM shift
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		bra.s	Load_PlaneText_Loop
; ---------------------------------------------------------------------------

Load_PlaneText_Options:
		cmpi.b	#-1,d0						; If $FF flag, stop loading letters
		beq.s	Load_PlaneText_Return
		cmpi.b	#-2,d0						; If $FE flag, calc pos loading letters
		beq.s	Load_PlaneText_Calculate

Load_PlaneText_NextLine:
		andi.w	#$1F,d0						; If $80-$9F flag, load letters to the next line

.load
		add.l	d2,d1
		dbf	d0,.load
		bra.s	Load_PlaneText_SetPos
; ---------------------------------------------------------------------------

Load_PlaneText_Calculate:

		; get pos
		move.l	d1,d5
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		; clear line
		moveq	#0,d0
		moveq	#40-1,d4			; max 40 characters

.clear
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d4,.clear
		move.l	d5,VDP_control_port-VDP_control_port(a5)

		moveq	#40-1,d4						; max 40 characters

		; calc center position
		moveq	#0,d0
		move.b	(a1)+,d0						; get name size
		move.w	d0,d6
		addq.w	#1,d4						; fix dbf count(-1)
		sub.w	d0,d4
		lsr.w	d4							; even value
		add.w	d4,d4
		swap	d4
		clr.w	d4
		add.l	d4,d5
		move.l	d5,VDP_control_port-VDP_control_port(a5)
		bra.s	Load_PlaneText_Loop
; ---------------------------------------------------------------------------

Load_PlaneText_Return:
		enableIntsSave
		rts
