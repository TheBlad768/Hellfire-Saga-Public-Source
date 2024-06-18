; ===========================================================================
; ---------------------------------------------------------------------------
; SRAM handler - MarkeyJester
; ---------------------------------------------------------------------------
EndSRAM		= (*+$1000)	; The assembler cannot forward reference on first pass
; ---------------------------------------------------------------------------

CheckSRAM:
		sf.b	(SupportSRAM).w					; set NO SRAM support
	if DisableSRAM=1
		rts
	endif
	if EndSRAM > $1FFFFF
		rts							; return (failed)
	endif
		move.l	#$200000,d2					; SRAM start and size
		lea	($01B4).w,a0					; load SRAM address space in header
		move.l	(a0)+,d0					; load SRAM start
		move.l	d0,d1						; check if it's in the 2MB to 4MB range
		sub.l	d2,d1						; ''
		cmp.l	d2,d1						; ''
		bhs.w	.NoSRAM						; if it's not, skip SRAM support
		move.l	(a0),d1						; load SRAM end
		addq.l	#$02,d1						; allow FFFF to be accessed...
		sub.l	d2,d1						; check if it's in the 2MB to 4MB range
		cmp.l	d2,d1						; ''
		bhs.w	.NoSRAM						; if it's not, skip SRAM support
		add.l	d2,d1						; restore SRAM end address
		sub.l	d0,d1						; get size
		move.l	d1,d2						; copy size
		subi.l	#SR_VITAL,d2					; is there enough SRAM for the watermark/checksum at least?
		bmi.w	.NoSRAM						; if not (or if the end address is before the start address, skip)
		lsr.l	#$01,d2						; half it due to odd-SRAM (most older/cheaper carts only support odd)
		cmpi.l	#SR_END-SR_VITAL,d2				; is there enough SRAM space for the size storage, version number, and our data?
		bcs.w	.NoSRAM						; if not, skip SRAM
		movea.l	d0,a0						; set start address

		move.b	#$01,($A130F1).l				; switch to SRAM
		movep.l	SR_WaterMark(a0),d0				; load watermark
		cmpi.l	#WaterSRAM,d0					; is the watermark in SRAM?
		bne.s	.Init						; if not, initialise SRAM

		bsr.w	GetSumSRAM					; get the checksum
		movep.l	SR_CheckSum(a0),d0				; load checksum in SRAM
		cmp.l	d0,d3						; does it have the sum it says it has?
		beq.s	.SumOkay					; if so, resume

		; Double checks to see if the sum matches the size in SRAM already
		; If so, then we might have changed the SRAM size since the last
		; version, this should protect against that.

		move.l	d2,d4						; store current size
		movep.l	SR_Size(a0),d2					; load size currently already in SRAM (just in-case we changed the size since)
		cmpi.l	#$200000/2,d2					; is the size valid (at all)?
		bhs.s	.InitD4						; if not, no way...
		bsr.w	GetSumSRAM					; get the checksum
		movep.l	SR_CheckSum(a0),d0				; load checksum in SRAM
		cmp.l	d0,d3						; does it have the sum it says it has?
		bne.s	.InitD4						; if not, definitely corrupt/wrong, branch to initialise SRAM
		move.l	d4,d2						; restore current size

	.SumOkay:
		movep.l	SR_Version(a0),d0				; load version number
		cmpi.l	#VerSRAM,d0					; is this version the same as the ROM version?
		beq.w	.Valid						; if so, branch (all fine~)
		bcc.w	.Avoid						; the SRAM is NEWER than this ROM, don't touch it!!

	; --- Older version ---
	; Right here, if the version inside SRAM (d0.l) is older than the current ROM version, then
	; we can technically update the SRAM contents, make it compatible with the newer ROM.
	;
	; We only have 1 version at the moment, so there's nothing to update, but just in-case...
	; You may need to do a jump table of different subroutines based on the version number
	; in order to update it from the correct old version to the current version.
	; ---------------------

		; *Nothing....*

	; ---------------------

		bra.s	.Update						; continue, update the checksum and size

	; --- Initalising ---
	; First ever run of the game, SRAM is reset
	; to the beginning.
	; -------------------

	.Init:
		; Double check size/range

		move.l	d2,d4						; store expected size

	.InitD4:
		move.l	#'OSIM',d1					; test mark
		movep.l	d1,$00(a0)					; set mark
		movep.l	$00(a0),d3					; reload
		cmp.l	d3,d1						; did it save successfully?
		bne.s	.Avoid						; if not, skip
		moveq	#$00,d0						; clear mark
		movep.l	d0,$00(a0)					; ''

		moveq	#$20/2,d2					; starting power of 2 offset to check

	.FindSize:
		lea	(a0,d2.l),a1					; load offset
		movep.l	d1,$00(a1)					; save mark
		movep.l	$00(a1),d3					; reload mark
		cmp.l	d3,d1						; was the mark saved?
		bne.s	.FoundSize					; if not, end of range found...
		movep.l	$00(a0),d3					; load beginning of SRAM
		cmp.l	d3,d1						; has the data mirrored?
		beq.s	.FoundSize					; if so, found a mirror
		moveq	#$00,d3						; clear mark
		movep.l	d3,$00(a1)					; ''
		add.l	d2,d2						; advance to next power of 2
		cmp.l	d4,d2						; has it reached what the ROM expects to use?
		bmi.s	.FindSize					; if not, continue

	;	lea	(a0,d0.l),a1					; load offset
	;	movep.l	d1,$00(a1)					; save mark
	;	movep.l	$00(a1),d3					; reload mark
	;	cmp.l	d3,d1						; was the mark saved?
	;	bne.s	.FoundSize					; if not, end of range found...
	;	lea	(a0,d2.l),a1					; load offset
	;	movep.l	$00(a1),d3					; reload mark
	;	cmp.l	d3,d1						; is there mirror access?
	;	beq.s	.FoundSize					; if so, end of range found...
	;	sf.b	$00(a0,d0.l)					; clear mark
	;	move.l	d0,d2						; store halfway of next range
	;	cmp.l	d4,d2						; has it reached what the ROM expects to use?
	;	bge.s	.FoundSize					; if so, finish here...
	;	add.l	d0,d0						; check next range
	;	bra.s	.FindSize					; keep repeating until the end is found

	.FoundSize:

		subi.l	#SR_VITAL/2,d2					; remove vital header from size

		; Reset/Clear

		lea	SR_VITAL(a0),a1					; load start of actual SRAM (exluding watermark/checksum)
		move.l	d2,d1						; get size to check
		bra.s	.StartWord					; jump into the loop

	.NextLong:
		swap	d1						; get lower word count again

	.NextWord:
		sf.b	(a1)+						; clear SRAM
		addq.w	#$01,a1						; skip even address

	.StartWord:
		dbf	d1,.NextWord					; repeat for lower word bound
		swap	d1						; repeat for upper word bound
		dbf	d1,.NextLong					; ''

		move.l	#WaterSRAM,d0					; save watermark
		movep.l	d0,SR_WaterMark(a0)				; ''

		st.b	(FirstSRAM).w					; set this as the first time SRAM is activated/ran

	; -------------------

	.Update:
		move.l	#VerSRAM,d0					; update version number
		movep.l	d0,SR_Version(a0)				; ''
		movep.l	d2,SR_Size(a0)					; store size of SRAM
		bsr.w	GetSumSRAM					; get the checksum
		movep.l	d3,SR_CheckSum(a0)				; store checksum (not including watermark/checksum value)

	.Valid:
		st.b	(SupportSRAM).w					; set YES SRAM support

	.Avoid:
		move.b	#$00,($A130F1).l				; switch to ROM

	.NoSRAM:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load a save slot - if zero condition on return, then fail
; --- input -----------------------------------------------------------------
; d0.b = slot number to load
; a0.l = RAM address to load the slot contents to
; ---------------------------------------------------------------------------

LoadSlot:
		move.w	sr,-(sp)					; store sr for later
		move.w	#$2700,sr					; disable interrupts
		movem.l	d0/d2/a0-a1,-(sp)				; store register data
		tst.b	(SupportSRAM).w					; is SRAM supported/compatible?
		beq.s	.NoSRAM						; if not, STRICTLY NO TOUCHING
		lea	(a0),a1						; move destination RAM to a1
		movea.l	($01B4).w,a0					; load SRAM address
		move.b	#$01,($A130F1).l				; switch to SRAM

		mulu.w	#SR_SlotSize*2,d0				; multiply slot ID by size of slot
		addi.l	#SR_Slots,d0					; advance to starting slot
		cmp.l	#SR_END,d0					; is the slot invalid (too high)?
		bcc.s	.Fail						; if so, cancel...
		movep.l	SR_Size(a0),d2					; load size of SRAM
		add.l	d2,d2						; get full size
		addi.l	#SR_VITAL,d2					; ''
		cmp.l	d2,d0						; if the slot is out of range of hardware SRAM's allowed access, branch
		bcc.s	.Fail						; not allowed... skip
		adda.l	d0,a0						; advance to starting slot

		move.w	#SR_SlotSize-1,d2				; size of slot to load
		bmi.s	.LoadedSlot					; if there's no slot size to speak of, skip (unlikely, but strict programming here...)

	.LoadSlot:
		move.b	(a0)+,(a1)+					; load data from SRAM
		addq.w	#$01,a0						; skip to next odd slot
		dbf	d2,.LoadSlot					; repeat until entire data is loaded out

	.LoadedSlot:
		move.b	#$00,($A130F1).l				; switch to ROM
		andi.w	#$FF00|%11011,$10(sp)				; clear zero (success)
		bra.s	.NoSRAM						; continue

	.Fail:
		move.b	#$00,($A130F1).l				; switch to ROM
		ori.w	#%11011,$10(sp)					; set zero (fail)

	.NoSRAM:
		movem.l	(sp)+,d0/d2/a0-a1				; restore register data
		move.w	(sp)+,sr					; restore sr/ccr
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to save a slot - if zero condition on return, then fail
; --- input -----------------------------------------------------------------
; d0.b = slot number to save
; a0.l = RAM address to save the slot contents from
; ---------------------------------------------------------------------------

SaveSlot:
		move.w	sr,-(sp)					; store sr for later
		move.w	#$2700,sr					; disable interrupts
		movem.l	d0/d2-d3/a0-a1,-(sp)				; store register data
		tst.b	(SupportSRAM).w					; is SRAM supported/compatible?
		beq.s	.NoSRAM						; if not, STRICTLY NO TOUCHING
		lea	(a0),a1						; move source RAM to a1
		movea.l	($01B4).w,a0					; load SRAM address
		move.b	#$01,($A130F1).l				; switch to SRAM

		mulu.w	#SR_SlotSize*2,d0				; multiply slot ID by size of slot
		addi.l	#SR_Slots,d0					; advance to starting slot
		cmp.l	#SR_END,d0					; is the slot invalid (too high)?
		bcc.s	.Fail						; if so, cancel...
		movep.l	SR_Size(a0),d2					; load size of SRAM
		add.l	d2,d2						; get full size
		addi.l	#SR_VITAL,d2					; ''
		cmp.l	d2,d0						; if the slot is out of range of hardware SRAM's allowed access, branch
		bcc.s	.Fail						; not allowed... skip
		adda.l	d0,a0						; advance to starting slot

		move.w	#SR_SlotSize-1,d2				; size of slot to load
		bmi.s	.SavedSlot					; if there's no slot size to speak of, skip (unlikely, but strict programming here...)

	.SaveSlot:
		move.b	(a1)+,(a0)+					; save data to SRAM
		addq.w	#$01,a0						; skip to next odd slot
		dbf	d2,.SaveSlot					; repeat until entire data is loaded out

	.SavedSlot:
		movea.l	($01B4).w,a0					; reload SRAM address
		movep.l	SR_Size(a0),d2					; load size of SRAM to get the checksum of
		bsr.s	GetSumSRAM					; get the checksum
		movep.l	d3,SR_CheckSum(a0)				; update checksum
		move.b	#$00,($A130F1).l				; switch to ROM
		andi.w	#$FF00|%11011,$14(sp)				; clear zero (success)
		bra.s	.NoSRAM						; continue

	.Fail:
		move.b	#$00,($A130F1).l				; switch to ROM
		ori.w	#%11011,$14(sp)					; set zero (fail)

	.NoSRAM:
		movem.l	(sp)+,d0/d2-d3/a0-a1				; restore register data
		move.w	(sp)+,sr					; restore sr/ccr
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to get the checksum of SRAM
; --- input -----------------------------------------------------------------
; a0.l = start of SRAM (e.g. $200001)
; d2.l = size of SRAM divided by 2 and minus first 2 long-words
;	 (e.g. $200001 - $20FFFF = $FFFE / 2 = $7FFF - (4 * 2) = $7FF7)
; --- output ----------------------------------------------------------------
; d3.l = checksum value
; ---------------------------------------------------------------------------

GetSumSRAM:
		lea	SR_VITAL(a0),a1					; load start of actual SRAM (exluding watermark/checksum)
		move.l	d2,d1						; get size to check
		moveq	#$00,d3						; reset checksum match
		bra.s	.Start						; jump into loop

	.NextLong:
		swap	d1

	.No1:
		move.b	(a1)+,d0					; load first byte
		addq.w	#$01,a1						; advance...
		lsl.w	#$08,d0						; put into place
		dbf	d1,.No2						; repeat until all SRAM is checked
		swap	d0						; send to upper word
		bra.s	.Fin						; finish and check

	.No2:
		move.b	(a1)+,d0					; load second byte
		addq.w	#$01,a1						; advance...
		swap	d0						; send lower word to upper word
		dbf	d1,.No3						; repeat until all SRAM is checked
		bra.s	.Fin						; finish and check

	.No3:
		move.b	(a1)+,d0					; load third byte
		addq.w	#$01,a1						; advance...
		lsl.w	#$08,d0						; put into place
		dbf	d1,.No4						; repeat until all SRAM is checked
		bra.s	.Fin						; finish and check

	.No4:
		move.b	(a1)+,d0					; load forth byte
		addq.w	#$01,a1						; advance...
		add.l	d0,d3						; add long to total sum

	.Start:
		moveq	#$00,d0						; clear upper long
		dbf	d1,.No1						; repeat until all SRAM is checked

	.Fin:
		swap	d1						; check upper word counter
		dbf	d1,.NextLong					; repeat until all SRAM is checked in upper bound
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Warning message
; ---------------------------------------------------------------------------

	if EndSRAM > $1FFFFF
		message " "
		message "Warning, part of (or all) SRAM code is beyond the 2MB ($200000) spot in ROM"
		message "(up to offset $\{*} to be precise), please move the code to somewhere before"
		message	"the 2MB mark, or else the code will deliberately ignore save support..."
		message " "
	endif

; ===========================================================================