Map_TitleText4:								; EX MODE
		dc.w SME_FLIak4_6-Map_TitleText4	; 0
		dc.w SME_FLIak4_6-Map_TitleText4	; 1
		dc.w SME_FLIak4_1A-Map_TitleText4	; 2
		dc.w SME_FLIak4_6-Map_TitleText4	; 3
SME_FLIak4_6:
		dc.b 0, 2
		dc.b $F4, $D, $40, $35, 0, $29
		dc.b $F4, $D, $40, $3D, 0, $49
SME_FLIak4_1A:
		dc.b 0, 2
		dc.b $F4, $D, 0, $35, 0, $29
		dc.b $F4, $D, 0, $3D, 0, $49
		even