; ===========================================================================
; Sonic the hedgehog in Hellfire Saga - sound test program
; ===========================================================================

GameDebug:			= 0	; If 1, enable debug mode for sonic
OptimiseSound:	  		= 1	; change to 1 to optimise sound queuing
zeroOffsetOptimization:		= 1	; If 1, makes a handful of zero-offset instructions smaller
VISUAL_DEBUG			= 1
; ---------------------------------------------------------------------------

; VDP addresses
VDP_data_port =					$C00000
VDP_control_port =				$C00004
VDP_counter =					$C00008

PSG_input =						$C00011
; ---------------------------------------------------------------------------

; Z80 addresses
Z80_RAM =						$A00000	; start of Z80 RAM
Z80_RAM_end =					$A02000	; end of non-reserved Z80 RAM
Z80_bus_request =				$A11100
Z80_reset =						$A11200
; ---------------------------------------------------------------------------
; I/O Area
HW_Version =					$A10001
HW_Port_1_Data =				$A10003
HW_Port_2_Data =				$A10005
HW_Expansion_Data =			$A10007
HW_Port_1_Control =				$A10009
HW_Port_2_Control =				$A1000B
HW_Expansion_Control =			$A1000D
HW_Port_1_TxData =				$A1000F
HW_Port_1_RxData =				$A10011
HW_Port_1_SCtrl =				$A10013
HW_Port_2_TxData =				$A10015
HW_Port_2_RxData =				$A10017
HW_Port_2_SCtrl =				$A10019
HW_Expansion_TxData =			$A1001B
HW_Expansion_RxData =			$A1001D
HW_Expansion_SCtrl =			$A1001F
; ---------------------------------------------------------------------------
; SRAM addresses
SRAM_access_flag =				$A130F1
Security_addr =					$A14000
; ---------------------------------------------------------------------------
; compatibility
object_size =	2
PLCNEM_COUNT =	1
PLCKOSM_COUNT =	4

vram_hscroll =	0
vram_sprites =	0
vram_fg =	0
vram_bg =	0
vram_window =	0
; ---------------------------------------------------------------------------

; Assembler code:
		cpu 68000
		include "MacroSetup.asm"			; include a few basic macros
		include "Macros.asm"				; include some simplifying macros and functions
		include "Variables.asm"
		include "Misc Data/Debugger/ErrorHandler/Debugger.asm"

		RELAXED ON
		include "Fractal/Code/equ.asm"
		RELAXED OFF
mFadeFlag	EQU mTiming					; this is used for enabling fadeout detection
; ---------------------------------------------------------------------------

StartOfROM:
	if * <> 0
		fatal "StartOfROM was $\{*} but it should be 0"
	endif
Vectors:
		dc.l System_stack, EntryPoint, BusError, AddressError		; 0
		dc.l IllegalInstr, ZeroDivide, ChkInstr, TrapvInstr			; 4
		dc.l PrivilegeViol, Trace, Line1010Emu, Line1111Emu		; 8
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept	; 12
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept	; 16
		dc.l ErrorExcept, ErrorExcept, ErrorExcept, ErrorExcept	; 20
		dc.l ErrorExcept, ErrorTrap, ErrorTrap, ErrorTrap			; 24
		dc.l H_int_jump, ErrorTrap, V_int_jump, ErrorTrap		; 28
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 32
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 36
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 40
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 44
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 48
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 52
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 56
		dc.l ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap			; 60
Header:		dc.b "SEGA GENESIS    "
Copyright:	dc.b "(C)SEGA XXXX.XXX"				      ;
Domestic_Name:	dc.b "HELLFIRE SAGA - SOUND TEST PROGRAM              "
Overseas_Name:	dc.b "HELLFIRE SAGA - SOUND TEST PROGRAM              "
Serial_Number:	dc.b "GM MK-0000 -00"
Checksum:	dc.w 0
Input:		dc.b "J               "
RomStartLoc:	dc.l StartOfROM
RomEndLoc:	dc.l EndOfROM-1
RamStartLoc:	dc.l (RAM_start&$FFFFFF)
RamEndLoc:	dc.l (RAM_start&$FFFFFF)+$FFFF
CartRAM_Info:	dc.b "  "
CartRAM_Type:	dc.w %10000000100000
CartRAMStartLoc:dc.l $20202020	; SRAM start ($200001)
CartRAMEndLoc:	dc.l $20202020	; SRAM end ($20xxxx)
Modem_Info:	dc.b "                                                    "
Country_Code:	dc.b "JUE             "
; ---------------------------------------------------------------------------
; VDP Subroutine
; ---------------------------------------------------------------------------

		include "Data/Misc/VDP.asm"
		
; ---------------------------------------------------------------------------
; Controllers Subroutine
; ---------------------------------------------------------------------------

		include "Data/Misc/Controllers.asm"

; ---------------------------------------------------------------------------
; Interrupt Handler Subroutine
; ---------------------------------------------------------------------------

VInt:
HInt:
		rte

; ---------------------------------------------------------------------------
; Decompression Subroutine
; ---------------------------------------------------------------------------

		include "Data/Decompression/Kosinski Decompression.asm"
		
; ---------------------------------------------------------------------------
; DMA Queue Subroutine
; ---------------------------------------------------------------------------
		
		include "Data/Misc/DMA Queue.asm"
		
; ---------------------------------------------------------------------------
; Security Subroutine
; ---------------------------------------------------------------------------

		include "Data/Misc/Security Startup 1.asm"

; ---------------------------------------------------------------------------
; Sound test
; ---------------------------------------------------------------------------

		lea	V_int_addr.w,a0			; load v-blank routine to a0
		lea	dFractalExtra(pc),a1		; load external routine to a1 (will be called by visual debugger)
		jmp	dVisualDebugger			; go to visual debugger

; ---------------------------------------------------------------------------
; AMPS sound driver subroutines
; ---------------------------------------------------------------------------

		RELAXED ON
		include "Fractal/Code/extra.asm"
		include "Fractal/Code/main.asm"
		RELAXED OFF

; ---------------------------------------------------------------------------
; DualPCM include
; ---------------------------------------------------------------------------

DualPCM:
		binclude "Fractal/Code/DualPCM.kos"
		even

; ---------------------------------------------------------------
; Error handling module
; ---------------------------------------------------------------

		include "Misc Data/Debugger/ErrorHandler/ErrorHandler.asm"

; end of 'ROM'
EndOfROM:

		END


