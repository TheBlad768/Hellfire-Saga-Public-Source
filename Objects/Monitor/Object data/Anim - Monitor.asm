Ani_Monitor:
		dc.w byte_1DB50-Ani_Monitor		; 0 (Null)
		dc.w byte_1DB54-Ani_Monitor		; 1 (Robotnik)
		dc.w byte_1DB5C-Ani_Monitor		; 2 (Rings)
		dc.w byte_1DB64-Ani_Monitor		; 3 (Fire)
		dc.w byte_1DB6C-Ani_Monitor		; 4 (Electro)
		dc.w byte_1DB74-Ani_Monitor		; 5 (Bubble)
		dc.w byte_1DB7C-Ani_Monitor		; 6 (XZ)
		dc.w byte_1DB84-Ani_Monitor		; 7 (Sword)
		dc.w byte_1DB8C-Ani_Monitor		; 8 (Skull)
		dc.w byte_1DB9C-Ani_Monitor		; 9 (Random)
		dc.w byte_1DBAC-Ani_Monitor		; $A (Break)
byte_1DB50:	dc.b 1, 0, 1, 2, $FF
byte_1DB54:	dc.b	1, 3, 3, 3, 3, $C, 3, $C, 3, $E, 3, $E, 3, $D, 3, $D, 3, $FF
byte_1DB5C:	dc.b	1, 4, 4, 4, 4, $F, 4, $F, 4, $11, 4, $11, 4, $10, 4, $10, 4, $FF
byte_1DB64:	dc.b	1, 5, 5, 5, 5, $12, 5, $12, 5, $14, 5, $14, 5, $13, 5, $13, 5, $FF
byte_1DB6C:	dc.b	1, 6, 6, 6, 6, $15, 6, $15, 6, $17, 6, $17, 6, $16, 6, $16, 6, $FF
byte_1DB74:	dc.b	1, 7, 7, 7, 7, $18, 7, $18, 7, $1A, 7, $1A, 7, $19, 7, $19, 7, $FF
byte_1DB7C:	dc.b	1, 8, 8, 8, 8, $1B, 8, $1B, 8, $1D, 8, $1D, 8, $1C, 8, $1C, 8, $FF
byte_1DB84:	dc.b	1, 9, 9, 9, 9, $1E, 9, $1E, 9, $20, 9, $20, 9, $1F, 9, $1F, 9, $FF
byte_1DB8C:	dc.b	1, $A, $A, $A, $A, $21, $A, $21, $A, $23, $A, $23, $A, $22, $A, $22, $A, $FF
byte_1DB9C:	dc.b	1, 4, $12, $16, $18, $1A, 8, $20, $FF
byte_1DBAC:	dc.b	2, 0, 1, 2, $B, $FE, 1
	even