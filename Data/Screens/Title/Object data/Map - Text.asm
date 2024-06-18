Map_TitleText:								; PRESS
		dc.w SME_FLIak_6-Map_TitleText		; 0
		dc.w SME_FLIak_1A-Map_TitleText		; 1
		dc.w SME_FLIak_6-Map_TitleText		; 2
		dc.w SME_FLIak_6-Map_TitleText		; 3
SME_FLIak_6:
		dc.b 0, 2
		dc.b $E0, $D, $40, 0, 0, $35
		dc.b $E0, 1, $40, 8, 0, $55
SME_FLIak_1A:
		dc.b 0, 2
		dc.b $E0, $D, 0, 0, 0, $35
		dc.b $E0, 1, 0, 8, 0, $55
		even