; ===========================================================================
; Level Size Array
; ===========================================================================

;		xstart, xend, ystart, yend			; Level
LevelSizes:
		dc.w 0, $2800, 0, $710				; FDZ 1
		dc.w 0, $1FF0, 0, $4E5				; FDZ 2
		dc.w 0, $2000, 0, $8D0			; FDZ 3
		dc.w 0, $6FB, 0, $B0				; FDZ 4
		dc.w 0, $5600, 0, $600			; SCZ 1
		dc.w 0, $3000, 0, $500			; SCZ 2
		dc.w 0, $C00, $378, $378			; SCZ 3
		dc.w 0, $5F0, 0, $100				; SCZ 4
		dc.w 0, $4000, 0, $710				; GMZ 1
		dc.w 0, $2A00, 0, $440			; GMZ 2
		dc.w 0, $4000, 0, $28C			; GMZ 3
		dc.w 0, $2020, 0, $500			; GMZ 4
		dc.w 0, $8C0, 0, 0					; DDZ 1
		dc.w 0, $1FF0, 0, $4E5				; DDZ 2
		dc.w 0, $2000, 0, $8D0			; DDZ 3
		dc.w 0, $6FB, 0, $B0				; DDZ 4
		dc.w 0, $4000, 0, $710				; Credits