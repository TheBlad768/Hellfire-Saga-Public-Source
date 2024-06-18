; ---------------------------------------------------------------------------
; Nut from Sonic 2.
; Version 1.0
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; Dynamic object variables
obNut_bxpos					= objoff_30	; .w		; backup x_pos
obNut_bypos					= objoff_32	; .w		; backup y_pos
obNut_speed					= objoff_34	; .w		; radius speed
obNut_timer					= objoff_36	; .w		; radius move
obNut_ram					= objoff_38	; .w		; routine, flag
obNut_routine				= objoff_38	; .b		; routine
obNut_flag					= objoff_39	; .b		; flag
obNut_orientation			= objoff_3A	; .b		; orientation
; ---------------------------------------------------------------------------

Data_MGZNut:		; move time, direction move, unused(aligned)

; 0
		dc.w -$100	; distance, up - 0, down - 4(1), left - 8(2), right - C(3)
		dc.b 0<<2, 0
; 1
		dc.w $100	; distance, up - 0, down - 4(1), left - 8(2), right - C(3)
		dc.b 1<<2, 0
; 2
		dc.w -$100	; distance, up - 0, down - 4(1), left - 8(2), right - C(3)
		dc.b 2<<2, 0
; 3
		dc.w $100	; distance, up - 0, down - 4(1), left - 8(2), right - C(3)
		dc.b 3<<2, 0

; =============== S U B R O U T I N E =======================================

Obj_MGZNut:
		move.b	subtype(a0),d0
		andi.w	#$1F,d0
		add.b	d0,d0
		add.b	d0,d0
		lea	Data_MGZNut(pc,d0.w),a1
		move.w	(a1)+,obNut_timer(a0)			; timer
		move.b	(a1)+,obNut_orientation(a0)	; orientation
		move.l	#Map_MGZNut,mappings(a0)
		move.w	#$C388,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$200,priority(a0)
		moveq	#32/2,d0
		move.b	d0,height_pixels(a0)
		move.b	d0,y_radius(a0)
		move.b	#64/2,width_pixels(a0)
		move.w	x_pos(a0),obNut_bxpos(a0)	; backup x_pos
		move.w	y_pos(a0),obNut_bypos(a0)	; backup y_pos
		move.l	#.solid,address(a0)

.solid:
		lea	(Player_1).w,a1					; a1=character
		lea	obNut_ram(a0),a4
		moveq	#p1_standing_bit,d6
		move.w	x_pos(a0),-(sp)
		bsr.s	.action
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		subi.w	#$B,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		jsr	(SolidObjectFull).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------
; Action
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.action:
		btst	d6,status(a0)					; Sonic standing on Nut?
		bne.s	.stand					; if yes, branch
		clr.b	(a4)							; clear $38(a0) routine

.stand:
		clr.w	d0
		move.b	(a4),d0					; load $38(a0) routine
		jmp	.modes(pc,d0.w)
; ---------------------------------------------------------------------------

.modes:
		bra.w	.checkstanding			; 0
		bra.w	.soniconnut				; 4
		bra.w	.moveup					; 8	; 0
		bra.w	.movedown				; C	; 4
		bra.w	.moveleft					; 10	; 8
		bra.w	.moveright				; 14	; C
; ---------------------------------------------------------------------------

.checkstanding:
		btst	d6,status(a0)					; Sonic standing on Nut?
		bne.s	.sonicstand				; if yes, branch
		rts
; ---------------------------------------------------------------------------

.sonicstand:
		addq.b	#4,(a4)					; next $38(a0) routine
		clr.b	1(a4)						; clear $39(a0) flag
		move.w	x_pos(a0),d0
		sub.w	x_pos(a1),d0
		bhs.s	.soniconnut
		st	1(a4)						; set $39(a0) flag

.soniconnut:
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		tst.b	1(a4)						; check $39(a0) flag
		beq.s	+
		addi.w	#$F,d0
+		cmpi.w	#$10,d0
		bhs.s	+
		move.w	x_pos(a0),x_pos(a1)
		moveq	#4,d0
		add.b	obNut_orientation(a0),d0
		add.b	d0,(a4)					; next $38(a0) routine
+		rts

; ---------------------------------------------------------------------------
; Move Up
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.moveup:
		move.w	x_pos(a1),d0				; sonic
		sub.w	x_pos(a0),d0				; nut
		blo.s		.leftupmove				; left move
		bsr.s	.accelerationymove
		sub.w	obNut_bypos(a0),d1		; sub backup y_pos	; distance
		move.w	obNut_timer(a0),d0		; timer
		cmp.w	d0,d1
		bgt.s	.yreturn

.ystop:
		move.w	d0,d1
		add.w	obNut_bypos(a0),d1		; add backup y_pos
		move.w	d1,y_pos(a0)
		lsl.w	#3,d0
		neg.w	d0
		move.w	d0,obNut_speed(a0)
		clr.b	mapping_frame(a0)
		clr.b	(a4)							; clear $38(a0) routine

.yreturn:
		rts
; ---------------------------------------------------------------------------

.leftupmove:
		bsr.s	.accelerationymove
		moveq	#0,d0					; clear timer
		sub.w	obNut_bypos(a0),d1		; sub backup y_pos	; distance
		bpl.s	.ystop
		rts

; ---------------------------------------------------------------------------
; Acceleration Ypos Move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.accelerationymove:
		add.w	d0,obNut_speed(a0)		; radius Sonic and Nut
		move.w	x_pos(a0),x_pos(a1)
		move.w	obNut_speed(a0),d0		; radius Sonic and Nut
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d0
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)
		neg.w	d1
		add.w	obNut_bypos(a0),d1		; add backup y_pos
		move.w	d1,y_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Move Down
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.movedown:
		move.w	x_pos(a1),d0				; sonic
		sub.w	x_pos(a0),d0				; nut
		bhs.s	.rightdownmove			; right move
		bsr.s	.accelerationymove
		sub.w	obNut_bypos(a0),d1		; sub backup y_pos	; distance
		move.w	obNut_timer(a0),d0		; timer
		cmp.w	d0,d1
		bgt.s	.ystop
		rts
; ---------------------------------------------------------------------------

.rightdownmove:
		bsr.s	.accelerationymove
		moveq	#0,d0					; clear timer
		sub.w	obNut_bypos(a0),d1		; sub backup y_pos	; distance
		bmi.s	.ystop
		rts

; ---------------------------------------------------------------------------
; Move Left
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.moveleft:
		move.w	x_pos(a1),d0				; sonic
		sub.w	x_pos(a0),d0				; nut
		bhs.s	.rightleftmove				; right move
		bsr.s	.accelerationxmove
		sub.w	obNut_bxpos(a0),d1		; sub backup x_pos	; distance
		move.w	obNut_timer(a0),d0		; timer
		cmp.w	d0,d1
		bgt.s	.xreturn

.xstop:
		move.w	d0,d1
		add.w	obNut_bxpos(a0),d1		; add backup x_pos
		move.w	d1,x_pos(a0)
		lsl.w	#3,d0
		move.w	d0,obNut_speed(a0)
		clr.b	mapping_frame(a0)
		clr.b	(a4)							; clear $38(a0) routine

.xreturn:
		rts
; ---------------------------------------------------------------------------

.rightleftmove:
		bsr.s	.accelerationxmove
		moveq	#0,d0					; clear timer
		sub.w	obNut_bxpos(a0),d1		; sub backup x_pos	; distance
		bpl.s	.xstop
		rts

; ---------------------------------------------------------------------------
; Acceleration Xpos Move
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.accelerationxmove:
		add.w	d0,obNut_speed(a0)		; radius sonic and nut
		move.w	x_pos(a0),x_pos(a1)
		move.w	obNut_speed(a0),d0		; radius sonic and nut
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d0
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)
		add.w	obNut_bxpos(a0),d1		; add backup x_pos
		move.w	d1,x_pos(a0)
		rts

; ---------------------------------------------------------------------------
; Move Right
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.moveright:
		move.w	x_pos(a1),d0				; sonic
		sub.w	x_pos(a0),d0				; nut
		blo.s		.leftrightmove				; left move
		bsr.s	.accelerationxmove
		sub.w	obNut_bxpos(a0),d1		; sub backup x_pos	; distance
		move.w	obNut_timer(a0),d0		; timer
		cmp.w	d0,d1
		bge.s	.xstop
		rts
; ---------------------------------------------------------------------------

.leftrightmove:
		bsr.s	.accelerationxmove
		moveq	#0,d0					; clear timer
		sub.w	obNut_bxpos(a0),d1		; sub backup x_pos	; distance
		bmi.s	.xstop
		rts
; ---------------------------------------------------------------------------

		include "Objects/MGZ Nut/Object Data/Map - MGZNut.asm"
