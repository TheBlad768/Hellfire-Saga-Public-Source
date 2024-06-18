; ===========================================================================
; ---------------------------------------------------------------------------
; SRAM handler equates - MarkeyJester
; ---------------------------------------------------------------------------

VerSRAM		= 0		; Version number (just in-case a newer version of hellfire comes out, and you want to bring the save data over)
WaterSRAM	= "MISO"	; Watermark DO NOT TOUCH THIS IF YOU WANT BACKWARDS/FORWARDS COMPATABILITY
MaxSlotSRAM	= 8		; maximum number of slots
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

	; --- Slot Space ---

			phase	0
SR_Zone			ds.b	1					; Zone ID
SR_Act			ds.b	1					; Act ID
SR_Difficulty		ds.b	1					; Difficult setting
SR_Camera		ds.b	1					; Cinematic camera setting
SR_Complete		ds.b	1					; if the game has been completed and level select is unlocked
			ds.b	1
SR_SlotSize
			dephase

	; --- Main Space --

			phase	0
SR_WaterMark		ds.l	1*2					; "MISO"
SR_CheckSum		ds.l	1*2					; checksum from SR_VITAL to SR_END
SR_VITAL
SR_Size			ds.l	1*2					; size of data from SR_VITAL to SR_END in odd byte count only
SR_Version		ds.l	1*2					; version number of SRAM contents (forwards compatability)

SR_Slots		ds.b	(SR_SlotSize*2)*MaxSlotSRAM		; save slots available

SR_END
			dephase

		!org	OffsetROM					; Reset the program counter

; ===========================================================================