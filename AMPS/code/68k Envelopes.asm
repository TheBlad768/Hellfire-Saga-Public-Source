; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for running modulation envelope programs
;
; input:
;   d2 - Input frequency
;   d4 - Envelope ID
;   a1 - Channel to use
; output:
;   d2 - Output frequency
; thrash:
;   d4 - Envelope position
;   d5 - Byte read from envelope data & envelope sensitivity
;   a2 - Used for envelope data address
; ---------------------------------------------------------------------------

dModEnvProg:
	if FEATURE_MODENV
		moveq	#0,d4
		move.b	cModEnv(a1),d4		; load modulation envelope ID to d4
		beq.s	locret_ModEnvProg	; if 0, return

	if safe=1
		AMPS_Debug_ModEnvID		; check if modulation envelope ID is valid
	endif

		lea	ModEnvs-4(pc),a2	; load modulation envelope data array
		add.w	d4,d4			; quadruple modulation envelope ID
		add.w	d4,d4			; (each entry is 4 bytes in size)
		move.l	(a2,d4.w),a2		; get pointer to modulation envelope data

		moveq	#0,d4
		moveq	#0,d5
; ---------------------------------------------------------------------------

dModEnvProg2:
		move.b	cModEnvPos(a1),d5	; get envelope position to d5
		move.b	(a2,d5.w),d4		; get the data in that position
		bpl.s	.value			; if positive, its a normal value

		cmp.b	#eLast-2,d4		; check if this is a command
		ble.s	dModEnvCommand		; if it is handle it

.value
		addq.b	#1,cModEnvPos(a1)	; increment envelope position
		btst	#cfbFreqFrz,(a1)	; check if frequency is frozen
		bne.s	locret_ModEnvProg	; if yes, skip this shiz
		bset	#mfbUpdateFreq,mExtraFlags.w; plz update frequency

		move.b	cModEnvSens(a1),d5	; load sensitivity to d1 (unsigned value - effective range is ~ -$7000 to $8000)
		addq.w	#1,d5			; increment sensitivity by 1 (range of 1 to $100)
		ext.w	d4			; extend to displacement to a word
		muls	d5,d4			; signed multiply loaded value with sensitivity
		add.w	d4,d2			; add the frequency to channel frequency

locret_ModEnvProg:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for handling modulation envelope commands
; ---------------------------------------------------------------------------

dModEnvCommand:
	if safe=1
		AMPS_Debug_VolEnvCmd		; check if command is valid
	endif

.durr =		.comm-$80			; damn it AS
		jmp	.durr(pc,d4.w)		; jump to command handler

.comm
		bra.s	.reset			; 80 - Loop back to beginning
		bra.s	.hold			; 82 - Hold the envelope at current level
		bra.s	.loop			; 84 - Go to position defined by the next byte
		bra.s	.stop			; 86 - Stop current note and envelope
		bra.s	.seset			; 88 - Set the sensitivity of the modulation envelope
		bra.s	.seadd			; 8A - Add to the sensitivity of the modulation envelope
; ---------------------------------------------------------------------------

.hold
		subq.b	#1,cModEnvPos(a1)	; decrease envelope position
		jmp	dModEnvProg2(pc)	; run the program again (make modulation and portamento work)
; ---------------------------------------------------------------------------

.reset
		clr.b	cModEnvPos(a1)		; set envelope position to 0
		jmp	dModEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.loop
		move.b	1(a2,d5.w),cModEnvPos(a1); set envelope position to the next byte
		jmp	dModEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.seset
		move.b	1(a2,d5.w),cModEnvSens(a1); set modulation envelope sensitivity
		bra.s	.ignore
; ---------------------------------------------------------------------------

.seadd
		move.b	1(a2,d5.w),d4		; load sensitivity to d4
		add.b	d4,cModEnvSens(a1)	; add to modulation envelope sensitivity
; ---------------------------------------------------------------------------

.ignore
		addq.b	#2,cModEnvPos(a1)	; skip the command and the next byte
		jmp	dModEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.stop
		bset	#cfbRest,(a1)		; set channel resting bit
	dStopChannel	1			; stop channel operation
; ---------------------------------------------------------------------------
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for running volume envelope programs
;
; input:
;   d1 - Input volume
;   d4 - Envelope ID
;   a1 - Channel to use
; output:
;   d1 - Output volume
; thrash:
;   d4 - Byte read from envelope data
;   a2 - Used for envelope data address
; ---------------------------------------------------------------------------

dVolEnvProg:
	if safe=1
		AMPS_Debug_VolEnvID		; check if volume envelope ID is valid
	endif

		lea	VolEnvs-4(pc),a2	; load volume envelope data array
		add.w	d4,d4			; quadruple volume envelope ID
		add.w	d4,d4			; (each entry is 4 bytes in size)

		move.l	(a2,d4.w),a2		; get pointer to volume envelope data
		moveq	#0,d4
; ---------------------------------------------------------------------------

dVolEnvProg2:
		move.b	cEnvPos(a1),d4		; get envelope position to d4
		move.b	(a2,d4.w),d4		; get the data in that position
		bpl.s	.value			; if positive, its a normal value

		cmp.b	#eLast-2,d4		; check if this is a command
		ble.s	dEnvCommand		; if it is handle it

.value
		addq.b	#1,cEnvPos(a1)		; increment envelope position
		ext.w	d4			; extend volume to a word
		add.w	d4,d1			; add envelope volume to d1

	if FEATURE_PSGADSR=0
		moveq	#1,d4			; set Z flag to 0
	endif

locret_VolEnvProg:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for handling volume envelope commands
; ---------------------------------------------------------------------------

dEnvCommand:
	if safe=1
		AMPS_Debug_VolEnvCmd		; check if command is valid
	endif

.grrr =		.comm-$80			; damn it AS
		jmp	.grrr(pc,d4.w)		; jump to command handler

.comm
		bra.s	.reset			; 80 - Loop back to beginning
		bra.s	.hold			; 82 - Hold the envelope at current level
		bra.s	.loop			; 84 - Go to position defined by the next byte
		bra.s	.stop			; 86 - Stop current note and envelope
		bra.s	.ignore			; 88 - ignore
		bra.s	.ignore			; 8A - ignore
; ---------------------------------------------------------------------------

.hold
	if FEATURE_PSGADSR
		subq.b	#1,cEnvPos(a1)		; read the previous byte
		jmp	dVolEnvProg2(pc)	; run the program again
	else
		moveq	#0,d4			; set Z flag to 1
		rts
	endif
; ---------------------------------------------------------------------------

.reset
		clr.b	cEnvPos(a1)		; set envelope position to 0
		jmp	dVolEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.loop
		move.b	cEnvPos(a1),d4		; get envelope position to d4
		move.b	1(a2,d4.w),cEnvPos(a1)	; set envelope position to the next byte
		jmp	dVolEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.ignore
		addq.b	#2,cEnvPos(a1)		; skip the command and the next byte
		jmp	dVolEnvProg2(pc)	; run the program again
; ---------------------------------------------------------------------------

.stop
		bset	#cfbRest,(a1)		; set channel resting bit

	if FEATURE_PSGADSR
		dStopChannel	1		; stop channel operation
	else
		dStopChannel	0		; stop channel operation
		moveq	#0,d4			; set Z flag to 1
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for running TL envelope programs
;
; input:
;   a1 - Channel to operate on
;   a3 - Address to TL modulation data for this operator
;   d5 - Input volume
; output:
;   d5 - Output volume
; thrash:
;   a2 - Used for envelope data address
;   d4 - Used for envelope calculations, other various uses
; ---------------------------------------------------------------------------

	if FEATURE_MODTL
dModulateTL:
		tst.b	(a3)			; check if modulation or volume envelope is in progress
		bpl.s	locret_dModulateTL	; branch if none active

		btst	#0,toFlags(a3)		; check if modulation is enabled
		beq.s	.env			; if not, branch
		beq.s	.started		; if not, modulate!
		tst.b	toModDelay(a3)		; check if there is delay left
		beq.s	.started		; if not, modulate!
		subq.b	#1,toModDelay(a3)	; decrease delay
		bra.s	.env

.started
		subq.b	#1,toModSpeed(a3)	; decrease modulation speed counter
		bne.s	.env			; if there's still delay left, update vol and return
		movea.l	toMod(a3),a2		; get modulation data offset to a1
		move.b	(a2)+,toModSpeed(a3)	; reset modulation speed counter

		tst.b	toModCount(a3)		; check if this was the last step
		bne.s	.norev			; if was not, do not reverse
		move.b	(a2)+,toModCount(a3)	; reset steps counter
		neg.b	toModStep(a3)		; negate step amount

.norev
		subq.b	#1,toModCount(a3)	; decrease step counter
		move.b	toModStep(a3),d4	; get step offset into d5

		add.b	d4,toModVol(a3)		; add it to modulation volume
		add.b	toModVol(a3),d5		; add to channel base volume

.env
		moveq	#0,d4
		move.b	toVolEnv(a3),d4		; load volume envelope ID to d4
		beq.s	locret_dModulateTL	; if 0, no volume update is necessary

	if safe=1
		AMPS_Debug_VolEnvID		; check if volume envelope ID is valid
	endif

		lea	VolEnvs-4(pc),a2	; load volume envelope data array
		add.w	d4,d4			; quadruple volume envelope ID
		add.w	d4,d4			; (each entry is 4 bytes in size)
		move.l	(a2,d4.w),a2		; get pointer to volume envelope data

		moveq	#0,d4

dModulateTL2:
		move.b	toEnvPos(a3),d4		; get envelope position to d4
		move.b	(a2,d4.w),d4		; get the data in that position
		bpl.s	.value			; if positive, its a normal value

		cmp.b	#eLast-2,d4		; check if this is a command
		ble.s	dEnvCommandTL		; if it is handle it

.value
		addq.b	#1,toEnvPos(a3)		; increment envelope position
		ext.w	d4			; extend volume to a word
		add.w	d4,d5			; add envelope volume to d5

locret_dModulateTL:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for handling volume envelope commands
; ---------------------------------------------------------------------------

dEnvCommandTL:
	if safe=1
		AMPS_Debug_VolEnvCmd		; check if command is valid
	endif

.bich =		.comm-$80			; damn it AS
		jmp	.bich(pc,d4.w)		; jump to command handler

.comm
		bra.s	.reset			; 80 - Loop back to beginning
		bra.s	.hold			; 82 - Hold the envelope at current level
		bra.s	.loop			; 84 - Go to position defined by the next byte
		bra.s	.stop			; 86 - Stop current note and envelope
		bra.s	.ignore			; 88 - ignore
		bra.s	.ignore			; 8A - ignore
; ---------------------------------------------------------------------------

.hold
		subq.b	#1,toEnvPos(a3)		; decrease envelope position
		jmp	dModulateTL2(pc)	; update the volume correctly
; ---------------------------------------------------------------------------

.reset
		clr.b	toEnvPos(a3)		; set envelope position to 0
		jmp	dModulateTL2(pc)	; run the program again
; ---------------------------------------------------------------------------

.loop
		move.b	toEnvPos(a3),d4		; get envelope position to d4
		move.b	1(a2,d4.w),toEnvPos(a3)	; set envelope position to the next byte
		jmp	dModulateTL2(pc)	; run the program again
; ---------------------------------------------------------------------------

.ignore
		addq.b	#2,toEnvPos(a3)		; skip the command and the next byte
		jmp	dModulateTL2(pc)	; run the program again
; ---------------------------------------------------------------------------

.stop
		move.w	#$4000,d5		; set volume to maximum
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for running modulation envelope programs
;
; input:
;   a1 - Channel to use
;   a3 - Channel ADSR data
;   a4 - Used to calculating ADSR data address
;   d1 - Input volume
; output:
;   d1 - Output volume
; thrash:
;   d3 - Used for various calculations
;   d4 - Also used for various calculations
;   d5 - Low byte cleared
; ---------------------------------------------------------------------------

	if FEATURE_PSGADSR
dProcessADSR:
		moveq	#0,d4
		move.b	cADSR(a1),d4		; load ADSR to d4
		lsl.w	#3,d4			; multiply offset by 8
		clr.b	d5			; clear low byte of d5

		moveq	#adpMask,d3		; load bits to keep to d4
		and.b	adFlags(a3),d3		; get only flags to d3
		add.w	d3,d3			; double offset
		jmp	.table(pc,d3.w)		; run the appropriate routines
; ---------------------------------------------------------------------------

.table
		bra.s	.attack			; attack phase
		bra.s	.decay			; decay phase
		bra.s	.sustain		; sustain phase
		bra.s	.release		; release phase
; ---------------------------------------------------------------------------

.decay
		addq.w	#2,d4			; skip first 2 bytes

.attack
		lea	dBankADSR(pc),a4	; load ADSR bank address to a4
		lea	2(a4,d4.w),a4		; load ADSR data to a4
		move.w	(a4)+,d4		; load next byte of ADSR data
		clr.b	d4			; clear low byte
		lsr.w	#2,d4			; shift 2 bits down (2.6 fixed point format)

		move.b	-1(a4),d3		; load target volume to d3
		cmp.b	(a3),d3			; check if we need to go backwards
		beq.s	.nextphase		; if they're the same already (damn wtf), go to next phase
		bhi.s	.atkpos			; branch if addition should be performed

		sub.w	d4,(a3)			; subtract from volume
		cmp.b	(a3),d3			; check if we reached the target volume
		bgt.s	.phaseset		; if we did, branch

.sustain
		move.b	(a3),d4			; load volume to d4
		ext.w	d4			; extend to word
		add.w	d4,d1			; add to volume in d1
		rts

.atkpos
		add.w	d4,(a3)			; add to volume
		cmp.b	(a3),d3			; check if we reached the target volume
		bhi.s	.sustain		; if we did not, branch
		bra.s	.phaseset
; ---------------------------------------------------------------------------

.release
		lea	dBankADSR(pc),a4	; load ADSR bank address to a4
		lea	6(a4,d4.w),a4		; load ADSR data to a4
		move.w	(a4)+,d4		; load next byte of ADSR data
		clr.b	d4			; clear low byte
		lsr.w	#2,d4			; shift 2 bits down (2.6 fixed point format)

		add.w	d4,(a3)			; add to volume
		bpl.s	.sustain		; if not max volume, branch
		move.b	#$7F,(a3)		; force max volume
		move.w	#$4000,d1		; mute as well
		rts
; ---------------------------------------------------------------------------

.phaseset
		move.b	-1(a4),(a3)		; copy real volume here

.nextphase
		bset	#cfbVol,(a1)		; force volume update
		moveq	#adpMask|admMask,d3	; prepare mode and phase mask to d3
		and.b	adFlags(a3),d3		; and with flags on d3
		move.b	dPhaseTableADSR(pc,d3.w),adFlags(a3); load flags from table

		move.b	(a3),d4			; load volume to d4
		ext.w	d4			; extend to word
		add.w	d4,d1			; add to volume in d1
		rts
; ---------------------------------------------------------------------------

dPhaseTableADSR:
	; normal mode:
		dc.b admNormal|adpDecay, admNormal|adpSustain, admNormal|adpRelease, admNormal|adpAttack

	; noattack mode:
		dc.b admNoAttack|adpDecay, admNoAttack|adpSustain, admNoAttack|adpRelease, admNoAttack|adpAttack

	; reattack mode:
		dc.b admReAttack|adpAttack, admReAttack|adpAttack, admReAttack|adpAttack, admReAttack|adpAttack

	; nodecay mode:
		dc.b admNoDecay|adpSustain, admNoDecay|adpSustain, admNoDecay|adpRelease, admNoDecay|adpAttack

	; noattack mode:
		dc.b admReDecay|adpDecay, admReDecay|adpDecay, admReDecay|adpDecay, admReDecay|adpAttack

	; norelease mode:
		dc.b admNoRelease|adpDecay, admNoRelease|adpSustain, admNoRelease|adpAttack, admNoRelease|adpAttack

	; attackrelease mode:
		dc.b admAttRel|adpRelease, admAttRel|adpRelease, admAttRel|adpRelease, admAttRel|adpAttack

	; immediate mode
		dc.b adpSustain|admImm, adpSustain|admImm, adpRelease|admImm, adpSustain|admImm
; ---------------------------------------------------------------------------
	endif
