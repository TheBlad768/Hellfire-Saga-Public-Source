Ani_BloodeauFantom:
		dc.w BloodeauFly-Ani_BloodeauFantom
		dc.w BloodeauSummBat-Ani_BloodeauFantom
		dc.w BloodeauTomb-Ani_BloodeauFantom
		dc.w TombWarn-Ani_BloodeauFantom
		dc.w BloodeauCross-Ani_BloodeauFantom
		dc.w TombWarn_Safe-Ani_BloodeauFantom

BloodeauFly:	dc.b 6, 0, 1, $FF
BloodeauSummBat: dc.b 3, 2, 2, $FD, 0
BloodeauTomb:	dc.b 0, 3, $FF
TombWarn:	dc.b 2, 4, 5, $FF
BloodeauCross:	dc.b 2, 6, 7, $FF
TombWarn_Safe:	dc.b $7F, 5, $FF
		even
