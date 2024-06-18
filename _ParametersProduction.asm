; ===========================================================================
; Production build options
; ===========================================================================

; These are parameter values used for building a production ROM of the game.
; This file MUST be included in git to ensure a consistent set of parameters for production.

Debug_Title         = 1     ; set to 1 to enable title screen
GameDebug           = 0     ; If 1, enable debug mode for sonic
Debug_Lagometer     = 0     ; set to 1 to enable CPU lagometer
Debug_EasyBoss      = 0     ; set to 1 to make every boss 1-hit kill

DisableSRAM         = 0     ; set to 1 to create a ROM without SRAM

Debug_LevelId       = -1    ; $0202 ; set to -1 to disable debugging a level
Debug_Xpos          = $0234 ; xpos to spawn to
Debug_Ypos          = $0728 ; ypos to spawn to

; ---------------------------------------------------------------------------

    include "Sonic.asm"