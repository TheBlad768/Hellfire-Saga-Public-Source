; ---------------------------------------------------------------------------
; FDZ3 palette
; ---------------------------------------------------------------------------

BLENDTYPE	= 1		; 0 = use original version | 1 = use new precise version
BLENDSPEED	= $0010		; $0001 to $0100 (very slow to instant)

; =============== S U B R O U T I N E =======================================

AnPal_FDZ3:
		lea	(PalCycle_Frame).w,a0

.pcount			= $00	; .b		; palette count
.routine			= $01	; .b		; routine jump
.timer			= $02	; .b		; wait time
.range			= $03	; .b		; range flag
.pointer			= $04	; .l		; palette pointer

	if BLENDTYPE=0
		tst.b	.pcount(a0)
		bne.s	.main
	else
		tst.w	(Pal_BlendAmount).w
		bne.s	.main
	endif

		tst.b	(Warper_Flag).w							; is alt layout?
		bne.s	.return								; if yes, branch

.main
		moveq	#0,d0
		move.b	.routine(a0),d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.data
		dc.w $2F0, $590		; miny, maxy
		dc.w $1236, $1710	; minx, maxx
; ---------------------------------------------------------------------------

.index
		bra.s	.inrange			; 0
		bra.s	.palprocess		; 2
		bra.s	.outrange		; 4
; ---------------------------------------------------------------------------

.inrange
	if BLENDTYPE=1
		bsr.s	.ResetPal
	endif
		; check camera xypos
		lea	.data(pc),a1
		jsr	(Check_SonicInRange).w
		bne.s	.return

		; load alt palette
		st	.range(a0)
		addq.b	#2,.routine(a0)
		move.l	#Pal_FDZ3_Alt,.pointer(a0)

	if BLENDTYPE=0
		move.b	#7,.pcount(a0)
	endif

.return
		rts
; ---------------------------------------------------------------------------

.palprocess
	if BLENDTYPE=0
		subq.b	#1,.timer(a0)
		bpl.s	.return
		move.b	#3,.timer(a0)
		subq.b	#1,.pcount(a0)
		beq.s	.done
		movea.l	.pointer(a0),a2			; palette pointer
		lea	(Normal_palette_line_3).w,a1	; palette ram
		moveq	#32-1,d0					; palette size
		jmp	(Pal_SmoothToPalette).w
	else
		pea	(a0)						; MJ: store object
		movea.l	.pointer(a0),a1					; MJ: load source palette 2 (0100)
		lea	(Target_palette+$40).w,a0			; MJ: load source palette 1 (0000)
		lea	(Normal_palette+$40).w,a2			; MJ: load destination palette buffer
		moveq	#($40/2)-1,d0					; MJ: palette size
		move.w	(Pal_BlendAmount).w,d1				; MJ: load blend amount
		addi.w	#$0010,d1					; MJ: increase blend amount
		jsr	(Pal_BlendPalette).w				; MJ: blend the palette
		move.w	d1,(Pal_BlendAmount).w				; MJ: update blend amount (if capped)
		move.l	(sp)+,a0					; MJ: restore object
		cmpi.w	#$0100,d1					; MJ: has the blend 100% finished?
		beq.s	.done						; MJ: if so, branch
		rts							; MJ: return (keep blending)
	endif

; ---------------------------------------------------------------------------

.done
		moveq	#0,d0
		tst.b	.range(a0)
		beq.s	.notinrange
		addq.b	#4,d0

.notinrange
		move.b	d0,.routine(a0)
		rts
; ---------------------------------------------------------------------------

.outrange
	if BLENDTYPE=1
		bsr.s	.ResetPal
	endif
		; check camera xypos
		lea	.data(pc),a1
		jsr	(Check_SonicInRange).w
		beq.s	.exit

		; load normal palette
		clr.b	.range(a0)
		subq.b	#2,.routine(a0)
		move.l	#Pal_FDZ3_Rain,.pointer(a0)

	if BLENDTYPE=0
		move.b	#7,.pcount(a0)
	endif

.exit
		rts



	if BLENDTYPE=1
.ResetPal:
		clr.w	(Pal_BlendAmount).w				; MJ: reset blend amount

		lea	(Normal_palette+$40).w,a1			; MJ: load current palette
		lea	(Target_palette+$40).w,a2			; MJ: load target palette
		moveq	#($40/4)-1,d0					; MJ: size to store

	.Copy:
		move.l	(a1)+,(a2)+					; MJ: store current palette as source 1 palette
		dbf	d0,.Copy					; MJ: repeat until done
		rts							; MJ: return (finished)
	endif