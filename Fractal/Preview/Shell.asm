; ===========================================================================
; ---------------------------------------------------------------------------
; Compatibility macros
; ---------------------------------------------------------------------------

dvDMA		macro
	endm

; ===========================================================================
; ---------------------------------------------------------------------------
; Equates
; ---------------------------------------------------------------------------

Main		SECTION org(0)
__pack
		opt	l.				; local label symbol is .
		opt	w-				; disable warnings
		opt	ae-				; disable auto even

dvMemory =	$FFFF8200			; $4000	; visual debugger memory
dMemory =	$FFFFD180			; $1000	; sound driver memory location
Stack =		$FFFFD080			; $80	; end of stack
HBlankRAM =	$FFFFFFF0			; word	; jmp $00000000
HBlankRout =	HBlankRAM+$02			; long	; ''
VBlankRAM =	HBlankRout+$04			; word	; jmp $00000000
VBlankRout =	VBlankRAM+$02			; long	; ''
ConsoleRegion =	$FFFFFFEE			; byte	; region settings

binclude	macros					; allow AS-style binclude macros
		incbin	\_

		include	"error/Debugger.asm"
		include "Fractal/Code/equ.asm"		; include the equates file
		include "Fractal/Preview/Init.asm"	; include init routines
; ---------------------------------------------------------------------------

		include "Example External Functions.asm"; include the example external code

DualPCM:
		incbin	"Fractal/Code/DualPCM.dat"
		include	"Fractal/Code/main.asm"

tracksize =	(dSoundData_End-dSoundData)/1024
		inform 0, "Song data size:   \#tracksize KB"

sampsize =	(dSampleData_End-dSampleData)/1024
		inform 0, "Sample data size: \#sampsize KB"
		include	"error/ErrorHandler.asm"
EndOfRom:	END


