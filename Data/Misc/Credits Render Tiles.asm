; ===========================================================================
; ---------------------------------------------------------------------------
; Special tile rendering for Credits
; ---------------------------------------------------------------------------

ScrollDraw_VInt_Jump:
		jmp	ScrollDraw_VInt

ScrollDraw_Credits_VInt:
		lea	vdp_control_port,a5				; get VDP control port address
		lea	vdp_data_port,a6				; get VDP data port address

		tst.b	(CreditsLine).w					; is the special line rendering occuring?
		beq.w	.Normal						; if not, continue
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,(CreditsLine_Amount).w
		bge.s	ScrollDraw_VInt_Jump
		dma68kToVDP CreditsPlane+$1000,$C000,$1000,VRAM		; transfer plane data

		rts							; return

	.Normal:
		lea	PlaneBuf.w,a0					; get VInt plane write array
		moveq	#$03,d0						; the low bits for VRAM WRITE comm


		movem.l	d1-d2/d4,-(sp)					; store registers
		move.l	#$20002000|((VRAM_CreditsArt/$20)<<$10)|(VRAM_CreditsArt/$20),d2 ; tile shift to use level art
		move.w	(a0),d3						; load VDP write address
		beq.s	.Finish						; if list is empty, skip
		clr.w	(a0)+						; clear list
		moveq	#-$80,d4					; prepare line advance

	.Next:
		move.l	(a0)+,d1					; load tiles
		add.l	d2,d1						; shift (if necessary)

		move.w	#$2700,sr					; disable interrupts
		move.w	d3,(a5)						; set VDP write mode
		move.w	d0,(a5)						; ''
		move.l	d1,(a6)						; save tiles to VDP
		move.w	#$2300,sr					; enable interrupts

		sub.w	d4,d3						; advance to next line
		move.l	(a0)+,d1					; load tiles
		add.l	d2,d1						; shift (if necessary)

		move.w	#$2700,sr					; disable interrupts
		move.w	d3,(a5)						; set VDP write mode
		move.w	d0,(a5)						; ''
		move.l	d1,(a6)						; save tiles to VDP
		move.w	#$2300,sr					; enable interrupts

		move.w	(a0)+,d3					; load VDP write address
		bne.s	.Next						; if not finished list, continue

	; --- Reading mappings from VRAM ready for line effect ---

	.Finish:
		tst.b	(CreditsRead).w					; has a read been requested?
		beq.w	.NoRead						; if not, finish up
		sf.b	(CreditsRead).w					; clear request
		st.b	(CreditsLine).w					; enable special rendering
		sf.b	(CreditsText_Ready).w				; disable credits sprite text
		move.w	#$2700,sr					; disable interrupts
		move.l	#$00000003,(a5)					; set VDP to VRAM read
		lea	(CreditsPlane).l,a0				; load plane mappings RAM address
		move.w	#(($1000/4)/4)-1,d0				; size of VRAM plane

	.LoadVRAM:
		rept	4
		move.l	(a6),d1						; load plane tile mappings from VRAM
		sub.l	d2,d1						; remove line VRAM address (should be in line mode already in VRAM)
		move.l	d1,(a0)+					; save to 68k RAM
		endm
		dbf	d0,.LoadVRAM					; repeat til done

		move.l	#$40000000|vdpCommDelta(VRAM_CreditsSprites),(a5)

		move.l	#$1234F432,(a6)
		move.l	#$01234F43,(a6)
		move.l	#$001234F4,(a6)
		move.l	#$0001234F,(a6)
		move.l	#$00001234,(a6)
		move.l	#$00000123,(a6)
		move.l	#$00000012,(a6)
		move.l	#$00000001,(a6)
		move.l	#$10000000,(a6)
		move.l	#$21000000,(a6)
		move.l	#$32100000,(a6)
		move.l	#$43210000,(a6)
		move.l	#$F4321000,(a6)
		move.l	#$4F432100,(a6)
		move.l	#$34F43210,(a6)
		move.l	#$234F4321,(a6)

		move.w	#$2300,sr					; enable interrupts

	.NoRead:
		movem.l	(sp)+,d1-d2/d4					; restore registers
		rts							; return

; ===========================================================================