Map_Results:
		dc.w word_2F2E0-Map_Results		; Null
		dc.w word_2F2E2-Map_Results		; 1 (Number 0)
		dc.w word_2F2EA-Map_Results		; 2 (Number 1)
		dc.w word_2F2F2-Map_Results		; 3 (Number 2)
		dc.w word_2F2FA-Map_Results		; 4 (Number 3)
		dc.w word_2F302-Map_Results		; 5 (Number 4)
		dc.w word_2F30A-Map_Results		; 6 (Number 5)
		dc.w word_2F312-Map_Results		; 7 (Number 6)
		dc.w word_2F31A-Map_Results		; 8 (Number 7)
		dc.w word_2F322-Map_Results		; 9 (Number 8)
		dc.w word_2F32A-Map_Results		; A (Number 9)
		dc.w word_2F332-Map_Results		; B
		dc.w word_2F346-Map_Results		; C (Bonus)
		dc.w word_2F35A-Map_Results		; D (Ring)
		dc.w word_2F362-Map_Results		; E (Time)
		dc.w word_2F36A-Map_Results		; F
		dc.w word_2F378-Map_Results		; 10
		dc.w word_2F39E-Map_Results		; 11
		dc.w word_2F3B2-Map_Results		; 12 (Null?)
		dc.w word_2F3C6-Map_Results		; 13
word_2F2E0:
		dc.w 0
word_2F2E2:
		dc.w 0
word_2F2EA:
		dc.w 0
word_2F2F2:
		dc.w 0
word_2F2FA:
		dc.w 0
word_2F302:
		dc.w 0
word_2F30A:
		dc.w 0
word_2F312:
		dc.w 0
word_2F31A:
		dc.w 0
word_2F322:
		dc.w 0
word_2F32A:
		dc.w 0
word_2F332:
		dc.w 0
	;	dc.b	0,   1,	$84, $A4,   0,	 0
	;	dc.b	0,  $D,	$84, $A2,   0,	 8
	;	dc.b  $F6,   6,	$84, $94,   0, $24
word_2F346:		; Bonus
		dc.w 0
word_2F35A:
		dc.w 0	; Ring
word_2F362:
		dc.w 0	; Time
word_2F36A:
		dc.w 7
		dc.b  $28,  $C,	$84, $AA,   $FF, $AD
		dc.b  $28,  0,	$84, $AE,   $FF, $CD
		dc.b  $38,  $F,	$84, $C8,   $FF, $B0
		dc.b $38, $F, $84, $80, $FF, $78
		dc.b $38, $B, $84, $90, $FF, $98
		dc.b $38, $F, $8C, $80, $FF, $E8
		dc.b $38, $B, $8C, $90, $FF, $D0
word_2F378:
		dc.w 6
		dc.b	0,   5,	$84, $C0,   0,	 0
		dc.b	0,   5,	$84, $B4,   0, $10
		dc.b	0,   5,	$84, $BC,   0, $20
		dc.b	0,   5,	$84, $B8,   0, $30
		dc.b	0,   5,	$84, $C4,   0, $40
		dc.b	0,  $D,	$84, $B0,   0, $50
word_2F39E:
		dc.w 3
		dc.b	0,   5,	$84, $B0,   0,	 0
		dc.b	0,   5,	$84, $B8,   0, $10
		dc.b	0,   5,	$84, $C0,   0, $1E
word_2F3B2:
		dc.w 3
		dc.b	0,  $D,	$84,  $6F,   0,	 0
		dc.b	0,  $D,	$84, $77,   0, $20
		dc.b	0,   5,	$84, $7F,   0, $40
word_2F3C6:
		dc.w 3
		dc.b	0,  $D,	$84, $D8,   0,	 1
		dc.b	0,  $D,	$84, $E0,   0, $21
		dc.b	0,   1,	$84, $E8,   0, $41