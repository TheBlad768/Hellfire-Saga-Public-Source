; ===========================================================================
; ---------------------------------------------------------------------------
; Macros
; ---------------------------------------------------------------------------

	; --- Alignment ---

align		macro
		cnop	0,\1
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

		dc.l Stack, EntryPoint, BusError, AddressError
		dc.l IllegalInstr, ZeroDivide, ChkInstr, TrapvInstr
		dc.l PrivilegeViol, Trace, Line1010Emu,	Line1111Emu
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept
		dc.l ErrorExcept, ErrorTrap, ErrorTrap,	ErrorTrap
		dc.l HBlankRAM,	ErrorTrap, VBlankRAM, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
		dc.l ErrorTrap,	ErrorTrap, ErrorTrap, ErrorTrap
HConsole:	dc.b 'SEGA MEGA DRIVE '
		dc.b 'AURORAF 2021-NOV'
		dc.b 'AURORA FIELDS'' FRACTAL SOUND TESTING ROM        '
		dc.b 'AURORA FIELDS'' FRACTAL SOUND TESTING ROM        '
		dc.b 'UNOFFICIAL-21 '
		dc.w 0
		dc.b 'J               '
		dc.l 0, EndOfRom-1, $FF0000, $FFFFFF
		dc.b 'NO SRAM     '
		dc.b 'OPEN SOURCE SOFTWARE. YOU ARE WELCOME TO MAKE YOUR  '
		dc.b 'JUE '
		dc.b 'OWN MODIFICATIONS. PLEASE CREDIT WHEN USED'

; ===========================================================================
; ---------------------------------------------------------------------------
; Code section
; ---------------------------------------------------------------------------

EntryPoint:
		tst.l	$A10009-1			; test port A control
		bne.s	PortA_Ok
		tst.w	$A1000B-1			; test port C control

PortA_Ok:
		bne.s	PortC_Ok
		lea	SetupValues(pc),a5
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0			; get hardware version
		andi.b	#$F,d0
		beq.s	SkipSecurity
		move.l	HConsole.w,$2F00(a1)

SkipSecurity:
		move.w	(a4),d0				; check	if VDP works
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp				; set usp to $0

		moveq	#$17,d1
VDPInitLoop:
		move.b	(a5)+,d5			; add $8000 to value
		move.w	d5,(a4)				; move value to	VDP register
		add.w	d7,d5				; next register
		dbf	d1,VDPInitLoop

		move.l	(a5)+,(a4)
		move.w	d0,(a3)				; clear	the screen
		move.w	d7,(a1)				; stop the Z80
		move.w	d7,(a2)				; reset	the Z80

WaitForZ80:
		btst	d0,(a1)				; has the Z80 stopped?
		bne.s	WaitForZ80			; if not, branch
		moveq	#endinit-initz80-1,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop

		move.w	d0,(a2)
		move.w	d0,(a1)				; start	the Z80
		move.w	d7,(a2)				; reset	the Z80
ClrRAMLoop:
		move.l	d0,-(a6)
		dbf	d6,ClrRAMLoop			; clear	the entire RAM

		move.l	(a5)+,(a4)			; set VDP display mode and increment
		move.l	(a5)+,(a4)			; set VDP to CRAM write
		moveq	#$1F,d3
ClrCRAMLoop:
		move.l	d0,(a3)
		dbf	d3,ClrCRAMLoop			; clear	the CRAM

		move.l	(a5)+,(a4)
		moveq	#$13,d4

ClrVDPStuff:
		move.l	d0,(a3)
		dbf	d4,ClrVDPStuff

		moveq	#3,d5
PSGInitLoop:
		move.b	(a5)+,$11(a3)			; reset	the PSG
		dbf	d5,PSGInitLoop

		move.w	d0,(a2)
		movem.l	(a6),d0-a6			; clear	all registers
		move	#$2700,sr			; set the sr

PortC_Ok:
		moveq	#$40,d0
		move.b	d0,$A10009
		move.b	d0,$A1000B
		move.b	d0,$A1000D
		bra.w	GameProgram

; ===========================================================================
SetupValues:	dc.w $8000
		dc.w $3FFF
		dc.w $100

		dc.l $A00000				; start	of Z80 RAM
		dc.l $A11100				; Z80 bus request
		dc.l $A11200				; Z80 reset
		dc.l $C00000
		dc.l $C00004				; address for VDP registers

		dc.b 4,	$74, $30, $3C			; values for VDP registers
		dc.b 7,	$6C, 0,	0
		dc.b 0,	0, $FF,	0
		dc.b $81, $37, 0, 1
		dc.b 1,	0, 0, $FF
		dc.b $FF, 0, 0,	$80

		dc.l $40000080

initz80
	if def(__pack)		; pre-assembled sound driver because of course!
		dc.b $F3, $ED, $56, $21, $00, $12, $11, $C0
		dc.b $01, $3E, $FF, $77, $23, $77, $23, $77
		dc.b $23, $77, $23, $77, $23, $77, $23, $77
		dc.b $23, $77, $23, $1B, $7A, $B3, $20, $E9
		dc.b $18, $FE
	else
	z80prog 0
		di
		im	1
		ld	hl,YM_Buffer1			; we need to clear from YM_Buffer1
		ld	de,(YM_BufferEnd-YM_Buffer1)/8	; to end of Z80 RAM, setting it to 0FFh

.loop
		ld	a,0FFh				; load 0FFh to a
		rept 8
			ld	(hl),a			; save a to address
			inc	hl			; go to next address
		endr

		dec	de				; decrease loop counter
		ld	a,d				; load d to a
		zor	e				; check if both d and e are 0
		jr	nz, .loop			; if no, clear more memoty
.pc		jr	.pc				; trap CPU execution
	z80prog
	endif
		even
endinit
		dc.w $8174				; value	for VDP	display	mode
		dc.w $8F02				; value	for VDP	increment
		dc.l $C0000000				; value	for CRAM write mode
		dc.l $40000010

		dc.b $9F, $BF, $DF, $FF			; values for PSG channel volumes
; ===========================================================================

GameProgram:
		move	#$2700,sr			; disable interrupts

		moveq	#0,d0
		moveq	#0,d1
		moveq	#0,d2
		moveq	#0,d3
		moveq	#0,d4
		moveq	#0,d5
		moveq	#0,d6
		moveq	#0,d7
		move.l	d0,a0
		move.l	d0,a1
		move.l	d0,a2
		move.l	d0,a3
		move.l	d0,a4
		move.l	d0,a5
		move.l	d0,a6				; load RAM end to a6

	rept $10000/56
		movem.l	d0-a5,-(a6)			; clear 56 bytes at once
	endr

		lea	$C00004,a6
		move.l	#$8F019780,(a6)			; VRAM fill, VRAM pointer increment: $0001
		move.l	#(($9400|((($FFFF)&$FF00)>>8))<<16)|($9300|(($FFFF)&$FF)),(a6) ; DMA length ...
		move.l	#$40000080|((0&$3FFF)<<16)|((0&$C000)>>14),(a6) ; Start at ...
		move.w	#0<<8,-4(a6)			; Fill with byte

.loop		move.w	(a6),d1
		btst	#1,d1
		bne.s	.loop				; busy loop until the VDP is finished filling...
		move.w	#$8F02,(a6)			; VRAM pointer increment: $0002


		move.b	$A10001,d0			; get System version bits
		andi.b	#$C0,d0
		move.b	d0,ConsoleRegion.w		; save into RAM

		move.w	#$4EF9,VBlankRAM.w
		move.w	#$4EF9,HBlankRAM.w
		move.l	#NullBlank,HBlankRout.w
		lea	Decompress(pc),a3		; load decompression routine to a3
		jsr	dFractalInit			; load dual pcm

		lea	VBlankRout.w,a0			; load v-blank routine to a0
		lea	dxExternalExample(pc),a1	; load external routine to a1 (will be called by visual debugger)
		jmp	dVisualDebugger			; run the visual debugger
; ---------------------------------------------------------------------------

NullBlank:
		rte
; ---------------------------------------------------------------------------

Decompress:
		move.w	(a0)+,d0			; load the driver size to d0
		subq.w	#1,d0				; account for dbf
		bmi.s	.done				; branch if its 0 bytes(???)

.next
		move.b	(a0)+,(a1)+			; copy every byte one at a time
		dbf	d0,.next			; loop until all is copied

.done
		rts
