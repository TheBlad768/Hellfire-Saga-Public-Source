; ---------------------------------------------------------------------------
; Animation script
; ---------------------------------------------------------------------------

Ani_Bump:
		dc.w byte_EAF4-Ani_Bump
		dc.w byte_EAF8-Ani_Bump
byte_EAF4:	dc.b $F, 0, afEnd
byte_EAF8:	dc.b 3, 1, 0, 1, 0, 1, afChange, 0
	even