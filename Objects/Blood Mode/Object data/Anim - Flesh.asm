		dc.w heart-Ani_Flesh	; Сердце.
		dc.w bone-Ani_Flesh		; Кость.
		dc.w gut-Ani_Flesh		; Кишка.
		dc.w meat-Ani_Flesh		; Куски мяса.
		dc.w gut2-Ani_Flesh		; Кишка 2(или хз что это...).
		dc.w blood-Ani_Flesh	; Капли крови.
heart:	dc.b 5, 1, 2, 3, 4, $FF	; Повтор с самого начала.
bone:	dc.b 5, 5, 6, 7, 8, $FF	; Повтор с самого начала.
gut:	dc.b 5, 9, $A, $B, $C, $FF	; Повтор с самого начала.
meat:	dc.b 5, $D, $E, $F, $10, $FF	; Повтор с самого начала.
gut2:	dc.b 5, $11, $12, $13, $14, $FF	; Повтор с самого начала.
blood:	dc.b 2, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $FE, 1	; Повторять последний кадр постоянно.
	even