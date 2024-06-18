; ===========================================================================
; Palette pointers
; ===========================================================================

PalPointers:				; palette address, RAM address, colours

; Main
ptr_Pal_Sonic:			palp	Pal_Sonic, Normal_palette_line_1, 16				; 0 - Sonic
ptr_Pal_SonicFDZ:		palp	Pal_SonicFDZ, Normal_palette_line_1, 16				; 1 - Sonic FDZ
ptr_Pal_SonicFDZRain:	palp	Pal_SonicFDZRain, Normal_palette_line_1, 16			; 2 - Sonic FDZ Rain (FDZ3)
ptr_Pal_SonicSCZ:		palp	Pal_SonicSCZ, Normal_palette_line_1, 16				; 3 - Sonic SCZ
ptr_Pal_SonicMGZ:		palp	Pal_SonicMGZ, Normal_palette_line_1, 16			; 4 - Sonic MGZ1
ptr_Pal_SonicMGZ2:		palp	Pal_SonicMGZ2, Normal_palette_line_1, 16			; 5 - Sonic MGZ2
ptr_Pal_SonicDDZ:		palp	Pal_SonicDDZ, Normal_palette_line_1, 16			; 6 - Sonic DDZ
ptr_Pal_WaterSonic:		palp	Pal_WaterSonic, Water_palette_line_1, 16			; 7 - Water Sonic (SCZ)

; Levels
ptr_Pal_FDZ:				palp	Pal_FDZ, Normal_palette_line_2, 48					; 8 - FDZ1
ptr_Pal_FDZ3:			palp	Pal_FDZ3, Normal_palette_line_2, 48				; 9 - FDZ3
ptr_Pal_FDZ3Rain:		palp	Pal_FDZ3_Rain, Normal_palette_line_3, 32			; A - FDZ3 Rain
ptr_Pal_SCZ:				palp	Pal_SCZ, Normal_palette_line_2, 48					; B - SCZ1
ptr_Pal_SCZ2:			palp	Pal_SCZ2, Normal_palette_line_2, 48				; C - SCZ1
ptr_Pal_SCZWater:		palp	Pal_SCZWater, Water_palette_line_2, 48				; D - SCZ underwaters
ptr_Pal_GMZ:			palp	Pal_GMZ, Normal_palette_line_2, 48				; E - GMZ1
ptr_Pal_GMZ2:			palp	Pal_GMZ2, Normal_palette_line_2, 48				; F - GMZ2
ptr_Pal_GMZ3:			palp	Pal_GMZ3, Normal_palette_line_2, 48				; 10 - GMZ3
ptr_Pal_DDZ:			palp	Pal_DDZ, Normal_palette_line_2, 48				; 11 - DDZ
ptr_Pal_CRE:			palp	Pal_CreditsNew, Normal_palette_line_2, 48			; 12 - Credits
; ---------------------------------------------------------------------------

; Main
palid_Sonic:				equ (ptr_Pal_Sonic-PalPointers)/8						; 0 - Sonic
palid_SonicFDZ:			equ (ptr_Pal_SonicFDZ-PalPointers)/8					; 1 - Sonic FDZ
palid_SonicFDZRain:		equ (ptr_Pal_SonicFDZRain-PalPointers)/8				; 2 - Sonic FDZ Rain (FDZ3)
palid_SonicSCZ:			equ (ptr_Pal_SonicSCZ-PalPointers)/8					; 3 - Sonic SCZ
palid_SonicMGZ:			equ (ptr_Pal_SonicMGZ-PalPointers)/8					; 4 - Sonic MGZ1
palid_SonicMGZ2:		equ (ptr_Pal_SonicMGZ2-PalPointers)/8					; 5 - Sonic MGZ2
palid_SonicDDZ:			equ (ptr_Pal_SonicDDZ-PalPointers)/8					; 6 - Sonic DDZ
palid_WaterSonic:		equ (ptr_Pal_WaterSonic-PalPointers)/8					; 7 - Water Sonic

; Levels
palid_FDZ:				equ (ptr_Pal_FDZ-PalPointers)/8						; 8 - FDZ1
palid_FDZ3:				equ (ptr_Pal_FDZ3-PalPointers)/8						; 9 - FDZ3
palid_FDZ3Rain:			equ (ptr_Pal_FDZ3Rain-PalPointers)/8					; A - FDZ3 Rain
palid_SCZ:				equ (ptr_Pal_SCZ-PalPointers)/8						; B - SCZ1
palid_SCZ2:				equ (ptr_Pal_SCZ2-PalPointers)/8						; C - SCZ2
palid_SCZWater:			equ (ptr_Pal_SCZWater-PalPointers)/8					; D - SCZ underwaters
palid_GMZ:				equ (ptr_Pal_GMZ-PalPointers)/8						; E - GMZ1
palid_GMZ2:				equ (ptr_Pal_GMZ2-PalPointers)/8						; F - GMZ2
palid_GMZ3:				equ (ptr_Pal_GMZ3-PalPointers)/8						; 10 - GMZ3
palid_DDZ:				equ (ptr_Pal_DDZ-PalPointers)/8						; 11 - DDZ
palid_CRE:				equ (ptr_Pal_CRE-PalPointers)/8						; 12 - Credits
